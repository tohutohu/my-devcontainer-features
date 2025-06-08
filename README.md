# Dev Container Features: Personal Development Tools

[devcontainers/images](https://github.com/devcontainers/images/tree/main/src/universal) の universal イメージをベースとした devcontainer に個人的に利用したいツールを追加するための [dev container Features](https://containers.dev/implementors/features/) リポジトリです。

## Features

### `tools` - 開発ツールコレクション

ripgrep (rg)、ast-grep、semgrep の3つの開発ツールをまとめてインストールする Feature です。

#### 使用例

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/universal:2-linux",
    "features": {
        "ghcr.io/to-hutohu/devcontainer-features/tools:1": {}
    }
}
```

#### オプション

| オプション | 説明 | タイプ | デフォルト値 |
|-----|-----|-----|-----|
| installRg | ripgrep (rg) をインストール | boolean | true |
| rgVersion | ripgrep のバージョン | string | latest |
| installAstGrep | ast-grep をインストール | boolean | true |
| astGrepVersion | ast-grep のバージョン | string | latest |
| installSemgrep | semgrep をインストール | boolean | true |
| semgrepVersion | semgrep のバージョン | string | latest |

#### カスタマイズ例

特定のツールのみインストール:
```jsonc
{
    "features": {
        "ghcr.io/to-hutohu/devcontainer-features/tools:1": {
            "installRg": true,
            "installAstGrep": false,
            "installSemgrep": true
        }
    }
}
```

特定のバージョンを指定:
```jsonc
{
    "features": {
        "ghcr.io/to-hutohu/devcontainer-features/tools:1": {
            "rgVersion": "latest",
            "astGrepVersion": "0.12.0",
            "semgrepVersion": "1.45.0"
        }
    }
}
```

## インストールされるツール

### ripgrep (rg)
高速なファイル内容検索ツール。正規表現を使用してディレクトリを再帰的に検索します。

### ast-grep
コード構造を理解して検索・リファクタリングを行うツール。構文木ベースの検索が可能です。`ast-grep` と `sg` の両コマンドが利用可能です。

### semgrep
バグ、コードの匂い、セキュリティ脆弱性を見つけるための静的解析ツール。

## リポジトリ構造

```
├── src
│   └── tools
│       ├── devcontainer-feature.json
│       ├── install.sh
│       └── README.md
└── test
    └── ...
```

## ライセンス

MIT