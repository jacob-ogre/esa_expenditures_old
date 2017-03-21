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

from expenditures import StateRecord as states
from species_names import LookupNames as look
import sys


def main():
    """Standardize species names in state expenditure files."""
    lookup = look(stdfil)
    with open(outfil, 'w') as out:
        for line in open(infile):
            if not line.startswith("State"):
                rec = states(line)
                if rec.group != "Multi-Species":
                    found_common = lookup.find_by_scientific(rec.sci)
                    if found_common != "No match":
                        rec.common = found_common.common
                        rec.make_newline()
                        out.write(rec.newl)
                    else:
                        # this is an ugly hack...
                        print rec.sci, rec.common
                        if "Setophaga kirtlandii" in rec.sci:
                            rec.sci = "Setophaga kirtlandii"
                        print rec.sci, rec.common
                        rec.make_newline()
                        out.write(rec.newl)
                else:
                    out.write(rec.line)
            else:
                out.write(line)


if __name__ == '__main__':
    if len(sys.argv) != 4:
        print main.__doc__
        sys.exit()
    infile = sys.argv[1]
    stdfil = sys.argv[2]
    outfil = sys.argv[3]
    main()
