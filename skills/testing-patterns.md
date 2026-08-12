---
id: testing-patterns
description: Testing strategies, patterns, and conventions
tags: [testing, quality]
---

## Table-driven tests (Go)

```go
func TestFoo(t *testing.T) {
    tests := []struct {
        name    string
        input   string
        want    string
        wantErr bool
    }{
        {"happy path", "valid", "result", false},
        {"empty input", "", "", true},
    }
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, err := Foo(tt.input)
            if (err != nil) != tt.wantErr {
                t.Fatalf("Foo() error = %v, wantErr %v", err, tt.wantErr)
            }
            if got != tt.want {
                t.Errorf("Foo() = %q, want %q", got, tt.want)
            }
        })
    }
}
```

## Mocking strategy

- Define interfaces at consumption point (not implementation point)
- Mock only external boundaries (HTTP clients, databases, filesystems)
- Never mock the thing you're testing
- Use `t.Helper()` for shared assertion functions

## Test categories

- **Unit tests**: test one function, mock dependencies, fast (< 100ms)
- **Integration tests**: test component interaction, use real deps, build tag guarded
- **Smoke tests**: verify the binary starts and basic commands work

## Coverage targets

- New code: >= 80%
- Critical paths (auth, payments, data): >= 95%
- Don't chase 100% — test behavior, not lines
