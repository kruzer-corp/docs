# Integrações

Este repositório de documentação tem integrações em duas categorias:

1. **Operacionais** — serviços que processam o repo (build, deploy, hospedagem).
2. **Conteúdo-referenciadas** — repositórios e produtos da Kruzer que esta documentação descreve. Mudanças nesses repos podem exigir atualizações aqui.

## Integrações Operacionais

### Mintlify (Plataforma de Documentação)
**Tipo:** SaaS de documentação.
**Propósito:** renderizar `.mdx` + `docs.json` em site público com tema, busca e navegação.
**Protocolo:** GitHub App + webhook em push para `main`.
**Dados trocados:** todo o conteúdo do repositório.
**Dependência:** crítica — sem Mintlify, não há site publicado.
**Tratamento de falhas:** em caso de falha de build, a Mintlify normalmente sinaliza por email/dashboard. Não há fallback configurado no repo.
**Configuração:** `docs.json` (schema `https://mintlify.com/docs.json`).
**CLI local:** `mint` (npm `mint`) — `mint dev` para preview, `mint update` para atualização.

### GitHub
**Tipo:** repositório de código + GitHub App da Mintlify.
**Propósito:** versionar conteúdo, revisar via PRs, disparar deploy.
**Branch padrão:** `main`.
**Padrão de branch para edição:** `docs/<assunto>` (observado em `docs/api-gateway-and-platform`, `docs/update-mongodb`).
**Org:** **TODO** — confirmar org GitHub (provavelmente `kruzer-corp` baseado nos PRs do histórico).

## Integrações Referenciadas no Conteúdo

> Os itens abaixo são repositórios/serviços **descritos pela documentação**. Não são dependências de build deste repo, mas mudanças neles devem refletir aqui. Todos são internos privados — **TODO: confirmar URLs/orgs exatos**.

### `@kruzer/cli` (pacote npm)
**Tipo:** CLI publicado no npm.
**Binário:** `krz`.
**Propósito:** ferramenta de linha de comando para autenticação, seleção de tenant e execução local de automações.
**Comandos cobertos pela doc:** `configure`, `login`, `auth`, `run`, `select tenant`.
**Comunicação:** HTTP com a UI/backend Kruzer (host configurado via `krz configure`, validação em `/api/healthcheck`).
**Armazenamento local:** `~/.config/configstore/krz-cli.json`.
**Página da doc:** `cli.mdx`.
**Repositório fonte:** **TODO** — confirmar repo (provavelmente `kruzer-corp/cli` ou similar, privado).
**Sincronização:** novos comandos/flags devem ser refletidos em `cli.mdx`.

### `@kruzer/idk` (pacote npm)
**Tipo:** SDK TypeScript publicado no npm.
**Propósito:** biblioteca usada nas automações para acessar Data Sources, REST APIs, SAP RFC e logging.
**Exports principais:** `MySqlDataSource`, `MsSqlDataSource`, `OracleDataSource`, `MongoDbDataSource`, `RestDataSource`, `SapRFCDatasource`, `KrzLogger`.
**Páginas da doc:**
- `instalacao.mdx` — instalação/imports
- `data-sources/{mysql,mssql,oracle,mongodb}.mdx`
- `integracoes/{rest-api,sap-rfc}.mdx`
- `utilitarios/logger.mdx`
- `conceitos/tratamento-erros.mdx`
**Repositório fonte:** **TODO** — confirmar repo (privado, possivelmente `kruzer-corp/idk`).
**Sincronização:** breaking changes em assinaturas/imports devem disparar atualização imediata da documentação.

### Plataforma iPaaS (UI + Backend)
**Tipo:** aplicação web Kruzer.
**URL exemplo na doc:** `https://app.kruzer.io`.
**Propósito:** painel onde se configuram Tenants, Repositories, Conectores, Credentials, Triggers e Consumers.
**Interação documentada:** ações manuais via UI (criar repositório, configurar credenciais, etc.).
**Repositório fonte:** **TODO** — privado.
**Sincronização:** mudanças na UI (novos campos, fluxos alterados) podem invalidar screenshots/passos. **TODO:** definir cadência de revisão.

### API Gateway (Produto Kruzer)
**Tipo:** componente da plataforma Kruzer.
**Propósito:** expor automações/conectores como APIs HTTP versionadas.
**Conceitos documentados:** Gateway, Release, Endpoint, Ambiente, Policy, Acesso.
**Páginas da doc:** `api-gateway/*.mdx`.
**Repositório fonte:** **TODO** — privado.
**Sincronização:** novas Policies, mudanças no ciclo de vida de Releases ou no fluxo de Acessos devem ser refletidos.

### Repositórios de Automação (provisionados pela plataforma)
**Tipo:** repositórios GitHub criados automaticamente quando se cria um Repository no painel.
**Template:** estrutura padrão com `automations/`, `functions/`, `data-transformations/`, `tsconfig.json`, `package.json` com dependência `@kruzer/idk`.
**Página da doc:** `devtools/plataforma/repositories.mdx`.
**Sincronização:** mudanças no template de provisionamento devem refletir aqui.

### `pim-api` (Backend do PIM)
**Tipo:** API backend (TypeScript + Koa + `@kruzer/sdk` + MongoDB + Kafka).
**Repositório fonte:** `kruzer-corp/pim-api` (privado).
**Páginas da doc:** todo o conteúdo de `pim/` — conceitos, funcionalidades e referência de API.
**Integração técnica especial — geração de OpenAPI:**
- O script `pim-api/scripts/generate-openapi.ts` faz parsing estático dos controllers em `src/features/*/actions/*` e emite `openapi.json` na raiz do `pim-api`.
- O comando `npm run generate:openapi` regenera o spec.
- O arquivo gerado é **copiado manualmente** para `pim/api/openapi.json` neste repo de docs.
- Mintlify consome via campo `openapi` no group "Referência da API" do `docs.json`.
- **TODO**: automatizar a sincronização (CI no `pim-api` que abre PR aqui ao detectar diff).
**Sincronização:** sempre que um endpoint for adicionado, removido ou alterado no `pim-api`, regerar e atualizar este repo.

### `iam-api` (Identidade transversal)
**Tipo:** API de identidade (autenticação JWT, RBAC, SSO Microsoft/Azure AD).
**Repositório fonte:** `kruzer-corp/iam-api` (privado).
**Papel:** transversal — atende DevTools, PIM e (futuramente) OMS.
**Páginas da doc:** `plataforma-kruzer/iam-autenticacao.mdx`, `plataforma-kruzer/iam-permissoes.mdx`, `plataforma-kruzer/sso.mdx`.
**Sincronização:** mudanças no fluxo de auth, política de tokens ou suporte a novos provedores SSO devem refletir aqui.

### `mdt-api` / `sns-api` (Suporte ao PIM)
**Tipo:** APIs de suporte ao PIM (master data: idiomas/unidades; notificações em tempo real via Socket.IO).
**Páginas da doc:** `pim/funcionalidades/master-data.mdx`, `pim/funcionalidades/notificacoes.mdx`.
**Sincronização:** mudanças nas entidades de master data ou eventos de notificação devem refletir aqui.

## Dependências Externas (do Conteúdo)

Bancos e sistemas que o IDK suporta — cobertos em `data-sources/` e `integracoes/`:

| Sistema | Conector | Página |
|---------|----------|--------|
| MySQL | `MySqlDataSource` | `data-sources/mysql.mdx` |
| SQL Server | `MsSqlDataSource` | `data-sources/mssql.mdx` |
| Oracle | `OracleDataSource` | `data-sources/oracle.mdx` |
| MongoDB | `MongoDbDataSource` | `data-sources/mongodb.mdx` |
| REST APIs | `RestDataSource` | `integracoes/rest-api.mdx` |
| SAP RFC | `SapRFCDatasource` | `integracoes/sap-rfc.mdx` |
| Brokers de mensageria | (Consumers) | `plataforma/consumers.mdx` — **TODO**: listar brokers específicos suportados |

## Eventos

Não aplicável — repo de documentação não publica/consome eventos. Os eventos descritos na doc (Triggers webhook, Consumers de fila) são funcionalidades do produto Kruzer documentadas, não do repo.

## Contratos de Integração

- **Schema do `docs.json`:** `https://mintlify.com/docs.json` (mantido pela Mintlify).
- **Frontmatter `.mdx`:** convenção de `title`, `description`, `icon` (não há schema formalizado neste repo).

## Resiliência

Não aplicável a este repo. A resiliência descrita na documentação (retries em `RestDataSource`, tratamento de erros em automações) refere-se ao IDK, não ao repo de docs.

## Como Identificar uma Mudança que Exige Atualização

Use esta heurística antes de acreditar que a documentação está correta:

1. **Mudou algo no `@kruzer/cli`?** → revisar `cli.mdx` e `quickstart.mdx` (passos da CLI).
2. **Mudou algo no `@kruzer/idk`?** → revisar `instalacao.mdx`, `data-sources/*`, `integracoes/*`, `utilitarios/*`, `conceitos/*`.
3. **Mudou a UI da plataforma iPaaS?** → revisar `plataforma/*.mdx`.
4. **Mudou o API Gateway?** → revisar `api-gateway/*.mdx`.
5. **Mudou o template de repositório provisionado?** → revisar `plataforma/repositories.mdx` e a estrutura de pastas mencionada em `quickstart.mdx`.
