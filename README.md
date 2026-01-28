# cursor-but-fun

Play [Stimulation Clicker](https://neal.fun/stimulation-clicker/) while waiting for your Cursor AI agent to finish thinking.

## Demo

https://github.com/user-attachments/assets/YOUR_VIDEO_ID_HERE

> To add the demo: Create a new issue in your repo, drag `cursor-but-fun.mov` into the comment box, and replace the URL above with the generated link.

## What it does

`cursor-but-fun` uses **Cursor Hooks** to automatically:

1. **When you submit a prompt** → Remembers your current app, switches to Chrome with the game
2. **When the agent finishes** → Switches back to whatever app you were using (Cursor IDE, iTerm, Terminal, etc.)

No wrapper scripts, no output parsing. Just native Cursor integration.

## Requirements

- macOS (uses AppleScript for window management)
- [Cursor IDE](https://cursor.com/) or CLI (`agent`) with Hooks support
- Google Chrome

## Installation
**If you already have hooks installed, merge the configurations instead of replacing it.** 

```bash
mkdir -p ~/.cursor/hooks

cp ./hooks.json ~/.cursor/hooks.json 
cp ./hooks/switch-to-game.sh ~/.cursor/hooks/switch-to-game.sh
cp ./hooks/switch-to-terminal.sh ~/.cursor/hooks/switch-to-terminal.sh

chmod +x ~/.cursor/hooks/switch-to-game.sh ~/.cursor/hooks/switch-to-terminal.sh
```


Restart Cursor to ensure hooks are loaded.

## How it works

This project uses [Cursor Hooks](https://cursor.com/docs/agent/hooks) - a native way to extend Cursor's agent behavior:

```
┌─────────────────┐
│  You submit a   │
│  prompt         │
└────────┬────────┘
         │
         ▼
┌─────────────────┐     ┌─────────────────┐
│ beforeSubmit-   │────▶│  Switch to      │
│ Prompt hook     │     │  Chrome + Game  │
└────────┬────────┘     └─────────────────┘
         │
         │ (agent working...)
         │
         ▼
┌─────────────────┐     ┌─────────────────┐
│  stop hook      │────▶│  Switch back to │
│  (agent done)   │     │  previous app   │
└─────────────────┘     └─────────────────┘
```

### Hooks used

- **`beforeSubmitPrompt`** - Fires right after you hit send, before the request goes to the backend
- **`stop`** - Fires when the agent loop ends (completed, aborted, or error)

## Configuration

The hooks are installed to `~/.cursor/hooks.json`. To change the game URL, edit `~/.cursor/hooks/switch-to-game.sh`:

```bash
GAME_URL="https://neal.fun/stimulation-clicker/"  # Change this
```


## Files

```
~/cursor-but-fun/
├── hooks.json                  # Cursor hooks configuration
├── hooks/
│   ├── switch-to-game.sh       # Hook: switch to Chrome on prompt submit
│   └── switch-to-terminal.sh   # Hook: switch to iTerm when agent stops
└── README.md
```

## Troubleshooting

### Hooks not working

1. Check Cursor Settings → Hooks tab to see if hooks are loaded
2. Check the Hooks output channel in Cursor for errors

## License

Do whatever you want with it. Have fun.
