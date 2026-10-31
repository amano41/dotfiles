"""センテンスケースに変換する"""

import re
import sys

import common  # noqa

_WORDS = re.compile(r"[A-Za-z]+(?:['’][A-Za-z]+)*")
_SUBTITLES = re.compile(r"([:!?][ \t]+)")
_NEWLINES = re.compile(r"(\r\n|\r|\n)")


def _convert_segment(segment):
    matches = list(_WORDS.finditer(segment))
    if not matches:
        return segment

    uppercase_title = segment.isupper() and len(matches) > 1
    first_word = True

    def replace(match):
        nonlocal first_word

        word = match.group()

        is_first = first_word
        first_word = False

        if re.fullmatch(r"i(?:['’](?:m|ve|ll|d))?", word, flags=re.IGNORECASE):
            return "I" + word[1:].lower()

        if not uppercase_title:
            if word.isupper():
                return word
            if any(ch.isupper() for ch in word[1:]):
                return word

        word = word.lower()
        return word[0].upper() + word[1:] if is_first else word

    return _WORDS.sub(replace, segment)


def _convert_line(line):
    parts = _SUBTITLES.split(line)
    for i in range(0, len(parts), 2):
        parts[i] = _convert_segment(parts[i])
    return "".join(parts)


def _format(data):
    parts = _NEWLINES.split(data)
    for i in range(0, len(parts), 2):
        parts[i] = _convert_line(parts[i])
    return "".join(parts)


def main():
    sys.stdout.write(_format(sys.stdin.read()))


if __name__ == "__main__":
    main()
