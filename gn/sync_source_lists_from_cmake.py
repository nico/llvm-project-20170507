#!/usr/bin/env python

# For each BUILD.gn file in the tree, checks if the list of cpp files in
# it is identical to the list of cpp files in the adjacent CMakeLists.txt
# file, and prints the difference if not.

from __future__ import print_function

import re
import os
import subprocess

def main():
    gn_files = subprocess.check_output(
            ['git', 'ls-files', '*BUILD.gn']).splitlines()

    # Matches e.g. |   "foo.cpp",|.
    gn_cpp_re = re.compile(r'^\s*"([^"]+\.cpp)",$', re.MULTILINE)
    # Matches e.g. |   "foo.cpp",|.
    cmake_cpp_re = re.compile(r'^\s*([A-Za-z_0-9/-]+.cpp)$', re.MULTILINE)

    for gn_file in gn_files:
        cmake_file = os.path.join(os.path.dirname(gn_file), 'CMakeLists.txt')
        if not os.path.exists(cmake_file):
            continue

        def get_sources(source_re, text):
            return set([m.group(1) for m in source_re.finditer(text)])
        gn_cpp = get_sources(gn_cpp_re, open(gn_file).read())
        cmake_cpp = get_sources(cmake_cpp_re, open(cmake_file).read())

        if gn_cpp == cmake_cpp:
            continue

        print(gn_file)
        print('add:')
        if cmake_cpp - gn_cpp:
            for s in cmake_cpp - gn_cpp:
                print('    "%s",' % s)
        if gn_cpp - cmake_cpp:
            print('remove:')
            for s in gn_cpp - cmake_cpp:
                print(s)
        print()

if __name__ == '__main__':
    main()
