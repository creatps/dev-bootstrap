# dev-bootstrap

クレイテプスの開発環境セットアップの入口（公開）。各スクリプトは「Homebrew → gh → GitHub ログイン → private リポジトリ内のセットアップスクリプトを取得して実行」だけを行う薄い殻で、プロジェクト固有の処理・情報・秘密値は置かない。

| スクリプト | 実行 | 実体 |
|---|---|---|
| `bgu.sh` | `bash -c "$(curl -fsSL https://raw.githubusercontent.com/creatps/dev-bootstrap/main/bgu.sh)"` | `creatps/bgu-switch-on` の `scripts/setup-mac.sh` |

既存 clone がある場合は自動で main を取り込む（起動スクリプトが無い古い main のときだけ fast-forward）。未コミットの変更があるときは何も変えずに案内を表示して停止する。
