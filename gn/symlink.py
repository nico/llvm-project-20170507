import argparse
import errno
import os
import sys

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-f', '--force', action='store_true')
    parser.add_argument('--stamp')
    parser.add_argument('source')
    parser.add_argument('output')
    args = parser.parse_args()
    try:
        os.makedirs(os.path.dirname(args.output))
    except OSError as err:
        if err.errno != errno.EEXIST:
            raise
    try:
        os.symlink(args.source, args.output)
    except OSError as e:
      if e.errno == errno.EEXIST and args.force:
          os.remove(args.output)
          os.symlink(args.source, args.output)
      else:
          raise
    open(args.stamp, 'w') # Update mtime on stamp file.

if __name__ == '__main__':
    sys.exit(main())
