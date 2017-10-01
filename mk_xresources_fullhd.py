import sys

source = open('xresources_qhd/.Xresources', 'r')
dest = open('xresources_fullhd/.Xresources', 'w')
config = ''
for line in source:
    txt = line.strip()
    if txt == 'rofi.font: San Francisco Display 40':
        txt = 'rofi.font: San Francisco Display 30'
    if txt == 'rofi.padding: 300':
        txt = 'rofi.padding: 150'
    config += txt
source.close()

dest.write(config)
dest.close()
