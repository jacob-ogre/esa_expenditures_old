# Use tables of good:bad names to update the semi-clean expenditure tables.
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
    def __init__(self, line, com, sci):
        super(Record, self).__init__()
        self.line = line.replace('"', "")
        self.data = self.line.strip().split("\t")
        self.common= self.data[3]
        self.sci = self.data[4]
        
        if self.data[3] in com:
            self.data[3] = com[self.data[3]]
        if self.data[4] in sci:
            self.data[4] = sci[self.data[4]]

        self.newl = "\t".join(self.data) +"\n"

def main():
    """
    """
    com_dat = load_lookup(com_fil)
    sci_dat = load_lookup(sci_fil)
    with open(outfil, 'w') as out:
        for line in open(infile, 'rU'):
            rec = Record(line, com_dat, sci_dat)
            out.write(rec.newl)

def load_lookup(f):
    res = {}
    for line in open(f, 'rU'):
        data = line.rstrip().replace('"', '').split("\t")
        res[data[1]] = data[0]
    return res

if __name__ == '__main__':
    if len(sys.argv) != 5:
        print main.__doc__
        sys.exit()
    com_fil = sys.argv[1]
    sci_fil = sys.argv[2]
    infile = sys.argv[3]
    outfil = sys.argv[4]
    main()

