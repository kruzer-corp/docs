# Revisão da doc do OMS — rodar e conferir localmente

**Como usar:** abra o Claude Code na pasta deste repositório e escreva:

> Leia o arquivo `REVISAO-OMS.md` e me conduza pela revisão.

O restante deste arquivo é a instrução para o agente. Você não precisa ler,
mas pode — está em linguagem de negócio, não de código.

---

## Instrução para o agente

Você vai preparar um ambiente local de documentação e **conduzir uma pessoa de
negócio** por uma revisão de conteúdo. Ela não é desenvolvedora. Não presuma
familiaridade com git, terminal, API ou qualquer jargão técnico.

### Regras da sessão

1. **Não altere o conteúdo da documentação.** Esta sessão é de leitura e coleta de
   opinião. Se a pessoa apontar algo errado, **anote** num arquivo
   `REVISAO-OMS-APONTAMENTOS.md` e siga. Quem corrige é outra pessoa, depois.
2. **Não faça commit, não faça push, não abra PR.** Nada aqui vai para o ar.
3. Explique cada passo em uma frase antes de executar. Se algo falhar, resolva
   você e diga o que fez, sem despejar log na tela.
4. Fale em português, sem jargão. "Endpoint" vira "chamada da API". "Deploy" vira
   "publicação".

### Contexto que a pessoa precisa saber (diga isso a ela no começo)

A documentação pública do Kruzer OMS estava desatualizada: a referência da API era
de julho e várias páginas descreviam o produto como ele era meses atrás. Algumas
diziam que módulos "estavam em fase de especificação" quando já existiam e
funcionavam.

Esta revisão corrigiu isso. O que ela vai revisar é **se o texto descreve o produto
de forma correta e compreensível para um cliente**. Não é revisão de código.

Um ponto importante: a doc descreve o que está na branch `main` do produto, que é a
versão que chega aos clientes. Existe bastante coisa pronta na branch de
desenvolvimento que **de propósito não foi documentada**, porque ainda não chegou a
nenhum cliente e ainda pode mudar.

### Passo 1 — Confirmar a branch

O conteúdo revisado está na branch `docs/revisao-oms-negocio`. Confirme que é ela
que está ativa antes de qualquer coisa. Se não estiver, mude para ela.

### Passo 2 — Subir o site localmente

A ferramenta é o CLI da Mintlify. Três armadilhas conhecidas, já mapeadas:

- **Node 25 não funciona.** O CLI exige uma versão LTS. Use a 22:
  `export NVM_DIR="$HOME/.nvm"; . "$NVM_DIR/nvm.sh"; nvm use 22`
  Se a 22 não estiver instalada, instale com `nvm install 22`.
- **O CLI precisa estar instalado naquela versão do Node:** `npm i -g mint`.
- Rode `mint dev` **da raiz do repositório**, onde está o `docs.json`.

O site sobe em **http://localhost:3000**. Abra no navegador e deixe aberto.

> A busca do site fica desativada no preview local. Isso é esperado, não é defeito.
> Avise a pessoa para não reportar isso.

### Passo 3 — Explicar as marcações de revisão

O conteúdo revisado está sinalizado na tela:

| Marcação | Significa |
|---|---|
| Etiqueta **NOVO**, azul, ao lado do título | Seção escrita do zero nesta revisão |
| Etiqueta **ATUALIZADO**, verde | Seção que já existia e ganhou trechos novos |
| Faixa azul no topo da página | A página inteira é nova, foi reescrita, ou teve a referência regerada |

Diga à pessoa: a etiqueta significa **novo na documentação**, não necessariamente
novo no produto. Muita coisa marcada como nova já existia no sistema há meses e
simplesmente não estava escrita em lugar nenhum.

Essas marcações são temporárias e serão removidas antes de publicar. Não são parte
do texto final.

### Passo 4 — Conduzir a revisão, página por página

Leve a pessoa nesta ordem. Em cada uma, abra o endereço, deixe ela ler, e faça a
pergunta indicada. Não avance sozinho: espere a resposta.

**1. Trocas e Devoluções** — http://localhost:3000/oms/trocas-e-devolucoes
A maior mudança. A página inteira foi reescrita: antes dizia que o módulo estava
em especificação, quando o fluxo já funciona ponta a ponta.
Pergunte: *o fluxo descrito bate com a operação real de pós-venda? Os estados pelos
quais uma solicitação passa fazem sentido para quem atende o cliente? A regra de
que a solicitação só se conclui depois que toda unidade foi inspecionada está
correta?*

**2. Clientes** — http://localhost:3000/oms/clientes
Página nova. Nunca existiu documentação de cliente no OMS.
Pergunte: *falta alguma informação que um cliente perguntaria? A regra de que
documento, tipo e identificador externo não podem ser alterados depois de criados
está certa?*

**3. Trilha de Auditoria** — http://localhost:3000/oms/trilha-de-auditoria
Página nova. Trata de um assunto sensível: o que o sistema guarda sobre quem fez o
quê.
Pergunte: *a explicação de que consultas são guardadas por menos tempo que
alterações está clara? O aviso de que uma página vazia pode significar "histórico
expirado" e não "nada aconteceu" está compreensível?*

**4. DOM** — http://localhost:3000/oms/dom
Motor que decide de onde cada pedido sai. Ganhou duas seções novas.
Aqui há uma **decisão de negócio** a validar: a página diz abertamente que dois dos
quatro critérios de seleção (menor custo e mais rápido) ainda não funcionam de
verdade e se comportam como um terceiro.
Pergunte: *queremos expor essa limitação ao cliente com essa clareza, ou preferimos
outra forma de dizer? Omitir não é opção, porque o cliente descobriria na prática.*

**5. Fulfillment** — http://localhost:3000/oms/fulfillment
Ganhou as seções de remessa e rastreio.
Pergunte: *a sequência de status da entrega bate com o que as transportadoras
informam na prática?*

**6. Configuração Base** — http://localhost:3000/oms/configuracao-base
Ganhou a seção de Configurações da Conta e trechos novos em Estratégias, Clusters e
Catálogo.
Pergunte: *os três parâmetros de conta estão explicados de forma que um cliente
entenda o efeito de cada um?*

**7. Visão Geral da API** — http://localhost:3000/oms/api/visao-geral
A referência da API foi regerada e saiu de 66 para 87 chamadas documentadas.
Outra **decisão de negócio**: a página agora orienta o cliente a usar o Swagger do
próprio ambiente dele para testar chamadas.
Pergunte: *queremos direcionar o cliente para essa ferramenta técnica, ou preferimos
que ele fique só nesta documentação?*

### Passo 5 — Confirmar as omissões deliberadas

Três coisas foram **deixadas de fora de propósito**. Confirme cada uma com a pessoa,
porque são decisões de produto, não esquecimento:

1. **Cupons continua descrito como "escopo planejado"**, na página de Preços e
   Promoções. O módulo existe em desenvolvimento, mas ainda não chegou a nenhum
   cliente. *Concorda em só documentar quando chegar?*
2. **Transferência de Produto e Relatórios seguem marcados como roadmap.** Não
   existem no produto hoje. *Confirma?*
3. **A home não convida a "conhecer o OMS".** Nem todo cliente tem o módulo, e o
   endereço é próprio de cada conta. *Confirma que é assim que queremos?*

### Passo 6 — Fechar

Consolide tudo que ela apontou em `REVISAO-OMS-APONTAMENTOS.md`, agrupado por
página, separando o que é **erro factual** (o texto afirma algo que o produto não
faz) do que é **ajuste de texto** (está certo mas podia ficar mais claro). Mostre o
arquivo a ela antes de encerrar e confirme que representa bem o que ela disse.

Encerre o servidor local com `Ctrl+C` ou encerrando o processo do `mint`.

---

## O que foi modificado nesta revisão

Para referência, sem necessidade de abrir os arquivos.

| Arquivo | O que aconteceu |
|---|---|
| `oms/trocas-e-devolucoes.mdx` | Reescrita completa |
| `oms/clientes.mdx` | Página nova |
| `oms/trilha-de-auditoria.mdx` | Página nova |
| `oms/dom.mdx` | Duas seções novas, roadmap corrigido |
| `oms/fulfillment.mdx` | Duas seções novas |
| `oms/configuracao-base.mdx` | Uma seção nova, três trechos atualizados |
| `oms/api/visao-geral.mdx` | Swagger do ambiente, aviso de endereço por conta, tabela de recursos |
| `oms/api/openapi.json` | Referência regerada da `main`: 66 → 87 chamadas |
| `docs.json` | Registro das duas páginas novas no menu |
| `style.css` e `scripts/` | Marcações temporárias de revisão e o script que as remove |

## Pendências conhecidas

Não são defeitos desta revisão, são decisões em aberto:

- **23 mudanças esperando na branch de desenvolvimento**, 5 delas quebrando
  contrato. Quando forem promovidas, atingem principalmente Máquina de Estado,
  Pedidos e Cupons — páginas que esta revisão não tocou.
- **Não existe tag de homologação nem de produção no repositório do produto.** Isso
  deixa em aberto se a branch `main` é mesmo o que o cliente roda. Pergunta para a
  área técnica.
