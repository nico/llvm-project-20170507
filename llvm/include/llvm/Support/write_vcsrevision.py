from __future__ import print_function

import argparse
import distutils.spawn
import os
import subprocess
import sys

THIS_DIR = os.path.abspath(os.path.dirname(__file__))
LLVM_DIR = os.path.dirname(os.path.dirname(os.path.dirname(THIS_DIR)))
MONO_DIR = os.path.dirname(LLVM_DIR)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '--depfile')
    parser.add_argument('vcs_header')
    args = parser.parse_args()

    if os.path.isdir(os.path.join(LLVM_DIR, '.svn')):
        print('SVN support not yet implemented', file=sys.stderr)
        return 1
    if os.path.isdir(os.path.join(LLVM_DIR, '.git')):
        print('non-mono-repo git support not yet implemented', file=sys.stderr)
        return 1

    git_dir = os.path.join(MONO_DIR, '.git')
    if not os.path.isdir(git_dir):
        print('.git dir not found at "%s"' % git_dir, file=sys.stderr)
        return 1

    git = distutils.spawn.find_executable('git')
    rev = subprocess.check_output([git, 'rev-parse', '--short', 'HEAD'],
                                  cwd=git_dir)
    # FIXME: In addition to .svn and non-monorepo .git, add pizzas such as
    # the svn revision read off a git note, git-svn info, etc.
    vcsrevision_contents = '#define LLVM_REVISION "git-%s"\n' % rev.strip()

    # If the output already exists and is identical to what we'd write,
    # return to not perturb the existing file's timestamp.
    if os.path.exists(args.vcs_header) and \
            open(args.vcs_header).read() == vcsrevision_contents:
        return 0

    # http://neugierig.org/software/blog/2014/11/binary-revisions.html
    build_dir = os.getcwd()
    with open(args.depfile, 'w') as depfile:
        depfile.write('%s: %s\n' % (
            args.vcs_header,
            os.path.relpath(os.path.join(git_dir, 'logs', 'HEAD'), build_dir)))
    open(args.vcs_header, 'w').write(vcsrevision_contents)

    return 0

if __name__ == '__main__':
    sys.exit(main())
