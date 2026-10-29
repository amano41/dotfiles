import os
import re
from urllib.parse import quote

from keyhac import ThreadedAction, WaitTimeout


class SearchSelection(ThreadedAction):

    def __init__(self, url):
        self.url = url

    def run(self):
        cb = self.keymap.clipboard
        old = cb.get_text()

        try:
            cb.set_text("")

            with self.keymap.get_input_context() as ctx:
                ctx.send_key("C-C")

            try:
                txt = self.ui.wait(cb.get_text, timeout=1.0, message="selected text to be copied")
            except WaitTimeout:
                return None

            return txt

        finally:
            cb.set_text(old or "")

    def finished(self, txt):
        if not txt:
            return

        txt = txt.strip()

        if re.match("^h?ttps?://", txt, re.IGNORECASE):
            if not txt.lower().startswith("h"):
                txt = "h" + txt
            command = txt
        else:
            command = self.url + quote(txt)
        os.startfile(command)
