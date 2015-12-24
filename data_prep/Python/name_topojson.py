import json
from pprint import pprint as pp

def main():
    with open("US_counties_5e4_topo.json") as fil:
        data = json.load(fil)

    # pp(data)
    print len(data)
    print data.keys()
    print data["objects"].keys()
    print data["objects"]["tl_2015_us_county"].keys()
    print len(data["objects"]["tl_2015_us_county"]["geometries"])
    print data["objects"]["tl_2015_us_county"]["geometries"][1000]

if __name__ == '__main__':
    main()
