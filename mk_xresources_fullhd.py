import sys

source = open('xresources/.Xresources', 'r')

for line in source:
    txt = line.strip()
    if txt == 'rofi.padding: 300':
        txt = 'rofi.padding: 150'
    sys.stdout.write(txt + '\n')
sys.stdout.flush()

source.close()
