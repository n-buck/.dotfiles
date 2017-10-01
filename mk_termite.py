import sys

source = open('termite_qhd/.config/termite/config', 'r')
dest = open('termite_fullhd/.config/termite/config', 'w')

config = ''
for line in source:
    txt = line.strip()
    if txt == 'font = Hack 14':
        txt ='font = Hack 11'
    config += txt
source.close()

dest.write(config)
dest.close()
