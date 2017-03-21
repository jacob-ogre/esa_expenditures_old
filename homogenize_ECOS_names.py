# -*- coding: utf-8 -*-
# Match the species names in ECOS county data to standard names references.
# Copyright © 2015 Defenders of Wildlife, jmalcom@defenders.org

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

from ECOS_county_data import SpeciesCountyRec as SC
from species_names import StandardNames as SN
from species_names import LookupNames as look
import sys

def main():
    """Match the species names in ECOS county data to standard names references.

    USAGE
        python homogenize_ECOS_names.py <std_names> <county_sp> <outfile>
    ARGS
        std_names, path to our standardized table of species names
        county_sp, path to the file of species' county occurrences
        outfile, path to the updated county_sp file with standard names
    """
    stdname = look(std_names)
    with open(std_names, 'a') as newstd:
        with open(outfile, 'w') as out:
            for line in open(county_sp):
                if not line.startswith("abbrev"):
                    rec = SC(line)
                    cur_name = stdname.find_by_scientific(rec.sci)
                    tmp = rec.common.split(" - ")[0]
                    reftmp = cur_name.common.split(" - ")[0]
                    if cur_name == "No match":
                        new_name = make_new_std_name(rec)
                        newstd.write(new_name)
                        out.write(rec.line)
                    elif reftmp != tmp:
                        rec.data[4] = cur_name.common
                        newl = "\t".join(rec.data) + "\n"
                        out.write(newl)
                    else:
                        out.write(line)
                else:
                    out.write(line)

def make_new_std_name(rec):
    common = rec.common[0].upper() + rec.common[1:]
    com_group = common.split(", ")[0]
    com_specific = " ".join(common.split(", ")[1:])
    com_alt = ""
    sci_parts = rec.sci.split(" ")
    genus = sci_parts[0]
    species = sci_parts[1]
    if len(sci_parts) > 2:
        subsp = sci_parts[2]
    else:
        subsp = ""
    new_rec = [common, rec.sci, com_group, com_specific, com_alt, genus,
               species, subsp]
    return "\t".join(new_rec) + "\n"


if __name__ == '__main__':
    if len(sys.argv) != 4:
        print main.__doc__
        sys.exit()
    std_names = sys.argv[1]
    county_sp = sys.argv[2]
    outfile = sys.argv[3]
    main()
