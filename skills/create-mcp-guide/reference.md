# MCP Install Guide — Reference (Cursor)

Paths are relative to the **idp-docs** repo root. Open that workspace before reading exemplars.

**Exemplar folder:** `docs/technical-practices/ai-capabilities/mcp-servers/`

## Canonical exemplars

Read before drafting. Prefer **Cursor** files (`*_cursor.md`):

| Service | Cursor guide | Pattern |
|---------|--------------|---------|
| Freshservice | [kb_freshservice_mcp_setup_cursor.md](docs/technical-practices/ai-capabilities/mcp-servers/kb_freshservice_mcp_setup_cursor.md) | `uvx`, env vars, tool table (~890 words) |
| Context7 | [kb_context7_mcp_setup_cursor.md](docs/technical-practices/ai-capabilities/mcp-servers/kb_context7_mcp_setup_cursor.md) | `npx`, optional API key (~830 words) |
| Databricks | [kb_databricks_mcp_setup_cursor.md](docs/technical-practices/ai-capabilities/mcp-servers/kb_databricks_mcp_setup_cursor.md) | HTTP, PAT, WSL vs Windows (~760 words) |
| Terraform | [kb_terraform_mcp_setup_cursor.md](docs/technical-practices/ai-capabilities/mcp-servers/kb_terraform_mcp_setup_cursor.md) | Docker stdio (~940 words) |
| Generic client | [kb_connecting_cursor_to_mcp_server.md](docs/technical-practices/ai-capabilities/mcp-servers/kb_connecting_cursor_to_mcp_server.md) | Link from prerequisites |

**Baseline style:** Freshservice or Databricks depending on complexity.

**VS Code variants** (`kb_*_mcp_setup.md` without `_cursor`) exist for the same services but are often 2× longer. Do not use them as length targets for new Cursor guides.

## Length benchmark

- **Soft target:** ~1,000 words for simple stdio MCPs.
- **OK to exceed** for Docker, HTTP auth, dual keys, or large tool tables.
- Cursor guides in this repo range ~480–940 words; VS Code siblings can exceed 2,000.

## Common runtime patterns (Cursor)

| Pattern | command / type | args / url example | When |
|---------|----------------|-------------------|------|
| npm package | `npx` | `["-y", "@scope/package@latest"]` | Node MCP servers |
| Python (uv) | `uvx` | `["package-name"]` | PyPI MCP servers |
| Docker | `docker` | `["run", "-i", "--rm", "image:tag"]` | Containerized MCP |
| Local binary | `pytenable-mcp` | `[]` | PATH-installed tools |
| Managed HTTP | `streamable-http` | `"url": "https://…"` | Databricks, hosted MCP |

- **Settings UI args:** mirror the config-file args string, including `-y` and `@latest` for npm packages (e.g. `-y @upstash/context7-mcp@latest --api-key YOUR_API_KEY`).
- Document **no-key** and **with-key** JSON variants when the upstream server supports anonymous/rate-limited mode.

**Docker credential passing:**

- Inline: `-e", "VAR=value"` in the `args` array
- Host inherit (preferred in Terraform gold): `-e", "VAR"` with no value — Docker reads from host environment
- Avoid redundant top-level `"env"` in `mcp.json` when credentials are already passed via docker `-e` flags

### Primary path vs alternates

When the gold exemplar documents one runtime path (e.g. pip / local binary / npx stdio), treat it as **primary**:
- Settings **Option A** and the first JSON example must match the gold primary path
- Docker, `uvx`, remote HTTP, or interactive-auth alternates belong in **Option B**, callouts, or "Advanced" — labeled optional, never recommended above gold unless the exemplar changes
- Server id in `mcpServers` must match the gold key (e.g. `tenable-mcp`, not `tenable`)

## Context7-specific patterns

When Context7 is the closest exemplar ([kb_context7_mcp_setup_cursor.md](docs/technical-practices/ai-capabilities/mcp-servers/kb_context7_mcp_setup_cursor.md)):

| Topic | Gold pattern |
|-------|----------------|
| Tool names | `resolve-library-id`, `get-library-docs` (not `query-docs`) |
| Connection order | stdio/npx primary (Settings Option A, config Option B); remote HTTP as Option C |
| No-key config | `"args": ["-y", "@upstash/context7-mcp@latest"]` without `env` |
| With-key config | `--api-key` in args **or** `CONTEXT7_API_KEY` in `env`; tip that env is alternative to CLI flag |
| Verify | Name both tools; explain resolve → fetch two-step flow; use azurerm test prompt from gold |
| Example prompts | Categorize by Terraform/IaC, JavaScript/TypeScript, Python; tip `/org/project` ID skips resolve |
| Tags | Include `ai` in frontmatter when matching gold |

## Terraform-specific patterns

When Terraform is the closest exemplar ([kb_terraform_mcp_setup_cursor.md](docs/technical-practices/ai-capabilities/mcp-servers/kb_terraform_mcp_setup_cursor.md)):

| Topic | Gold pattern |
|-------|----------------|
| Primary path | **Registry only** — no `TFE_TOKEN` / `TFE_ADDRESS` required for public Registry search |
| Optional Step 2 | **(Optional) Create an HCP Terraform API Token** — skip for registry-only |
| Image pin | `hashicorp/terraform-mcp-server:0.4.0` (confirm current release before changing) |
| Registry-only args | `run -i --rm hashicorp/terraform-mcp-server:0.4.0` |
| Registry tool restriction | `--toolsets=registry` when limiting to registry tools |
| HCP/TFE config | Second JSON variant with `-e TFE_TOKEN=…` and `-e TFE_ADDRESS=…` |
| Host env inherit | `-e TFE_TOKEN` (no value) inherits from host; prefer over `${env:TFE_TOKEN}` in docker args when matching gold |
| Tool summary | Use gold **toolset** table (`registry` / `registry-private` / `terraform`, Token Required column) — not only a per-tool table |
| Verify prompts | azurerm provider version; Azure Key Vault module search; optional HCP workspace list when token configured |
| Troubleshooting | Zscaler/corporate-proxy: mount CA + `SSL_CERT_FILE`; empty registry results bullet |
| References | Include [Terraform Registry](https://registry.terraform.io/); confirm HashiCorp doc URLs (`terraform/mcp-server` vs legacy paths) |

## Databricks-specific patterns

When Databricks is the closest exemplar ([kb_databricks_mcp_setup_cursor.md](docs/technical-practices/ai-capabilities/mcp-servers/kb_databricks_mcp_setup_cursor.md)):

| Topic | Gold pattern |
|-------|----------------|
| Transport | `streamable-http`; URL `https://<hostname>/api/2.0/mcp/sql`; `Authorization: Bearer` header |
| Step order | Hostname → configure (placeholder PAT) → generate PAT → secure → verify |
| Settings UI | **+ Add New MCP Server** opens `mcp.json` for editing — document WSL vs Windows paths inline |
| PAT placeholder | Leave `<YOUR_DATABRICKS_PAT>` in Step 2; fill in Step 3 with `mcp.json` still open |
| PAT generation | **Comment** `MCP Server - Cursor`; **Lifetime** up to 730 days |
| Persona | Developer or Data Engineer |
| Business verify prompt | e.g. "how many on-risk clients are there?" (not only generic `poll_sql_result` mention) |
| Extension note | Link Databricks **extension** under **Available Capabilities** — not in Prerequisites |
| Org content | Workspace hostname example; Data Platform Teams channel in Troubleshooting |
| Secure step title | "Keep Your Credentials Safe" (gold heading variant) |
| Optional trim | Standalone **Example Prompts** and OAuth callout are enrichments — trim only for strict gold-length parity |

## Tenable-specific patterns

When Tenable is the closest exemplar ([kb_tenable_mcp_setup_cursor.md](docs/technical-practices/ai-capabilities/mcp-servers/kb_tenable_mcp_setup_cursor.md)):

| Topic | Gold pattern |
|-------|----------------|
| Step order | API keys → `pip install --upgrade pytenable-mcp` → configure → secure → verify |
| Primary path | **pip / `pytenable-mcp`** stdio — Settings Option A and first JSON use `command` `pytenable-mcp`, `args` `[]` |
| Server name | `tenable-mcp` in Settings and `mcpServers` key |
| API key UI | Username (top right) → **My Account** → **API Keys** → **Generate**; **IMPORTANT**: Secret Key shown only once |
| Install verify | `python -c "import pytenable_mcp; print('OK')"` after pip install |
| Env vars | `TIO_ACCESS_KEY`, `TIO_SECRET_KEY`; optional `TIO_URL` for non-default tenants |
| Write scope | `launch_scan` requires `TIO_ENABLE_WRITE=1` — footnote in Available Capabilities or configure step |
| Persona | Security Engineer or Developer |
| Frontmatter tag | `vulnerabilities` |
| Verify prompts | "Show me the Tenable server info"; "List my Tenable scans"; "List all assets in Tenable" |
| References | Include [pyTenable Documentation](https://pytenable.readthedocs.io/) |
| Alternates (subordinate) | Docker image and `uvx` on-demand — document **after** pip primary path; do not invert to Docker-first |

## Azure DevOps-specific patterns

When Azure DevOps is the closest exemplar ([kb_azure_devops_mcp_setup_cursor.md](docs/technical-practices/ai-capabilities/mcp-servers/kb_azure_devops_mcp_setup_cursor.md)):

| Topic | Gold pattern |
|-------|----------------|
| Step order | PAT creation → configure → secure → verify (**4 steps**); Node.js in **Prerequisites** only |
| Persona | Developer (not Platform Engineer) |
| PAT walkthrough | Profile → **User settings** → **Personal access tokens** → **+ New Token** |
| PAT config | Name `MCP Server - Cursor`; org `cfcunderwriting`; 90-day expiration; full scope checklist (Code R&W, Work Items R&W, Build Read, PR Threads R&W, Project and Team Read, Identity Read) |
| Auth contract | `AZURE_DEVOPS_PAT` (raw PAT) + `AZURE_DEVOPS_ORG_URL`: `https://dev.azure.com/cfcunderwriting` — **no** `--authentication` flag in gold |
| Settings Option A | List both env vars inline in the Settings UI fields |
| Option B JSON | Always include `env` block with `YOUR_PERSONAL_ACCESS_TOKEN_HERE` placeholder and org URL |
| Args | `npx` with `-y`, `@azure-devops/mcp`, org slug `cfcunderwriting` |
| Secure step | `${env:AZURE_DEVOPS_PAT}` — raw PAT, not base64-encoded `PERSONAL_ACCESS_TOKEN` |
| Verify prompt | "List repositories in the Engineering project" |
| Upstream note | Current `@azure-devops/mcp` npm package may document `PERSONAL_ACCESS_TOKEN`, base64 encoding, and `--authentication pat` — **reconcile with gold** before choosing strict gold parity vs upstream-accurate draft |
| Alternates (subordinate) | Bearer-token (`envvar`), `ado_mcp_project` / `ado_mcp_team`, Windows `cmd /c npx`, domain `-d` flags — keep as enrichments under gold primary path |

## Freshservice layout variant

[kb_freshservice_mcp_setup_cursor.md](docs/technical-practices/ai-capabilities/mcp-servers/kb_freshservice_mcp_setup_cursor.md) promotes post-verify content to top-level `##` sections with `---` horizontal rules before **Available Capabilities**, **Example Prompts**, and **Troubleshooting**. Use this layout **only** when Freshservice is the closest exemplar — not for Context7 or Terraform.

| Freshservice-only | Value |
|-------------------|-------|
| Settings shortcut | `Ctrl+Shift+J` / `Cmd+Shift+J` |
| Frontmatter tag | `service-desk` |
| Security placement | Fold `${env:…}` setup into Step 3 config (no separate numbered Secure step) |
| Org troubleshooting | Wrong domain `servicedesk.cfcunderwriting.com` vs `cfcunderwriting.freshservice.com`; Releases 403 → use Changes module |
| Capabilities table | Full tool list including change-approval-group tools |

## Cursor config schema

Global: `~/.cursor/mcp.json` (WSL) or `%USERPROFILE%\.cursor\mcp.json` (Windows).

**stdio:**

```json
{
  "mcpServers": {
    "server-id": {
      "command": "npx",
      "args": ["-y", "package-name"],
      "env": { "API_KEY": "${env:API_KEY}" }
    }
  }
}
```

**HTTP:**

```json
{
  "mcpServers": {
    "server-id": {
      "type": "streamable-http",
      "url": "https://example.com/mcp",
      "headers": { "Authorization": "Bearer ${env:TOKEN}" }
    }
  }
}
```

## VS Code adaptation (manual)

If a maintainer needs a VS Code guide:

| Cursor | VS Code |
|--------|---------|
| `"mcpServers"` | `"servers"` |
| `~/.cursor/mcp.json` | `~/.config/Code/User/mcp.json` |
| Cursor Settings → MCP | Copilot Agent Mode + `mcp.json` |
| [kb_connecting_cursor_to_mcp_server.md](docs/technical-practices/ai-capabilities/mcp-servers/kb_connecting_cursor_to_mcp_server.md) | [kb_connecting_vscode_to_mcp_server.md](docs/technical-practices/ai-capabilities/mcp-servers/kb_connecting_vscode_to_mcp_server.md) |

See existing pairs (e.g. Freshservice) for full VS Code structure.

## Troubleshooting template

- **Server not appearing**: restart Cursor; verify runtime on PATH; toggle MCP off/on in Settings
- **401 / auth errors**: regenerate token; confirm env var names
- **404 / wrong endpoint**: bare hostname where required; no stray `https://` in env vars
- **Wrong config file**: WSL vs Windows path — see gold Databricks guide
- **Tools empty**: use Agent chat; confirm server enabled

## Verify-step prompts

Copy test prompts from the closest gold exemplar when calibrating. Examples:

- **Freshservice:** ticket list + pending change requests; API key from Profile Settings → **Your API Key**
- **Context7:** azurerm_key_vault doc lookup; demonstrate resolve → get-library-docs
- **Terraform:** azurerm provider version; Azure Key Vault module search

Do not invent tool names — confirm against upstream MCP README or gold table.

## External links (standard references block)

- Service official API / product docs
- Package registry (npm, PyPI) if applicable
- [Cursor MCP Documentation](https://docs.cursor.com/context/model-context-protocol)
- [Model Context Protocol Specification](https://spec.modelcontextprotocol.org/)

## Filename convention

```
kb_<service_slug>_mcp_setup_cursor.md
```

Use lowercase slugs; match existing files (e.g. `azure_devops`, `context7`, `freshservice`).

## Gold + deltas (optional enrichments)

When the draft exceeds gold length but adds accurate value, **keep** these if present — do not delete solely for word-count parity:

| MCP | Examples |
|-----|----------|
| Freshservice | Hosted Freshworks MCP EAP note; path-scope table |
| Context7 | `npx ctx7 setup --cursor`, OAuth endpoint, curl ping, one-click install callout |
| Terraform | Docker version minimums; `docker pull` in Step 1; invalid JSON in `mcp.json` troubleshooting; local-binary advanced path |
| Databricks | Option B config-path table; OAuth callout; `${env:DATABRICKS_TOKEN}` hardening; expanded capabilities/troubleshooting; Example Prompts section |
| Tenable | Docker and `uvx` alternates; WSL+Docker Desktop callout; per-tool capabilities table; Hexa AI MCP callout in WHY/References |
| Azure DevOps | Bearer-token JSON; `ado_mcp_project`/`ado_mcp_team`; Windows `cmd /c npx`; domain-limit `-d` flags; remote MCP preview callout; full tool-list link |

Trim only when the user requests strict gold parity.
