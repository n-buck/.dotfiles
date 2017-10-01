import sys

source = open('i3_qhd/.i3/config', 'r')

for line in source:
    txt = line.strip()
    if txt == 'font pango: System San Francisco Display 14':
        txt ='font pango: System San Francisco Display 11'
    sys.stdout.write(txt + '\n')
sys.stdout.flush()

source.close()
