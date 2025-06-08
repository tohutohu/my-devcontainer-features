
# Development Tools (rg, ast-grep, semgrep, deno) (tools)

Collection of development tools: ripgrep (rg), ast-grep, semgrep, and deno

## Example Usage

```json
"features": {
    "ghcr.io/tohutohu/my-devcontainer-features/tools:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| installRg | Install ripgrep (rg) - a blazing fast search tool | boolean | true |
| rgVersion | Version of ripgrep to install | string | latest |
| installAstGrep | Install ast-grep - a fast and polyglot tool for code structural search | boolean | true |
| astGrepVersion | Version of ast-grep to install | string | latest |
| installSemgrep | Install semgrep - static analysis tool for finding bugs and security vulnerabilities | boolean | true |
| semgrepVersion | Version of semgrep to install | string | latest |
| installDeno | Install Deno - a secure runtime for JavaScript and TypeScript | boolean | true |
| denoVersion | Version of Deno to install | string | latest |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/tohutohu/my-devcontainer-features/blob/main/src/tools/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
