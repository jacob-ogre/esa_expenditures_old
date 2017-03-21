# Mainly just split out species names and pops from budget tables. 
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
    def __init__(self, line):
        super(Record, self).__init__()
        self.line = line.replace("'", "")
        self.data = self.line.rstrip().split("\t")
        if len(self.data) > 1:
            self.rank = self.data[0]
            self.sp_info = self.data[1]
            self.stat = self.data[2]
            self.FWS_tot = self._fix_dollars(self.data[3])
            self.other_fed_tot = self._fix_dollars(self.data[4])
            self.fed_tot = self._fix_dollars(self.data[5])
            self.state_tot = self._fix_dollars(self.data[6])
            self.total = self._fix_dollars(self.data[7])

            self.common, self.sci, self.pop = self._get_species(self.sp_info)
            self.new_dat = [self.rank, self.common, self.sci, self.pop, self.stat,
                            self.FWS_tot, self.other_fed_tot, self.fed_tot, 
                            self.state_tot, self.total]
            self.newl = "\t".join(self.new_dat) + "\n"
        else:
            self.new_dat = 10 * ["NA"]
            self.newl = "\t".join(self.new_dat) + "\n"
               
    def _fix_dollars(self, x):
        return x.replace("$", "").replace(",", "")

    def _get_species(self, x):
        if x.count("(") == 1:
            if " (" in x:
                split1 = x.split(" (")
            else:
                split1 = x.split("(")
            common = split1[0]
            split2 = split1[1].split(")")
            scient = split2[0]
            pop = split2[1]
            return common, scient, pop
        elif x.count("(") > 1:
            opens = [i for i, letter in enumerate(x) if letter == "("]
            common = x[:opens[0]-1]
            close = [i for i, letter in enumerate(x) if letter == ")"]
            scient = x[opens[0]+1:close[-1]]
            pop = x[close[-1]:]
            return common, scient, pop
        else:
            return "NA", x.replace(')', ''), "NA"

def main():
    """Split out species names and pops from budget tables.
    
    USAGE
        python clean_FY12_all_exp.py <infile> <outfil>
    ARGS
        infile, path to the input expenditures file, tab'd
        outfil, path to the tab'd output
    """
    with open(outfil, 'wb') as out:
        for line in open(infile):
            if line.startswith("Group"):
                head_dat = ["Year", "Group", "Rank", "Common", "Scientific", 
                            "Population", "Status", "FWS_tot", "other_fed", 
                            "Fed_tot", "State_tot", "Species_tot"]
                out.write("\t".join(head_dat) + "\n")
            else:
                rec = Record(line)
                if len(rec.new_dat) != 10:
                    print rec.new_dat
                    sys.exit()
                out.write(rec.newl)

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print main.__doc__
        sys.exit()
    infile = sys.argv[1]
    outfil = sys.argv[2]
    main()
