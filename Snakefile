"""
Run Kestrel test cases.
"""

import os
import sys

from kescaseslib import bedreader

# Update sys.path
sys.path.append('build/pysam')


##################
### Initialize ###
##################

### Read configuration ###
configfile: "config/kescases.json"

### Environment ###

# Save environment as dictionary
ENV = os.environ.copy()

# Home
if 'HOME' in ENV:
    HOME_DIR = ENV['HOME']
else:
    HOME_DIR = None

# Tools
class ToolClass:
    pass

tools = ToolClass()

for tool_name in config['tools']:
    setattr(tools, tool_name, config['tools'][tool_name])

### Persistent Data: Strep ###

# Variant call regions
STREP_REGIONS = bedreader.bed_interval_to_dataframe(config['strep']['pbp_bed'])


#############
### Rules ###
#############

### All (rules shared over multiple experiments) ###
include: 'rules/all/variant.snakefile'
include: 'rules/all/data.snakefile'

### Strep ###
include: 'rules/strep/strep.snakefile'

### MLST ###
include: 'rules/mlst/mlst.snakefile'
