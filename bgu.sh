#!/usr/bin/env bash
# creatps dev-bootstrap — 開発環境セットアップの入口（公開リポ・薄い殻）
#
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/creatps/dev-bootstrap/main/bgu.sh)"
#
# やること（ここに固有の処理・固有情報・秘密値は置かない）:
#   1. Homebrew が無ければ導入（sudo パスワードを求められることがある）
#   2. gh（GitHub CLI）が無ければ導入
#   3. gh が未認証なら `gh auth login --web`（ブラウザ承認）
#   4. 認証済みの gh で private リポジトリ内のセットアップスクリプトを取得し、そのまま実行する
#      （実体: creatps/bgu-switch-on の scripts/setup-mac.sh。以降の処理はすべてそちら）
#
# 環境変数（任意）: BOOTSTRAP_REF — 取得するブランチ／タグ（既定 main）
set -Eeuo pipefail

REPO="creatps/bgu-switch-on"
SCRIPT_PATH="scripts/setup-mac.sh"
REF="${BOOTSTRAP_REF:-main}"

log() { printf '\033[1;34m[bootstrap]\033[0m %s\n' "$*"; }
die() { printf '\033[1;31m[bootstrap][ERROR]\033[0m %s\n' "$*" >&2; exit 1; }
tty_in() { if [ -t 0 ]; then "$@"; else "$@" < /dev/tty; fi; }

[ "$(uname -s)" = "Darwin" ] || die "macOS 専用です"

# 1. Homebrew
if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi
if [ -x /usr/local/bin/brew ];  then eval "$(/usr/local/bin/brew shellenv)";  fi
if ! command -v brew >/dev/null 2>&1; then
	log "Homebrew を導入します"
	NONINTERACTIVE=1 tty_in /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; else eval "$(/usr/local/bin/brew shellenv)"; fi
	command -v brew >/dev/null 2>&1 || die "Homebrew の導入に失敗しました"
fi

# 2. gh
if ! command -v gh >/dev/null 2>&1; then
	log "GitHub CLI（gh）を導入します"
	brew install gh
fi

# 3. gh 認証
if ! gh auth status -h github.com >/dev/null 2>&1; then
	log "GitHub にログインします（ブラウザで表示されるコードを承認してください）"
	tty_in gh auth login --hostname github.com --git-protocol https --web
	gh auth status -h github.com >/dev/null 2>&1 || die "gh の認証が完了していません"
fi

# 4. セットアップスクリプトを取得して実行
log "取得: ${REPO} ${REF} ${SCRIPT_PATH}"
script="$(gh api "repos/${REPO}/contents/${SCRIPT_PATH}?ref=${REF}" -H 'Accept: application/vnd.github.raw')" \
	|| die "スクリプトを取得できません（${REPO} へのアクセス権を確認してください）"
[ -n "$script" ] || die "取得したスクリプトが空です"
exec bash -c "$script"
