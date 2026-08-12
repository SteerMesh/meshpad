---
id: security-review
description: "Security review checklist — injection, auth, secrets, crypto"
tags: ["security", "review", "vulnerability", "audit"]
---

## Input validation

- All inputs from external sources (HTTP requests, files, env vars, CLI args) are validated before use.
- String inputs are length-bounded. Numeric inputs are range-checked.
- File paths are sanitized and resolved with `filepath.Clean` before use. Check for path traversal: reject paths containing `..` or that resolve outside the expected root.

## Injection

**SQL:** parameterized queries only — no string concatenation in query construction.

```go
// Good
rows, err := db.Query("SELECT * FROM users WHERE id = $1", id)

// Bad — never do this
rows, err := db.Query("SELECT * FROM users WHERE id = " + id)
```

**Shell:** avoid `exec.Command("sh", "-c", userInput)`. Use `exec.Command` with separate args so the shell never sees user data.

**Templates:** use `html/template` for web output, never `text/template`. User-supplied values are escaped automatically.

## Authentication and authorization

- Authentication precedes all resource access — no early returns that skip auth.
- Authorization is per-operation, not just at session start.
- Tokens, session IDs, and secrets never appear in logs, error messages, URLs, or response bodies.
- Short-lived tokens are preferred. Implement rotation.

## Secrets and credentials

- No hardcoded secrets, API keys, passwords, or connection strings in source.
- Runtime secrets via environment variables or a secret manager, not config files checked into git.
- `.gitignore` must cover `.env`, `*.pem`, `*.key`, `*secret*`, `credentials.*`.
- Verify `git log --all -S <secret>` before shipping if a secret was accidentally committed.

## Cryptography

- Random values: `crypto/rand`, never `math/rand`.
- Hashing passwords: `bcrypt` or `argon2id`, never `sha256` or `md5`.
- Use standard library crypto — no custom crypto implementations.
- TLS: minimum 1.2, prefer 1.3. Do not disable certificate verification (`InsecureSkipVerify = true` is never acceptable in production).
- Avoid deprecated algorithms: no MD5, SHA1, DES, RC4.

## Error handling

- Errors returned to external callers are generic: "internal server error", "not found". Detailed context goes to structured logs only.
- No stack traces, internal paths, or SQL query text in client-facing error responses.
- Distinguish between programmer errors (panic) and operational errors (return error).

## Concurrency

- Shared mutable state protected by `sync.Mutex` or `sync.RWMutex`, or accessed only through channels.
- Run tests with `-race` to catch data races.
- Never close a channel from the receiver side.

## Dependencies

- Check new dependencies for known CVEs before adding (`govulncheck ./...`).
- Prefer the standard library when it's sufficient.
- Audit indirect dependencies in `go.sum` when adding a new direct dependency.
