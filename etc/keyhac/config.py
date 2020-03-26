import datetime
import os
from time import sleep
from urllib.parse import quote

from keyhac import getClipboardText, setClipboardText


def configure(keymap):

    def scoop_app(exe_name):
        home = os.environ.get("USERPROFILE")
        dir_name = exe_name[:-4].lower()
        app_path = f"scoop/apps/{dir_name}/current"
        return os.path.join(home, app_path, exe_name)

    # エディタ
    keymap.editor = scoop_app("Mery.exe")

    # コンソール画面の設定
    keymap.setFont("Cica", 18)
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
    keymap_global["W-Space"] = lambda: None    # 入力言語の切り替え
    keymap_global["W-C-Enter"] = lambda: None  # ナレーター

    # Win+Q でプログラムを終了する
    keymap_global["W-Q"] = "Alt-F4"

    # -------------------------------------------------------------------------
    #  IME 制御
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
    #  クリップボードの操作
    # -------------------------------------------------------------------------

    def clibor_command(param):
        clibor = scoop_app("Clibor.exe")
        return keymap.ShellExecuteCommand(None, clibor, param, "")

    def clibor_mode_command(param):
        def _command():
            clibor_command(param)()
            keymap.delayedCall(keymap.InputKeyCommand("A-Esc"), 100)
        return _command

    # クリップボード履歴
    keymap_global["W-V"] = clibor_command("/vc")

    # 常に表示するの切り替え
    keymap_global["W-Z"] = clibor_command("/fr")

    # FIFO/LIFO モードの切り替え
    keymap_global["W-C"] = clibor_mode_command("/ff")
    keymap_global["W-X"] = clibor_mode_command("/lf")

    def paste_plain():
        txt = getClipboardText()
        if txt:
            setClipboardText(txt)
            keymap.InputKeyCommand("C-V")()

    # 書式なしで貼り付け
    keymap_global["C-S-V"] = paste_plain

    # -------------------------------------------------------------------------
    #  ウィンドウの切り替え
    # -------------------------------------------------------------------------

    def restore_window():
        w = keymap.getTopLevelWindow()
        if w is None:
            return
        if w.isMinimized():
            w.restore()
        w = w.getLastActivePopup()
        w.setForeground()

    def next_window():
        keymap.InputKeyCommand("A-Esc")()
        keymap.delayedCall(restore_window, 200)

    def prev_window():
        keymap.InputKeyCommand("A-S-Esc")()
        keymap.delayedCall(restore_window, 200)

    keymap_global["W-Space"] = next_window
    keymap_global["W-S-Space"] = prev_window
    keymap_global["W-N"] = next_window
    keymap_global["W-P"] = prev_window

    # 方向キーでもアプリの切り替えができるようにする
    keymap_global["A-Tab"] = "C-A-Tab"

    # -------------------------------------------------------------------------
    #  ウィンドウの移動
    # -------------------------------------------------------------------------

    def _grid_alignment(pos, delta):

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

            d = _grid_alignment(rect[0], dx)
            rect[0] += d
            rect[2] += d

            d = _grid_alignment(rect[1], dy)
            rect[1] += d
            rect[3] += d

            w.setRect(rect)

        return _move_window

    keymap_global["W-A-Left"] = move_window_command(-16, 0)
    keymap_global["W-A-Right"] = move_window_command(16, 0)
    keymap_global["W-A-Up"] = move_window_command(0, -16)
    keymap_global["W-A-Down"] = move_window_command(0, 16)

    # -------------------------------------------------------------------------
    #  ウィンドウのリサイズ
    # -------------------------------------------------------------------------

    def resize_window_command(dw, dh):

        def _resize_window():

            w = keymap.getTopLevelWindow()
            if w is None or w.isMaximized() or w.isMinimized():
                return

            rect = list(w.getRect())

            d = _grid_alignment(rect[2] - rect[0], dw)
            if rect[0] < rect[2] + d:
                rect[2] += d

            d = _grid_alignment(rect[3] - rect[1], dh)
            if rect[1] < rect[3] + d:
                rect[3] += d

            w.setRect(rect)

        return _resize_window

    keymap_global["W-A-S-Left"] = resize_window_command(-16, 0)
    keymap_global["W-A-S-Right"] = resize_window_command(16, 0)
    keymap_global["W-A-S-Up"] = resize_window_command(0, -16)
    keymap_global["W-A-S-Down"] = resize_window_command(0, 16)

    # -------------------------------------------------------------------------
    #  ウィンドウの整列
    # -------------------------------------------------------------------------

    def upper_half_window():

        w = keymap.getTopLevelWindow()
        if w is None:
            return

        # 現在のサイズ
        rect = w.getRect()

        # 上半分にスナップしたときのサイズ
        w.maximize()
        half = list(w.getRect())
        half[3] = (half[1] + half[3]) // 2
        half = tuple(half)

        if rect != half:
            w.restore()
            w.setRect(half)

    def lower_half_window():

        w = keymap.getTopLevelWindow()
        if w is None:
            return

        # 現在のサイズ
        rect = w.getRect()

        # 下半分にスナップしたときのサイズ
        w.maximize()
        half = list(w.getRect())
        half[1] = (half[1] + half[3]) // 2
        half = tuple(half)

        if rect != half:
            w.restore()
            w.setRect(half)

    # 上下のエアロスナップ
    keymap_global["W-S-Up"] = upper_half_window
    keymap_global["W-S-Down"] = lower_half_window

    def cascade_windows():
        # タスクバーの右クリックメニューで「重ねて表示」を実行
        keymap.InputKeyCommand("W-B", "S-F10", "D")()
        keymap.delayedCall(keymap.InputKeyCommand("A-Esc"), 100)

    # 重ねて表示
    keymap_global["W-Esc"] = cascade_windows

    # アクティブウィンドウ以外を最小化
    keymap_global["W-C-Down"] = "W-Home"

    # -------------------------------------------------------------------------
    #  仮想デスクトップ
    # -------------------------------------------------------------------------

    # タスクビュー
    keymap_global["W-C-Up"] = "W-Tab"

    # -------------------------------------------------------------------------
    #  マウスの操作
    # -------------------------------------------------------------------------

    # Ctrl+Alt+LRUD でマウスカーソルを移動
    keymap_global["C-A-Left"] = keymap.MouseMoveCommand(-10, 0)
    keymap_global["C-A-Right"] = keymap.MouseMoveCommand(10, 0)
    keymap_global["C-A-Up"] = keymap.MouseMoveCommand(0, -10)
    keymap_global["C-A-Down"] = keymap.MouseMoveCommand(0, 10)

    # Ctrl+Alt+Space でマウスクリック
    keymap_global["D-C-A-Space"] = keymap.MouseButtonDownCommand("left")
    keymap_global["U-C-A-Space"] = keymap.MouseButtonUpCommand("left")

    # -------------------------------------------------------------------------
    #  日付・時刻の挿入
    # -------------------------------------------------------------------------

    def _input_datetime(format):
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
        _input_datetime("%Y-%m-%d")

    def current_time_iso():
        _input_datetime("%H:%M:%S")

    def current_date():
        _input_datetime("%Y%m%d")

    def current_time():
        _input_datetime("%H%M%S")

    # Excel と同じ Ctrl-; で日付，Ctrl-: で時刻を挿入
    keymap_global["C-Semicolon"] = current_date_iso
    keymap_global["C-S-Semicolon"] = current_time_iso

    # Alt キーを同時に押すと区切り記号なしで挿入
    keymap_global["C-A-Semicolon"] = current_date
    keymap_global["C-A-S-Semicolon"] = current_time

    # -------------------------------------------------------------------------
    #  ランチャー
    # -------------------------------------------------------------------------

    def launch_command(app_path, param="", directory=""):
        return keymap.ShellExecuteCommand(None, app_path, param, directory)

    keymap_global["W-A"] = launch_command("C:/Asr/AsrLoad.exe", "/x")
    keymap_global["W-E"] = launch_command(scoop_app("Mery.exe"))
    keymap_global["W-F"] = launch_command(scoop_app("Everything.exe"))
    keymap_global["W-G"] = launch_command(scoop_app("TresGrep.exe"))

    def search_selection():
        old = getClipboardText()
        setClipboardText("")
        keymap.InputKeyCommand("C-C")()
        sleep(0.1)
        txt = getClipboardText()
        if txt:
            txt = quote(txt)
            url = f"https://www.google.com/search?q={txt}"
            keymap.ShellExecuteCommand(None, url, "", "")()
        else:
            setClipboardText(old)

    # 選択文字列で検索
    keymap_global["W-S"] = search_selection

    ###########################################################################
    # エディタ用の設定
    ###########################################################################

    def is_editor(window):

        editors = (
            "notepad.exe",
            "Mery.exe",
            "WINWORD.EXE",
            "Evernote.exe",
            "rstudio.exe"
        )

        pn = window.getProcessName()
        if pn in editors:
            return True

        cn = window.getClassName()
        if "Edit" in cn:
            return True

        if cn == "Chrome_WidgetWin_1":
            return True

        return False

    # エディタ用キーマップ
    keymap_editor = keymap.defineWindowKeymap(check_func=is_editor)

    # CapsLock を RCtrl に置き換えた上で Emacs キーバインドを割り当てる
    # LCtrl は通常の Windows ショートカットが使えるようにそのまま残しておく

    # カーソル移動
    keymap_editor["RC-P"] = "Up"
    keymap_editor["RC-N"] = "Down"
    keymap_editor["RC-B"] = "Left"
    keymap_editor["RC-F"] = "Right"
    keymap_editor["RC-A"] = "Home"
    keymap_editor["RC-E"] = "End"

    # 編集
    keymap_editor["RC-D"] = "Delete"
    keymap_editor["RC-H"] = "Back"
    keymap_editor["RC-K"] = "S-End", "C-X"
    keymap_editor["RC-U"] = "S-Home", "C-X"
    keymap_editor["S-Delete"] = "Home", "S-End", "Delete"
