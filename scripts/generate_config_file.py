#!/usr/bin/env python

"""Generates a user descriptor file for parsing power system raw data."""

# Note:  This is written in Python instead of Julia because the Julia YAML
# package does not support writing (only reading).

import json
import os
import sys

import yaml


POWER_SYSTEM_DESCRIPTOR_FILE = os.path.join(
    "src",
    "descriptors",
    "power_system_inputs.json"
)


def read_json_data(filename):
    """Return the JSON data from a file."""
    with open(filename) as fp_in:
        return json.load(fp_in)


def generate_config(input_file):
    """Generate user descriptors from the PowerSystems descriptor file."""
    config = {}
    data = read_json_data(input_file)
    for key, value in data.items():
        items = []
        for item in value:
            config_item = {
                "name": item["name"],
                "custom_name": item["name"],
            }
            items.append(config_item)

        config[key] = items

    return config


def generate_file(output_file, input_file=POWER_SYSTEM_DESCRIPTOR_FILE):
    """Generate user file from the PowerSystems descriptor file."""
    config = generate_config(input_file)
    with open(output_file, "w") as fp_out:
        yaml.dump(config, fp_out)

    print("Generated {} from {}".format(output_file, input_file))


def main():
    """Controls execution."""
    if len(sys.argv) != 2:
        print("Usage: {} output_file".format(os.path.basename(__file__)))
        sys.exit(1)

    generate_file(sys.argv[1])


if __name__ == "__main__":
    main()
