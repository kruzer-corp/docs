# Padrões de Design

## Padrão Arquitetural

**Documentação estática com navegação declarativa.** O Mintlify é o "framework"; o repositório aplica o padrão *content-as-code* onde:

- Arquivos `.mdx` são unidades atômicas de página.
- `docs.json` é a fonte da verdade para a navegação — não há descoberta automática de arquivos.
- Slugs de URL derivam diretamente do caminho relativo (sem extensão). Ex.: `plataforma/tenants.mdx` → `/plataforma/tenants`.

## Estrutura de Página `.mdx`

Toda página segue o padrão:

```mdx
---
title: "Título da Página"
description: "Descrição curta usada em SEO e listagens"
icon: "nome-do-icone-fontawesome"
---

Parágrafo de abertura explicando o que é o conceito.

## Seção principal

<CardGroup cols={2}>
  <Card title="..." icon="..." href="/destino">
    Texto curto
  </Card>
</CardGroup>

---

## Próxima seção
```

**Convenções observadas:**

- Frontmatter sempre em primeira posição, com `title`, `description` e `icon`.
- Primeiro parágrafo introduz o conceito em negrito (`**Termo**`).
- Separadores horizontais (`---`) entre seções macro.
- `<CardGroup>` com `cols={2}` ou `cols={3}` na home, na introdução de produtos e na seção "Próximos Passos" ao final das páginas.
- Páginas longas terminam com uma seção "Próximos Passos" linkando recursos relacionados.

## Convenções de Nomenclatura

| Elemento | Padrão | Exemplo |
|----------|--------|---------|
| Arquivo | `kebab-case.mdx` | `tratamento-erros.mdx` |
| Pasta | `kebab-case` ou termo simples | `data-sources/`, `api-gateway/` |
| Slug | igual ao path sem extensão | `/plataforma/triggers` |
| Título | Substantivo capitalizado em PT-BR | "Tenants", "API Gateway" |
| Ícone | Font Awesome (slug em kebab-case) | `shield-halved`, `code-branch` |

Pastas em PT-BR (`plataforma`, `integracoes`, `utilitarios`, `conceitos`) e termos em EN quando são nomes de produto ou conceito técnico universal (`api-gateway`, `data-sources`).

## Padrões de Conteúdo

### Diagramas

- **Mermaid** para diagramas de relacionamento (multi-tenant, fluxo de credenciais).
- **ASCII art** dentro de blocos ` ``` ` para hierarquias e fluxos simples (ver `api-gateway/conceitos.mdx`, `api-gateway/introducao.mdx`).

### Exemplos de Código

- TypeScript é o padrão para exemplos de IDK.
- Blocos shell prefixados com `$` para indicar prompt interativo.
- `<CodeGroup>` quando há mais de uma variação relevante (ex.: forma curta vs. completa, sem params vs. com params).

### Tabelas

Usadas para parâmetros, campos e códigos de erro. Padrão: cabeçalho `| Campo | Descrição |` ou `| Opção | Função |`.

### Caixas de Destaque

| Componente | Uso |
|------------|-----|
| `<Tip>` | Dica útil mas não obrigatória |
| `<Note>` | Informação contextual importante |
| `<Warning>` | Pré-condição ou consequência de erro |
| `<AccordionGroup>` | FAQ, lista de erros, exemplos opcionais |

### Referência de API/Comando

Usar `<ResponseField name type>` para parâmetros e `<AccordionGroup>` para enumerar mensagens de erro com causa/solução (padrão visto em `cli.mdx`).

## Padrões de Navegação

`docs.json` usa **tabs → groups → pages**, com sub-grupos aninhados (ver `IDK` aninhado dentro de `Desenvolvimento`):

```json
{
  "navigation": {
    "tabs": [
      { "tab": "Guia", "groups": [
        { "group": "Plataforma", "pages": [
          "plataforma/tenants",
          { "group": "API Gateway", "icon": "shield", "pages": [...] }
        ]}
      ]}
    ]
  }
}
```

Sub-grupos aninhados podem ter `icon` próprio. Páginas são listadas pelo slug (path sem `.mdx`).

## Padrão Editorial

- **Idioma único:** PT-BR para todo conteúdo público.
- **Tom:** direto, técnico, sem informalidade excessiva. Frases curtas. Voz ativa.
- **Conceitos antes de exemplos:** introduzir o "o que é" antes de mostrar código.
- **Cross-linking generoso:** páginas terminam linkando 2-4 destinos relacionados via `<CardGroup>`.

## Padrão de Atualização

Não há testes automatizados de conteúdo. Validação prática:

1. `mint dev` localmente para verificar render.
2. Conferir que cada arquivo novo está referenciado em `docs.json`.
3. Conferir que links internos (`href="/..."`) batem com slugs reais.
