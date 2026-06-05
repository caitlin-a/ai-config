# ai-config

My personal AI agent config, pushed to GitHub so I can share with others and port between machines. Attempting to make model-agnostic.

Intended to be used as a submodule of [`dotfiles`](https://github.com/caitlin-a/dotfiles), where `setup.sh` symlinks everything into place so the same config is available on any machine. Changes are auto-committed and pushed daily to the `auto/sync` branch via `dotfiles/sync.sh`. Merge to main manually whenever you're happy with it.

## Layout

```
ai-config/
├── AGENTS.md               # source of truth — tool-neutral working prefs + personal context
├── CLAUDE.md               # one-line @AGENTS.md shim for Claude Code's loader
├── settings.json           # Claude Code settings (model, theme, permissions)
├── setup.sh                # symlinks everything into ~/.claude and ~/.cursor/commands
├── rules/                  # modular instruction files (e.g. writing style)
└── skills/                 # custom skills — each linked into ~/.cursor/commands/<name>.md
```

`AGENTS.md` is the canonical source of truth — tool-neutral, readable by any agent. `CLAUDE.md`
is a one-line shim so Claude Code's `~/.claude/CLAUDE.md` loader picks it up.

## What stays local (not tracked)

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

Idempotent - safe to re-run. Creates:

- `~/.claude/CLAUDE.md` -> `CLAUDE.md`
- `~/.claude/AGENTS.md` -> `AGENTS.md`
- `~/.claude/settings.json` -> `settings.json`
- `~/.claude/rules` -> `rules/`
- `~/.cursor/commands/<name>.md` -> `skills/<name>/SKILL.md` (one per skill)

After first run: create `~/.claude/AGENTS.personal.md` with your personal context.

## Cursor note

Cursor has no global `AGENTS.md` file location. To apply these rules globally in Cursor,
paste `AGENTS.md` into Settings -> Rules once per machine (and re-paste after edits).
Per-project use works normally - Cursor reads `AGENTS.md` in a repo root automatically.
