---
id: architecture
inclusion: auto
description: "Architecture principles — active when discussing design or structure"
globs: []
tags: ["architecture", "design", "structure", "refactor", "package", "module"]
priority: 5
---

## Architecture Principles

- **Single responsibility per package.** If a package is named `util`, `helpers`, or `common`, it needs to be split into packages with real names.
- **Dependencies point inward.** `cmd/` depends on `internal/`. `internal/` packages import each other explicitly. Nothing in `internal/` imports `cmd/`.
- **`internal/` is free territory.** Packages under `internal/` are not part of any public API. Use them freely, rename them, split them — no external consumers can break.
- **Circular imports are a design signal.** Go prevents them, but wanting them means two packages belong together or a third package needs to be extracted.
- **Interfaces at the point of use.** A package should not export an interface that only it implements. Define the interface where it is consumed.
- **Configuration at the boundary.** CLI flags, env vars, and config files are read in `cmd/`. Internal packages receive typed values. No `os.Getenv` deep in a library package.
- **Data flows in one direction.** Avoid packages that call each other in a cycle via callbacks or registries. If you find one, extract the shared concept.
