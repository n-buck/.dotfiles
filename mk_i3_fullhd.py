import sys

source = open('i3_qhd/.i3/config', 'r')
dest = open('i3_fullhd/.i3/config', 'w')

config = ''
for line in source:
    txt = line.strip()
    if txt == 'font pango: System San Francisco Display 14':
        txt ='font pango: System San Francisco Display 11'
    config +=(txt + '\n')
source.close()

dest.write(config)
dest.close()
