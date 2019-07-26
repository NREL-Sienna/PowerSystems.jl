#!/usr/bin/env python

"""Generates a validation configuration file from JSON struct data"""

# Note:  This is written in Python instead of Julia because the Julia YAML
# package does not support writing (only reading).

import json
import os
import sys
import pdb
from collections import OrderedDict


import yaml


POWER_SYSTEM_DESCRIPTOR_FILE = os.path.join(
    "src",
    "descriptors",
    "power_system_structs.json"
)

def setup_yaml():
  """ https://stackoverflow.com/a/8661021 """
  represent_dict_order = lambda self, data:  self.represent_mapping('tag:yaml.org,2002:map', data.items())
  yaml.add_representer(OrderedDict, represent_dict_order)
setup_yaml()

def read_json_data(filename):
    """Return the JSON data from a file."""
    with open(filename) as fp_in:
        return json.load(fp_in)


def generate_config(input_file):
    """Generate validation descriptors from the PowerSystems struct data file."""
    config = {}
    data = read_json_data(input_file)
    items=[]
    #structName = str()
    for struct in data:
        # new_struct = {"struct_name":struct["struct_name"], "fields":[]}
        new_struct = OrderedDict()
        new_struct["struct_name"] = struct["struct_name"]
        new_struct["fields"] = []
        for field in struct["fields"]:
            new_field = OrderedDict()
            new_field["name"] = field["name"]
            if "data_type" in field:
                new_field["data_type"] = field["data_type"]
            if "valid_range" in field:
                new_field["valid_range"] = field["valid_range"]
            if "validation_action" in field:
                new_field["validation_action"] = field["validation_action"]
            new_struct["fields"].append(new_field)
        items.append(new_struct)
    return items

def generate_file(output_file, input_file=POWER_SYSTEM_DESCRIPTOR_FILE):
    """Generate validation descriptors from the PowerSystems struct data file."""
    config = generate_config(input_file)
    with open(output_file, "w") as fp_out:
        yaml.dump(config, fp_out, default_flow_style=False)

    print("Generated {} from {}".format(output_file, input_file))


def main():
    """Controls execution."""
    if len(sys.argv) != 2:
        print("Usage: {} output_file".format(os.path.basename(__file__)))
        sys.exit(1)

    generate_file(sys.argv[1])


if __name__ == "__main__":
    main()
