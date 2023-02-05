#!/usr/bin/env python

"""Generates a validation configuration file from JSON struct data"""

# Note:  This is written in Python instead of Julia because the Julia YAML
# package does not support writing (only reading).

import json
import os
import sys
from collections import OrderedDict

#import yaml

def read_json_data(filename):
    """Return the JSON data from a file."""
    with open(filename) as fp_in:
        return json.load(fp_in)


def generate_config(input_file):
    """Generate validation descriptors from the PowerSystems struct data file."""
    config = {}
    data = read_json_data(input_file)
    items = []

    for ps_struct in data["auto_generated_structs"]:
        new_struct = OrderedDict()
        new_struct["struct_name"] = ps_struct["struct_name"]
        new_struct["fields"] = []
        for field in ps_struct["fields"]:
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
    return {"auto_generated_structs": items}


def generate_file(input_file, output_file):
    """Generate validation descriptors from the PowerSystems struct data file."""
    config = generate_config(input_file)
    with open(output_file, "w") as fp_out:
        #yaml.dump(config, fp_out, vspacing=True)
        json.dump(config, fp_out, indent=4)

    print("Generated {} from {}".format(output_file, input_file))


def main():
    """Controls execution."""
    if len(sys.argv) != 3:
        example = "python bin/{} src/descriptors/power_system_structs.json validation.json".format(
            os.path.basename(__file__)
        )
        print("Usage: {} input_file output_file\nExample:  {}".format(
            os.path.basename(__file__), example)
        )
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]
    generate_file(input_file, output_file)


if __name__ == "__main__":
    main()
