from string import ascii_uppercase
from threading import Timer

from keyhac import getLogger


def enable_alt_ime(keymap, delay_ms=200):

    alt_state = "IDLE"
    pending_keys = []
    generation = 0
    timer = None
    shortcut_fired = False

    logger = getLogger(__name__)

    def send(*keys):
        logger.debug(f"send: {' '.join(keys)}")
        with keymap.get_input_context() as ctx:
            for key in keys:
                ctx.send_key(key)

    def flush(with_alt):
        nonlocal shortcut_fired
        logger.debug(f"flush: {with_alt}")
        if not pending_keys:
            return
        if with_alt:
            prefix = "Alt-"
            shortcut_fired = True
        else:
            prefix = ""
        send(*(f"{prefix}{key}" for key in pending_keys))
        pending_keys.clear()

    def alt_down(alt_key):
        nonlocal alt_state, timer, shortcut_fired
        logger.debug(f"alt_down: {alt_key}")
        send(f"D-{alt_key}")

        if alt_state == "PRESSED":
            return

        token = generation
        timer = Timer(delay_ms / 1000, lambda: keymap.call_on_main_thread(lambda: alt_timeout(token)))
        timer.daemon = True
        timer.start()

        shortcut_fired = False

        alt_state = "PRESSED"

    def alt_up(alt_key, ime_key=None):
        nonlocal alt_state, generation, timer
        logger.debug(f"alt_up: {alt_key}")
        send(f"U-{alt_key}")

        ## すでに離す処理が実行されている
        if alt_state == "IDLE":
            return

        ## ショートカットが押されていなければ
        ## IME を切り替える
        if not shortcut_fired and ime_key:
            send(ime_key)

        ## 0.2秒以降は即時処理しているため
        ## HOLDING のときは出力するものがないはず
        flush(with_alt=False)

        generation += 1
        if timer:
            timer.cancel()
            timer = None

        alt_state = "IDLE"

    def modifier_alt_up(modifier, alt_key):
        nonlocal alt_state
        logger.debug(f"modifier_alt_up: {modifier}{alt_key}")
        if alt_state != "IDLE":
            alt_up(alt_key)
        send(f"U-{modifier}{alt_key}")

    def alt_timeout(token):
        nonlocal alt_state
        logger.debug(f"alt_timeout: {token}")

        if alt_state != "PRESSED" or token != generation:
            return

        timer = None
        flush(with_alt=True)

        alt_state = "HOLDING"

    def alt_letter_down(alt_key, letter_key):
        nonlocal shortcut_fired
        logger.debug(f"alt_letter_down: {letter_key}")
        if alt_state == "PRESSED" and not shortcut_fired:
            pending_keys.append(letter_key)
        else:  ## HOLDING
            send(f"D-{alt_key}-{letter_key}")
            shortcut_fired = True

    def alt_letter_up(alt_key, letter_key):
        nonlocal shortcut_fired
        logger.debug(f"alt_letter_up: {letter_key}")
        if alt_state == "PRESSED" and letter_key in pending_keys:
            pending_keys.remove(letter_key)
            send(f"D-{alt_key}-{letter_key}")
            shortcut_fired = True
        send(f"U-{alt_key}-{letter_key}")

    kt = keymap.define_keytable(focus_path_pattern="*")

    kt["D-LAlt"] = lambda: alt_down("LAlt")
    kt["D-RAlt"] = lambda: alt_down("RAlt")

    kt["U-LAlt"] = lambda: alt_up("LAlt", "Eisu")
    kt["U-RAlt"] = lambda: alt_up("RAlt", "Kana")

    for m in ("C-", "S-", "W-", "C-S-", "C-W-", "S-W-", "C-S-W-"):
        kt[f"U-{m}LAlt"] = lambda m=m: modifier_alt_up(m, "LAlt")
        kt[f"U-{m}RAlt"] = lambda m=m: modifier_alt_up(m, "RAlt")

    for c in ascii_uppercase:
        kt[f"D-LAlt-{c}"] = lambda c=c: alt_letter_down("LAlt", c)
        kt[f"D-RAlt-{c}"] = lambda c=c: alt_letter_down("RAlt", c)
        kt[f"U-LAlt-{c}"] = lambda c=c: alt_letter_up("LAlt", c)
        kt[f"U-RAlt-{c}"] = lambda c=c: alt_letter_up("RAlt", c)
