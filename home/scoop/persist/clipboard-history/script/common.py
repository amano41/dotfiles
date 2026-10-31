"""
Clipboard-History で共通に使用する設定
"""

import codecs
import os
import sys

## エンコーディングを Shift_JIS に変更する
## PYTHONUTF8 が有効だとパイプで文字化けが発生するため
sys.stdin = codecs.getreader("shift_jis")(sys.stdin.buffer)
sys.stdout = codecs.getwriter("shift_jis")(sys.stdout.buffer)

## 改行コード LF のままで入出力できるようにする
#sys.stdin = codecs.getreader("utf_8")(sys.stdin.buffer)
#sys.stdout = codecs.getwriter("utf_8")(sys.stdout.buffer)
