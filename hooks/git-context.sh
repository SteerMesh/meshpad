#!/bin/sh
# agentSpawn hook: inject git context into the session.
# Stdout is appended to the <context> section of the system prompt.
# Non-zero exit: mesh warns and continues — session still starts.

BRANCH=$(git -C "$MESH_PROJECT_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ -z "$BRANCH" ]; then
    exit 0  # not a git repo — nothing to inject
fi

echo "## Git context"
echo "Branch: $BRANCH"

COMMITS=$(git -C "$MESH_PROJECT_DIR" log --oneline -5 2>/dev/null)
if [ -n "$COMMITS" ]; then
    echo ""
    echo "Recent commits:"
    echo "$COMMITS" | while IFS= read -r line; do
        echo "  $line"
    done
fi

DIRTY=$(git -C "$MESH_PROJECT_DIR" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
if [ "$DIRTY" -gt 0 ]; then
    echo ""
    echo "Uncommitted changes: $DIRTY file(s)"
    git -C "$MESH_PROJECT_DIR" status --short 2>/dev/null | head -10 | while IFS= read -r line; do
        echo "  $line"
    done
fi
