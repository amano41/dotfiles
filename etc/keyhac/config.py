import datetime
import os
import re
from pathlib import Path
from time import sleep
from urllib.parse import quote

import pyauto
from keyhac import Window, getClipboardText, setClipboardText


def configure(keymap):

    ###########################################################################
    # 基本設定
    ###########################################################################

    # エディタ
    localappdata = os.getenv("LOCALAPPDATA")
    keymap.editor = f"{localappdata}/Programs/Microsoft VS Code/Code.exe"

    # コンソール画面の設定
    keymap.setFont("HackGen Console", 14)
    keymap.setTheme("black")

    # クリップボード履歴を無効化
    keymap.clipboard_history.enableHook(False)
    keymap.clipboard_history.maxnum = 0
    keymap.clipboard_history.quota = 0

    ###########################################################################
    # グローバル設定
    ###########################################################################

    keymap_global = keymap.defineWindowKeymap()

    # LWin でスタートメニューが開かないようにする
    # 実際には U-LWin の時点でスタートメニューが開くが
    # U-LWin を上書きすると他のショートカットに影響してしまう
    keymap_global["D-LWin"] = "D-LWin", "LCtrl"

    # デフォルトショートカットの無効化
    keymap_global["W-C"] = lambda: None  # Microsoft Teams チャット
    keymap_global["W-F"] = lambda: None  # フィードバック Hub
    keymap_global["W-G"] = lambda: None  # Xbox Game Bar
    keymap_global["W-A-B"] = lambda: None  # Xbox Game Bar: HDR 切り替え
    keymap_global["W-A-R"] = lambda: None  # Xbox Game Bar: 録画
    keymap_global["W-H"] = lambda: None  # 音声入力
    keymap_global["W-J"] = lambda: None  # ヒント
    keymap_global["W-K"] = lambda: None  # キャスト
    keymap_global["W-O"] = lambda: None  # デバイスの向きをロック
    keymap_global["W-P"] = lambda: None  # プレゼンテーション表示モード
    keymap_global["W-C-Q"] = lambda: None  # クイックアシスト
    keymap_global["W-Q"] = lambda: None  # 検索
    keymap_global["W-S"] = lambda: None  # 検索
    keymap_global["W-U"] = lambda: None  # アクセシビリティの設定
    keymap_global["W-S-V"] = lambda: None  # 通知
    keymap_global["W-W"] = lambda: None  # ウィジェット
    keymap_global["W-Y"] = lambda: None  # Windows Mixed Reality
    keymap_global["W-Period"] = lambda: None  # 絵文字
    keymap_global["W-Semicolon"] = lambda: None  # 絵文字
    keymap_global["W-Comma"] = lambda: None  # デスクトップのプレビュー
    keymap_global["W-Space"] = lambda: None  # 入力言語の切り替え
    keymap_global["W-S-Space"] = lambda: None  # 入力言語の切り替え
    keymap_global["W-C-Space"] = lambda: None  # 入力言語の切り替え
    keymap_global["W-C-Enter"] = lambda: None  # ナレーター

    # Win+Q でプログラムを終了する
    keymap_global["W-Q"] = "Alt-F4"

    # Win+W でドキュメントを閉じる
    keymap_global["W-W"] = "Ctrl-F4"

    # -------------------------------------------------------------------------
    #  IME
    # -------------------------------------------------------------------------

    def ime_off():
        w = keymap.getWindow()
        if w is None:
            return
        w.setImeStatus(0)
        keymap.popBalloon("ime_status", "[A]", 500)

    def ime_on():
        w = keymap.getWindow()
        if w is None:
            return
        w.setImeStatus(1)
        keymap.popBalloon("ime_status", "[あ]", 500)

    def toggle_ime():
        w = keymap.getWindow()
        if w is None:
            return
        if w.getImeStatus():
            ime_off()
        else:
            ime_on()

    # Ctrl+SPACE で IME 切り替え
    keymap_global["C-Space"] = toggle_ime

    # Mac の英数／かな切り替えと同じ挙動を Alt キーで行う
    keymap_global["O-LAlt"] = ime_off
    keymap_global["O-RAlt"] = ime_on

    # Alt キー空打ちでメニューにフォーカスが移動するのを防ぐ
    keymap_global["D-LAlt"] = "D-LAlt", "LCtrl"
    keymap_global["D-RAlt"] = "D-RAlt", "RCtrl"

    # -------------------------------------------------------------------------
    #  クリップボード
    # -------------------------------------------------------------------------

    def set_clipboard(text):
        old = getClipboardText()
        setClipboardText(text)
        return old

    def get_selection(delete=False):
        old = set_clipboard("")
        sleep(0.05)
        if delete:
            keymap.InputKeyCommand("C-X")()
        else:
            keymap.InputKeyCommand("C-C")()
        sleep(0.05)
        return set_clipboard(old)

    def copy_append(sep=""):
        old = getClipboardText()
        if not old:
            keymap.InputKeyCommand("C-C")()
            return
        txt = get_selection()
        if txt:
            setClipboardText(old + sep + txt)

    def cut_append(sep=""):
        old = getClipboardText()
        if not old:
            keymap.InputKeyCommand("C-X")()
            return
        txt = get_selection(True)
        if txt:
            setClipboardText(old + sep + txt)

    def paste_plain():
        txt = getClipboardText()
        if txt:
            setClipboardText(txt)
            sleep(0.05)
            keymap.InputKeyCommand("C-V")()

    # 追加コピー・追加切り取り
    keymap_global["C-S-C"] = copy_append
    keymap_global["C-S-X"] = cut_append

    # 書式なしで貼り付け
    keymap_global["C-S-V"] = paste_plain

    # -------------------------------------------------------------------------
    #  日付・時刻の挿入
    # -------------------------------------------------------------------------

    def input_datetime(format):
        is_ime_on = keymap.getWindow().getImeStatus()
        dt = datetime.datetime.now().strftime(format)
        if is_ime_on:
            ime_off()
            sleep(0.1)
            keymap.InputTextCommand(dt)()
            sleep(0.1)
            ime_on()
        else:
            keymap.InputTextCommand(dt)()

    def current_date_iso():
        input_datetime("%Y-%m-%d")

    def current_time_iso():
        input_datetime("%H:%M:%S")

    def current_date():
        input_datetime("%Y%m%d")

    def current_time():
        input_datetime("%H%M%S")

    # Excel と同じ Ctrl-; で日付，Ctrl-: で時刻を挿入
    keymap_global["C-Semicolon"] = current_date_iso
    keymap_global["C-S-Semicolon"] = current_time_iso

    # Alt キーを同時に押すと区切り記号なしで挿入
    keymap_global["C-A-Semicolon"] = current_date
    keymap_global["C-A-S-Semicolon"] = current_time

    # -------------------------------------------------------------------------
    #  ウィンドウの切り替え
    # -------------------------------------------------------------------------

    def restore_minimized_window():
        w = keymap.getTopLevelWindow()
        if w is None:
            return
        if w.isMinimized():
            w.restore()
            w = w.getLastActivePopup()
            w.setForeground()

    def next_window():
        keymap.InputKeyCommand("A-Esc")()
        keymap.delayedCall(restore_minimized_window, 100)

    def prev_window():
        keymap.InputKeyCommand("A-S-Esc")()
        keymap.delayedCall(restore_minimized_window, 100)

    keymap_global["W-PageUp"] = prev_window
    keymap_global["W-PageDown"] = next_window

    # -------------------------------------------------------------------------
    #  ウィンドウの移動・サイズ変更
    # -------------------------------------------------------------------------

    def grid_alignment(pos, delta):

        if delta == 0:
            return 0

        # グリッドの位置にいる場合
        r = pos % abs(delta)
        if r == 0:
            return delta

        # グリッドの位置からずれている場合
        if delta < 0:
            return -r
        else:
            return -r + delta

    def move_window_command(dx, dy):
        def _move_window():

            w = keymap.getTopLevelWindow()
            if w is None or w.isMaximized() or w.isMinimized():
                return

            rect = list(w.getRect())

            d = grid_alignment(rect[0], dx)
            rect[0] += d
            rect[2] += d

            d = grid_alignment(rect[1], dy)
            rect[1] += d
            rect[3] += d

            w.setRect(rect)

        return _move_window

    def resize_window_command(dw, dh):
        def _resize_window():

            w = keymap.getTopLevelWindow()
            if w is None or w.isMaximized() or w.isMinimized():
                return

            rect = list(w.getRect())

            d = grid_alignment(rect[2] - rect[0], dw)
            if rect[0] < rect[2] + d:
                rect[2] += d

            d = grid_alignment(rect[3] - rect[1], dh)
            if rect[1] < rect[3] + d:
                rect[3] += d

            w.setRect(rect)

        return _resize_window

    # Win+Alt+LRUD でウィンドウを移動
    keymap_global["W-A-Left"] = move_window_command(-64, 0)
    keymap_global["W-A-Right"] = move_window_command(64, 0)
    keymap_global["W-A-Up"] = move_window_command(0, -64)
    keymap_global["W-A-Down"] = move_window_command(0, 64)

    # Win+Alt+Shift+LRUD でウィンドウのサイズを変更
    keymap_global["W-A-S-Left"] = resize_window_command(-64, 0)
    keymap_global["W-A-S-Right"] = resize_window_command(64, 0)
    keymap_global["W-A-S-Up"] = resize_window_command(0, -64)
    keymap_global["W-A-S-Down"] = resize_window_command(0, 64)

    # -------------------------------------------------------------------------
    #  ウィンドウの整列
    # -------------------------------------------------------------------------

    def upper_half_window():

        w = keymap.getTopLevelWindow()
        if w is None:
            return

        wl, wt, wr, wb = w.getRect()
        x = (wl + wr) // 2
        y = (wt + wb) // 2

        for info in pyauto.Window.getMonitorInfo():
            ml, mt, mr, mb = info[1]
            if (ml <= x <= mr) and (mt <= y <= mb):
                wl, wt, wr, wb = ml, mt, mr, (mt + mb) // 2
                break
        else:
            w.maximize()
            return

        # Chrom は最大化状態ではサイズ変更が効かない
        if w.getClassName() == "Chrome_WidgetWin_1":
            if w.isMaximized():
                w.restore()
        else:
            w.maximize()

        w.setRect((wl, wt, wr, wb))

    def lower_half_window():

        w = keymap.getTopLevelWindow()
        if w is None:
            return

        wl, wt, wr, wb = w.getRect()
        x = (wl + wr) // 2
        y = (wt + wb) // 2

        for info in pyauto.Window.getMonitorInfo():
            ml, mt, mr, mb = info[1]
            if (ml <= x <= mr) and (mt <= y <= mb):
                wl, wt, wr, wb = ml, (mt + mb) // 2, mr, mb
                break
        else:
            w.maximize()
            return

        # Chrom は最大化状態ではサイズ変更が効かない
        if w.getClassName() == "Chrome_WidgetWin_1":
            if w.isMaximized():
                w.restore()
        else:
            w.maximize()

        w.setRect((wl, wt, wr, wb))

    def maximize_window():
        w = keymap.getTopLevelWindow()
        if w is None or w.isMaximized():
            return
        if w.isMinimized():
            w.restore()
        else:
            w.maximize()
        w = w.getLastActivePopup()
        w.setForeground()

    def minimize_window():
        w = keymap.getTopLevelWindow()
        if w is None or w.isMinimized():
            return
        if w.isMaximized():
            w.restore()
        else:
            w.minimize()
        w = w.getLastActivePopup()
        w.setForeground()

    def restore_window():
        w = keymap.getTopLevelWindow()
        if w is None:
            return
        if w.isMaximized() or w.isMinimized():
            w.restore()
            w = w.getLastActivePopup()
            w.setForeground()

    def cascade_windows():
        # タスクバーの右クリックメニューで「重ねて表示」を実行
        keymap.InputKeyCommand("W-B", "S-F10", "D")()
        keymap.delayedCall(keymap.InputKeyCommand("A-Esc"), 100)

    # 最大化・最小化
    keymap_global["W-S-Up"] = maximize_window
    keymap_global["W-S-Down"] = minimize_window

    # 元に戻す
    keymap_global["W-Esc"] = restore_window

    # すべて最小化・元に戻す
    keymap_global["W-End"] = "W-D"

    # -------------------------------------------------------------------------
    #  仮想デスクトップ
    # -------------------------------------------------------------------------

    # タスクビュー
    keymap_global["W-C-Up"] = "W-Tab"

    # アプリの切り替え
    keymap_global["W-C-Down"] = "C-A-Tab", "U-Alt"

    # -------------------------------------------------------------------------
    #  マウスの操作
    # -------------------------------------------------------------------------

    # Win+Ctrl+Alt+LRUD でマウスカーソルを移動
    keymap_global["W-C-A-Left"] = keymap.MouseMoveCommand(-10, 0)
    keymap_global["W-C-A-Right"] = keymap.MouseMoveCommand(10, 0)
    keymap_global["W-C-A-Up"] = keymap.MouseMoveCommand(0, -10)
    keymap_global["W-C-A-Down"] = keymap.MouseMoveCommand(0, 10)

    # Win+Ctrl+Alt+Enter でマウスクリック
    keymap_global["D-W-C-A-Enter"] = keymap.MouseButtonDownCommand("left")
    keymap_global["U-W-C-A-Enter"] = keymap.MouseButtonUpCommand("left")

    # -------------------------------------------------------------------------
    #  ランチャー
    # -------------------------------------------------------------------------

    def scoop_app(exe_name, dir_name=None):
        if not dir_name:
            dir_name = Path(exe_name).stem.lower()
        home = Path.home()
        app = home.joinpath("scoop", "apps", dir_name, "current", exe_name)
        return str(app)

    def launch_command(app_path, param="", directory=""):
        return keymap.ShellExecuteCommand(None, str(app_path), param, directory)

    def launch_asr_command():
        def _command():
            home = Path.home()
            asr = home.joinpath("bin", "asr", "AsrLoad.exe")
            txt = getClipboardText().strip().strip('"')
            if txt:
                path = Path(txt).resolve()
                if path.is_dir():
                    launch_command(asr, f"/x /n {path}")()
                    return
                if path.is_file():
                    launch_command(asr, f"/x /nf {path}")()
                    return
            launch_command(asr, f"/x /n {home}")()

        return _command

    def launch_pen_command():
        def _command():

            names = []

            # すでに起動しているか検索する
            # クラス名が毎回変わるので Window.find() は使えない
            w = Window.getDesktop()
            w = w.getFirstChild()
            while w:
                c = w.getClassName()
                t = w.getText()
                if "JikagakiDesktop.exe" in c and "直書きデスクトップ" in t:
                    names.append(c)
                w = w.getNext()

            # 見つかった場合はウィンドウを元に戻す
            if names:
                for c in names:
                    w = Window.find(c, None)
                    if w:
                        w.restore()
                        w.setForeground()

            # 見つからなかった場合は新たに起動する
            else:
                launch_command(scoop_app("JikagakiDesktop.exe", "jikagaki-desktop"))()

        return _command

    keymap_global["W-A"] = launch_asr_command()
    keymap_global["W-B"] = launch_command(scoop_app("Bitwarden.exe"))
    keymap_global["W-F"] = launch_command(scoop_app("Everything.exe"))
    keymap_global["W-G"] = launch_command(scoop_app("TresGrep.exe"))
    keymap_global["W-Insert"] = launch_pen_command()
    keymap_global["PrintScreen"] = launch_command(scoop_app("Rapture.exe"))

    # -------------------------------------------------------------------------
    #  選択テキストで検索
    # -------------------------------------------------------------------------

    def search_selection(url):
        def _search_selection():
            txt = get_selection()
            if txt:
                if re.match("^h?ttps?://", txt):
                    if not txt.startswith("h"):
                        txt = "h" + txt
                    command = txt
                else:
                    command = url + quote(txt)
                launch_command(command)()

        return _search_selection

    keymap_global["W-S"] = search_selection("https://www.google.com/search?q=")
    keymap_global["W-D"] = search_selection("https://eow.alc.co.jp/search?q=")
    keymap_global["W-T"] = search_selection("https://www.deepl.com/translator#en/ja/")

    ###########################################################################
    # Emacs キーバインドの設定
    ###########################################################################

    def is_emacs_target(window):

        proc_name = window.getProcessName()
        if proc_name in ("WindowsTerminal.exe",):
            return False

        return True

    keymap_emacs = keymap.defineWindowKeymap(check_func=is_emacs_target)

    # CapsLock を RCtrl に置き換えた上で Emacs キーバインドを割り当てる
    # LCtrl は通常の Windows ショートカットが使えるようにそのまま残しておく

    # カーソルの移動と範囲選択
    for modifier in ("", "S-"):

        keymap_emacs[modifier + "RC-P"] = modifier + "Up"
        keymap_emacs[modifier + "RC-N"] = modifier + "Down"
        keymap_emacs[modifier + "RC-B"] = modifier + "Left"
        keymap_emacs[modifier + "RC-F"] = modifier + "Right"
        keymap_emacs[modifier + "RC-A"] = modifier + "Home"
        keymap_emacs[modifier + "RC-E"] = modifier + "End"

        # 本来 Meta キーを使うものは RC-A との組み合わせに変更する
        keymap_emacs[modifier + "RC-A-P"] = modifier + "PageUp"
        keymap_emacs[modifier + "RC-A-N"] = modifier + "PageDown"
        keymap_emacs[modifier + "RC-A-B"] = modifier + "C-Left"
        keymap_emacs[modifier + "RC-A-F"] = modifier + "C-Right"
        keymap_emacs[modifier + "RC-A-A"] = modifier + "C-Home"
        keymap_emacs[modifier + "RC-A-E"] = modifier + "C-End"

        # 単語単位の移動はよく使うので RC-Comma/Period を割り当てる
        keymap_emacs[modifier + "RC-Comma"] = modifier + "C-Left"
        keymap_emacs[modifier + "RC-Period"] = modifier + "C-Right"

    # 削除
    keymap_emacs["RC-D"] = "Delete"
    keymap_emacs["RC-H"] = "Back"
    keymap_emacs["RC-K"] = "S-End", "C-X"
    keymap_emacs["RC-U"] = "S-Home", "C-X"

    ###########################################################################
    # エディタ全般の設定
    ###########################################################################

    def is_editor(window):

        editors = ("notepad.exe", "Mery.exe", "WINWORD.EXE")

        proc_name = window.getProcessName()
        if proc_name in editors:
            return True

        class_name = window.getClassName()
        if "Edit" in class_name:
            return True

        return False

    keymap_editor = keymap.defineWindowKeymap(check_func=is_editor)

    # -------------------------------------------------------------------------
    #  単語単位の編集
    # -------------------------------------------------------------------------

    def delete_word():
        keymap.InputKeyCommand("C-S-Right", "Delete")()

    def delete_word_backward():
        keymap.InputKeyCommand("C-S-Left", "Delete")()

    keymap_editor["C-Delete"] = delete_word

    # -------------------------------------------------------------------------
    #  行単位の編集
    # -------------------------------------------------------------------------

    def select_line(newline=True):
        if newline:
            keymap.InputKeyCommand("End", "Home", "Home", "Home", "S-Down")()
        else:
            keymap.InputKeyCommand("End", "Home", "Home", "Home", "S-End")()

    def delete_line():
        select_line()
        keymap.InputKeyCommand("Delete")()

    def copy_line():
        select_line()
        keymap.InputKeyCommand("C-C", "Left", "Home", "Home", "Home")()

    def paste_line():
        txt = getClipboardText()
        if not txt:
            return
        if txt.endswith("\n"):
            keymap.InputKeyCommand("End", "Home", "Home", "Home")()
        else:
            keymap.InputKeyCommand("End", "Home", "Home", "Home", "Enter", "Up")()
        paste_plain()  # 書式付きのままだと Word で改行が追加されてしまう

    def insert_line_below():
        keymap.InputKeyCommand("End", "Enter")()

    def insert_line_above():
        keymap.InputKeyCommand("End", "Home", "Home", "Home", "Enter", "Up")()

    def move_line_up():
        old = set_clipboard("")
        select_line()
        keymap.InputKeyCommand("C-X", "Up", "C-V", "Up")()
        sleep(0.05)
        setClipboardText(old)

    def move_line_down():
        old = getClipboardText()
        select_line()
        keymap.InputKeyCommand("C-X", "End", "Enter", "Home", "S-Down", "C-V", "Up")()
        sleep(0.05)
        setClipboardText(old)

    def copy_line_up():
        old = getClipboardText()
        select_line()
        keymap.InputKeyCommand("C-C", "Left", "Home", "Home", "Home", "C-V", "Up")()
        sleep(0.05)
        setClipboardText(old)

    def copy_line_down():
        old = getClipboardText()
        select_line()
        keymap.InputKeyCommand("C-C", "Left", "End", "Enter", "Home", "S-Down", "C-V", "Up")()
        sleep(0.05)
        setClipboardText(old)

    keymap_editor["C-S-Space"] = select_line
    keymap_editor["S-Delete"] = delete_line
    keymap_editor["S-Insert"] = paste_line

    keymap_editor["C-Enter"] = insert_line_below
    keymap_editor["C-S-Enter"] = insert_line_above

    keymap_editor["A-Up"] = move_line_up
    keymap_editor["A-Down"] = move_line_down
    keymap_editor["A-S-Up"] = copy_line_up
    keymap_editor["A-S-Down"] = copy_line_down

    ###########################################################################
    # Asr 用の設定
    ###########################################################################

    keymap_asr = keymap.defineWindowKeymap(exe_name="Asr.exe")

    # タブの切り替え
    keymap_asr["C-PageDown"] = "C-Tab"
    keymap_asr["C-PageUP"] = "C-S-Tab"

    ###########################################################################
    # Biscuit 用の設定
    ###########################################################################

    keymap_biscuit = keymap.defineWindowKeymap(exe_name="Biscuit.exe")

    # アプリの切り替え
    keymap_biscuit["C-PageDown"] = "C-A-Down"
    keymap_biscuit["C-PageUP"] = "C-A-Up"

    ###########################################################################
    # Bitwarden 用の設定
    ###########################################################################

    keymap_bitwarden = keymap.defineWindowKeymap(exe_name="Bitwarden.exe")

    # タスクトレイに最小化
    keymap_bitwarden["Esc"] = "C-S-M"

    ###########################################################################
    # Excel 用の設定
    ###########################################################################

    keymap_excel = keymap.defineWindowKeymap(exe_name="excel.exe", class_name="EXCEL7")

    # 編集モード
    keymap_excel["C-Enter"] = "F2"

    # 行・列の追加・削除
    keymap_excel["S-Insert"] = "A-I", "R"
    keymap_excel["A-S-Insert"] = "A-I", "C"
    keymap_excel["S-Delete"] = "A-H", "D", "R"
    keymap_excel["A-S-Delete"] = "A-H", "D", "C"

    # 選択範囲追加モード
    keymap_excel["C-S-Space"] = "S-F8"

    # 列の選択
    # Global Keymap で IME 切り替えに設定したのを戻す
    keymap_excel["C-Space"] = "C-Space"

    # 名前を付けて保存
    keymap_excel["C-S-S"] = "F12"

    # シートの切り替え
    keymap_excel["C-Tab"] = "C-PageDown"
    keymap_excel["C-S-Tab"] = "C-PageUp"

    # ズーム
    # C-A-Plus で +15%，C-A-Minus で -15%
    keymap_excel["C-A-Z"] = "A-W", "Q"  # ズーム
    keymap_excel["C-A-0"] = "A-W", "J", "A-H", "Esc", "Esc"  # 100%
    keymap_excel["C-A-9"] = "A-W", "G", "A-H", "Esc", "Esc"  # 選択範囲に合わせる

    # 列の再表示
    # Windows 10 でショートカットキーが効かない場合がある
    keymap_excel["C-S-0"] = "A-H", "O", "U", "L"

    # 数式を表示
    # 日本語 Windows で英語配列のキーボードを使っている場合
    # Ctrl+` が Windows によって［半角／全角］と解釈されてしまう
    keymap_excel["U-C-(243)"] = lambda: None
    keymap_excel["D-C-(244)"] = "A-M", "H", "A-H", "Esc", "Esc"

    ###########################################################################
    # AllRename 用の設定
    ###########################################################################

    keymap_allrename = keymap.defineWindowKeymap(exe_name="allrename.exe")

    # 終了
    keymap_allrename["ESC"] = "A-F4"

    ###########################################################################
    # JikagakiDesktop 用の設定
    ###########################################################################

    keymap_jikagaki = keymap.defineWindowKeymap(exe_name="JikagakiDesktop.exe")

    # 最小化
    keymap_jikagaki["Enter"] = "ESC"
