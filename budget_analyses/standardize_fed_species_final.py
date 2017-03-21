# Standardize speices names in state expenditure files against std name table.
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

from expenditures import RefinedRecord as Record
from species_names import LookupNames as look
import sys


def main():
    """Standardize species names in Cong. report expenditure files."""
    lookup = look(stdfil)
    with open(outfil, 'w') as out:
        for line in open(infile):
            if not line.startswith("Year"):
                rec = Record(line)
                if rec.group != "Multi-Species":
                    found_common = lookup.find_by_scientific(rec.sci)
                    if found_common != "No match":
                        rec.common = found_common.common
                        fix_capital(rec)
                        rec.make_newline()
                        out.write(rec.newl)
                    else:
                        print rec.sci, rec.common
                else:
                    out.write(rec.line)
            else:
                out.write(line)

def fix_capital(r):
    if r.group != "Multi-species":
        r.comm_group = r.comm_group[0].upper() + r.comm_group[1:]

if __name__ == '__main__':
    if len(sys.argv) != 4:
        print main.__doc__
        sys.exit()
    infile = sys.argv[1]
    stdfil = sys.argv[2]
    outfil = sys.argv[3]
    main()

