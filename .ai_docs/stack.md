# Stack Tecnológica

## Plataforma de Documentação

**Mintlify** — plataforma SaaS de documentação que renderiza arquivos `.mdx` em um site estático com tema próprio, busca embutida e navegação configurada por JSON.

- Schema oficial: `https://mintlify.com/docs.json`
- Tema configurado: `mint`
- Versão da plataforma: gerenciada pela Mintlify (sem pin de versão no repo)

## Linguagens e Formatos

- **MDX** — Markdown estendido com componentes JSX. Todas as páginas de conteúdo são `.mdx`.
- **JSON** — `docs.json` define navegação, branding e features.
- **Mermaid** — diagramas embutidos em blocos ` ```mermaid ` (ex.: `plataforma/tenants.mdx`, `plataforma/credentials.mdx`).

## Configuração Principal (`docs.json`)

Campos relevantes:

| Campo | Valor / Função |
|-------|----------------|
| `theme` | `mint` |
| `name` | `Kruzer` |
| `colors.primary` | `#3151CE` |
| `colors.light` | `#818CF8` |
| `colors.dark` | `#4F46E5` |
| `favicon` | `/favicon.svg` |
| `logo.light` / `logo.dark` | `/logo/light.svg`, `/logo/dark.svg` |
| `logo.href` | `https://kruzer.ai/` |
| `navigation.tabs` | Estrutura hierárquica de tabs → groups → pages |
| `contextual.options` | `copy`, `view`, `chatgpt`, `claude`, `cursor`, `vscode` (botões "Open with…") |
| `footer.socials.linkedin` | `https://linkedin.com/company/kruzerio` |

## Ferramentas de Desenvolvimento

| Ferramenta | Uso |
|------------|-----|
| `mint` (npm `mint`) | CLI da Mintlify para preview local (`mint dev`) e atualização (`mint update`) |
| Mintlify GitHub App | Deploy automático ao push na branch padrão (`main`) |

Não há `package.json`, `node_modules`, lint, formatter, testes ou pipeline de CI no repo — toda a infraestrutura de build e deploy é provida pela Mintlify.

## Componentes Mintlify Usados

Componentes JSX disponíveis no MDX (sem necessidade de import):

- `<CardGroup cols={N}>` + `<Card title icon href>` — grades de navegação
- `<Tip>`, `<Note>`, `<Warning>` — caixas de destaque coloridas
- `<AccordionGroup>` + `<Accordion title>` — conteúdo expansível
- `<Steps>` + `<Step title>` — passos numerados
- `<CodeGroup>` — abas com múltiplos blocos de código
- `<ResponseField name type>` — descrição de parâmetros/campos de API

Ícones usam o nome do Font Awesome (ex.: `icon="rocket"`, `icon="shield-halved"`).

## Estrutura de Pastas

```
docs/
├── docs.json              # Navegação e branding (fonte da verdade)
├── index.mdx              # Home
├── quickstart.mdx         # Tutorial inicial
├── instalacao.mdx         # Instalação do IDK
├── cli.mdx                # Referência da CLI krz
├── plataforma/            # iPaaS: Tenants, Repos, Conectores, Credentials, Triggers, Consumers
├── api-gateway/           # API Gateway: conceitos, releases, endpoints, ambientes, policies, acessos, publicacao
├── data-sources/          # Conectores do IDK: mysql, mssql, oracle, mongodb
├── integracoes/           # Integrações do IDK: rest-api, sap-rfc
├── utilitarios/           # logger
├── conceitos/             # tratamento-erros
├── images/                # Capturas e assets visuais
├── logo/                  # Logos light/dark
├── favicon.svg / .ico
├── README.md              # Boilerplate do template Mintlify
└── LICENSE
```

## Decisões Arquiteturais Importantes

- **Documentação como código** — todo conteúdo versionado em git, revisões via Pull Request.
- **Navegação separada do filesystem** — `docs.json` controla a ordem e os grupos. Mover/renomear arquivos exige atualizar `docs.json`.
- **Sem build local obrigatório** — preview é via `mint dev`, deploy é serverless via Mintlify.
- **PT-BR como idioma único** — não há i18n configurado no `docs.json`.
- **AI-friendly por design** — `contextual.options` expõe botões de "abrir no ChatGPT/Claude/Cursor/VSCode" em cada página, sinalizando que o conteúdo é otimizado para consumo por IA.

## Arquitetura Geral (do Conteúdo Documentado)

A documentação descreve este fluxo do produto Kruzer DevTools:

```
Cliente externo / Agendamento / Fila / Webhook
       ↓
[ Triggers | Consumers | API Gateway ]
       ↓
Automações TypeScript (repositórios provisionados em GitHub)
       ↓
@kruzer/idk (Data Sources, RestDataSource, SapRFC, KrzLogger)
       ↓
Sistemas integrados (MySQL, MSSQL, Oracle, MongoDB, REST APIs, SAP, mensageria)
```
