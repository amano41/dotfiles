"""タイトルケースに変換する"""

import re
import sys

import common  # noqa

_WORDS = re.compile(r"[A-Za-z]+(?:['’][A-Za-z]+)*")
_SUBTITLES = re.compile(r"([:!?][ \t]+)")  # キャプチャの丸括弧をつけると
_NEWLINES = re.compile(r"(\r\n|\r|\n)")    # split 時に結果のリストに含まれる

# 3 文字以下の冠詞・等位接続詞・前置詞
# タイトル・サブタイトルの先頭以外では小文字にする
_MINORS = frozenset(
    {
        "a",
        "an",
        "the",
        "and",
        "but",
        "for",
        "nor",
        "or",
        "yet",
        "at",
        "by",
        "in",
        "of",
        "on",
        "per",
        "to",
    }
)


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

        after_hyphen = match.start() > 0 and segment[match.start() - 1] == "-"

        if not is_first and not after_hyphen and word.lower() in _MINORS:
            return word.lower()

        if not uppercase_title:
            if word.isupper():
                return word
            if any(ch.isupper() for ch in word[1:]):
                return word

        return word[0].upper() + word[1:].lower()

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
