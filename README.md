# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Windows

### 1. Bootstrap

PowerShell を起動して以下のコマンドを実行する。

```powershell
irm https://raw.githubusercontent.com/amano41/dotfiles/main/bootstrap.ps1 | iex
```

Git，PowerShell 7，chezmoi がインストールされ，`chezmoi init` で dotfiles リポジトリが取得される。

### 2. Setup

［設定］➔［システム］➔［詳細設定］を開き，［sudo の有効化］をオンにする。
オプションの［sudo によるアプリケーションの実行方法を構成する］を［インライン］にする。

新しく PowerShell 7 (`pwsh`) を起動して以下のコマンドを実行する。

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

```powershell
& (Join-Path (Split-Path (chezmoi source-path)) "scripts/windows/setup.ps1")
```

途中で age の秘密鍵を求められたら以下に配置する。

```text
~/.config/chezmoi/key.txt
```

鍵の配置後に Enter キーを押すと `chezmoi apply` で dotfiles が反映される。
