---
id: architecture-patterns
description: Architecture patterns and design principles
tags: [architecture, design]
---

## Package organization (Go)

```text
cmd/<binary>/       → thin main, wires dependencies
internal/cli/       → cobra commands (one per file)
internal/<domain>/  → business logic (no framework deps)
internal/model/     → shared data types
internal/backend/   → external service adapters
```

## Interface design

- Define interfaces where they're consumed, not where they're implemented
- Keep interfaces small (1-3 methods)
- Use composition: `io.ReadCloser` = `io.Reader` + `io.Closer`

## Dependency direction

```text
cmd → cli → domain ← adapters
                ↑
              model
```

- Domain code never imports adapters
- Adapters implement domain interfaces
- Config flows inward (cmd → cli → domain)

## Error handling

- Wrap errors with context: `fmt.Errorf("load config: %w", err)`
- Define sentinel errors for expected cases: `var ErrNotFound = errors.New("not found")`
- Return errors, don't panic (except truly unrecoverable)
- Log at the boundary, not in library code

## Concurrency patterns

- Own the goroutine lifecycle (start + stop in the same scope)
- Use `context.Context` for cancellation
- Prefer channels for coordination, mutexes for state protection
- Never start a goroutine without a way to stop it
