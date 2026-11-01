import os
import pathlib
import re
import subprocess
import sys

if len(sys.argv) != 3:
    sys.exit()

home = os.environ.get("USERPROFILE", "")
asrload = os.path.join(home, r"bin\Asr\AsrLoad.exe")

path = pathlib.PurePath(sys.argv[1])
offset = int(sys.argv[2])

parts = list(path.parts)
index = -1

for i, x in enumerate(reversed(parts)):
    m = re.fullmatch(r"(19|20)[0-9]{2}", x)
    if m:
        other = int(x) + offset
        if other < 1990 or other > 2099:
            sys.exit()
        index = -i - 1
        parts[index] = str(other)
        break
else:
    sys.exit()

path = pathlib.Path("\\".join(parts))
while not path.exists():
    if re.fullmatch(r"(19|20)[0-9]{2}", path.name):
        sys.exit()
    path = path.parent

subprocess.run([asrload, "/j", str(path)])
