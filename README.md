# ai-config

Personal Claude Code configuration, synced to GitHub so it can be carried between
machines (Windows and macOS).

This repository **is** `~/.claude` itself: the directory is a git repo, and
`.gitignore` ignores everything by default and allowlists only the config worth
keeping. That means there's no separate repo to sync and no symlinks — you edit
config in place, then commit.

## What's tracked

| File / Directory | Purpose |
|---|---|
| `CLAUDE.md` | Global instructions and context loaded into every Claude session |
| `rules/` | Reusable instruction files, pulled into sessions on demand |
| `skills/` | User-authored skills (`skills/<name>/SKILL.md`) |
| `agents/` | User-authored subagent definitions |
| `commands/` | User-authored slash commands |
| `projects/*/memory/` | Persistent memory written by Claude across sessions; each project has a `MEMORY.md` index and topic files |
| `.gitignore` | Controls what gets tracked |

## What's excluded

Everything else in `~/.claude/` — conversation history, session state, cache,
credentials, IDE locks, telemetry — is gitignored.

`settings.json` is **deliberately not tracked**: it contains machine-specific
paths (e.g. `Edit(C:/Users/caitl/.claude/*)` permission globs) that differ
between Windows and macOS. Each machine keeps its own.

## Setting up on a new machine

Claude Code creates `~/.claude/` with its own files on first run. To turn that
fresh directory into a clone of this repo (without touching credentials or
history, which stay gitignored):

```sh
cd ~/.claude
git init -b main
git remote add origin https://github.com/caitlin-a/ai-config.git
git fetch origin
git reset --hard origin/main
git branch --set-upstream-to=origin/main main
```

`git reset --hard` only overwrites tracked config files (`CLAUDE.md`, `skills/`,
etc.); your local credentials, history, and other ignored files are left alone.

After cloning, recreate `settings.json` for that machine (theme, model, and any
permission globs using that machine's home path).

## Day-to-day

Edit config in place, then commit and push as normal:

```sh
cd ~/.claude
git add -A
git commit -m "..."
git push
```
