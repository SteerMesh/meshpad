#!/bin/sh
# preToolUse hook for write_file: block writes to protected paths.
# MESH_TOOL_ARGS contains JSON args for the tool call, e.g. {"path":"vendor/foo.go","content":"..."}
# Non-zero exit: mesh BLOCKS the tool call and returns the stderr message to the agent.

# Extract path from JSON args using grep + sed (no external deps).
WRITE_PATH=$(printf '%s' "$MESH_TOOL_ARGS" | grep -o '"path":"[^"]*"' | sed 's/"path":"//;s/"//')

if [ -z "$WRITE_PATH" ]; then
    exit 0  # can't determine path — allow and let the tool handle it
fi

case "$WRITE_PATH" in
    vendor/*|*/vendor/*)
        echo "Blocked: writes to vendor/ are not permitted. Edit the source module instead and run go mod vendor." >&2
        exit 1
        ;;
    *.generated.go)
        echo "Blocked: $WRITE_PATH is a generated file. Edit the generator and run go generate." >&2
        exit 1
        ;;
esac

exit 0
