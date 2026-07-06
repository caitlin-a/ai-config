---
name: create-mcp-guide
description: >-
  Authors Cursor MCP install KB guides in idp-docs (WHAT/WHY/HOW format).
  Use when creating or updating kb_*_mcp_setup_cursor.md files, writing MCP
  server documentation, or when the user asks for a Cursor MCP install guide.
disable-model-invocation: true
---

# Create MCP Guide (Cursor)

Author human-facing KB articles for **Cursor** MCP server setup in **idp-docs**.

> **Workspace:** Open the **idp-docs** repository. Paths below are relative to the repo root. Read exemplar guides from `docs/technical-practices/ai-capabilities/mcp-servers/` before drafting.

> **VS Code / GitHub Copilot:** This skill targets Cursor guides only. To adapt for VS Code, use `"servers"` instead of `"mcpServers"` in `mcp.json`, link `docs/technical-practices/ai-capabilities/mcp-servers/kb_connecting_vscode_to_mcp_server.md`, and enable GitHub Copilot Agent Mode. Existing VS Code guides (`kb_*_mcp_setup.md` without `_cursor`) in the same folder are the style reference for that variant.

## Output location

```
docs/technical-practices/ai-capabilities/mcp-servers/kb_<service>_mcp_setup_cursor.md
```

## Length

Aim for **~1,000 words** (body, excluding frontmatter and code blocks) when the setup is straightforward. **Exceed this when the MCP needs it** — Docker prereqs, multi-key auth, WSL vs Windows splits, or large tool tables. Match the proportionality of the closest exemplar in [reference.md](reference.md); do not pad and do not cut essential steps.

## Orchestration (multi-agent workflow)

When the user asks for a full guide with review and testing, act as **orchestrator**. Delegate work; do minimal writing yourself. All subagents **must use Composer 2.5 Standard** (`model: "composer-2.5"` with orchestrator on Standard tier — not Fast).

| Role | Responsibility |
|------|----------------|
| **Writer** | Drafts or updates the markdown from gathered info |
| **Reviewer** | Checks style, structure, accuracy vs exemplars; returns actionable feedback |
| **Tester** | Follows the doc alone to configure MCP from scratch; reports confusion *(optional if user lacks MCP access)* |

### Plan

1. Writer creates initial doc (user's current setup + upstream docs).
2. **Review loop** (max 3): Reviewer → feedback → Writer updates.
3. **Test loop** (max 10, optional): Tester follows doc only → feedback → Writer updates. Skip if user has no MCP access or asks for doc-only. Escalate after 10 failures.

Use a temporary plan tracker at `docs/technical-practices/ai-capabilities/mcp-servers/_<service>_mcp_plan.md` if helpful. **Do not commit** plan or calibration files.

### Scope constraints (unless user overrides)

- **Only** create or edit the target `kb_*_mcp_setup_cursor.md` file.
- **Never** paste the user's personal credentials into the document.
- **Do not** commit or push unless the user explicitly asks.
- **Do not** include unrelated setup (e.g. Databricks extension) — link out instead.

### Platform notes

- Many readers use **Windows native Cursor**; author may be on **WSL**. Call out when config paths differ:
  - WSL / Remote-WSL: `~/.cursor/mcp.json`
  - Windows native: `%USERPROFILE%\.cursor\mcp.json`
- Document both paths where setup diverges.

## Before writing

1. Read [reference.md](reference.md) for exemplars and config patterns.
   - WHAT persona line — copy from the closest gold exemplar; do not default to Platform Engineer when the exemplar uses a different role. Use a service-specific persona when the user or domain dictates it (e.g. **member of the Product and Delivery team** for Aha!)
   - Scope **WHAT** and **WHY** to what readers can actually do after setup. Verify exposed tools or org policy before claiming capabilities — do not invent tools. Note org-specific limits once (e.g. in **Available Capabilities**), not across WHAT/WHY/Troubleshooting
2. Gather from the user (or upstream MCP README):
   - Service name and one-line purpose
   - Install/runtime method (`npx`, `uvx`, `docker`, binary, remote HTTP/SSE URL)
   - Required env vars and how to obtain credentials
   - Whether credentials are **required** or **optional** (e.g. public registry only, anonymous rate-limited mode) — lead with the lowest-friction path
   - Available MCP tools (names + short descriptions)
   - CFC-specific domains, endpoints, org slugs, project names, and permission caveats — **preserve org-specific values from the closest gold exemplar** (e.g. `cfcunderwriting`, `Engineering` project, workspace hostnames) unless the user explicitly requests generic placeholders
   - Example prompts that prove the connection works
3. Search `docs/technical-practices/ai-capabilities/mcp-servers/` for an existing guide — update in place rather than duplicate.

## Document structure

Every guide uses this structure (see `docs/technical-practices/documentation-standards/template-files/kb_template.md` for general KB rules):

### YAML frontmatter

```yaml
---
title: 'KB - Configuring <Service> MCP Server in Cursor'
tags:
  - <service-slug>
  - mcp
  - cursor
  - how-to
  - integration
---
```

Add domain tags as needed (`itsm`, `documentation`, `azure`, etc.).

### WHAT

```markdown
## **WHAT**

___

**AS A** <persona from closest exemplar — e.g. Developer, Security Engineer or Developer, Developer or Data Engineer>
**I WANT TO** configure the <Service> MCP server in Cursor
**SO THAT** I can <concrete benefit using natural language>
```

### WHY

4–6 bullet points: productivity, no context-switch, specific capabilities enabled. Be concrete (example prompts in parentheses).

### HOW

#### Prerequisites

Order: service account and access first, then admin/org gates, then Cursor and runtime deps, then network.

- Cursor installed
- Link `kb_connecting_cursor_to_mcp_server.md` (same folder as the output guide) when helpful
- Runtime deps (Node, `uv`, Docker, etc.)
- Account/access and credentials
- Network reachability to required endpoints

#### Numbered steps

**Step order is exemplar-specific** — read the closest gold guide before numbering steps. The list below is a common default only; do **not** force it when the exemplar uses a different pedagogy:

| Pattern | When | Example |
|---------|------|---------|
| Credentials first | Portal keys/PAT must exist before install or config | Tenable (API keys → pip), Azure DevOps (PAT → configure) |
| Runtime in Prerequisites only | Install is not a numbered onboarding step | Azure DevOps (Node.js in Prerequisites) |
| Configure before token | HTTP/managed MCP: add server block with placeholder, then obtain PAT | Databricks (hostname → configure → PAT) |
| Settings opens config file | **+ Add New MCP Server** opens `mcp.json` — use one combined numbered step (paths + JSON), not separate Option A / Option B | Databricks, Aha! |
| OAuth / session only | No tokens or env vars in `mcp.json`; skip **Secure Your Credentials** numbered step | Aha! remote MCP |
| Default stdio flow | No exemplar-specific inversion | Freshservice, Terraform, Context7 |

Typical flow (when no exemplar override applies):

1. **Install runtime** (if not built-in) — **Windows PowerShell** and **macOS/Linux** blocks when CLI install differs
2. **(Optional) Obtain credentials** — when the MCP supports a no-auth or registry-only path, mark this step optional and state what requires a token
3. **Configure MCP server** — when **+ Add New MCP Server** opens `mcp.json` (Databricks, Aha!), combine Settings navigation and JSON in one step; otherwise Settings UI first (Option A), then config file (Option B). Include no-auth and authenticated JSON variants when both exist
4. **Secure Your Credentials** — numbered step when the guide uses API keys, PATs, or env vars: `.gitignore` for workspace `mcp.json`, `${env:VAR}` pattern, PowerShell + macOS/Linux env setup, CLI-flag alternatives where applicable (e.g. `--api-key`). **Omit** when auth is OAuth/session-only and nothing secret goes in `mcp.json`
5. **Verify connection** — restart/reload MCP; name expected tools when the MCP uses multi-step flows; one copy-paste test prompt in Agent chat (and Composer when relevant). Do not put post-connection failure guidance in pre-verify steps — use **Troubleshooting**

#### Cursor configuration

| Scope | Path |
|-------|------|
| Global (WSL) | `~/.cursor/mcp.json` |
| Global (Windows) | `%USERPROFILE%\.cursor\mcp.json` |
| Workspace | `<repo-root>/.cursor/mcp.json` |

**Combined flow (when Add MCP Server opens `mcp.json`)** — prefer for Databricks, Aha!, and similar:

1. Open **Cursor Settings** — gear icon (top right) or `Ctrl+,` / `Cmd+,`
2. Navigate to **Features → MCP** → **+ Add New MCP Server** — Cursor opens `mcp.json`
3. Document WSL vs Windows paths; add the server block; save

**Option A / Option B (when UI and manual file edit differ materially)**

1. Open **Cursor Settings** (`Ctrl+,` / `Cmd+,`; some guides use `Ctrl+Shift+J` / `Cmd+Shift+J` — match the closest exemplar). Also reachable via the **gear icon** (top right).
2. Navigate to **Features → MCP** → **+ Add New MCP Server**
3. Name, type (Command stdio or HTTP/SSE), command/URL, args, env vars

**Option B: Config file**

```json
{
  "mcpServers": {
    "<server-id>": {
      "command": "<command>",
      "args": ["<args>"],
      "env": {
        "<ENV_VAR>": "${env:<ENV_VAR>}"
      }
    }
  }
}
```

For managed HTTP MCP (e.g. Databricks):

```json
{
  "mcpServers": {
    "<server-id>": {
      "type": "streamable-http",
      "url": "https://<host>/api/2.0/mcp/sql",
      "headers": {
        "Authorization": "Bearer <YOUR_TOKEN>"
      }
    }
  }
}
```

Merge with existing servers — do not replace the whole file.

**Step N: Secure Your Credentials** (numbered step when credentials or secrets appear in setup — not for OAuth/session-only hosted MCPs):

- Never commit API keys or tokens
- When the portal shows a secret only once (API secret keys, PATs, bearer tokens), include an **IMPORTANT** callout in the credential-obtain step **and** remind users here not to lose it
- Do not paste credentials into **Cursor chat**, tickets, or shared docs — use env vars or Settings env fields only
- Add `.cursor/mcp.json` to `.gitignore` when workspace config may hold secrets
- Prefer `${env:VAR}` in `mcp.json` over hardcoded values; document PowerShell `SetEnvironmentVariable` and macOS/Linux `export`
- When credentials are passed via Docker `-e`, show host-inherit form (`-e VAR` without a value) where the exemplar does

#### Post-config subsections (stay inside HOW)

After the numbered steps, add these as `###` subsections **inside** `## **HOW**` — do **not** close HOW or promote them to `##` before the footer.

| Subsection | Notes |
|------------|-------|
| `### **Available Capabilities**` (or service-specific title, e.g. **Available Tools**) | Tool table: exact MCP tool name + one-line description |
| `### **Example Prompts**` | Optional; omit when the service is straightforward and one verify prompt is enough |
| `### **Troubleshooting**` | Symptom → fix bullets; include admin/permission fixes here, not in pre-config steps |
| `### **References**` | Service-specific official docs plus [Connecting Cursor MCP Client](./kb_connecting_cursor_to_mcp_server.md) when helpful — omit redundant blog posts and generic MCP spec links unless the setup is unusual |

Only after **References**, insert the footer `---` block. See [reference.md](reference.md) for the Freshservice variant that uses promoted `##` sections with `---` dividers.

Link related setup (e.g. Databricks **extension**) in a callout — do not document the full extension install here.

**End-reader only:** Every sentence must help someone complete setup or use the MCP. Do not explain auth mechanics, deprecated packages, or author reasoning unless the reader needs it to succeed.

### Footer

```markdown
---

**Last Updated**: <Month YYYY>
**Maintained By**: <name of the person running this skill for the request — ask if unknown>

___
```

## Quality checklist

- [ ] No real secrets or placeholder keys that look like real tokens
- [ ] Env var names match the MCP server's actual requirements
- [ ] `mcpServers` schema (not VS Code `"servers"`)
- [ ] Configure uses combined Settings→`mcp.json` step when Add MCP Server opens the file; otherwise Settings UI before config file
- [ ] WSL vs Windows paths when relevant
- [ ] WHAT persona matches the closest gold exemplar (not a generic default)
- [ ] Numbered step order and titles match the closest gold exemplar (including 4-step vs 5-step guides)
- [ ] Runtime dependencies appear in Prerequisites only when the exemplar does not use a numbered install step
- [ ] Credential-obtain step warns when the portal displays a secret only once
- [ ] Secure step included only when setup uses tokens/env vars; omitted for OAuth/session-only MCPs
- [ ] Secure step warns against pasting secrets into Cursor chat or shared channels (when included)
- [ ] Configure step uses combined Settings→`mcp.json` flow when Add MCP Server opens the file (not duplicate Option A/B)
- [ ] No author-only or maintainer-facing notes — every sentence is for the end reader completing setup
- [ ] WHAT/WHY scoped to verified capabilities only; org limits stated once, not repeated across sections
- [ ] Do not claim tools or operations that are not exposed or enabled — verify tool lists or org policy first
- [ ] Prerequisites ordered: account/access → admin gates → Cursor/runtime → network
- [ ] Troubleshooting holds post-connection permission failures, not pre-verify setup steps
- [ ] Example Prompts omitted when verify prompt + capabilities table are sufficient
- [ ] Rate limiting documented only when commonly encountered — not by default from upstream API docs
- [ ] References trimmed to what the reader needs — no redundant blog/spec links by default
- [ ] **Maintained By** is the person who ran the skill for the request, not a default team name
- [ ] Org-specific slugs, URLs, and verify prompts match the closest gold exemplar (not genericized `{your-org}` during calibration)
- [ ] Available Capabilities, Example Prompts, Troubleshooting, and References are `###` subsections inside HOW (not top-level `##`)
- [ ] When the MCP supports no-auth use, the primary config example does not require a token/key
- [ ] Optional credential steps are labeled **(Optional)** with clear skip criteria
- [ ] Verify step lists expected MCP tool names when the server exposes a small, named toolset
- [ ] Verify step mentions **Agent** chat; add **Composer** (`Ctrl+I` / `Cmd+I`) when the closest exemplar does
- [ ] Test prompts are copy-paste ready
- [ ] Tool table matches server capabilities
- [ ] Cross-links use relative paths within `mcp-servers/`
- [ ] Filename: `kb_<service>_mcp_setup_cursor.md`
- [ ] Length proportional to complexity (~1,000 words when simple; longer OK when needed)

## Workflow

```
Task Progress:
- [ ] Read reference.md and any existing guide for this service
- [ ] Confirm server metadata (command, args, env, auth steps)
- [ ] Writer: draft kb_<service>_mcp_setup_cursor.md
- [ ] Reviewer: up to 3 review cycles
- [ ] Tester: up to 10 cycles (optional — skip if no MCP access)
- [ ] Run quality checklist
```

## Additional resources

- Exemplars and config cheat sheet: [reference.md](reference.md)
- General KB template: `docs/technical-practices/documentation-standards/template-files/kb_template.md`
