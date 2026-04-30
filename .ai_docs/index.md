# Documentação do Repositório `kruzer/docs`

## Visão Geral

Este repositório contém a **documentação pública da plataforma Kruzer**, publicada em produção via [Mintlify](https://mintlify.com). É um conjunto de páginas `.mdx` organizadas por `docs.json` — não há código de aplicação.

A Kruzer é uma **plataforma multi-módulo** e a documentação reflete essa estrutura via tabs separadas no `docs.json`:

- **Plataforma** (`plataforma-kruzer/`) — conceitos transversais: IAM (autenticação, permissões, SSO).
- **DevTools** (`devtools/`) — iPaaS (Triggers/Consumers), API Gateway, CLI `krz`, IDK `@kruzer/idk`.
- **PIM** (`pim/`) — gestão de informações de produto, com referência de API auto-gerada a partir do `pim-api`.

Um futuro módulo **OMS** terá tab própria quando for lançado.

## Documentação Disponível

### Arquitetura e Stack
- [Stack Tecnológica](stack.md) — Mintlify, MDX, `docs.json`, ferramentas
- [Padrões de Design](patterns.md) — estrutura de pastas, frontmatter, componentes Mintlify, convenções

### Funcionalidades e Regras
- [Funcionalidades](features.md) — mapa página-a-página do conteúdo (atualizado para multi-módulo)
- [Regras de Negócio](business-rules.md) — regras editoriais, sincronização com `docs.json`, idioma, estilo
- [Gotchas](gotchas.md) — armadilhas Mintlify/MDX, dependências de ordem, configurações não-óbvias

### Integrações
- [Integrações](integrations.md) — relação com Mintlify, GitHub e os repos da Kruzer (`@kruzer/cli`, `@kruzer/idk`, `pim-api`, `iam-api`, etc.) incluindo o fluxo de geração de OpenAPI

## Links Rápidos

- Repositório: `kruzer-corp/docs` (branch principal: `main`)
- Deploy: automático via Mintlify GitHub App ao push em `main`
- Preview local: `mint dev` (requer `npm i -g mint`) — http://localhost:3000
- Logo aponta para: `https://kruzer.ai/`
