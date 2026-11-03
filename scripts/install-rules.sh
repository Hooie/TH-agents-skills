#!/usr/bin/env bash
# 항상 지킬 작업 규칙(templates/AGENTS.md)을 에이전트의 전역 지시 파일에 넣는다.
# 스킬은 요청이 설명과 맞을 때만 불리지만, 전역 지시 파일은 세션마다 항상 읽힌다.
#
# 사용법:
#   bash scripts/install-rules.sh codex     # ${CODEX_HOME:-~/.codex}/AGENTS.md
#   bash scripts/install-rules.sh claude    # ~/.claude/CLAUDE.md
#   bash scripts/install-rules.sh codex <파일 경로>   # 다른 파일에 넣기
#
# 파일의 기존 내용은 그대로 둔다. 표시 줄 사이의 블록만 넣거나 새로 바꾸므로 여러 번 실행해도 한 번만 들어간다.
set -euo pipefail

TOOL="${1:-}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/templates/AGENTS.md"

case "$TOOL" in
  codex)  DEST="${2:-${CODEX_HOME:-$HOME/.codex}/AGENTS.md}" ;;
  claude) DEST="${2:-$HOME/.claude/CLAUDE.md}" ;;
  *) echo "사용법: bash scripts/install-rules.sh <codex|claude> [파일 경로]" >&2; exit 1 ;;
esac

BEGIN='<!-- my-agent-skills:rules:begin -->'
END='<!-- my-agent-skills:rules:end -->'

mkdir -p "$(dirname "$DEST")"
touch "$DEST"
tmp="$(mktemp)"
# 이전에 넣은 블록을 빼고, 끝에 남는 빈 줄을 정리한다.
awk -v b="$BEGIN" -v e="$END" '$0==b{skip=1;next} $0==e{skip=0;next} !skip' "$DEST" \
  | awk '{a[NR]=$0} NF{last=NR} END{for(i=1;i<=last;i++) print a[i]}' > "$tmp"
{
  if [ -s "$tmp" ]; then cat "$tmp"; echo; fi
  echo "$BEGIN"
  cat "$SRC"
  echo "$END"
} > "$DEST"
rm -f "$tmp"
echo "규칙을 넣었습니다: $DEST"
echo "새 세션부터 적용됩니다."
