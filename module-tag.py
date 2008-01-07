#!/usr/bin/env python

subversion_id = "$Id: TestMain.py 7635 2008-01-04 09:46:06Z thierry $"

import sys, os, os.path
import re
import time
import glob
from optparse import OptionParser

####################
# where to store user's config
globals_storage="GLOBALS"
svnpath_example="svn+ssh://thierry@svn.planet-lab.org/svn/"
# what to parse in a spec file
name_varname="name"
major_varname="version"
minor_varname="subversion"
varnames = [name_varname,major_varname,minor_varname]
varmatcher=re.compile("%define\s+(\S+)\s+(.*)")
# 
svn_magic_line="--This line, and those below, will be ignored--"
####################

def prompt (question,default=True):
    if default:
        question += " [y]/n ? "
    else:
        question += " y/[n] ? "
    answer=raw_input(question)
    if not answer:
        return default
    elif answer[0] in [ 'y','Y']:
        return True
    elif answer[0] in [ 'n','N']:
        return False
    else:
        return prompt(question,default)

class Command:
    def __init__ (self,command,options):
        self.command=command
        self.options=options
        self.tmp="/tmp/command-%d"%os.getpid()

    def run (self):
        if self.options.verbose:
            print '+',self.command
            sys.stdout.flush()
        return os.system(self.command)

    def run_silent (self):
        if self.options.verbose:
            print '+',self.command,' .. ',
            sys.stdout.flush()
        retcod=os.system(self.command + " &> " + self.tmp)
        if retcod != 0:
            print "FAILED ! -- output quoted below "
            os.system("cat " + self.tmp)
            print "FAILED ! -- end of quoted output"
        elif self.options.verbose:
            print "OK"
        os.unlink(self.tmp)
        return retcod

    def run_fatal(self):
        if self.run_silent() !=0:
            raise Exception,"Command %s failed"%self.command

    # returns stdout, like bash's $(mycommand)
    def output_of (self):
        tmp="/tmp/status-%d"%os.getpid()
        if self.options.vverbose:
            print '+',self.command,' .. ',
            sys.stdout.flush()
        os.system(self.command + " &> " + tmp)
        result=file(tmp).read()
        os.unlink(tmp)
        if self.options.vverbose:
            print '+',self.command,'Done',
        return result

class svnpath:
    def __init__(self,path,options):
        self.path=path
        self.options=options

    def url_exists (self):
        if self.options.verbose:
            print 'Checking url',self.path
        return os.system("svn list %s &> /dev/null"%self.path) == 0

    def dir_needs_revert (self):
        command="svn status %s"%self.path
        return len(Command(command,self.options).output_of()) != 0
    # turns out it's the same implem.
    def file_needs_commit (self):
        command="svn status %s"%self.path
        return len(Command(command,self.options).output_of()) != 0

class Module:
    def __init__ (self,name,options):
        self.name=name
        self.options=options
        self.moddir="%s/%s/%s"%(os.getenv("HOME"),options.modules,name)
        self.trunkdir="%s/trunk"%(self.moddir)

    globals={}
    globalKeys=[ ('svnpath',"Enter your toplevel svnpath (e.g. %s)"%svnpath_example),
                 ('username',"Enter your firstname and lastname for changelogs"),
                 ("email","Enter your email address for changelogs") ]

    def run (self,command):
        return Command(command,self.options).run()
    def run_fatal (self,command):
        return Command(command,self.options).run_fatal()
    def run_prompt (self,message,command):
        if not self.options.verbose:
            question=message
        else:
            question="Want to run " + command
        if prompt(question,True):
            self.run(command)            

    @staticmethod
    def init_homedir (options):
        topdir="%s/%s"%(os.getenv("HOME"),options.modules)
        if options.verbose:
            print 'Checking for',topdir
        storage="%s/%s"%(topdir,globals_storage)
        if not os.path.isdir (topdir):
            # prompt for login or whatever svnpath
            print "Cannot find",topdir,"let's create it"
            for (key,message) in Module.globalKeys:
                Module.globals[key]=raw_input(message+" : ").strip()
            Command("svn co -N %s %s"%(Module.globals['svnpath'],topdir),options).run_fatal()
            # store globals
            f=file(storage,"w")
            for (key,message) in Module.globalKeys:
                f.write("%s=%s\n"%(key,Module.globals[key]))
            f.close()
            if options.vverbose:
                print 'Stored',storage
                Command("cat %s"%storage,options).run()
        else:
            # read globals
            f=open(storage)
            for line in f.readlines():
                (key,value)=re.compile("^(.+)=(.+)$").match(line).groups()
                Module.globals[key]=value                
            f.close()
            if options.vverbose:
                print 'Using globals'
                for (key,message) in Module.globalKeys:
                    print key,'=',Module.globals[key]

    def init_moddir (self):
        if self.options.verbose:
            print 'Checking for',self.moddir
        if not os.path.isdir (self.moddir):
            self.run_fatal("svn up -N %s"%self.moddir)
        if not os.path.isdir (self.moddir):
            print 'Cannot find %s - check module name'%self.moddir
            sys.exit(1)

    def init_trunkdir (self):
        if self.options.verbose:
            print 'Checking for',self.trunkdir
        if not os.path.isdir (self.trunkdir):
            self.run_fatal("svn up %s"%self.trunkdir)

    def revert_trunkdir (self):
        if self.options.verbose:
            print 'Checking whether',self.trunkdir,'needs being reverted'
        if svnpath(self.trunkdir,self.options).dir_needs_revert():
            self.run_fatal("svn revert -R %s"%self.trunkdir)

    def update_trunkdir (self):
        if self.options.verbose:
            print 'Updating',self.trunkdir
        self.run_fatal("svn update %s"%self.trunkdir)

    def guess_specname (self):
        attempt="%s/%s.spec"%(self.trunkdir,self.name)
        if os.path.isfile (attempt):
            return attempt
        else:
            from glob import glob
            try:
                return glob("%s/*.spec"%self.trunkdir)[0]
            except:
                print 'Cannot guess specfile for module %s'%self.name
                sys.exit(1)

    def spec_dict (self):
        specfile=self.guess_specname()
        if self.options.verbose:
            print 'Parsing',specfile,
        result={}
        f=open(specfile)
        for line in f.readlines():
            if varmatcher.match(line):
                (var,value)=varmatcher.match(line).groups()
                if var in varnames:
                    result[var]=value
        f.close()
        if self.options.verbose:
            print 'found',len(result),'keys'
        return result

    def patch_spec_var (self, patch_dict):
        specfile=self.guess_specname()
        newspecfile=specfile+".new"
        if self.options.verbose:
            print 'Patching',specfile,'for',patch_dict.keys()
        spec=open (specfile)
        new=open(newspecfile,"w")

        for line in spec.readlines():
            if varmatcher.match(line):
                (var,value)=varmatcher.match(line).groups()
                if var in patch_dict.keys():
                    new.write('%%define %s %s\n'%(var,patch_dict[var]))
                    continue
            new.write(line)
        spec.close()
        new.close()
        os.rename(newspecfile,specfile)

    def unignored_lines (self, logfile):
        result=[]
        for logline in file(logfile).readlines():
            if logline.strip() == svn_magic_line:
                break
            result += logline
        return result

    def insert_changelog (self, logfile, oldtag, newtag):
        specfile=self.guess_specname()
        newspecfile=specfile+".new"
        if self.options.verbose:
            print 'Inserting changelog from %s into %s'%(logfile,specfile)
        spec=open (specfile)
        new=open(newspecfile,"w")
        for line in spec.readlines():
            new.write(line)
            if re.compile('%changelog').match(line):
                dateformat="* %a %b %d %Y"
                datepart=time.strftime(dateformat)
                logpart="%s <%s> - %s %s"%(Module.globals['username'],
                                             Module.globals['email'],
                                             oldtag,newtag)
                new.write(datepart+" "+logpart+"\n")
                for logline in self.unignored_lines(logfile):
                    new.write(logline)
                new.write("\n")
        spec.close()
        new.close()
        os.rename(newspecfile,specfile)
            
    def show_dict (self, spec_dict):
        if self.options.verbose:
            for (k,v) in spec_dict.iteritems():
                print k,'=',v

    def trunk_url (self):
        return "%s/%s/trunk"%(Module.globals['svnpath'],self.name)
    def tag_name (self, spec_dict):
        return "%s-%s.%s"%(spec_dict['name'],spec_dict['version'],spec_dict['subversion'])
    def tag_url (self, spec_dict):
        return "%s/%s/tags/%s"%(Module.globals['svnpath'],self.name,self.tag_name(spec_dict))

    def diff (self):
        self.init_moddir()
        self.init_trunkdir()
        self.revert_trunkdir()
        self.update_trunkdir()
        spec_dict = self.spec_dict()
        self.show_dict(spec_dict)

        trunk_url=self.trunk_url()
        tag_url=self.tag_url(spec_dict)
        for url in [ trunk_url, tag_url ] :
            if not svnpath(url,self.options).url_exists():
                print 'Could not find svn URL %s'%url
                sys.exit(1)

        self.run("svn diff %s %s"%(tag_url,trunk_url))

    def patch_tags_files (self, tagsfile, oldname, newname):
        newtagsfile=tagsfile+".new"
        if self.options.verbose:
            print 'Replacing %s into %s in %s'%(oldname,newname,tagsfile)
        tags=open (tagsfile)
        new=open(newtagsfile,"w")
        matcher=re.compile("^(.*)%s(.*)"%oldname)
        for line in tags.readlines():
            if not matcher.match(line):
                new.write(line)
            else:
                (begin,end)=matcher.match(line).groups()
                new.write(begin+newname+end+"\n")
        tags.close()
        new.close()
        os.rename(newtagsfile,tagsfile)

    def create_tag (self):
        self.init_moddir()
        self.init_trunkdir()
        self.revert_trunkdir()
        self.update_trunkdir()
        spec_dict = self.spec_dict()
        self.show_dict(spec_dict)
        
        # parse specfile, check that the old tag exists and the new one does not
        trunk_url=self.trunk_url()
        old_tag_name = self.tag_name(spec_dict)
        old_tag_url=self.tag_url(spec_dict)
        # increment subversion
        new_subversion = str ( int (spec_dict['subversion']) + 1)
        spec_dict['subversion'] = new_subversion
        new_tag_name = self.tag_name(spec_dict)
        new_tag_url=self.tag_url(spec_dict)
        for url in [ trunk_url, old_tag_url ] :
            if not svnpath(url,self.options).url_exists():
                print 'Could not find svn URL %s'%url
                sys.exit(1)
        if svnpath(new_tag_url,self.options).url_exists():
            print 'New tag\'s svn URL %s already exists ! '%url
            sys.exit(1)

        # side effect in trunk's specfile
        self.patch_spec_var({"subversion":new_subversion})

        # prepare changelog file 
        # we use the standard subversion magic string (see svn_magic_line)
        # so we can provide useful information, such as version numbers and diff
        # in the same file
        changelog="/tmp/%s-%d.txt"%(self.name,os.getpid())
        file(changelog,"w").write("""
%s
module %s
old tag %s
new tag %s
"""%(svn_magic_line,self.name,old_tag_url,new_tag_url))

        if not self.options.verbose or prompt('Want to run diff',True):
            self.run("(echo 'DIFF========='; svn diff %s %s) >> %s"%(old_tag_url,trunk_url,changelog))
        # edit it        
        self.run("%s %s"%(self.options.editor,changelog))
        # insert changelog in spec
        if self.options.changelog:
            self.insert_changelog (changelog,old_tag_name,new_tag_name)

        ## update build
        build = Module(self.options.build,self.options)
        build.init_moddir()
        build.init_trunkdir()
        build.revert_trunkdir()
        build.update_trunkdir()
        
        for tagsfile in glob.glob(build.trunkdir+"/*-tags.mk"):
            print 'tagsfile : ',tagsfile
            self.patch_tags_files(tagsfile,old_tag_name,new_tag_name)

        paths=""
        paths += self.trunkdir + " "
        paths += build.trunkdir + " "
        self.run_prompt("Check","svn diff " + paths)
        self.run_prompt("Commit","svn commit --file %s %s"%(changelog,paths))
        self.run_prompt("Create tag","svn copy --file %s %s %s"%(changelog,trunk_url,new_tag_url))

        if self.options.vverbose:
            print 'Preserving',changelog
        else:
            os.unlink(changelog)
            
usage="""Usage: %prog options module1 [ .. modulen ]
Purpose:
  manage subversion tags and specfile
Behaviour:
  show the diffs between the trunk and the latests tag
  or, if -t or --tag is provided, the specfile is updated and the module is tagged"""

def main():
    parser=OptionParser(usage=usage,version=subversion_id)
    diff_mode =  (sys.argv[0].find("diff") >= 0)
    parser.add_option("-d","--diff", action="store_true", dest="diff", default=diff_mode, 
                      help="Show diff between trunk and latest tag")
    parser.add_option("-e","--editor", action="store", dest="editor", default="emacs",
                      help="Specify editor")
    parser.add_option("-c","--changelog", action="store_false", dest="changelog", default=True,
                      help="Does not update changelog when tagging")
    parser.add_option("-m","--modules", action="store", dest="modules", default="modules",
                      help="Name for topdir - defaults to modules")
    parser.add_option("-b","--build", action="store", dest="build", default="build",
                      help="Set module name for build")
    parser.add_option("-v","--verbose", action="store_true", dest="verbose", default=False, 
                      help="Run in verbose mode")
    parser.add_option("-V","--veryverbose", action="store_true", dest="vverbose", default=False, 
                      help="Very verbose mode")
    (options, args) = parser.parse_args()
    if options.vverbose: options.verbose=True

    if len(args) == 0:
        parser.print_help()
        sys.exit(1)
    else:
        Module.init_homedir(options)
        for modname in args:
            module=Module(modname,options)
            if options.diff:
                module.diff()
            else:
                module.create_tag()

# basically, we exit if anything goes wrong
if __name__ == "__main__" :
    main()
