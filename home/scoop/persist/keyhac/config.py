import datetime
from string import ascii_uppercase

from alt_ime import enable_alt_ime
from emacs_keybindings import enable_emacs_keybindings
from search_selection import SearchSelection

from keyhac import *


def configure(keymap):

    MASK_KEY = "(232)"  ## 0xEB

    keymap.editor = "Mery"

    ## クリップボード履歴を残さない
    keymap.clipboard_history.max_items = 0
    keymap.clipboard_history.persist = False

    kt = keymap.define_keytable(focus_path_pattern="*")

    ## ユーザーモディファイア
    ## F13 (VK = 124) を User0 とする
    ## Scancode Map で RCtrl を F13 (0x0064) に変更しておく
    keymap.define_modifier(124, "User0")

    ## User0 で設定のリロード・押下状態をすべてリセット
    for mod in (
        "",
        "C-",
        "S-",
        "A-",
        "W-",
        "C-S-",
        "C-A-",
        "C-W-",
        "S-A-",
        "S-W-",
        "A-W-",
        "C-S-A-",
        "C-S-W-",
        "C-A-W-",
        "S-A-W-",
        "C-S-A-W-",
    ):
        kt[f"O-{mod}(124)"] = keymap.reload_config

    ## Win キーでスタートメニューが開かないようにする
    kt["U-LWin"] = MASK_KEY, "U-LWin"
    kt["U-RWin"] = MASK_KEY, "U-RWin"

    ## LCtrl, RCtrl を単独で押した場合は F13 を押したことにする
    ## クリップボード履歴ソフトで F13 をホットキーに指定して暴発を防ぐ
    kt["O-LCtrl"] = MASK_KEY, "U-LCtrl", "(124)"
    kt["O-RCtrl"] = MASK_KEY, "U-RCtrl", "(124)"

    ## -------------------------------------------------------------------------
    ##  Windows キーのショートカットの無効化
    ## -------------------------------------------------------------------------

    modifiers = ("", "C-", "S-", "A-", "C-S-", "C-A-", "S-A-", "C-S-A-")
    keys = (*ascii_uppercase, "Space", "Enter", "Comma", "Period", "Semicolon")

    ## いったんすべてを無効にする
    for mod in modifiers:
        for key in keys:
            kt[f"W-{mod}{key}"] = lambda: None

    ## 必要なものだけを有効にする
    kt["W-A"] = "W-A"  ## クイック設定
    kt["W-B"] = "W-B"  ## 通知領域
    kt["W-E"] = "W-E"  ## エクスプローラー
    kt["W-I"] = "W-I"  ## 設定
    kt["W-L"] = "W-L"  ## ロック
    kt["W-M"] = "W-M"  ## すべて最小化
    kt["W-S-M"] = "W-S-M"  ## 復元
    kt["W-N"] = "W-N"  ## 通知センター
    kt["W-P"] = "W-P"  ## プレゼンテーション表示モード
    kt["W-R"] = "W-R"  ## ファイル名を指定して実行
    kt["W-S-S"] = "W-S-S"  ## スクリーンショット
    kt["W-V"] = "W-V"  ## クリップボード履歴
    kt["W-X"] = "W-X"  ## クイックリンク
    kt["W-Z"] = "W-Z"  ## スナップレイアウト
    kt["W-C-S-B"] = "W-C-S-B"  ## グラフィックボードのリセット

    ## -------------------------------------------------------------------------
    ##  Alt 空打ちで IME On/Off
    ## -------------------------------------------------------------------------

    enable_alt_ime(keymap)

    ## kt["O-LAlt"] = (MASK_KEY, "U-LAlt", "Eisu")  ## IME off
    ## kt["O-RAlt"] = (MASK_KEY, "U-RAlt", "Kana")  ## IME on

    ## -------------------------------------------------------------------------
    ##  Emacs キーバインド
    ## -------------------------------------------------------------------------

    enable_emacs_keybindings(keymap)

    ## -------------------------------------------------------------------------
    ##  日付・時刻の挿入
    ## -------------------------------------------------------------------------

    def input_datetime(fmt):
        date_time = datetime.datetime.now().strftime(fmt)
        ime_status = keymap.get_ime_status()
        with keymap.get_input_context() as ctx:
            ctx.send_key("Eisu")
            ctx.send_text(date_time)
            if ime_status:
                ctx.send_key("Kana")

    def current_date_iso():
        input_datetime("%Y-%m-%d")

    def current_time_iso():
        input_datetime("%H:%M:%S")

    def current_date():
        input_datetime("%Y%m%d")

    def current_time():
        input_datetime("%H%M%S")

    ## Ctrl-; で日付，Ctrl-: で時刻を挿入
    kt["C-Semicolon"] = current_date_iso
    kt["C-S-Semicolon"] = current_time_iso

    ## Alt キーを同時に押すと区切り記号なしで挿入
    kt["C-A-Semicolon"] = current_date
    kt["C-A-S-Semicolon"] = current_time

    ## -------------------------------------------------------------------------
    ##  ウィンドウの操作
    ## -------------------------------------------------------------------------

    def maximize_window():
        window = keymap.get_active_window()
        if window:
            if window.is_maximized():
                window.restore()
            else:
                window.maximize()

    def minimize_window():
        window = keymap.get_active_window()
        if window:
            if window.is_maximized():
                window.restore()
            else:
                window.minimize()

    class SwitchWindow(ThreadedAction):

        def __init__(self, reverse=False):
            self.reverse = reverse
            self.previous = None

        def starting(self):
            self.previous = self.keymap.get_active_window()
            with self.keymap.get_input_context() as ctx:
                if self.reverse:
                    ctx.send_key("A-S-Esc")
                else:
                    ctx.send_key("A-Esc")

        def run(self):
            previous = self.previous

            def switched():
                window = self.keymap.get_active_window()
                return window if window and window != previous else None

            try:
                return self.ui.wait(switched, timeout=0.5)
            except WaitTimeout:
                return None

        def finished(self, window):
            if window and window.is_minimized():
                window.restore()

    def resize_window(dw, dh):
        def _resize():
            window = keymap.get_active_window()
            if not window or window.is_minimized() or window.is_maximized():
                return
            x, y, w, h = window.get_frame()
            window.set_frame(x, y, w + dw, h + dh)

        return _resize

    ## 最大化・最小化
    kt["W-S-Up"] = maximize_window
    kt["W-S-Down"] = minimize_window

    ## すべて最小化
    kt["W-Home"] = "W-Home"  ## アクティブウインドウ以外を最小化
    kt["W-End"] = "W-D"  ## すべて最小化（デスクトップを表示）

    ## ウインドウの切り替え
    kt["W-PageUp"] = SwitchWindow(reverse=True)
    kt["W-PageDown"] = SwitchWindow(reverse=False)

    ## ウインドウのスナップ
    ## FancyZonde に任せる
    ## kt["W-Up"] = SnapWindow("top")
    ## kt["W-Down"] = SnapWindow("bottom")
    ## kt["W-Left"] = SnapWindow("left")
    ## kt["W-Right"] = SnapWindow("right")

    ## ウインドウの移動
    kt["W-A-Up"] = MoveWindow(direction="up", distance=100)
    kt["W-A-Down"] = MoveWindow(direction="down", distance=100)
    kt["W-A-Left"] = MoveWindow(direction="left", distance=100)
    kt["W-A-Right"] = MoveWindow(direction="right", distance=100)

    ## ウインドウのサイズ変更
    kt["W-S-A-Up"] = resize_window(0, -20)
    kt["W-S-A-Down"] = resize_window(0, 20)
    kt["W-S-A-Left"] = resize_window(-20, 0)
    kt["W-S-A-Right"] = resize_window(20, 0)

    ## -------------------------------------------------------------------------
    ##  マウスの操作
    ## -------------------------------------------------------------------------

    kt["U0-Up"] = MouseMove(0, -10)
    kt["U0-Down"] = MouseMove(0, 10)
    kt["U0-Left"] = MouseMove(-10, 0)
    kt["U0-Right"] = MouseMove(10, 0)

    kt["U0-A-Up"] = MouseMove(0, -100)
    kt["U0-A-Down"] = MouseMove(0, 100)
    kt["U0-A-Left"] = MouseMove(-100, 0)
    kt["U0-A-Right"] = MouseMove(100, 0)

    kt["U0-Enter"] = MouseButtonClick("left")
    kt["U0-A-Enter"] = MouseButtonClick("right")
    kt["U0-S-Enter"] = MouseButtonClick("middle")

    ## -------------------------------------------------------------------------
    ##  ランチャー
    ## -------------------------------------------------------------------------

    kt["W-F"] = ActivateApplication(app="Everything", launch="Everything.exe")
    kt["PrintScreen"] = LaunchApplication("Rapture.exe")  ## 常に新規インスタンス

    ## -------------------------------------------------------------------------
    ##  選択テキストで検索
    ## -------------------------------------------------------------------------

    kt["W-S"] = SearchSelection("https://www.google.com/search?q=")
