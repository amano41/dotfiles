import pathlib
import re
import sys
import tkinter as tk

import common  # noqa


def main():
    src = sys.stdin.readline().rstrip("\n")
    path = pathlib.Path.cwd()
    path = path.joinpath("..", src).resolve()

    with open(path, "r", encoding="utf-8") as f:
        body = f.read()

    root = tk.Tk()
    root.title(path.stem)

    root.attributes("-topmost", True)
    root.lift()
    root.focus_set()

    # テキストボックス配置用
    frame = tk.Frame(root, padx=24)
    frame.pack()

    data = dict()

    i = 0
    for m in re.finditer(r"#([a-zA-Z_-]+)#", body):
        k = m.group(1)
        if k in data:
            continue

        label = tk.Label(frame, text=k)
        label.grid(column=0, row=i, padx=(0, 8), pady=(24, 0), sticky="E")

        data[k] = tk.StringVar()
        entry = tk.Entry(frame, width=30, font=("", 14), textvariable=data[k])
        entry.grid(column=1, row=i, pady=(24, 0), sticky="W")

        if i == 0:
            entry.focus_force()

        i = i + 1

    def output():
        text = body
        for key, value in data.items():
            text = text.replace("#" + key + "#", value.get())
        print(text, end="")
        root.quit()

    def cancel():
        root.quit()

    # ボタン配置用
    frame = tk.Frame(root)
    frame.pack()

    button = tk.Button(frame, text="OK", width=10, command=output)
    button.bind("<Return>", lambda x: output())
    button.pack(side="left", expand=True, anchor="e", padx=16, pady=24)

    button = tk.Button(frame, text="Cancel", width=10, command=cancel)
    button.bind("<Return>", lambda x: cancel())
    button.pack(side="left", expand=True, anchor="w", padx=16, pady=24)

    root.bind("<Return>", lambda x: output())
    root.bind("<Escape>", lambda x: cancel())

    root.mainloop()


if __name__ == "__main__":
    main()
