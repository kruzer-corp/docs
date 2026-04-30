# Gotchas e Conhecimento Tácito

Armadilhas e cuidados específicos ao trabalhar neste repositório de documentação Mintlify.

> A maioria dos itens abaixo é inferida do comportamento padrão do Mintlify e da estrutura observada do repo. Itens marcados com **TODO** precisam ser validados/complementados pela equipe.

## Armadilhas Comuns

### 1. Página criada não aparece no menu
**Sintoma:** novo arquivo `.mdx` foi criado, mas não aparece na navegação lateral em `mint dev` ou em produção.
**Causa:** o Mintlify não descobre páginas por filesystem — só renderiza no menu o que está em `docs.json`.
**Solução:** adicionar o slug (path sem `.mdx`) na lista `pages` do grupo apropriado em `docs.json`.
**Contexto:** a página fica acessível pela URL direta mesmo sem estar no `docs.json`, o que pode mascarar o erro durante testes.

### 2. Link interno quebrado após mover/renomear arquivo
**Sintoma:** `<Card href="/destino-antigo">` ou link Markdown leva a 404.
**Causa:** slug é o caminho relativo. Mover um arquivo muda a URL.
**Solução:** após qualquer rename/move, fazer busca global pelo slug antigo e atualizar todas as ocorrências; também atualizar `docs.json`.
**Cuidado:** links externos (e bookmarks de usuários) também quebram — considere adicionar redirects pela Mintlify se a página for popular. **TODO:** confirmar se a Mintlify tem feature de redirects e se está em uso.

### 3. MDX quebra com chaves `{` e `<` em texto livre
**Sintoma:** build do `mint dev` falha com erro de parser; ou trecho some da renderização.
**Causa:** MDX interpreta `{...}` como expressão JS e `<Tag>` como JSX.
**Solução:** escapar com crase (\`{\`), com `&#123;` HTML, ou envolver em bloco de código. Para `<` literal, usar `&lt;` ou bloco de código.
**Exemplo problemático:** documentar URL templates como `/customers/{id}` em texto livre — preferir bloco inline `` `/customers/{id}` ``.

### 4. Ícone Font Awesome inválido renderiza em branco
**Sintoma:** `<Card>` ou `<Tab>` aparece sem ícone visível.
**Causa:** valor de `icon` não corresponde a um slug Font Awesome válido.
**Solução:** consultar https://fontawesome.com/icons e usar o slug exato em kebab-case (ex.: `shield-halved`, não `shieldHalved`).
**Contexto:** o build não falha, então o erro só aparece visualmente.

### 5. Frontmatter ausente ou mal-formado
**Sintoma:** página renderiza sem título, sem ícone no menu, e busca fica pobre.
**Causa:** frontmatter ausente, mal-fechado (faltando `---`) ou com aspas inconsistentes.
**Solução:** todas as páginas devem começar com `---` + `title:` + `description:` + `icon:` + `---`.

## Comportamentos Contra-Intuitivos

### Ordem de páginas vem do `docs.json`, não do filesystem
**O que parece:** ordenar arquivos alfabeticamente ou por data muda a ordem do menu.
**O que realmente acontece:** a ordem é exatamente a ordem do array `pages` em `docs.json`. O filesystem é irrelevante para ordenação.
**Implicações:** mover arquivos não reordena o menu; reordenar `docs.json` reordena.

### Sub-grupo com `icon` é diferente de página
**O que parece:** itens em `pages` são sempre páginas.
**O que realmente acontece:** itens podem ser **strings** (slugs de página) ou **objetos** `{ "group": ..., "icon": ..., "pages": [...] }` (sub-grupos aninhados).
**Implicação:** o grupo `IDK` em `Desenvolvimento` é um sub-grupo, não uma página — não há `idk.mdx`.

### `mint dev` cacheia agressivamente em alguns casos
**O que parece:** alteração no `.mdx` reflete imediatamente.
**O que realmente acontece:** mudanças em `docs.json` ou em frontmatter podem exigir restart do `mint dev` para refletir.
**Solução:** parar (Ctrl+C) e rodar `mint dev` novamente; ou `mint update` se o CLI estiver desatualizado.

### Botões "Open with ChatGPT/Claude/Cursor/VSCode" são contextuais
**O que parece:** apenas decoração.
**O que realmente acontece:** habilitados via `contextual.options` em `docs.json`. Cada botão expõe a página em formato consumível por aquela ferramenta — assumir que **agentes de IA vão consumir esta documentação** ao escrever conteúdo.

## Workarounds e Soluções Temporárias

> TODO: nenhum workaround específico foi identificado a partir da análise estática. Atualizar este documento quando surgirem (ex.: bugs do Mintlify contornados com sintaxe alternativa).

## Dependências de Ordem e Sequência

### Atualização sincronizada `.mdx` ↔ `docs.json`
**Contexto:** sempre que um arquivo `.mdx` é criado, movido, renomeado ou removido.
**Ordem necessária:** o commit deve incluir tanto o arquivo `.mdx` quanto a alteração em `docs.json`.
**Consequência se ignorado:** menu mostra link para página inexistente (404) ou página existe mas não aparece no menu.

### Logos e favicon devem existir antes do deploy
**Contexto:** caminhos referenciados em `docs.json` (`/favicon.svg`, `/logo/light.svg`, `/logo/dark.svg`) precisam existir.
**Consequência se ignorado:** deploy pode quebrar ou renderizar sem identidade visual.

## Configurações Não-Óbvias

### `theme: mint` no `docs.json`
**Configuração:** `theme: "mint"`
**Por que parece estranho:** "mint" é literalmente o nome do tema padrão da Mintlify.
**Por que está certo:** é o tema oficial e único atualmente em uso; trocar quebraria o layout.

### `contextual.options` lista 6 ferramentas
**Configuração:** `["copy", "view", "chatgpt", "claude", "cursor", "vscode"]`
**Por que parece estranho:** parece duplicação ou exagero.
**Por que está certo:** cada item habilita um botão de "abrir/usar" diferente — remover algum perde uma forma de consumo da doc.

### `logo.href: https://kruzer.ai/`
**Configuração:** clique no logo leva a `kruzer.ai`, não à home da documentação.
**Por que parece estranho:** convenção comum é logo apontar para a home da própria doc.
**Por que está certo:** intencional — direciona usuários para o site institucional/marketing.

## Débitos Técnicos Conhecidos

### README.md genérico do template
**Descrição:** o `README.md` é o boilerplate "Mintlify Starter Kit" original e tem um typo (`## Developmentt`).
**Impacto:** primeira impressão de quem clona o repo é genérica; típo no header.
**Origem:** template inicial não foi customizado.
**Plano:** **TODO** — substituir por README específico do repo Kruzer Docs (descrição do produto, como contribuir, link para guia de estilo).

### Sem CI/lint para MDX
**Descrição:** não há GitHub Actions, lint de markdown, verificação de links quebrados, ou checagem de slugs em PRs.
**Impacto:** erros estruturais (slug em `docs.json` apontando para arquivo inexistente, link interno quebrado, MDX inválido) só aparecem no preview ou em produção.
**Plano:** **TODO** — avaliar adicionar `mint dev`-equivalente em CI ou linter de links.

## Dicas de Desenvolvimento

### Ambiente Local
- `npm i -g mint` instala/atualiza o CLI global.
- `mint dev` na raiz (onde está `docs.json`) → http://localhost:3000.
- Se 404 na home: verificar que está rodando da raiz correta (onde fica `docs.json`).
- Se algo está fora de hora: `mint update` para CLI mais recente.

### Debugging
- Página não aparece no menu → procurar slug em `docs.json`.
- Link 404 → verificar se slug existe (`find . -name "<nome>.mdx"`).
- MDX não renderiza → checar caracteres `{`, `}`, `<` em texto livre.
- Ícone vazio → validar slug em fontawesome.com/icons.

### Performance
- Imagens grandes em `images/` aumentam o bundle. Comprimir/otimizar antes de subir.

### Testes
> TODO: não há suíte de testes. Considerar adicionar verificação de links quebrados.

## O Que Eu Gostaria de Ter Sabido

- **`docs.json` é o roteador**, não o filesystem. Sempre comece por ele ao adicionar/mover páginas.
- **MDX ≠ Markdown puro:** caracteres `{` e `<` em texto livre quebram o build.
- **Slug é a URL pública.** Renomear arquivo = quebrar links externos.
- **A documentação é consumida por IAs** (`contextual.options`), então clareza estrutural e títulos descritivos importam tanto quanto prosa bem escrita.
- **PT-BR é regra**, não preferência — manter consistência mesmo em termos técnicos quando há tradução natural.
- **Padrão de "Próximos Passos"** ao final das páginas existe em quase todas — replicar ao criar páginas novas.

> TODO: complementar com o conhecimento tácito da equipe (incidentes passados, decisões editoriais documentadas em PRs antigos, convenções não-escritas).
