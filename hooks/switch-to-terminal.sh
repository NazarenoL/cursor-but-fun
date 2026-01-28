#!/bin/bash

# switch-to-terminal.sh - Cursor Hook: Called when agent stops
# Restores focus to the app that was active before the game switch

STATE_DIR="/tmp/cursor-but-fun"

# Read hook input JSON and extract IDs (same strategy as switch-to-game.sh).
INPUT="$(cat)"
extract_json_string() {
    local key="$1"
    printf '%s' "$INPUT" | sed -nE "s/.*\\\"${key}\\\"[[:space:]]*:[[:space:]]*\\\"([^\\\"]+)\\\".*/\\1/p" | head -n 1
}

CONVERSATION_ID="$(extract_json_string conversation_id)"
GENERATION_ID="$(extract_json_string generation_id)"

STATE_KEY="${CONVERSATION_ID:-${GENERATION_ID:-$$}}"
STATE_FILE="$STATE_DIR/${STATE_KEY}.txt"

# Default to Cursor if no state file found
PREVIOUS_APP="Cursor"

# Try to read the previous app from state file
if [[ -f "$STATE_FILE" ]]; then
    SAVED_APP="$(cat "$STATE_FILE" 2>/dev/null | head -n 1)"
    if [[ -n "$SAVED_APP" ]]; then
        PREVIOUS_APP="$SAVED_APP"
    fi
    # Clean up state file
    rm -f "$STATE_FILE"
fi

# Switch back to the previous application
osascript -e "tell application \"$PREVIOUS_APP\" to activate"

# Return empty response
echo '{}'
exit 0
