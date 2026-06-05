# ai-config

Personal AI agent configuration. Works as a standalone repo or as a submodule of [dotfiles](https://github.com/caitlin-a/dotfiles).

Inspired by [Jamie's agent-configs](https://github.com/jmemich/agent-configs).

## What's here

| File/Dir | Purpose |
|---|---|
| `AGENTS.md` | Source of truth — tool-neutral working preferences, loaded by all agents |
| `CLAUDE.md` | One-line shim: `@AGENTS.md` |
| `settings.json` | Claude Code settings (model, theme, permissions) — no machine-specific paths |
| `rules/` | Modular instruction files (e.g. writing style) |
| `skills/` | Custom skills, linked into `~/.cursor/commands/` for Cursor |

## What stays local (not tracked)

| File | Why |
|---|---|
| `~/.claude/AGENTS.personal.md` | Personal context: who I am, projects, tools — private |
| `~/.claude/settings.local.json` | Machine-specific permissions (absolute paths) |
| `~/.claude/history.jsonl` | Conversation history |

## Setup

Usually run via `dotfiles/setup.sh`, but can be run standalone:

```bash
git clone git@github.com:caitlin-a/ai-config.git
bash ai-config/setup.sh
```

`setup.sh` symlinks config files into `~/.claude/` and skills into `~/.cursor/commands/`. Idempotent - safe to re-run.

After first run, create `~/.claude/AGENTS.personal.md` with your personal context.
