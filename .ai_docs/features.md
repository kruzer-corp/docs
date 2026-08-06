# Funcionalidades

Mapa do conteúdo do repositório (multi-módulo) — onde cada tópico vive.

## Páginas-Chave

### `index.mdx` — Home Institucional Kruzer
Hub que apresenta a plataforma multi-módulo (DevTools, OMS, PIM) e linka para a base compartilhada (IAM).

## Tab Plataforma (`plataforma-kruzer/`)

Conceitos transversais que valem para todos os módulos.

| Página | Cobertura |
|--------|-----------|
| `visao-geral.mdx` | O que é a plataforma multi-módulo, como módulos se relacionam |
| `iam-autenticacao.mdx` | JWT, login, contas de serviço, recuperação de senha |
| `iam-permissoes.mdx` | RBAC, papéis, grupos, boas práticas |
| `sso.mdx` | SSO Microsoft / Azure AD |
| `mcp-visao-geral.mdx` | O que é o MCP da documentação e o que ele expõe |
| `mcp-instalacao.mdx` | Conectar o MCP em Claude, Cursor, VS Code e ChatGPT |

## Tab DevTools (`devtools/`)

### Entrada
- `visao-geral.mdx` — apresentação iPaaS + API Gateway
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

## Tab OMS (`oms/`)

### Entrada
- `visao-geral.mdx` — o que o OMS resolve e como os módulos se encaixam

### Módulos
- `configuracao-base.mdx` — cadastros base da operação
- `precos-promocoes-cupom.mdx` — preços, promoções e cupons
- `pedidos.mdx` — ciclo de vida do pedido
- `trocas-e-devolucoes.mdx` — pós-venda
- `maquina-de-estado.mdx` — estados e transições
- `fulfillment.mdx` — separação, expedição e entrega
- `dom.mdx` — motor de roteamento de pedidos
- `webhooks.mdx` — notificação push de eventos
- `transferencia-de-produto.mdx` — movimentação entre locais
- `relatorios-e-dashboards.mdx` — visões analíticas

### Assistentes de IA
- `mcp-tokens.mdx` — gerar o token MCP e conectar um assistente de IA ao OMS

### `api/`
- `visao-geral.mdx` — introdução à API REST (auth, convenções, base URL)
- `openapi.json` — spec da API do OMS

## Tab PIM (`pim/`)

### Entrada
- `visao-geral.mdx` — apresentação do PIM
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
- `visao-geral.mdx` — introdução à API REST (auth, convenções, base URL)
- `openapi.json` — spec da API do PIM

## Funcionalidades de Suporte ao Repositório

- **Tabs por módulo** em `docs.json` — hoje Plataforma, DevTools, OMS e PIM; a estrutura cresce por tab a cada novo módulo.
- **`contextual.options`** — botões "Open with…" (ChatGPT, Claude, Cursor, VSCode, copy, view) habilitados em todas as páginas.
- **OpenAPI auto-gerado** — as referências de API do OMS e do PIM são renderizadas pelo Mintlify a partir de `oms/api/openapi.json` e `pim/api/openapi.json`. Cada spec é produzido no repo do respectivo produto, por caminhos diferentes; o procedimento de cada um está documentado lá, e o resumo operacional para este repo está no `CLAUDE.md`.
- **Diagramas Mermaid** — usados em conceitos com hierarquia (catálogos, IAM, workflow).

## TODO / Lacunas Conhecidas

- Páginas de PIM são **stubs com conteúdo inicial** — detalhes operacionais e screenshots a serem adicionados conforme uso real.
- Schemas de request/response no OpenAPI estão como `object` genérico — a v0 do gerador prioriza paths/methods. Iteração futura: mapear `*.dictionary.ts` e DTOs para schemas tipados.
- Localização EN — não configurada.
- CI de regeneração automática de OpenAPI no merge do `pim-api` — não implementada.
