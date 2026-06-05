# ai-config

My AI agent config - Claude Code and Cursor.

## What's tracked

| | |
|---|---|
| `AGENTS.md` | Working preferences + personal context (tool-neutral; loaded by all agents) |
| `CLAUDE.md` | One-line shim: `@AGENTS.md` |
| `settings.json` | Claude Code settings - model, theme, permissions (no machine-specific paths) |
| `rules/` | Modular instruction files (e.g. writing style) |
| `skills/` | Custom skills - linked into `~/.cursor/commands/` for Cursor |

## What stays local

| | |
|---|---|
| `~/.claude/AGENTS.personal.md` | Personal context - private |
| `~/.claude/settings.local.json` | Machine-specific permissions (absolute paths) |
| `~/.claude/history.jsonl` | Conversation history, session state, cache |

## Setup

Usually called from `dotfiles/setup.sh`, but works standalone:

```bash
git clone git@github.com:caitlin-a/ai-config.git
bash ai-config/setup.sh
```

Symlinks config into `~/.claude/` and skills into `~/.cursor/commands/`. Idempotent.

After first run: create `~/.claude/AGENTS.personal.md` with your personal context.
