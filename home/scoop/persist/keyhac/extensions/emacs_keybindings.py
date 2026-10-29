def enable_emacs_keybindings(keymap, exclude_apps=None, exclude_classes=None):

    if exclude_apps is None:
        exclude_apps = []

    if exclude_classes is None:
        exclude_classes = []

    def remove_suffix(name):
        name = name.lower()
        if name.endswith(".exe"):
            name = name[:-4]
        return name

    exclude_apps = {remove_suffix(app) for app in exclude_apps}
    exclude_classes = {cls.lower() for cls in exclude_classes}

    def is_emacs_target(focus):
        if remove_suffix(focus.app_name) in exclude_apps:
            return False
        if focus.class_name.lower() in exclude_classes:
            return False
        return True

    kt = keymap.define_keytable(custom_condition_func=is_emacs_target)

    ## CapsLock を RCtrl に置き換えた上で Emacs キーバインドを割り当てる
    ## LCtrl は通常の Windows ショートカットが使えるようにそのまま残しておく

    ## カーソルの移動と範囲選択
    for modifier in ("", "S-"):

        kt[modifier + "RC-P"] = modifier + "Up"
        kt[modifier + "RC-N"] = modifier + "Down"
        kt[modifier + "RC-B"] = modifier + "Left"
        kt[modifier + "RC-F"] = modifier + "Right"
        kt[modifier + "RC-A"] = modifier + "Home"
        kt[modifier + "RC-E"] = modifier + "End"

        # 本来 Meta キーを使うものは RC-A との組み合わせに変更する
        kt[modifier + "RC-A-P"] = modifier + "PageUp"
        kt[modifier + "RC-A-N"] = modifier + "PageDown"
        kt[modifier + "RC-A-B"] = modifier + "C-Left"
        kt[modifier + "RC-A-F"] = modifier + "C-Right"
        kt[modifier + "RC-A-A"] = modifier + "C-Home"
        kt[modifier + "RC-A-E"] = modifier + "C-End"

        # 単語単位の移動はよく使うので RC-Comma/Period を割り当てる
        kt[modifier + "RC-Comma"] = modifier + "C-Left"
        kt[modifier + "RC-Period"] = modifier + "C-Right"

    ## 削除
    kt["RC-D"] = "Delete"
    kt["RC-A-D"] = "C-S-Right", "Back"
    kt["RC-H"] = "Back"
    kt["RC-A-H"] = "C-S-Left", "Back"
    kt["RC-K"] = "S-End", "C-X"
    kt["RC-U"] = "S-Home", "C-X"
    kt["RC-J"] = "Home", "S-End", "C-X"

    ## Enter/Esc
    kt["RC-M"] = "Enter"
    kt["RC-G"] = "Esc"
