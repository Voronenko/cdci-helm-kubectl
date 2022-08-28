#! /usr/bin/env python3

"""

update_chart_yaml.py path/Chart.yaml attrName "attrValue"

"""

import sys
from pathlib import Path
import ruamel.yaml

yaml_file = Path(sys.argv[1])
root_attr_name = sys.argv[2]
root_attr_value = sys.argv[3]

yaml = ruamel.yaml.YAML()
yaml.preserve_quotes = True
# uncomment and adapt next line in case defaults don't match your indentation
# yaml.indent(mapping=4, sequence=4, offset=2)
data = yaml.load(yaml_file)
data[root_attr_name] = root_attr_value
yaml.dump(data, yaml_file)
