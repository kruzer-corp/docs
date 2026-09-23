# Plano de Atualização da Aba OMS

> Rascunho de trabalho, não commitado. Vive na branch `docs/atualiza-modulos-oms`.
> Gerado em 2026-09-17, a partir do estado real do repo `kruzer-corp/oms`.

## Status da execução (2026-09-17)

Executado nesta branch, **sem nenhum commit** — tudo na árvore de trabalho, para avaliação:

- [x] **Spec da API regenerada** de `origin/main` (backend subido localmente via Docker, `nest build` + `/api/docs-json`), com todo o saneamento manual reaplicado. 66 → 87 endpoints, 269 → 338 schemas, 0 schema vazio, 0 `$ref` pendente. Validada com Redocly: **válida**, e com exatamente as mesmas 3 classes de aviso da versão de julho (nenhuma regressão).
- [x] **Trocas e Devoluções** reescrita do zero, com ciclo de vida real, inspeção por unidade, conclusão por troca/reembolso e motivos.
- [x] **DOM**: seções novas de Critério de Seleção e Regras de Roteamento; roadmap corrigido.
- [x] **Configuração Base**: visões agregadas de estratégia e cluster, categorias de produto e seção nova de Configurações da Conta.
- [x] **Fulfillment**: seções novas de Remessas e Rastreio.
- [x] **Clientes** (página nova) e **Trilha de Auditoria** (página nova), ambas registradas no `docs.json`.
- [x] **Visão geral da API**: Swagger do tenant como playground, aviso de URL por conta, tabela de recursos com as famílias novas.
- [x] Exemplos `curl` em Trocas e Devoluções, DOM e Trilha de Auditoria, com payloads conferidos contra os schemas reais.
- [x] **Link profundo** para a página de cada endpoint na Referência da API: 19 links aplicados nas páginas de módulo, todos verificados respondendo 200 no `mint dev`.
- [x] **Preview local validado** com `mint dev`: todas as páginas novas e alteradas em 200, conteúdo novo presente no HTML renderizado, nenhum erro no log.
- [ ] Pendente: nota "o que o assistente de IA faz aqui" por módulo, a partir de `mcp-tokens.mdx`.
- [ ] Pendente: revisitar Cupons quando `coupons` for promovido de `develop` para `main`; idem rastreio da transportadora (KOMS-1174/1175).

## Andaime visual de revisão — REMOVER ANTES DE MESCLAR

Para conferir a revisão navegando na doc, o conteúdo novo e o atualizado estão
marcados visualmente no preview local:

- `style.css` na raiz (o Mintlify carrega automaticamente) com as classes `krz-*`.
- Etiqueta ao lado do título das seções afetadas: **novo** em azul, **atualizado** em verde,
  com uma barra na lateral esquerda do título.
- Faixa no topo das páginas novas, da reescrita e da referência regerada.

São 12 etiquetas e 4 faixas, em 7 arquivos. **Nada disso é conteúdo de cliente.** Para remover:

```bash
./scripts/limpa-marcadores-revisao.sh
```

O script apaga as etiquetas, as faixas, o `style.css`, e avisa se sobrou algum marcador.
Rodar antes de abrir o PR.

## Como linkar um endpoint da Referência da API

O Mintlify gera uma página por operação e o slug é **derivado do `summary`** da operação,
não do path nem do `operationId`:

```
/oms/api/{primeira-tag}/{summary em minúsculas, apóstrofo REMOVIDO,
                        qualquer outro caractere não alfanumérico -> hífen}
```

Exemplos verificados:

| Operação | Slug |
|---|---|
| `GET /api/v1/dom-rules` — "List DOM rules" | `/oms/api/dom-rules/list-dom-rules` |
| `GET /api/v1/audit-events` — "List user-action audit events" | `/oms/api/audit-events/list-user-action-audit-events` |
| `GET .../shipments/{id}/tracking-events` — "List a shipment's tracking events (chronological timeline)" | `/oms/api/fulfillment-order-shipment-tracking-events/list-a-shipments-tracking-events-chronological-timeline` |

Atenção ao apóstrofo: `shipment's` vira `shipments`, **não** `shipment-s`. A regra foi
validada contra os 159 endpoints da spec — todos respondem 200 no preview local.

**Consequência importante:** mudar o `summary` de um `@ApiOperation` no backend **muda a URL
pública** daquela página e quebra os links das páginas de módulo. Ao regerar a spec, revalide
os links profundos.

### Dois achados que só apareceram por comparar contra `main`

1. **Cupons** existe em `develop`, não em `main`. A página de Preços/Promoções segue correta ao tratar cupons como planejado — **não foi alterada**.
2. **Link de rastreio da transportadora e despacho exigindo código de rastreio** (KOMS-1174/1175, de 16/09) também são só `develop`. A seção nova de Rastreio documenta apenas o que `main` tem: backfill do código no primeiro evento que o traz, sem sobrescrever código existente.

## Fonte da verdade: `main`, não `develop`

O OMS tem duas branches relevantes: `develop` recebe as mudanças e alimenta o
ambiente **DEV** interno da Kruzer; `main` é a branch promovida a partir da
`develop`, e é dela que saem as tags `hml/**` e `prod/**` — o que os clientes
de fato têm rodando. Este plano usa **`origin/main`** como referência do que
"existe hoje" para efeito de documentação pública. Isso importa na prática:

- **Backend**: `main` e `develop` estão ambas na versão `0.0.100`, mas o
  código diverge — `develop` está 48 commits à frente de `main` em
  `apps/backend`.
- **Frontend**: `main` está em `0.3.67`; `develop` já em `0.3.76` (39 commits
  à frente). Qualquer comportamento de UI que a doc descreva deve refletir
  `0.3.67`, não o que está em desenvolvimento.
- **Achado concreto da diferença de branch**: o módulo de **Cupons**
  (`coupons.controller.ts`) existe em `develop` mas **não em `main`** — ou
  seja, ainda não chegou a nenhum cliente. A página
  `oms/precos-promocoes-cupom.mdx`, que hoje marca cupons como "escopo
  planejado", **está certa** e não deve ser reescrita como se já existisse.
  Numa varredura anterior deste plano eu tinha concluído o contrário
  (baseado em `develop`) — a checagem contra `main` corrigiu isso. É o
  argumento vivo a favor de sempre comparar contra `main`.

Todos os achados abaixo já foram checados contra `origin/main` (commit
`bc25dcb5`, 2026-09-01), não contra o working tree local (que está em
`develop`).

## Diagnóstico (recapitulando o que já discutimos)

- A spec commitada em `oms/api/openapi.json` é de julho/2026 (backend então
  na `0.0.82`). Hoje `main` tem 88 endpoints contra 66 na spec — **22 rotas
  ausentes**, listadas abaixo.
- As páginas de módulo (prosa) são fortes em conceito e regra de negócio,
  mas têm zero blocos de código e quase nenhum link para a Referência da
  API gerada automaticamente do spec.
- A doc não deve convidar "clique aqui para ver o OMS" a partir do hub —
  nem todo cliente tem o módulo, e a URL é por tenant
  (`oms-api.<tenant>.krzlabs.io`), não uma URL única e pública. Os cards do
  OMS no `index.mdx` e no `plataforma-kruzer/visao-geral.mdx` já não têm
  `href` — manter assim, não adicionar.
- Sem Relatórios/Dashboards por enquanto (correto manter como estava).
- Swagger de cada tenant (`/api/docs`) deve ser o playground; a Referência
  da API na Mintlify fica para leitura e navegação por conceito.

## Módulos a adicionar (existem em `main`, zero cobertura na doc)

### 1. Trocas e Devoluções — reescrever a página inteira
Hoje `trocas-e-devolucoes.mdx` diz "o módulo está em fase de especificação".
Em `main` o fluxo está completo:

| Rota | Métodos |
|---|---|
| `/api/v1/return-requests` | GET, POST |
| `/api/v1/return-requests/{id}` | GET |
| `/api/v1/return-requests/{id}/status` | PATCH |
| `/api/v1/return-requests/{id}/inspections` | GET, POST |
| `/api/v1/return-requests/{id}/inspections/attachments/upload-url` | POST |
| `/api/v1/return-requests/{id}/complete/exchange` | POST |
| `/api/v1/return-requests/{id}/complete/refund` | POST |
| `/api/v1/return-reasons` | GET, POST |
| `/api/v1/return-reasons/defaults` | POST |
| `/api/v1/return-reasons/{id}` | GET, PATCH, DELETE |
| `/api/v1/orders/{orderId}/returnable-items` | GET |

Regras de negócio já capturadas no git log do backend, para orientar a
prosa: motivo de troca/devolução é por item (não mais por solicitação
inteira); reembolso publica só o valor total e conclui sem escolher forma
de pagamento; guarda de inspeção impede cancelar depois de aberta.

### 2. DOM — atualizar `dom.mdx`
Remover **"regras configuráveis"** do Roadmap — já existe:

| Rota | Métodos |
|---|---|
| `/api/v1/dom-rules` | GET, POST |
| `/api/v1/dom-rules/{id}` | GET, PATCH, DELETE |

Nota de contrato: a condição de regra migrou de `REGION` para referência a
`CLUSTER` (mudança breaking já em `main`). Adicionar também que o critério
de seleção **default por conta** (`selection_criterion`) e a opção de não
dividir pedido entre estratégias (`no_split`) vêm da nova página de
Configurações da Conta (item 3) — são o comportamento default que as regras
do DOM podem sobrescrever.

### 3. Configurações da Conta — página nova (ou seção em Configuração Base)
`account-configs.controller.ts`, `GET`/`PATCH /api/v1/account-configs`.
Expõe três campos, confirmados no DTO:

- `no_split` (bool) — desliga o split de pedido entre estratégias.
- `selection_criterion` (enum `CLOSEST | MOST_STOCK | LOWEST_COST |
  FASTEST`) — critério default de roteamento da conta. Nota real do
  backend: `LOWEST_COST` e `FASTEST` hoje caem para `MOST_STOCK` até o
  custo/lead-time por estratégia ser modelado — vale documentar essa
  ressalva, não prometer o que ainda não roteia de fato.
- `timezone` (IANA, nullable) — fuso default da conta quando a estratégia
  não define o próprio; `null` = UTC.

### 4. Trilha de Auditoria — página nova
`audit-events.controller.ts`, `GET /api/v1/audit-events`. Confirmado como
recurso com RBAC próprio (`oms:audit-events`), não é rota interna. Pontos a
documentar, tirados da própria descrição do endpoint: paginado, filtra por
`action`, `actorId`, `outcome`, `targetId`, `targetType`, `readOnly` e
período; não grava corpo de request nem valor de filtro, só o nome do
campo filtrado; retenção assimétrica (mutações guardadas bem mais tempo que
leituras) — período pedido antes da janela quente volta vazio com
`meta.retention.truncated: true`, o que significa "fora da janela", não
"nada aconteceu".

### 5. Clientes — página conceitual nova
`customers` e `customer-addresses` já existem na Referência da API desde a
primeira versão do spec, mas nunca ganharam página de conceito. Hoje só são
citados de passagem em `pedidos.mdx` ("identidade de quem comprou").

## Atualizações dentro de páginas que já existem

- **Configuração Base** — seção Clusters ganha `GET /clusters/summary`;
  seção Estratégias ganha `GET /strategies/summary`,
  `GET /strategies/{id}/inventory` (posição de estoque com ATP assinado) e
  `GET /strategies/{id}/overview`.
- **Configuração Base** (Catálogo) — `PATCH /product-categories/{id}/products`,
  vínculo de produtos em lote na categoria.
- **Fulfillment** — `PATCH .../shipments/{shipmentId}/status`: despacho
  agora exige remessa com tracking code, e a remessa carrega o link de
  rastreio da transportadora.

## Confirmado que continua roadmap (não mexer)

- **Cupons** (`precos-promocoes-cupom.mdx`) — só existe em `develop`. Nota
  interna: revisitar quando `coupons` for promovido a `main`.
- **Transferência de Produto** — nenhum controller de transferência em
  `main`. Página permanece com o aviso de "ainda não disponível".
- **Relatórios e Dashboards** — nenhum controller de relatório/dashboard em
  `main`. Idem.

## Referência da API (`oms/api/openapi.json`)

Regenerar a partir de `main` (não `develop`), reaplicando os ajustes
manuais documentados na memória (`oms-openapi-sync-procedure`):

1. Rodar `nest build` + boot do backend (não `ts-node`, senão volta a gerar
   schema vazio) e capturar `GET /api/docs-json`.
2. Reaplicar: remover `/api/health/*` e `/api/core/v1/permissions`; mover
   `GET /orders/{orderId}/fulfillment-orders` para a tag `orders`; sanear
   descrições com tickets internos e nomes de tópico Kafka/Elasticsearch;
   remover keywords inválidas do plugin (`selfRequired`, `required`
   booleano, `name` solto em schema); manter `servers` com URL concreta.
3. **Escapar `<...>` nas descrições** — o Mintlify compila a `description` de cada operação
   como MDX, então `<id>` é lido como tag JSX e **quebra o build da página**. Em `main` isso
   aparece em `GET /api/v1/product-categories/{id}`: "listed through GET /products?categories=<id>".
   Envolver em backticks (`` `GET /products?categories={id}` ``). As mensagens de erro de exemplo
   que contêm `<strategy>`, `<uuid>` etc. vivem em valores JSON e **não** quebram — não precisam
   de ajuste. Sintoma quando esquecido: `Error compiling content ...` no log do `mint dev`.
4. Conferir a branch remota não mergeada `docs/atualiza-oms` (saneamento de
   infra, 2026-07-07) — decidir se algum trecho dela ainda se aplica antes
   de descartar.

## Ajustes transversais

- Nova página curta "Sua conta OMS" (em Primeiros Passos ou Configuração
  Base): documenta o padrão de URL por tenant
  (`oms-api.<tenant>.krzlabs.io`) e aponta o Swagger do próprio tenant
  (`/api/docs`) como o lugar de testar — substitui a promessa de "URL Base"
  única que hoje está em `oms/api/visao-geral.mdx`.
- Cada página de módulo (Pedidos, Fulfillment, Trocas e Devoluções, DOM...)
  ganha, na seção de ações, um link direto para a página gerada do
  endpoint correspondente na Referência da API (não só um link genérico
  para a visão geral), mais um `curl` de exemplo.
- Manter os cards do OMS na home e em `plataforma-kruzer/visao-geral.mdx`
  sem `href` — não virar convite de "veja o OMS".
- MCP: cada módulo ganha uma nota curta "o que o assistente consegue fazer
  aqui", puxando do que já está descrito em `mcp-tokens.mdx`. Sem página de
  Dashboards.

## Ordem de execução sugerida

1. Regenerar `oms/api/openapi.json` a partir de `main` — desbloqueia os
   links profundos de todo o resto.
2. Trocas e Devoluções (maior gap de conteúdo, módulo inteiro incorreto).
3. DOM + Configurações da Conta (andam juntos — `account-configs` é o
   default que `dom-rules` sobrescreve).
4. Trilha de Auditoria e Clientes (páginas novas, menor volume).
5. Atualizações pontuais em Configuração Base e Fulfillment.
6. Passe de cross-linking + `curl` em todas as páginas de módulo + página
   "Sua conta OMS".

Cada etapa pode virar um commit/PR separado — dá pra ir avaliando o que
ficou bom antes de seguir para a próxima, como combinado.
