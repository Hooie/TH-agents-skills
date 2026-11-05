#!/usr/bin/env bash
# 스킬 세트를 골라 설치한다 (macOS, Linux, Git Bash, 클라우드 개발 환경의 터미널).
#
# 사용법:
#   bash scripts/install.sh <세트> [설치 폴더]
#
# 세트 (쉼표로 여러 개 가능, 예: core,cpp)
#   core    작업 진행 공통: problem-framing, task-breakdown, explain-as-you-go, session-handoff,
#           verification-before-completion, systematic-debugging, test-driven-development
#   cpp     C++ 코드 리뷰·알고리즘 문제: game-client-review, cpp-stress-test
#   cp      알고리즘 대회용 코드 습관: cp-skills-cpp (게임 코드에는 맞지 않아 cpp에서 뺐다)
#   unreal  언리얼 엔진 5: ue-* 스킬 7개
#   all     전부
#
# 설치 폴더 (생략하면 Codex 개인 폴더 ~/.agents/skills)
#   Codex 개인         ~/.agents/skills
#   Codex 프로젝트     <프로젝트>/.agents/skills
#   Claude Code 개인   ~/.claude/skills
#   Claude Code 프로젝트 <프로젝트>/.claude/skills
set -euo pipefail

SETS="${1:-core}"
DEST="${2:-$HOME/.agents/skills}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

CORE="problem-framing task-breakdown explain-as-you-go session-handoff verification-before-completion systematic-debugging test-driven-development"
CPP="game-client-review cpp-stress-test"
CP="cp-skills-cpp"
UNREAL="ue-project-context ue-cpp-foundations ue-actor-component-architecture ue-networking-replication ue-testing-debugging ue-module-build-system ue-performance"

LIST=""
IFS=',' read -r -a PARTS <<< "$SETS"
for part in "${PARTS[@]}"; do
  case "$part" in
    core)   LIST="$LIST $CORE" ;;
    cpp)    LIST="$LIST $CPP" ;;
    cp)     LIST="$LIST $CP" ;;
    unreal) LIST="$LIST $UNREAL" ;;
    all)    LIST="$LIST $CORE $CPP $CP $UNREAL" ;;
    *) echo "알 수 없는 세트: $part (core, cpp, cp, unreal, all 중에서 고르세요)" >&2; exit 1 ;;
  esac
done

mkdir -p "$DEST"
count=0
for s in $LIST; do
  if [ ! -f "$ROOT/skills/$s/SKILL.md" ]; then echo "없는 스킬: $s" >&2; exit 1; fi
  rm -rf "${DEST:?}/$s"
  cp -R "$ROOT/skills/$s" "$DEST/$s"
  echo "설치: $DEST/$s"
  count=$((count + 1))
done
echo "완료: 스킬 ${count}개 → $DEST"
echo "확인: Codex는 /skills, Claude Code는 입력창에서 / 를 눌러 목록을 보세요. 목록에 없으면 세션을 새로 시작하세요."
