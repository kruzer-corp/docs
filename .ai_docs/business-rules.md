# Regras de Negócio (Editoriais e Estruturais)

Este repositório não tem regras de negócio de aplicação — é documentação. As "regras de negócio" aqui são as **regras editoriais e estruturais** que mantêm a documentação consistente, navegável e publicável.

## Regras Críticas

### 1. `docs.json` é a Fonte da Verdade da Navegação
**Descrição:** uma página `.mdx` só aparece no menu se estiver explicitamente listada em `docs.json`.
**Justificativa:** o Mintlify não faz descoberta automática por filesystem. Páginas órfãs ainda são acessíveis pelo slug, mas não pelo menu.
**Implementação:** `docs.json` → `navigation.tabs[].groups[].pages[]`.
**Validações:** ao adicionar/mover/remover qualquer `.mdx`, atualizar `docs.json` na mesma mudança.
**Exceções:** arquivos auxiliares (não-página) como `README.md` e `LICENSE` ficam fora do `docs.json`.

### 2. Slug = Caminho Relativo Sem Extensão
**Descrição:** a URL pública de uma página é exatamente seu caminho relativo à raiz, sem `.mdx`.
**Justificativa:** convenção da Mintlify; mover um arquivo muda sua URL.
**Implicações:** renomear/mover quebra links externos e bookmarks. Antes de mover, verificar referências externas (analytics, parceiros, links em outras páginas).

### 3. Idioma Único: PT-BR
**Descrição:** todo conteúdo público é escrito em português brasileiro.
**Justificativa:** público-alvo da Kruzer é Brasil/Latam; não há setup de i18n no `docs.json`.
**Implementação:** títulos, descrições, frontmatter `description`, prosa e legendas.
**Exceções permitidas:** termos técnicos universais (API, Gateway, Trigger, Consumer, Webhook), nomes de produtos (`@kruzer/cli`, `@kruzer/idk`) e blocos de código (que seguem o que faz sentido para o linguagem).

### 4. Frontmatter Obrigatório
**Descrição:** toda página `.mdx` deve ter frontmatter com `title`, `description` e `icon`.
**Justificativa:** `title`/`description` alimentam SEO e listagens; `icon` é renderizado no menu lateral e nos cards.
**Validação:** páginas sem frontmatter renderizam, mas perdem ícones e metadados de busca.

### 5. Ícones do Font Awesome
**Descrição:** valor de `icon` deve ser um slug Font Awesome válido (ex.: `rocket`, `shield-halved`, `code-branch`).
**Justificativa:** o tema `mint` resolve ícones via Font Awesome.
**Cuidado:** ícones inválidos não falham o build, mas renderizam vazios.

### 6. Links Internos Usam Slug Absoluto
**Descrição:** referências a outras páginas via `href="/plataforma/triggers"` (não relativo, não com `.mdx`).
**Justificativa:** roteamento da Mintlify é baseado em slugs absolutos.

## Validações e Restrições

- **Cards de "Próximos Passos"** ao final de páginas devem apontar para slugs reais existentes.
- **Sub-grupos com `icon`** em `docs.json` (ex.: `API Gateway`, `IDK`) devem manter o ícone consistente com o card que os referencia em outras páginas.
- **Imagens** devem ficar em `images/` e referenciadas com path absoluto (`/images/foo.png`).
- **Logos** ficam em `logo/light.svg` e `logo/dark.svg` — não substituir sem atualizar `docs.json`.

## Políticas e Workflows

### Fluxo Editorial
1. Branch a partir de `main` (padrão observado: `docs/<assunto>` — ex.: `docs/api-gateway-and-platform`, `docs/update-mongodb`).
2. Edição local com `mint dev` rodando para preview.
3. Pull Request para `main`.
4. Merge dispara deploy automático via Mintlify GitHub App.

> TODO: confirmar regras formais de revisão (aprovações obrigatórias, code owners, checks de CI).

### Adição de Nova Página
1. Criar `caminho/nome.mdx` com frontmatter completo.
2. Adicionar entrada correspondente em `docs.json` no grupo certo.
3. Adicionar links cruzados em páginas relacionadas (cards de "Próximos Passos").
4. Verificar render via `mint dev`.

### Adição de Novo Grupo
1. Definir `group`, `icon` (opcional) e lista de `pages` em `docs.json`.
2. Considerar se vale criar uma página de "introdução" ao grupo (padrão visto em `api-gateway/introducao.mdx`).

## Compliance e Regulamentações

- **LICENSE** — ver arquivo `LICENSE` (MIT herdado do template Mintlify).
> TODO: confirmar se a licença atual reflete a intenção da Kruzer para documentação pública.
- **Marca / Logo** — `logo/` e `favicon.svg`/`favicon.ico` são propriedade da Kruzer; não substituir sem alinhamento.
- **Dados sensíveis** — exemplos de código não devem conter credenciais reais, hosts internos não publicados, ou dados de cliente.

## Regras de Domínio (Sobre o Conteúdo)

Regras do produto Kruzer que **a documentação afirma** e que devem permanecer consistentes entre páginas:

- **Repositories:** ao criar um Repository na plataforma, é provisionado automaticamente um repo no GitHub baseado em template padrão. A estrutura `automations/`, `functions/`, `data-transformations/` é **mandatória** para que o motor de execução interprete as integrações.
- **Multi-tenant:** um Data Source é único; cada Tenant possui suas próprias Credentials para esse Data Source.
- **Tipos de execução:** Triggers (cron/webhook), Consumers (mensageria), Endpoints do Gateway (HTTP).
- **Releases vs. Ambientes (Gateway):** Releases agrupam Endpoints versionados; Ambientes referenciam uma Release. Um mesmo Gateway pode ter múltiplos Ambientes apontando para Releases diferentes (ex.: Dev → 2.0 BUILDING; Prod → 1.0 CLOSED).
- **Policies por Ambiente:** Rate Limit, Quota, Cache e Inbound Rules são aplicadas por endpoint dentro de um ambiente.
- **CLI:** `krz configure` precisa ser executado antes de qualquer outro comando. Token é renovado por `krz auth`. Configurações ficam em `~/.config/configstore/krz-cli.json`.

Inconsistências entre páginas sobre estes itens devem ser reconciliadas — todas devem refletir o mesmo modelo.
