# Development Tools (rg, ast-grep, semgrep, deno)

Collection of development tools: ripgrep (rg), ast-grep, semgrep, and deno.

## Example Usage

```json
"features": {
    "ghcr.io/to-hutohu/devcontainer-features/tools:1": {}
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

## Installed Tools

### ripgrep (rg)
A blazing fast search tool that recursively searches directories for a regex pattern.

### ast-grep
A fast and polyglot tool for code structural search, lint and rewriting. Both `ast-grep` and `sg` commands will be available.

### semgrep
Static analysis tool for finding bugs, code smells, and security vulnerabilities.

### Deno
A secure runtime for JavaScript and TypeScript with native TypeScript support and built-in tooling.

## Customization Examples

Install only specific tools:
```json
"features": {
    "ghcr.io/to-hutohu/devcontainer-features/tools:1": {
        "installRg": true,
        "installAstGrep": false,
        "installSemgrep": true,
        "installDeno": true
    }
}
```

Install specific versions:
```json
"features": {
    "ghcr.io/to-hutohu/devcontainer-features/tools:1": {
        "rgVersion": "14.1.0",
        "astGrepVersion": "0.12.0",
        "semgrepVersion": "1.45.0",
        "denoVersion": "1.40.0"
    }
}
```

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/to-hutohu/devcontainer-features/blob/main/src/tools/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._