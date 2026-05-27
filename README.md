# ai-config

My personal Claude Code config, synced to GitHub so I can carry it between machines.

## How it works

This repo *is* `~/.claude`: the directory is a git repo. `.gitignore` excludes everything by default and allowlists only what's worth keeping. Edit config in place, commit, push. No symlinks, no separate repo.

## What's tracked

| File / Directory | Purpose |
|---|---|
| `CLAUDE.md` | Global instructions loaded into every Claude session |
| `rules/` | Reusable instruction files, pulled in on demand |
| `settings.json` | Model, theme, permissions (has machine-specific paths; review on a new machine) |
| `.gitignore` | Controls what's tracked |

`skills/`, `agents/`, and `commands/` are allowlisted but currently empty.

## What's excluded

Everything else - conversation history, session state, cache, credentials, and local personal context files - stays local to each machine.

## Setting up on a new machine

Claude Code creates `~/.claude/` on first run. To layer this config on top without touching local credentials or history:

```sh
cd ~/.claude
git init -b main
git remote add origin https://github.com/caitlin-a/ai-config.git
git fetch origin
git reset --hard origin/main
git branch --set-upstream-to=origin/main main
```

`git reset --hard` only overwrites tracked files; ignored files (credentials, history, etc.) are left alone.

After cloning: recreate any local personal context files and update `settings.json` for that machine (paths in the permission globs will differ).
