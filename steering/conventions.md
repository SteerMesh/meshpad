---
id: conventions
inclusion: always
description: "Core project conventions — always active"
globs: []
tags: []
priority: 10
---

## Project Conventions

- **Read before writing.** Understand existing code and patterns before adding to them.
- **Follow what's already there.** Consistency beats personal preference. Match the style of the surrounding code.
- **Minimum viable change.** Write the smallest code that correctly solves the problem. No speculative abstractions, no features that weren't asked for.
- **No explanatory comments.** Good names do the work. Comments explain *why* — hidden constraints, workarounds, non-obvious invariants — not *what*.
- **Prefer editing existing files** over creating new ones.
- **Test behaviour, not implementation.** Tests break when behaviour changes, not when you refactor internals.
- **When in doubt, do less and ask.** Clarifying scope early costs nothing. Undoing an overbuilt feature costs a lot.
