import sys
import json
import os
import argparse

ARCH_RUNNERS = {
    "x86_64-darwin": "macos-latest",
    "x86_64-linux": "ubuntu-latest",
}

parser = argparse.ArgumentParser()
parser.add_argument("--systems", required=True)
parser.add_argument("--input", required=True)
args = parser.parse_args()

supportedSystems = json.loads(args.systems)
input = json.loads(args.input)

# Systems that the flake supports and have runners available
availableSystems = [
    system for system in supportedSystems if system in ARCH_RUNNERS.keys()
]

outputs = []

# System-specific sets of attributes
attrs = ["packages", "checks", "devShells"]
for attribute in attrs:
    for system in supportedSystems:
        try:
            for key in input[attribute][system]:
                outputs.append(
                    {
                        "architecture": system,
                        "runner": ARCH_RUNNERS[system],
                        "attribute": f"{attribute}.{system}.{key}",
                    }
                )
        except KeyError:
            pass

# System-specific attributes
attrs = ["formatter"]
for attribute in attrs:
    for system in supportedSystems:
        try:
            outputs.append(
                {
                    "architecture": system,
                    "runner": ARCH_RUNNERS[system],
                    "attribute": f"{attribute}.{system}",
                }
            )
        except KeyError:
            pass

print(json.dumps(outputs))
