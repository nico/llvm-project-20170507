import argparse
import os
import re
import sys

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--from_to', nargs='+')
    parser.add_argument('input')
    parser.add_argument('-o', '--output')
    args = parser.parse_args()

    output = open(args.input).read()
    for from_to in args.from_to:
        from_, to = from_to.split('=', 1)
        output = output.replace(from_, to)

    leftovers = re.findall('@[^@]+@', output)
    if leftovers:
        print 'missing patterns for', ', '.join(leftovers)
        return 1

    if not os.path.exists(args.output) or open(args.output).read() != output:
        open(args.output, 'w').write(output)

if __name__ == '__main__':
    sys.exit(main())

