---
id: pr-conventions
description: Pull request conventions and review checklist
tags: [git, pr, review]
---

## PR title

Format: `type(scope): description` (< 70 chars)

Types: feat, fix, refactor, docs, test, chore, ci

Examples:
- `feat(compiler): add cursor compile target`
- `fix(tui): prevent crash on empty viewport`
- `refactor(cli): extract pad commands to separate file`

## PR description

Must include:
1. **Summary** — one sentence, what and why
2. **Changes** — bullet list of modifications
3. **Testing** — how it was verified

Optional:
- Breaking changes (if any)
- Screenshots (for UI changes)
- Related issues/tickets

## Review checklist

Before marking ready:
- [ ] `go build ./...` passes
- [ ] `go test ./...` passes
- [ ] No new lint warnings
- [ ] New code has tests
- [ ] No hardcoded paths or secrets
- [ ] Changes are scoped (one concern per PR)

## Branch naming

Format: `type/short-description`

Examples: `feat/cursor-target`, `fix/banner-rendering`, `docs/cli-reference`
