#!/usr/bin/env bash
# templates/AGENTS.md(원본)를 스킬 폴더 안의 사본(references/rules.md)으로 복사한다.
# 스킬만 설치되고 전역 지시 파일(AGENTS.md, CLAUDE.md)은 없는 환경에서도
# problem-framing과 task-breakdown이 이 사본을 읽어 같은 규칙으로 일하게 하기 위해서다.
# templates/AGENTS.md를 고친 뒤에는 이 스크립트를 한 번 실행하고 함께 커밋한다.
#
# 사용법: bash scripts/sync-rules.sh          # 복사
#         bash scripts/sync-rules.sh --check  # 사본이 원본과 같은지만 확인(다르면 종료 코드 1)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/templates/AGENTS.md"
TARGETS="problem-framing task-breakdown"

status=0
for s in $TARGETS; do
  dest="$ROOT/skills/$s/references/rules.md"
  if [ "${1:-}" = "--check" ]; then
    if cmp -s "$SRC" "$dest"; then echo "같음: $dest"; else echo "다름: $dest"; status=1; fi
  else
    mkdir -p "$(dirname "$dest")"
    cp "$SRC" "$dest"
    echo "복사: $dest"
  fi
done
exit $status
