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

    # ディレクトリ名が回数のみ
    m = re.fullmatch(r"[01][0-9]", x)
    if m:
        prev = int(x) + offset
        if prev < 0:
            sys.exit()
        index = -i - 1
        parts[index] = str(prev).zfill(2)
        break

    # ディレクトリ名が「回数 + タイトル」
    m = re.match(r"([01][0-9])(\..+)?$", x)
    if m:
        curr = m.group(1)
        prev = int(curr) + offset
        if prev < 0:
            sys.exit()

        # 前回のフォルダ名の検索パターン
        pattern = str(prev).zfill(2) + r"\..+$"

        # 親ディレクトリの中を検索
        index = -i - 1
        parent = pathlib.Path("\\".join(parts[:index]))
        for sibling in parent.iterdir():
            if not sibling.is_dir():
                continue
            m = re.match(pattern, sibling.name)
            if m:
                parts[index] = sibling.name
                break
        # 内側のループが正常終了したら外側のループを続ける
        else:
            continue
        # 内側のループが途中終了したら外側のループも抜ける
        break
else:
    sys.exit()

path = pathlib.Path("\\".join(parts))
while not path.exists():
    if re.fullmatch(r"[01][0-9](\..+)?", path.name):
        sys.exit()
    path = path.parent

subprocess.run([asrload, "/j", str(path)])
