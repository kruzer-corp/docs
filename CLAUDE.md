# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Type

**Mintlify documentation repository** for the Kruzer platform — not application code. All content is `.mdx` files rendered into a public docs site. Deploy is automatic via the Mintlify GitHub App when merging to `main`.

Public language is **PT-BR**. Keep all new prose in PT-BR (technical terms and product names like `@kruzer/cli`, `@kruzer/idk`, "API Gateway", "Trigger", "Webhook" stay as-is).

## Site Structure (Multi-Module)

The docs site is organized into **4 tabs in `docs.json`**, one per cross-cutting concern + product:

- **Plataforma** (`plataforma-kruzer/`) — transversal IAM/auth/SSO/permissions docs that apply to all Kruzer modules, plus the docs' own public MCP server.
- **DevTools** (`devtools/`) — iPaaS, API Gateway, CLI (`krz`), IDK (`@kruzer/idk`), data sources, integrations.
- **OMS** (`oms/`) — order management product docs, MCP tokens, and auto-generated API reference.
- **PIM** (`pim/`) — functional product docs + auto-generated API reference.

The institutional home (`index.mdx`) is a hub linking each module — it is intentionally **not** registered in `docs.json` navigation (Mintlify serves it at `/`), so the orphan-page check should ignore it.

## Commands

```bash
# Install Mintlify CLI (once, globally)
npm i -g mint

# Local preview from repo root (where docs.json lives)
mint dev          # http://localhost:3000

mint update       # update CLI if dev server misbehaves or 404s
```

There is no `package.json`, no test suite, no linter, no CI. Validation is visual via `mint dev`.

## Architecture

Two coordinated sources drive the site:

1. **`docs.json`** — single source of truth for navigation, branding, theme, and contextual AI buttons. Mintlify does **not** auto-discover pages from the filesystem. A new `.mdx` is invisible in the menu until added to `docs.json` under `tabs[].groups[].pages[]`. Sub-groups are objects (`{ "group": ..., "icon": ..., "pages": [...] }`) nested inside `pages`.

2. **`.mdx` files** — each page begins with frontmatter (`title`, `description`, `icon`) and uses Mintlify JSX components without imports: `<CardGroup>`/`<Card>`, `<Tip>`/`<Note>`/`<Warning>`, `<AccordionGroup>`/`<Accordion>`, `<Steps>`/`<Step>`, `<CodeGroup>`, `<ResponseField>`. Icons are Font Awesome slugs in kebab-case.

**Slug rule:** the URL of a page is its path relative to the repo root, without `.mdx`. So `pim/conceitos/produtos-e-skus.mdx` → `/pim/conceitos/produtos-e-skus`. Renaming or moving a file changes its public URL **and** breaks any internal `<Card href="/...">` references.

## API References (PIM and OMS)

The PIM and OMS tabs each include an **auto-generated API reference**, rendered from `pim/api/openapi.json` and `oms/api/openapi.json`. Both are wired in `docs.json` under the tab's "Referência da API" group via the `openapi` field. The two specs are produced in **different ways** — don't assume one workflow for both.

**PIM** — the spec is generated in the sibling `pim-api` repo; that repo documents the generation procedure. Copy the result over `pim/api/openapi.json`, then commit and merge — Mintlify rebuilds the API pages.

**OMS** — the spec is exported in the sibling `oms` repo; that repo documents the export procedure. Save the result over `oms/api/openapi.json`, then commit and merge.

For both: don't paste a fresh spec straight over the committed file. The committed version carries manual adjustments, so diff the new output against it and carry those adjustments forward.

Gotcha on `servers`: the OMS spec uses a **concrete** URL with a literal `tenant` segment, not an OpenAPI template variable — Mintlify's playground does not resolve template variables, so a templated URL renders as a broken request target.

<!-- NOTE: this repo is PUBLIC on GitHub. Everything here, including `.ai_docs/`, is world-readable
     even though only `docs.json`-registered `.mdx` pages reach the site. Never write internal
     architecture of the private product repos into this repo: no source paths, no internal
     endpoints, no description of what gets filtered out of a published spec. Keep such notes in
     the product repo. -->


## Editing Rules

- **Always pair `.mdx` changes with `docs.json` updates** in the same commit when adding, moving, renaming, or removing pages.
- **Internal links** use absolute slugs: `href="/devtools/plataforma/triggers"`, never relative paths and never with `.mdx`.
- **Escape MDX hazards** in free text: `{`, `}`, `<` are interpreted by the parser. Wrap things like `/customers/{id}` in inline backticks or use HTML entities.
- **End pages with a "Próximos Passos" `<CardGroup>`** linking to 2–4 related pages — established pattern across the site.
- **Cross-module links are encouraged**: PIM pages can link to Plataforma (IAM) and DevTools (iPaaS, API Gateway), and vice-versa.
- **Branch naming:** observed convention is `docs/<assunto>` (e.g. `docs/multi-modulo-pim`).
- **Logo click target** is `https://docs.kruzer.ai/` (set in `docs.json`) — the docs home, since the site moved to its own subdomain. It used to point at the institutional site (`https://kruzer.ai/`); changed deliberately in Aug/2026, so don't "restore" it.

## Where to Look First

For deeper context on conventions, gotchas, business rules and the relationship to external Kruzer repos (`@kruzer/cli`, `@kruzer/idk`, `pim-api`, `iam-api`, etc.), see `.ai_docs/`.
