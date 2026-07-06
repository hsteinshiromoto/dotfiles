#!/usr/bin/env bash
set -euo pipefail

THRESHOLD=90
CONTEXT_WINDOW=1000000

get_weight() {
  case "$1" in
    Read)             echo 500 ;;
    Bash)             echo 800 ;;
    Write)            echo 600 ;;
    Edit)             echo 400 ;;
    Grep)             echo 300 ;;
    Glob)             echo 100 ;;
    WebFetch)         echo 2000 ;;
    WebSearch)        echo 1500 ;;
    Agent)            echo 3000 ;;
    Task)             echo 3000 ;;
    FileEdit)         echo 400 ;;
    DirectoryCreate)  echo 100 ;;
    FileDelete)       echo 100 ;;
    FileMove)         echo 200 ;;
    *)                echo 200 ;;
  esac
}

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

[ -z "$SESSION_ID" ] && exit 0

STATE_FILE="/tmp/cc-handover-${SESSION_ID}"

find_project_root() {
  local dir="$1"
  [ -z "$dir" ] && dir="$PWD"
  local abs_dir
  abs_dir="$(cd "$dir" 2>/dev/null && pwd)" || return 1
  local check="$abs_dir"
  for _ in 1 2 3 4 5 6 7 8; do
    if [ -d "$check/.git" ] || [ -d "$check/.claude" ]; then
      echo "$check"
      return 0
    fi
    parent="$(dirname "$check")"
    [ "$parent" = "$check" ] && break
    check="$parent"
  done
  echo "$abs_dir"
  return 0
}

PROJECT_ROOT=$(find_project_root "$CWD")
HANDOVER_DIR="${PROJECT_ROOT}/.claude/handovers"

CUMULATIVE=0
TRIGGERED=0
if [ -f "$STATE_FILE" ]; then
  read -r CUMULATIVE TRIGGERED < "$STATE_FILE" 2>/dev/null || true
  CUMULATIVE=${CUMULATIVE:-0}
  TRIGGERED=${TRIGGERED:-0}
fi

WEIGHT=$(get_weight "$TOOL_NAME")
CUMULATIVE=$((CUMULATIVE + WEIGHT))
[ "$CUMULATIVE" -gt 50000000 ] && CUMULATIVE=50000000

PCT=$(( CUMULATIVE * 100 / CONTEXT_WINDOW ))

if [ "$PCT" -ge "$THRESHOLD" ] && [ "$TRIGGERED" -eq 0 ]; then
  TRIGGERED=1
  mkdir -p "$HANDOVER_DIR"
  TIMESTAMP=$(date "+%Y-%m-%d-%H%M%S")
  HANDOVER_FILE="${HANDOVER_DIR}/handover-${TIMESTAMP}.md"

  cat > "$HANDOVER_FILE" <<- HANDOVER_EOF
# Handover — $(date "+%Y-%m-%d %H:%M:%S")

**Session ID:** \`${SESSION_ID}\`
**Context:** ${PCT}% used (~${CUMULATIVE} estimated tokens)

> ⚠️ Context threshold exceeded. Claude will fill in the sections below.

## 1. Session Summary



## 2. Objectives / Goals



## 3. Decisions Made



## 4. Initial Plan & Current State



## 5. Next Steps



---

*Generated at $(date "+%Y-%m-%d %H:%M:%S") by the handover hook.*
HANDOVER_EOF

  echo "$CUMULATIVE $TRIGGERED" > "$STATE_FILE"

  jq -n --arg path "$HANDOVER_FILE" --arg pct "$PCT" \
    '{
      hookSpecificOutput: {
        hookEventName: "PostToolUse",
        additionalContext: ("⚠️ CONTEXT AT " + $pct + "% — HANDOVER REQUIRED\n\nThe context window is nearly full. Stop your current task and:\n1. Open the handover file: " + $path + "\n2. Fill in all 5 sections based on what we have worked on this session\n3. Tell the user the handover is ready and they should start a new session with that document.")
      }
    }'
  exit 0
fi

echo "$CUMULATIVE $TRIGGERED" > "$STATE_FILE"
exit 0
