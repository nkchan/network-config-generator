# generate-logical-interfaces-configurations.pl

This Perl script processes a configuration input file containing network link information and generates a set of logical system configurations based on the provided data.

The script is designed to automate the generation of network interface configuration commands, useful in the context of network device configuration (e.g., Juniper devices). The input file specifies network links in the form link=logical-system1,logical-system2, and the script generates appropriate configuration commands for each link.
# Requirements

- Perl 5.x or higher.
- Input file should be in plain text format.

# How to Run

To run the script, use the following command:

```bash
perl generate-logical-interfaces-configurations.pl <input_file>
```

Where <input_file> is the path to the text file containing the link information.

# Example:

If the input file is named input.txt, you would run:

```
perl generate-logical-interfaces-configurations.pl input.txt
```

# Input Format

The input file should contain one or more lines in the following format:

```input.txt
link=logical-system1,logical-system2
```

Where logical-system1 and logical-system2 are the names of the logical systems to be configured.

    Each line represents a network link between logical-system1 and logical-system2.
    The script assumes that each link has two units, starting with unit 0 for logical-system1 and unit 1 for logical-system2.

## Example Input File (input.txt):

```
link=pe-a-1,pe-a-2
link=pe-a-2,pe-a-3
link=pe-a-3,pe-a-4
```

# Output Format

For each valid line in the input file, the script generates a set of configuration commands for both logical systems (logical-system1 and logical-system2). The generated commands follow the format:

```
set logical-systems <logical-system1> interfaces lt-0/0/10 unit <unit1> description "<logical-system1> to <logical-system2>"
set logical-systems <logical-system1> interfaces lt-0/0/10 unit <unit1> encapsulation ethernet
set logical-systems <logical-system1> interfaces lt-0/0/10 unit <unit1> peer-unit <unit2>
set logical-systems <logical-system1> interfaces lt-0/0/10 unit <unit1> family inet address 192.168.10.<ip1>/30
set logical-systems <logical-system2> interfaces lt-0/0/10 unit <unit2> description "<logical-system2> to <logical-system1>"
set logical-systems <logical-system2> interfaces lt-0/0/10 unit <unit2> encapsulation ethernet
set logical-systems <logical-system2> interfaces lt-0/0/10 unit <unit2> peer-unit <unit1>
set logical-systems <logical-system2> interfaces lt-0/0/10 unit <unit2> family inet address 192.168.10.<ip2>/30
```

Where:

- `unit1` and `unit2` are sequentially assigned starting from `0` for the first link.
- `ip1` and `ip2` are generated IP addresses, starting from `192.168.10.1/30` and incrementing for each new link.

# Example Output

For the input file:

```
link=pe-a-1,pe-a-2
link=pe-a-2,pe-a-3
link=pe-a-3,pe-a-4
```

The script would produce the following output:

```
set logical-systems pe-a-1 interfaces lt-0/0/10 unit 0 description "pe-a-1 to pe-a-2"
set logical-systems pe-a-1 interfaces lt-0/0/10 unit 0 encapsulation ethernet
set logical-systems pe-a-1 interfaces lt-0/0/10 unit 0 peer-unit 1
set logical-systems pe-a-1 interfaces lt-0/0/10 unit 0 family inet address 192.168.10.1/30
set logical-systems pe-a-2 interfaces lt-0/0/10 unit 1 description "pe-a-2 to pe-a-1"
set logical-systems pe-a-2 interfaces lt-0/0/10 unit 1 encapsulation ethernet
set logical-systems pe-a-2 interfaces lt-0/0/10 unit 1 peer-unit 0
set logical-systems pe-a-2 interfaces lt-0/0/10 unit 1 family inet address 192.168.10.2/30
set logical-systems pe-a-2 interfaces lt-0/0/10 unit 2 description "pe-a-2 to pe-a-3"
set logical-systems pe-a-2 interfaces lt-0/0/10 unit 2 encapsulation ethernet
set logical-systems pe-a-2 interfaces lt-0/0/10 unit 2 peer-unit 3
set logical-systems pe-a-2 interfaces lt-0/0/10 unit 2 family inet address 192.168.10.5/30
set logical-systems pe-a-3 interfaces lt-0/0/10 unit 3 description "pe-a-3 to pe-a-2"
set logical-systems pe-a-3 interfaces lt-0/0/10 unit 3 encapsulation ethernet
set logical-systems pe-a-3 interfaces lt-0/0/10 unit 3 peer-unit 2
set logical-systems pe-a-3 interfaces lt-0/0/10 unit 3 family inet address 192.168.10.6/30
set logical-systems pe-a-3 interfaces lt-0/0/10 unit 4 description "pe-a-3 to pe-a-4"
set logical-systems pe-a-3 interfaces lt-0/0/10 unit 4 encapsulation ethernet
set logical-systems pe-a-3 interfaces lt-0/0/10 unit 4 peer-unit 5
set logical-systems pe-a-3 interfaces lt-0/0/10 unit 4 family inet address 192.168.10.9/30
set logical-systems pe-a-4 interfaces lt-0/0/10 unit 5 description "pe-a-4 to pe-a-3"
set logical-systems pe-a-4 interfaces lt-0/0/10 unit 5 encapsulation ethernet
set logical-systems pe-a-4 interfaces lt-0/0/10 unit 5 peer-unit 4
set logical-systems pe-a-4 interfaces lt-0/0/10 unit 5 family inet address 192.168.10.10/30
```

If an invalid line is found in the input file (e.g., a malformed line or a missing link entry), the script will skip the line and display a warning:

```
Skipped invalid line: invalid-line
```

# Error Handling

- The script skips any lines that don't follow the link=logical-system1,logical-system2 format and displays a warning for each skipped line.
- It will not terminate on encountering an invalid line but will continue processing the rest of the file.

# License

This script is provided as-is without any warranty. Use it at your own risk.
