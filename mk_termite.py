import sys

source = open('termite_qhd/.config/termite/config', 'r')

for line in source:
    txt = line.strip()
    if txt == 'font = Hack 14':
        txt ='font = Hack 11'
    sys.stdout.write(txt + '\n')
sys.stdout.flush()

source.close()
