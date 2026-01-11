## dotfiles

このディレクトリは、ホームディレクトリの設定ファイル（dotfiles）を Git などで管理するための場所です。
素の Arch Linux を入れたあと、ここを clone してスクリプトを 1 本叩けば、最低限の開発環境とシェル設定が再現できることを目指しています。

### 構成（初期）

- `zsh/.zshrc` : Zsh 用の設定
- `git/.gitconfig` : Git 全体設定
- `packages/arch-base.txt` : Arch 用の基本パッケージ一覧
- `install-arch.sh` : Arch Linux 用のセットアップスクリプト

---

### 素の Arch Linux からの再現手順

1. 必要最低限のパッケージを入れる（root もしくは sudo できるユーザで）:

   ```bash
   pacman -Syu --needed git
   ```

2. ユーザのホームディレクトリに dotfiles を clone:

   ```bash
   cd ~
   git clone git@github.com:<your-name>/dotfiles.git .dotfiles
   cd .dotfiles
   ```

3. セットアップスクリプトを実行（ユーザ権限で OK、途中で sudo を要求されます）:

   ```bash
   ./install-arch.sh
   ```

   このスクリプトが行うこと:

   - `packages/arch-base.txt` に書かれたパッケージを `pacman -Syu --needed` でインストール
   - `~/.zshrc` と `~/.gitconfig` を、`~/.dotfiles/zsh/.zshrc` と `~/.dotfiles/git/.gitconfig` への symlink にする  
     - 既存のファイルがあれば `*.bak.YYYYMMDDHHMMSS` に自動バックアップ
   - `zsh` が入っていれば、`chsh -s $(which zsh)` でログインシェルを Zsh に変更（失敗したらメッセージ表示）

4. 一度ログアウトして再ログイン、もしくはターミナルを開き直して Zsh が立ち上がることを確認します。

---

### 手動での使い方の例（任意）

1. このディレクトリを Git リポジトリにする:

   ```bash
   cd ~/.dotfiles
   git init
   git add .
   git commit -m \"Initial dotfiles\"
   ```

2. シンボリックリンクを貼る（手動で行う例）:

   ```bash
   ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc
   ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig
   ```

3. GNU Stow を使う場合（任意）:

   ```bash
   # まだならインストール
   # sudo pacman -S stow
   cd ~/.dotfiles
   stow zsh
   stow git
   ```

既存の `~/.zshrc` や `~/.gitconfig` がある場合は、上書きせずに内容をマージしてから symlink 化することをおすすめします。

