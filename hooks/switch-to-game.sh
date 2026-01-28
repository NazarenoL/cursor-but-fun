#!/bin/bash

# switch-to-game.sh - Cursor Hook: Called before submitting a prompt
# Saves the current active app, then switches to Chrome with the game tab

GAME_URL="https://neal.fun/stimulation-clicker/"
STATE_DIR="/tmp/cursor-but-fun"

# Ensure state directory exists
mkdir -p "$STATE_DIR"

# Read hook input JSON and extract IDs.
# Avoid python/jq here; hooks run in varied environments and we only need one string field.
INPUT="$(cat)"
extract_json_string() {
    local key="$1"
    # Matches: "key": "value" with arbitrary whitespace.
    printf '%s' "$INPUT" | sed -nE "s/.*\\\"${key}\\\"[[:space:]]*:[[:space:]]*\\\"([^\\\"]+)\\\".*/\\1/p" | head -n 1
}

CONVERSATION_ID="$(extract_json_string conversation_id)"
GENERATION_ID="$(extract_json_string generation_id)"

# Key primarily by conversation_id (present across events). If missing, fall back to generation_id, then pid.
STATE_KEY="${CONVERSATION_ID:-${GENERATION_ID:-$$}}"
STATE_FILE="$STATE_DIR/${STATE_KEY}.txt"

# Get the currently active application before switching
ACTIVE_APP=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true')

# Save the active app to state file
printf '%s\n' "${ACTIVE_APP}" > "$STATE_FILE"

# Switch to Chrome and open/focus the game tab
osascript <<EOF
tell application "Google Chrome"
    activate

    set gameTabFound to false
    set gameTabIndex to 0
    set gameWindowIndex to 0

    repeat with w from 1 to (count of windows)
        set theWindow to window w
        repeat with t from 1 to (count of tabs of theWindow)
            set theTab to tab t of theWindow
            if URL of theTab contains "neal.fun" then
                set gameTabFound to true
                set gameTabIndex to t
                set gameWindowIndex to w
                exit repeat
            end if
        end repeat
        if gameTabFound then exit repeat
    end repeat

    if gameTabFound then
        set active tab index of window gameWindowIndex to gameTabIndex
        set index of window gameWindowIndex to 1
    else
        if (count of windows) = 0 then
            make new window
        end if
        tell window 1
            make new tab with properties {URL:"$GAME_URL"}
        end tell
    end if
end tell
EOF

# Return success - allow the prompt to continue
echo '{"continue": true}'
exit 0
