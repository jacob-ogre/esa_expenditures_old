# Use 2008-2013 expenditure table to generate a single common, sci name reference.
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
import sys


def main():
    """Create a tab'd table of 'standardized' common and scientific names."""
    scis = set()
    res = set()
    for line in open(infile):
        rec = Record(line)
        if rec.sci not in scis:
            scis.add(rec.sci)
            update_capitals(rec)
            res.add((rec.common, rec.sci, rec.comm_group, rec.comm_spec, 
                     rec.comm_alt, rec.genus, rec.species, rec.ssp))

    with open(outfil, 'w') as out:
        head = ["Common", "Scientific", "Common_group", "Common_specific",
                "Common_alt", "Genus", "Species", "Subspecies"]
        out.write("\t".join(head) + "\n")
        for i in res:
            out.write("\t".join(i) + "\n")

def update_capitals(r):
    if r.group != "Multi-species" and not r.common[0].isupper():
        r.common = r.common[0].upper() + r.common[1:]
        r.comm_group = r.comm_group[0].upper() + r.comm_group[1:]

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print main.__doc__
        sys.exit()
    infile = sys.argv[1]
    outfil = sys.argv[2]
    main()
        
        

