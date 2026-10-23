# dev-bootstrap

クレイテプスの開発環境セットアップの入口（公開）。各スクリプトは「Homebrew → gh → GitHub ログイン → private リポジトリ内のセットアップスクリプトを取得して実行」だけを行う薄い殻で、プロジェクト固有の処理・情報・秘密値は置かない。

| スクリプト | 実行 | 実体 |
|---|---|---|
| `bgu.sh` | `bash -c "$(curl -fsSL https://raw.githubusercontent.com/creatps/dev-bootstrap/main/bgu.sh)"` | `creatps/bgu-switch-on` の `scripts/setup-mac.sh` |
