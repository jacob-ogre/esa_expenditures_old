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
        self.data = self.line.rstrip().split("\t")
        self.state = self.data[0]
        self.local = self.data[1]
        self.group = self.data[2]
        self.commn = self.data[3].replace('"', '')
        self.scien = self.data[4]
        self.popln = self.data[5].replace('"', '')
        self.genex = int(self.data[6].replace('"', '').replace("$", "").replace(",", ""))
        self.landx = int(self.data[7].replace('"', '').replace("$", "").replace(",", ""))
        self.total = int(self.data[8].replace('"', '').replace("$", "").replace(",", ""))
        if self.total != self.genex + self.landx:
            print "Addition error!"
            print self.line
            sys.exit()
        self.cumulative_tot = self.total + cumul

def main():
    """Make the FY2012 Endangered Species state-wise tables more useable."""
    skips = ["Locality", "*FY2012*", "Total", "Domestic subtotal"]
    cur_state = "Alabama"
    cur_local = "Domestic"
    cur_group = "Mammals"
    cur_cumex = 0
    with open(outfil, 'wb') as out:
        for line in open(infile):
            tmp = line.split("\t")
            if line.startswith("State"):
                out.write(line)
            elif (tmp[1] not in skips) and \
                    ("subtotal" not in tmp[2]) and \
                    (not tmp[1].endswith("--")):
                rec = Record(line, cur_cumex)

                if rec.state != cur_state and rec.state != "":
                    cur_state = rec.state
                    rec.cumulative_tot = rec.total
                    cur_cumex = rec.cumulative_tot
                elif rec.state == "":
                    rec.state = cur_state
                    cur_cumex = rec.cumulative_tot
                elif rec.state == cur_state:
                    cur_cumex = rec.cumulative_tot

                if rec.local != cur_local and rec.local != "":
                    cur_state = rec.local
                elif rec.local == "":
                    rec.local = cur_local

                if rec.group != cur_group and rec.group != "":
                    cur_group = rec.group
                elif rec.group == "":
                    rec.group = cur_group

                new_dat = [rec.state, rec.local, rec.group, rec.commn, 
                           rec.scien, rec.popln, str(rec.genex), str(rec.landx),
                           str(rec.total), str(rec.cumulative_tot)]
                newl = "\t".join(new_dat) + "\n"
                out.write(newl)
            elif tmp[1].endswith("--"):
                cur_state = tmp[1].replace(" --", "")
                cur_cumex = 0
            else:
                pass
                
if __name__ == '__main__':
    if len(sys.argv) != 3:
        print main.__doc__
        sys.exit()
    infile = sys.argv[1]
    outfil = sys.argv[2]
    main()











