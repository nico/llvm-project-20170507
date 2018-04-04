import argparse
import os
import sys

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--replace')
    parser.add_argument('--with', dest='with_')
    parser.add_argument('input')
    parser.add_argument('-o', '--output')
    parser.add_argument('--target', nargs='+')
    args = parser.parse_args()

    replacement = [args.with_ % { 'target': target } for target in args.target]
    replacement = '\n'.join(replacement)

    output = open(args.input).read().replace(args.replace, replacement)

    if not os.path.exists(args.output) or open(args.output).read() != output:
        open(args.output, 'w').write(output)

if __name__ == '__main__':
    sys.exit(main())
