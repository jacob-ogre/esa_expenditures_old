# Use 2008-2013 expenditures report to make a single table of common, sci names.
# Copyright (C) 2015 Defenders of Wildlife, jmalcom@defenders.org

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.

import sys

def main():
    """
    """
    names = {}
    with open(outfil, 'w') as out:
        for line in open(infile, 'rU'):
            if not line.startswith("Year"):
                data = line.rstrip().split("\t")
                if data[3] in names:
                    names[data[3]].add(data[4])
                else:
                    names[data[3]] = set([data[4]])

    for i in names:
        if len(names[i]) > 1:
            print i, names[i]

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print main.__doc__
        sys.exit()
    infile = sys.argv[1]
    outfil = sys.argv[2]
    main()
