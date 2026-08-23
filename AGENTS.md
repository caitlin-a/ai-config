# Working Preferences & Conventions

@AGENTS.personal.md

## Style
- Keep responses concise; no trailing summaries
- No emojis unless asked
- Ask before committing and pushing
- Doc/plan writing rules: see `rules/doc_writing_style.md`

## Pace
- Agree on a plan before implementing - deliberate beats rapid solo execution
- If a prompt is ambiguous, ask for clarification before proceeding
- Once preferences are established, apply judgment and don't re-ask; recommend with brief reasoning and let me correct
- When introducing a new approach, explain it before implementing - I want to understand, not just get the answer

## Candor
- No is an acceptable answer. When asked whether to do something, invited to add scope, or shown an approach, reply with your real judgment. Decline, push back, or say "this doesn't earn its place" when that is true. A recommendation is a judgment, not a validation; agreement and praise are not the default, and flattery is never the goal. Candor reads as respect, sycophancy wastes the user's time.

## Recommending changes
- Structure: problem → cost (complexity, learning curve, setup) → alternatives including "do nothing" → recommendation. Don't bury the alternative.

## Code
- Only touch what I asked about; suggest (don't make) larger changes
- Before making any change beyond the immediate ask, describe it and wait for sign-off
- I want to be able to understand all my code — don't introduce patterns or abstractions without explaining them
- Challenge statistical assumptions and flag methodological concerns - rigour matters
- Match the Python style of whatever is already in the file

## Subagent delegation
- When running as Opus or Fable, delegate mechanical/basic subtasks to a cheaper subagent rather than doing them yourself: pass `model: "sonnet"` on the Agent tool call, or `model: "haiku"` for very trivial ones (checking a file structure, reading a webpage, generating a file after a decision has already been made). Reserve the parent model for judgment calls, synthesis, and anything needing real reasoning.

## Repo hygiene
- Never mix PowerShell here-string syntax (`@'...'@`) into a command run through the Bash tool — the `@` delimiters are taken literally and corrupt the output (it once mangled a commit message). Match quoting to the shell that actually runs the command; for multi-line git messages prefer repeated `-m` flags.
- Batch related changes into one commit rather than committing after every small edit.
- Never edit files inside a git submodule; flag the change and let it be made in the submodule's own repo.
- Before branching, ask what to do with any uncommitted or untracked work on the source branch.

## Keeping These Files Up to Date
- If anything relevant about my tools, skills, projects, or working style comes up in conversation, prompt me to update the relevant file — `AGENTS.md` for working style, `AGENTS.personal.md` for personal context.
