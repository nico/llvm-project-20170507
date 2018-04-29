import argparse
import os
import re
import sys

"""Processes a foo.h.cmake file and writes foo.h"""

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--values', nargs='*')
    parser.add_argument('input')
    parser.add_argument('-o', '--output')
    args = parser.parse_args()

    values = {}
    for value in args.values:
        key, val = value.split('=', 1)
        values[key] = val

    # Matches e.g. '${CLANG_FOO}' and captures CLANG_FOO in group 1.
    var_re = re.compile(r'\$\{([^}]*)\}')

    in_lines = open(args.input).readlines()
    out_lines = []
    for in_line in in_lines:
        def repl(m):
            return values[m.group(1)]
        if in_line.startswith('#cmakedefine01 '):
            _, var = in_line.split()
            out_lines.append('#define %s %d\n' % (var, 1 if values[var] else 0))
        elif in_line.startswith('#cmakedefine '):
            _, var = in_line.split(None, 1)
            try:
                var, val = var.split(None, 1)
            except:
                var, val = var.rstrip(), '\n'
            if values[var]:
                out_lines.append('#define %s %s\n' % (var,
                                                      var_re.sub(repl, val)))
            else:
                out_lines.append('/* #undef %s */\n' % var)
        else:
            # In particular, handles `#define FOO ${FOO}` lines.
            out_lines.append(var_re.sub(repl, in_line))

    output = ''.join(out_lines)

    leftovers = var_re.findall(output)
    if leftovers:
        print >>sys.stderr, 'unprocessed values:\n', '\n'.join(leftovers)
        return 1

    if not os.path.exists(args.output) or open(args.output).read() != output:
        open(args.output, 'w').write(output)


if __name__ == '__main__':
    sys.exit(main())
