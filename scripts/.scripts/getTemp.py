# early state and more an idea than an implementation

import subprocess
bashCommand = "curl http://www.meteocentrale.ch/de/europa/schweiz/wetter-winterthur/details/N-3517946/"
process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
output, error = process.communicate()

index = 0
index1 = 0
for line in output.splitlines():
    print(line)
    if line.startswith(b'   		     <td title="Temperatur">'):
#    if line.startswith(b'this'):
        index1 += 1
    elif line.startswith(b'   <td class="caption">Temperatur</td>'):
        index += 1

print(index)
print(index1)
