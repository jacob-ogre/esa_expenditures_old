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
        self.line = line.replace("'", "").replace('"', '')
        self.data = self.line.rstrip().split("\t")
        if len(self.data) > 1:
            self.year = self.data[0]
            self.group = self.data[1]
            if self.group == "Multi-species":
                self.rank = ""
                self.common_group = ""
                self.common_spec = ""
                self.common_alt = ""
                self.genus = ""
                self.species = ""
                self.subsp = ""
                self.popn = ""
                self.stat = ""
                self.FWS_tot = self._fix_dollars(self.data[5])
                self.other_fed_tot = self._fix_dollars(self.data[6])
                self.fed_tot = self._fix_dollars(self.data[7])
                self.state_tot = self._fix_dollars(self.data[8])
                self.total = self._fix_dollars(self.data[9])
            else:
                self.rank = self.data[2]
                self.sp_info = self.data[3]
                self.stat = self.data[4].strip().replace("*", "").replace("`","")
                if "EXP N" in self.stat:
                    self.stat = "EXPN"
                self.FWS_tot = self._fix_dollars(self.data[5])
                self.other_fed_tot = self._fix_dollars(self.data[6])
                self.fed_tot = self._fix_dollars(self.data[7])
                self.state_tot = self._fix_dollars(self.data[8])
                self.total = self._fix_dollars(self.data[9])
                self._get_species()

            self._make_newl()                
        else:
            self.new_dat = 18 * ["NA"]
            self.newl = "\t".join(self.new_dat) + "\n"

        # catch some common OCR errors
        if "1" in self.species:
            self.species.replace("1", "i")
        if "/" in self.species:
            self.species.replace("/", "l")

    def _make_newl(self):
        "Combine elements to get the new line to write."
        self.common = self.common_group + ", " + self.common_spec
        if self.group == "Multi-species":
            self.common = ""
        if self.common_spec == "":
            self.common = self.common_group
        if self.common_alt != "":
            self.common = self.common + " " + self.common_alt

        self.sci = " ".join([self.genus, self.species])
        if self.subsp != "":
            self.sci = " ".join([self.genus, self.species, self.subsp])

        self.new_dat = [self.year, self.group, self.rank, self.common, self.sci, 
                        self.common_group, self.common_spec, self.common_alt,
                        self.genus, self.species, self.subsp,
                        self.popn, self.stat, self.FWS_tot, self.other_fed_tot, 
                        self.fed_tot, self.state_tot, self.total]
        self.newl = "\t".join(self.new_dat) + "\n"


    def _fix_dollars(self, x):
        return x.replace("$", "").replace(",", "")

    def _get_species(self):
        """Parse the species information column.

        The annual expenditure reports group taxonomic and population info
        in a single column. The variation between species spans 23 patterns:
            plain = Group, specific (Genus species)
            plain_multi = Group, specific1...specificN (Genus species)
            group_multi = Group1...groupN, specific (Genus species)
            plain_ssp = Group, specific (Genus species ssp)
            plain_var = Group, specific (Genus species var/ssp ssp)
            common_alt = Group, specific (alt_common) (Genus species)
            common_alt_2 = Group, specific 'or' alt_common (Genus species)
            common_alt_3 = Group, specific (=(alt),alt2(alt3)) (Genus species)
            common_alt_4 = Group, specific1...specificN (=alt) (Genus species)
            common_alt_5 = Group (=alt), specific (Genus species)
            one_common = Name (Genus species)
            one_common_alt = Name (alt_common) (Genus species)
            one_common_two_part = Name1 name2 (Genus species)
            with_pop = Group, specific (Genus species) - Population
            missing_pop = Group, specific (Genus species) - 
            genus_syn = Group, specific (Genus (=Syn) species)
            genus_syn_2 = Group, specific (Genus (=Syn) species ssp)
            species_syn = Group, specific (Genus species (=sp_syn))
            ssp_syn = Group, specific (Genus species ssp (=ssp_syn))
            no_common = Genus species ('=Sci name')
            no_common2 = 'No Common Name' (Genus species)
            multi_include = Group, specific (include1) (Genus sp (include2))
            multispecies = NA [I had to make this one for > 2011]
            ...and three more that put popn information between common and sci
        
        This function is an attempt to extract and assign the information 
        correctly for better analysis.
        """
        self._get_popn_split()
        self._parse_taxo_info()

    def _get_popn_split(self):
        "Get the taxonomic info and population string, if present; else popn=''."
        self.close_idx = self._find_indices(self.sp_info, ")")
        trail_text = []
        if len(self.close_idx) > 0:
            trail_text = self.sp_info[(self.close_idx[-1] + 1):]
        if (" - " in self.sp_info) or (self.sp_info.endswith("-")):
            pop_split = self.sp_info.split(" - ")
            self.taxo_info, self.popn = pop_split[0], pop_split[1]
        elif len(trail_text) > 3:
            self.taxo_info = self.sp_info[:(self.close_idx[-1] + 1)]
            self.popn = trail_text
        else:
            self.taxo_info, self.popn = self.sp_info, ""
        
    def _parse_taxo_info(self):
        "Top-level function for parsing the taxonomic information."
        # In processing parentheses, check first if a typo case
        if self.taxo_info.count("(") == 1 and self.taxo_info.count(")") == 0:
            self.taxo_split = self.taxo_info.split(" (")
            self.comm_info = self.taxo_split[0] 
            self.genus = self.taxo_info[1]
            self.species, self.subsp = "", ""
            self._parse_common_info()

        # Case one set of parentheses:
        elif self.taxo_info.count("(") == 1 and self.taxo_info.count(")") == 1:
            self.taxo_split = self.taxo_info.split(" (")
            self.comm_info = self.taxo_split[0]
            if "=Sci name" in self.taxo_split[1]:
                self.common_group = "No Common Name"
                self.common_spec = ""
                self.common_alt = ""
                self.sci_info = self.taxo_split[0].strip(")").rstrip().split(" ")
                self._parse_scientific_info()
            else:
                self.sci_info = self.taxo_split[1].strip(")").rstrip().split(" ")
                self._parse_scientific_info()
                self._parse_common_info()

        # Case two sets of parentheses
        elif self.taxo_info.count("(") == 2 and self.taxo_info.count(")") == 2:
            self.open_idx = self._find_indices(self.taxo_info, "(")
            self.close_idx = self._find_indices(self.taxo_info, ")")
            if self.open_idx[1] > self.close_idx[0] and \
                    self.open_idx[1] - self.close_idx[0] > 3:
                self.comm_info = self.taxo_info[:(self.open_idx[1] - 1)]
                self.sci_info = self.taxo_info[(self.open_idx[1] + 1):-1].split(" ")
                self._parse_common_info()
                self._parse_scientific_info()
            elif self.open_idx[1] > self.close_idx[0] and \
                    self.open_idx[1] - self.close_idx[0] <= 3:
                self.taxo_split = self.taxo_info.split(" (")
                self.comm_info = self.taxo_split[0]
                self._parse_common_info()
                self.common_alt = "(" + self.taxo_split[1]
                self.sci_info = self.taxo_split[2].strip(")").rstrip().split(" ")
                self._parse_scientific_info()
            else:
                self.comm_info = self.taxo_info[:(self.open_idx[0] - 1)]
                self.sci_info = self.taxo_info[(self.open_idx[0] + 1):-1]
                self._parse_common_info()
                self._parse_complex_sci()
        
        # Case either zero, or more than two sets of, parentheses:
        else:
            if self.taxo_info.count("(") == 0 and self.taxo_info.count(")") == 0:
                self.comm_info = self.taxo_info
                self._parse_common_info()
                self.genus = ""
                self.species = ""
                self.subsp = ""
            else:
                self.open_idx = self._find_indices(self.taxo_info, "(")
                self.close_idx = self._find_indices(self.taxo_info, ")")
                if self.open_idx[1] - self.close_idx[0] < 3:
                    self.comm_info = self.taxo_info[:(self.open_idx[0] - 1)]
                    self.sci_info = self.taxo_info[(self.open_idx[0] + 1):]
                    self._parse_common_info()
                    self._parse_scientific_info()
                else:
                    self.comm_info = self.taxo_info[:(self.open_idx[1] - 1)]
                    self.sci_info = self.taxo_info[(self.open_idx[1] + 1):-1].split(" ")
                    self._parse_common_info()
                    self._parse_scientific_info()

    def _parse_scientific_info(self):
        "Parse scientific name information for base case (simple)."
        self.genus = self.sci_info[0]
        self.species = self.sci_info[1]
        if len(self.sci_info) == 2:
            self.subsp = ""
        else:
            self.subsp = " ".join(self.sci_info[2:])

    def _parse_complex_sci(self):
        "Parse scientific name information with nested parentheses."
        sci_split = self.sci_info.split(" ")
        self.genus = sci_split[0]
        if self.sci_info.endswith(")"):
            self.species = sci_split[1]
            if sci_split[2].startswith("("):
                self.species = self.species + sci_split[2]
                self.subsp = ""
            else:
                self.subsp = " ".join(sci_split[2:])
        elif sci_split[1].startswith("("):
            self.genus = self.genus + " " + sci_split[1]
            self.species = sci_split[2]
            try:
                if len(sci_split) > 3 and sci_split[3].startswith("("):
                    self.species = self.species + sci_split[3]
                    self.subsp = ""
                else:
                    self.subsp = " ".join(sci_split[3:])
            except:
                print self.line
                print sci_split
        else:
            self.genus = " ".join(sci_split[:2])
            self.species = sci_split[2]
            if len(sci_split) > 3:
                self.subsp = sci_split[-1]
            else:
                self.subsp = ""

    def _parse_common_info(self):
        "Set common group, specific, and alternate elements."
        if "," not in self.comm_info or "No Common Name" in self.comm_info:
            self.common_group = self.comm_info
            self.common_alt = ""
            self.common_spec = ""
        else:
            self.comm_split = self.comm_info.split(", ")
            self.common_group = self.comm_split[0]
            self.common_spec = ""
            if len(self.comm_split) > 1:
                self.common_spec = self.comm_split[1]
            self.common_alt = ""
    
    def _find_indices(self, s, x):
        "Return a list of index position of all char x in string s."
        return [i for i, ltr in enumerate(s) if ltr == x]


def main():
    """Split out species names and pops from budget tables.
    
    USAGE
        python clean_FY12_all_exp.py <infile> <outfil>
    ARGS
        infile, path to the input expenditures file, tab'd
        outfil, path to the tab'd output
    """
    with open(outfil, 'wb') as out:
        for line in open(infile, 'rU'):
            if line.startswith("Year"):
                head_dat = ["Year", "Group", "Rank", "Common", "Scientific", 
                            "Common_group", "Common_specific", "Common_alt",
                            "Genus", "Species", "Subspecies",
                            "Population", "Status", "FWS_tot", "other_fed", 
                            "Fed_tot", "State_tot", "Species_tot"]
                out.write("\t".join(head_dat) + "\n")
            else:
                rec = Record(line)
                if len(rec.new_dat) != 18:
                    print rec.line
                    print rec.new_dat
                    print rec.newl
                    sys.exit()
                out.write(rec.newl)

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print main.__doc__
        sys.exit()
    infile = sys.argv[1]
    outfil = sys.argv[2]
    main()
