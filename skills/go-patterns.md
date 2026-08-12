---
id: go-patterns
description: "Go idioms, patterns, and style conventions"
tags: ["go", "patterns", "style", "idioms"]
---

## Error handling

Return errors as the last return value. Wrap with context using `fmt.Errorf("doing X: %w", err)`. Never silently discard errors.

```go
result, err := doThing()
if err != nil {
    return fmt.Errorf("doThing: %w", err)
}
```

Sentinel errors at package scope: `var ErrNotFound = errors.New("not found")`. Check with `errors.Is`, not `==`.

## Naming

- Short names in short scopes: `i`, `n`, `b`, `s`, `r`, `w`
- Descriptive names at package scope and in exported APIs
- Interfaces: one-method interfaces end in `-er` (`Reader`, `Closer`, `Stringer`)
- Error variables: `errFoo` (unexported), `ErrFoo` (exported)
- Constructor: `New<Type>` returns `(*Type, error)` when init can fail

## Interfaces

Define interfaces at the point of use, not at the point of implementation. Keep them small — one or two methods. Accept interfaces as parameters, return concrete types from constructors.

```go
// Good: defined where consumed
type store interface {
    Get(id string) (User, error)
    Put(u User) error
}
```

## Structs

Use pointer receivers for types that have mutable state or are large. Value receivers for small immutable types. Be consistent within a type — don't mix.

```go
func NewUserStore(db *sql.DB) (*UserStore, error) {
    if db == nil {
        return nil, errors.New("db is required")
    }
    return &UserStore{db: db}, nil
}
```

## Goroutines and channels

Every goroutine must have a clear exit path. Use `context.Context` for cancellation propagation. Close channels from the sender only. Prefer `sync.WaitGroup` or `golang.org/x/sync/errgroup` over raw coordination.

```go
ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
defer cancel()
```

## Testing

Table-driven tests with `t.Run`. Use `t.TempDir()` for temp files (auto-cleaned). Test exported behaviour, not internal implementation.

```go
cases := []struct {
    name    string
    input   string
    want    string
    wantErr bool
}{
    {"empty", "", "", true},
    {"valid", "hello", "HELLO", false},
}
for _, tc := range cases {
    t.Run(tc.name, func(t *testing.T) {
        got, err := Transform(tc.input)
        if (err != nil) != tc.wantErr {
            t.Fatalf("err = %v, wantErr %v", err, tc.wantErr)
        }
        if got != tc.want {
            t.Errorf("got %q, want %q", got, tc.want)
        }
    })
}
```

## Package layout

One package per concept. Avoid `util`, `helpers`, `common` — these are signs the package needs splitting. Use `internal/` for packages that must not be imported by outside consumers. Flat structure beats deep nesting.

## Zero values

Design types so the zero value is useful and safe. Avoid `Init()` or `Open()` methods when the constructor can do the job.
