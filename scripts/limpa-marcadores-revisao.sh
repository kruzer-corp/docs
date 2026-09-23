#!/usr/bin/env bash
# Remove o andaime visual de revisão (marcadores `krz-` e o style.css).
# Rode da raiz do repo, ANTES de mesclar a branch.
set -euo pipefail

cd "$(dirname "$0")/.."

# 1) etiquetas ao lado dos títulos de seção
find . -name "*.mdx" -not -path "./node_modules/*" -print0 \
  | xargs -0 perl -pi -e 's/ <span className="krz-tag[^>]*>[^<]*<\/span>//g'

# 2) faixas no topo das páginas (e a linha em branco que as segue)
find . -name "*.mdx" -not -path "./node_modules/*" -print0 \
  | xargs -0 perl -0pi -e 's/<div className="krz-banner">.*?<\/div>\n\n//gs'

# 3) a folha de estilo do andaime
rm -f style.css

echo "andaime de revisão removido. confira com: git diff --stat"
grep -rn "krz-" --include="*.mdx" . 2>/dev/null && echo "ATENÇÃO: sobrou marcador acima" || echo "nenhum marcador remanescente."
