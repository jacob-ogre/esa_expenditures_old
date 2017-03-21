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
        self.line = line
        self.data = self.line.rstrip().split(" ")
        self.state = self.data[0]
        self.year = self.data[1]
        self.group = self.data[2]
        if self.group.startswith("Flowering"):
            self.group = self.data[2] + " " + self.data[3]
            self.genus = self.data[4]
            self.genus_syn = ""
            if self.data[5].startswith("("):
                self.genus_syn = self.data[5]
                self.species = self.data[6]
                self.species_syn = ""
                if self.data[7].startswith("("):
                    self.species_syn = self.data[7]
                    self.common_range = self.data[8:-3]
                    self.process_comm_range(self.common_range)
                    self.general_exp = int(self.data[-3].replace(",", ""))
                    self.land_exp = int(self.data[-2].replace(",", ""))
                    self.total_exp = int(self.data[-1].replace(",", ""))
                else:
                    self.common_range = self.data[7:-3]
                    self.process_comm_range(self.common_range)
                    self.general_exp = int(self.data[-3].replace(",", ""))
                    self.land_exp = int(self.data[-2].replace(",", ""))
                    self.total_exp = int(self.data[-1].replace(",", ""))
            else:
                self.species = self.data[5]
                self.species_syn = ""
                if self.data[6].startswith("("):
                    self.species_syn = self.data[6]
                    self.common_range = self.data[7:-3]
                    self.process_comm_range(self.common_range)
                    self.general_exp = int(self.data[-3].replace(",", ""))
                    self.land_exp = int(self.data[-2].replace(",", ""))
                    self.total_exp = int(self.data[-1].replace(",", ""))
                else:
                    self.common_range = self.data[6:-3]
                    self.process_comm_range(self.common_range)
                    self.general_exp = int(self.data[-3].replace(",", ""))
                    self.land_exp = int(self.data[-2].replace(",", ""))
                    self.total_exp = int(self.data[-1].replace(",", ""))
        else:
            self.genus = self.data[3]
            self.genus_syn = ""
            if self.data[4].startswith("("):
                self.genus_syn = self.data[4]
                self.species = self.data[5]
                self.species_syn = ""
                if self.data[6].startswith("("):
                    self.species_syn = self.data[6]
                    self.common_range = self.data[7:-3]
                    self.process_comm_range(self.common_range)
                    self.general_exp = int(self.data[-3].replace(",", ""))
                    self.land_exp = int(self.data[-2].replace(",", ""))
                    self.total_exp = int(self.data[-1].replace(",", ""))
                else:
                    self.common_range = self.data[6:-3]
                    self.process_comm_range(self.common_range)
                    self.general_exp = int(self.data[-3].replace(",", ""))
                    self.land_exp = int(self.data[-2].replace(",", ""))
                    self.total_exp = int(self.data[-1].replace(",", ""))
            else:
                self.species = self.data[4]
                self.common_range = self.data[5:-3]
                self.process_comm_range(self.common_range)
                self.general_exp = int(self.data[-3].replace(",", ""))
                self.land_exp = int(self.data[-2].replace(",", ""))
                self.total_exp = int(self.data[-1].replace(",", ""))

        if self.total_exp != self.general_exp + self.land_exp:
            print "Addition error!"
            print self.line
            sys.exit()
        self.cumulative_tot = self.total_exp + cumul

    def process_comm_range(self, x):
        self.subsp = ""
        if len(x) == 1:
            self.common = x[0]
            self.population = ""
        elif len(x) == 2:
            self.common = x[1][0].upper() + x[1][1:] + ", " + x[0][0].lower() + x[0][1:]
            self.population = ""
        elif not x[0][0].isupper() and \
                not x[0][0].startswith("var.") and \
                not x[0][0].startswith("ssp"):
            self.subsp = x[0]
            self.common = x[2][0].upper() + x[2][1:] + ", " + x[1][0].lower() + x[1][1:]
            self.population = " ".join(x[3:])
        elif not x[0][0].isupper() and \
                x[0][0].startswith("var.") or \
                x[0][0].startswith("ssp"):
            self.subsp = x[0] + " " + x[1]
            self.common = x[3][0].upper() + x[3][1:] + ", " + x[2][0].lower() + x[2][1:]
            self.population = " ".join(x[4:])
        else:
            self.common = x[1][0].upper() + x[1][1:] + ", " + x[0][0].lower() + x[0][1:]
            self.population = " ".join(x[2:])

def main():
    """Make the FY2012 Endangered Species state-wise tables more useable."""
    skips = ["Locality", "*FY2012*", "Total", "Domestic subtotal"]
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

                new_dat = [rec.state, rec.year, rec.group, 
                           rec.common, 
                           " ".join([rec.genus, rec.species, rec.subsp]),
                           rec.population, str(rec.general_exp), 
                           str(rec.land_exp), str(rec.total_exp), 
                           str(rec.cumulative_tot)]
                newl = "\t".join(new_dat) + "\n"
                out.write(newl)
            else:
                pass
                # print "skipped the elif"
                # print line
                
if __name__ == '__main__':
    if len(sys.argv) != 3:
        print main.__doc__
        sys.exit()
    infile = sys.argv[1]
    outfil = sys.argv[2]
    main()











