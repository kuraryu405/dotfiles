#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
PACKAGES_FILE="$DOTFILES_DIR/packages/arch-base.txt"

echo "==> Arch Linux 用 dotfiles セットアップを開始します"

if ! command -v pacman >/dev/null 2>&1; then
  echo "このスクリプトは Arch Linux (pacman) 専用です。" >&2
  exit 1
fi

if [ ! -f "$PACKAGES_FILE" ]; then
  echo "パッケージファイルが見つかりません: $PACKAGES_FILE" >&2
  exit 1
fi

echo "==> パッケージリストを読み込み中: $PACKAGES_FILE"
mapfile -t PKGS < <(grep -vE '^\s*($|#)' "$PACKAGES_FILE" || true)

if [ "${#PKGS[@]}" -gt 0 ]; then
  echo "==> pacman で基本パッケージをインストールします:"
  printf '    %s\n' "${PKGS[@]}"
  sudo pacman -Syu --needed --noconfirm "${PKGS[@]}"
else
  echo "インストール対象パッケージがありません（ファイルが空か、すべてコメントアウトされています）。"
fi

backup_if_needed() {
  local src="$1"
  local dst="$2"

  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    local backup="${dst}.bak.$(date +%Y%m%d%H%M%S)"
    echo "==> 既存ファイルをバックアップ: $dst -> $backup"
    mv "$dst" "$backup"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -sfn "$src" "$dst"
  echo "==> symlink 作成: $dst -> $src"
}

echo "==> Zsh / Git の設定を symlink します"
backup_if_needed "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
backup_if_needed "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

if command -v zsh >/dev/null 2>&1; then
  ZSH_PATH="$(command -v zsh)"
  if [ "${SHELL:-}" != "$ZSH_PATH" ]; then
    echo "==> デフォルトシェルを zsh に変更します: $ZSH_PATH"
    chsh -s "$ZSH_PATH" || echo "chsh に失敗しました。手動で \`chsh -s $ZSH_PATH\` を実行してください。"
  fi
else
  echo "zsh が見つかりませんでした。パッケージリストに zsh が入っているか確認してください。" >&2
fi

echo
echo "==> セットアップ完了！一度ログアウトし、再ログインして zsh が有効になっているか確認してください。"

