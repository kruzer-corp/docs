# Funcionalidades

Mapa do conteúdo do repositório (multi-módulo) — onde cada tópico vive.

## Páginas-Chave

### `index.mdx` — Home Institucional Kruzer
Hub que apresenta a plataforma multi-módulo (DevTools, PIM, OMS futuro) e linka para a base compartilhada (IAM).

## Tab Plataforma (`plataforma-kruzer/`)

Conceitos transversais que valem para todos os módulos.

| Página | Cobertura |
|--------|-----------|
| `visao-geral.mdx` | O que é a plataforma multi-módulo, como módulos se relacionam |
| `iam-autenticacao.mdx` | JWT, login, contas de serviço, recuperação de senha |
| `iam-permissoes.mdx` | RBAC, papéis, grupos, boas práticas |
| `sso.mdx` | SSO Microsoft / Azure AD |

## Tab DevTools (`devtools/`)

### Entrada
- `index.mdx` — apresentação iPaaS + API Gateway
- `quickstart.mdx` — primeiro projeto com MySQL + REST
- `instalacao.mdx` — instalação do `@kruzer/idk`
- `cli.mdx` — referência da CLI `krz`

### `plataforma/` (iPaaS)
Tenants, Repositories, Conectores, Credentials, Triggers, Consumers.

### `api-gateway/`
Introdução, Conceitos (Gateway/Release/Endpoint/Ambiente/Policy/Acesso), Releases, Endpoints, Ambientes, Policies, Acessos, Publicação.

### `data-sources/`
Conectores IDK: MySQL, MSSQL, Oracle, MongoDB.

### `integracoes/`
Conectores IDK: REST, SAP RFC.

### `utilitarios/` e `conceitos/`
KrzLogger; Tratamento de erros.

## Tab PIM (`pim/`)

### Entrada
- `index.mdx` — apresentação do PIM
- `quickstart.mdx` — primeiro produto cadastrado

### `conceitos/`
- `catalogo-e-isolamento.mdx` — modelo multi-tenant (Catálogo + UserGroups)
- `produtos-e-skus.mdx` — Produto vs. SKU, tipos, multi-idioma
- `familias-e-atributos.mdx` — modelagem dinâmica
- `categorias.mdx` — árvores de classificação
- `canais-e-publicacao.mdx` — destinos e ciclo de publicação
- `workflow-de-aprovacao.mdx` — fluxos de enriquecimento e revisão

### `funcionalidades/`
- `importacao-em-massa.mdx` — Excel/CSV, validações, bulk update
- `exportacao.mdx` — extração para arquivos
- `precos-e-estoque.mdx` — gestão por SKU
- `associacoes.mdx` — relações entre produtos e associações de catálogo
- `webhooks.mdx` — notificação push para sistemas externos
- `notificacoes.mdx` — notificações in-app em tempo real (SNS)
- `master-data.mdx` — idiomas e unidades (MDT)

### `api/`
- `index.mdx` — introdução à API REST (auth, convenções, base URL)
- `openapi.json` — spec OpenAPI 3.1 gerado a partir do `pim-api` (150 endpoints, 29 domínios)

## Funcionalidades de Suporte ao Repositório

- **Tabs por módulo** em `docs.json` — preparado para crescer (OMS futuro).
- **`contextual.options`** — botões "Open with…" (ChatGPT, Claude, Cursor, VSCode, copy, view) habilitados em todas as páginas.
- **OpenAPI auto-gerado** — referência da API do PIM é renderizada pelo Mintlify a partir de `pim/api/openapi.json` (ver `integrations.md` para o fluxo).
- **Diagramas Mermaid** — usados em conceitos com hierarquia (catálogos, IAM, workflow).

## TODO / Lacunas Conhecidas

- Páginas de PIM são **stubs com conteúdo inicial** — detalhes operacionais e screenshots a serem adicionados conforme uso real.
- Schemas de request/response no OpenAPI estão como `object` genérico — a v0 do gerador prioriza paths/methods. Iteração futura: mapear `*.dictionary.ts` e DTOs para schemas tipados.
- OMS — placeholder, sem páginas.
- Localização EN — não configurada.
- CI de regeneração automática de OpenAPI no merge do `pim-api` — não implementada.
