# Identify common and scientific names that may be synonymous.
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
import itertools
import string
import sys


def main():
    """Identify common and scientific names that may be synonymous.

    USAGE
        python homogenize_names_fed_spending.py <infile> <comout> <sciout>
    ARGS
        infile, path to a clean, expanded expenditure file (tab'd)
        comout, path to tab'd output file of highly similar common names
        sciout, path to tab'd output file of highly similar scientific names
    """
    common_set, sci_set = set(), set()
    for line in open(infile, 'rU'):
        if not line.startswith("Year"):
            rec = Record(line)
            common_set.add(rec.common)
            sci_set.add(rec.sci)
    print "Num. unique common: %s", len(common_set)
    print "Num. unique scientific: %s", len(sci_set)
    find_write_diffs(common_set, comout, 3)
    find_write_diffs(sci_set, sciout, 5)

def find_write_diffs(cur_set, outf, delta):
    "Process pairs of names in cur_set to identify likely synonymous spp."
    with open(outf, 'w') as out:
        for i, j in itertools.combinations(cur_set, 2):
            if len(i) > 1 and len(j) > 1:
                big, n_diff = calculate_count_difference(i, j, delta)
                if not big:
                    data = [i, j, "simple_diff", str(n_diff)]
                    out.write("\t".join(data) + "\n")
                    if n_diff == 0:
                        print "Letter swap?"
                        print i, "\t", j
                elif (i in j) or (j in i) and big:
                    data = [i, j, "subset_diff", str(n_diff)]
                    out.write("\t".join(data) + "\n")
                elif big:
                    test_name_parts(i, j, out)

def calculate_count_difference(i, j, delta):
    "Tally the number of character differences between set elements i, j."
    dic_i = dict.fromkeys(string.printable)
    dic_j = dict.fromkeys(string.printable)
    for l in dic_i:
        dic_i[l] = i.count(l)
        dic_j[l] = j.count(l)

    res = {}
    for l in dic_i:
        res[l] = abs(dic_i[l] - dic_j[l])
        if sum(res.values()) > delta:
            return True, sum(res.values())
    return False, sum(res.values())

def test_name_parts(i, j, out):
    "Check if there is extra info in the names of i or j and write to file."
    i_split = i.split(" ")
    j_split = j.split(" ")
    if len(i_split) != len(j_split): 
        n_part_match = 0
        for x, y in itertools.product(i_split, j_split):
            if x == y:
                n_part_match += 1
        shorter = min([len(i_split), len(j_split)])
        longest = max([len(i_split), len(j_split)])
        if shorter == n_part_match and \
                not same_ssp(i_split) and \
                not same_ssp(j_split):
            data = [i, j, "part_diff", str(longest - n_part_match)]
            out.write("\t".join(data) + "\n")

def same_ssp(x):
    "Return true if two names within x are identical."
    for i, j in itertools.combinations(x, 2):
        if i == j:
            return True
    return False


if __name__ == '__main__':
    if len(sys.argv) != 4:
        print main.__doc__
        sys.exit()
    infile = sys.argv[1]
    comout = sys.argv[2]
    sciout = sys.argv[3]
    main()
