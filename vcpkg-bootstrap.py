#!/usr/bin/env python
import argparse
import subprocess


def run_vcpkg(ports, triplet):
    args = ['vcpkg', '--recurse']
    if triplet:
        args += ['--triplet', triplet]

    args.append('install')
    args += ports

    subprocess.check_call(args)


def main():
    parser = argparse.ArgumentParser(description='Bootstrap vcpkg ports.')
    parser.add_argument('-t', '--triplet', dest='triplet', metavar='TRIPLET', help='the triplet to use')
    parser.add_argument('-p', '--ports-file', dest='ports', metavar='PORTS_FILE', default='ports.txt', help='ports file containing the required ports')
    args = parser.parse_args()

    ports_to_install = []

    with open(args.ports) as f:
        content = f.readlines()
        for line in content:
            ports_to_install.append(line.strip())

    try:
        run_vcpkg(ports_to_install, args.triplet)
    except subprocess.CalledProcessError as e:
        print(str(e))


if __name__ == "__main__":
    main()
