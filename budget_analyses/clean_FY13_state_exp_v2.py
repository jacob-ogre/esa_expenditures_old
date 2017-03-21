# Make the FY2012 Endangered Species state-wise tables more useable.
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

class Record(object):
    """docstring for Record"""
    def __init__(self, line, cumul):
        super(Record, self).__init__()
        self.line = line.replace("'", "").replace("#", "Num.").replace("  ", " ")
        self.data = self.line.rstrip().split("\t")
        self.state = self.data[0].strip()
        self.year = self.data[1]
        self.group = self.data[2].strip()
        self.scientific = self.data[3].strip()
        self.common = self.parse_common_name(self.data[4])
        self.population = self.data[5]
        self.general_exp = int(self.data[6])
        self.land_exp = int(self.data[7])
        self.total_exp = int(self.data[8])

        if self.total_exp != self.general_exp + self.land_exp:
            print "Addition error!"
            print self.line
            sys.exit()
        self.cumulative_tot = self.total_exp + cumul

    def parse_common_name(self, dat):
        if "(" in dat:
            new = dat.split(" (")
            if len(new[0].split(" ")) > 1:
                new_lead = self._reorder(new[0].split(" "))
                new_paren = "(" + new[-1]
                return new_lead + " " + new_paren 
            else:
                return dat
        elif len(dat.strip().split(" ")) == 1:
            return dat
        else:
            new = dat.split(" ")
            return self._reorder(new)

    def _reorder(self, x):
        x = [a for a in x if a != ""]
        lead = x[-1][0].upper() + x[-1][1:] + ","
        suf_first = x[0].lower()
        tail = " ".join(x[1:-1])
        return " ".join([lead, suf_first, tail]).replace("  ", " ")
            
def main():
    """Make the FY2012 Endangered Species state-wise tables more useable."""
    cur_state = "Alabama"
    cur_cumex = 0
    with open(outfil, 'wb') as out:
        for line in open(infile, 'rU'):
            if line.startswith("State"):
                head_dat = ["State", "FY", "Group_Name", "Common_Name", 
                            "Scientific_Name", "Population", 
                            "General_Expenditures", "Land_Expenditures", 
                            "Grand_Total", "State_cumulative"]
                out.write("\t".join(head_dat) + "\n")
            elif not line.lstrip()[0].isdigit():
                rec = Record(line, cur_cumex)

                if rec.state != cur_state and rec.state != "":
                    cur_state = rec.state
                    rec.cumulative_tot = rec.total_exp
                    cur_cumex = rec.cumulative_tot
                elif rec.state == "":
                    rec.state = cur_state
                    cur_cumex = rec.cumulative_tot
                elif rec.state == cur_state:
                    cur_cumex = rec.cumulative_tot

                new_dat = [rec.state, rec.year, rec.group, rec.common, 
                           rec.scientific, rec.population, str(rec.general_exp), 
                           str(rec.land_exp), str(rec.total_exp), 
                           str(rec.cumulative_tot)]
                newl = "\t".join(new_dat) + "\n"
                out.write(newl)
            else:
                pass

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print main.__doc__
        sys.exit()
    infile = sys.argv[1]
    outfil = sys.argv[2]
    main()











