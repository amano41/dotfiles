import os
import pathlib
import subprocess
import sys
import stat

if len(sys.argv) != 3:
    sys.exit()

asrload = pathlib.Path.home().joinpath(r"bin\Asr\AsrLoad.exe")

path = pathlib.Path(sys.argv[1]).resolve()
offset = int(sys.argv[2])

siblings = [d for d in path.parent.iterdir() if d.is_dir()]

index = (siblings.index(path) + offset) % len(siblings)
target = siblings[index]

subprocess.run([asrload, "/j", target])
