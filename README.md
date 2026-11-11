# TH-agent-skills

기능 개발이나 버그 수정 같은 일을 문제 정의부터 작업 분해, 검증, 인계까지 순서대로 진행하기 위한 [Agent Skills](https://agentskills.io) 모음입니다. 게임 클라이언트(C++, 언리얼 엔진 5) 개발용 스킬도 함께 들어 있습니다. 직접 만든 스킬 6개와, 라이선스를 확인하고 가져온 오픈소스 스킬 11개로 이루어져 있습니다.

같은 `SKILL.md` 형식을 Claude Code와 Codex가 모두 읽습니다. 두 도구는 스킬 폴더 위치만 다릅니다.

모든 스킬은 한 가지 규칙을 공유합니다. 에이전트가 해결책을 제시할 때는 서로 다른 대안 2~3개를 같은 기준으로 비교하고, 추천안을 고른 이유와 나머지를 버린 이유를 설명합니다. 결정은 사용자가 하고, 결과는 NOTES.md 결정 로그에 결정한 순서대로 남습니다. 결정마다 장점과 트레이드오프, 코드 위치를 함께 적어, 나중에 사용자가 읽고 바로 설명할 수 있게 합니다.

## 스킬 세트

필요한 세트만 골라 설치합니다. 언리얼 작업이 없는 환경(예: 클라우드 개발 환경)에서는 `core`만 설치하는 것을 권장합니다. 쓰지 않는 스킬도 설명이 에이전트의 스킬 목록에 들어가 자리를 차지하기 때문입니다.

### core — 작업 진행 공통

| 스킬 | 출처 | 언제 쓰나 |
| --- | --- | --- |
| [problem-framing](skills/problem-framing/) | 직접 작성 · MIT | 여러 단계가 필요한 작업을 처음 받았을 때. 목표, 확인 질문, 가정, 수치 성공 기준, 범위 밖, 1순위 문제, 접근 방식 대안 비교를 NOTES.md에 정리한다 |
| [task-breakdown](skills/task-breakdown/) | 직접 작성 · MIT | 문제 정의 직후. 30분 단위 작업으로 나누고, 작업마다 방법 대안 비교 → 지시문 → 테스트 → 구현 → 점검 → 검증을 하나씩 한다 |
| [explain-as-you-go](skills/explain-as-you-go/) | 직접 작성 · MIT | 해결책을 낼 때와 구현하는 내내. 대안 비교와 추천, 고른 이유와 버린 이유, 복잡도, 엣지 케이스, 검증을 결정 로그에 남긴다 |
| [session-handoff](skills/session-handoff/) | 직접 작성 · MIT | 세션 전환, compact, PR을 올리거나 작업을 넘기기 직전. 다른 사람이나 새 세션이 이어받을 수 있게 HANDOFF.md를 쓴다 |
| [verification-before-completion](skills/verification-before-completion/) | obra/superpowers · MIT | "완료"라고 말하기 전. 검증 명령을 실행한 결과를 근거로 남긴다 |
| [systematic-debugging](skills/systematic-debugging/) | obra/superpowers · MIT | 버그나 테스트 실패. 원인을 찾기 전에는 고치지 않는다 |
| [test-driven-development](skills/test-driven-development/) | obra/superpowers · MIT | 실패하는 테스트를 먼저 쓰고 구현할 때 |

### cpp — C++ 코드 리뷰

| 스킬 | 출처 | 언제 쓰나 |
| --- | --- | --- |
| [game-client-review](skills/game-client-review/) | 직접 작성 · MIT | AI나 다른 사람이 쓴 게임 클라이언트 C++ 코드를 반영하기 전에 검토할 때 |

### cp — 알고리즘 문제 풀이 (선택)

| 스킬 | 출처 | 언제 쓰나 |
| --- | --- | --- |
| [cpp-stress-test](skills/cpp-stress-test/) | 직접 작성 · MIT | C++ 알고리즘 문제. 제약에서 복잡도를 정하고 브루트포스와 랜덤 입력으로 대조한다 |
| [cp-skills-cpp](skills/cp-skills-cpp/) | area44/cp-skills · MIT | C++ 경쟁 프로그래밍 습관과 알고리즘 패턴. 짧은 이름, `main()`에 몰아 쓰기 같은 대회용 규칙이라 게임 코드에는 맞지 않아 `cpp` 세트에서 뺐습니다 |

### unreal — 언리얼 엔진 5

| 스킬 | 출처 | 언제 쓰나 |
| --- | --- | --- |
| [ue-project-context](skills/ue-project-context/) | quodsoler/unreal-engine-skills · MIT | 언리얼 프로젝트에서 가장 먼저. `.agents/ue-project-context.md`를 만든다 |
| [ue-cpp-foundations](skills/ue-cpp-foundations/) | quodsoler/unreal-engine-skills · MIT | UCLASS, UPROPERTY, GC, TObjectPtr, 델리게이트, 컨테이너 |
| [ue-actor-component-architecture](skills/ue-actor-component-architecture/) | quodsoler/unreal-engine-skills · MIT | 액터·컴포넌트 수명주기, 스폰, Tick |
| [ue-networking-replication](skills/ue-networking-replication/) | quodsoler/unreal-engine-skills · MIT | 리플리케이션, RPC, 서버 권한 |
| [ue-testing-debugging](skills/ue-testing-debugging/) | quodsoler/unreal-engine-skills · MIT | 자동화 테스트, 로그, Unreal Insights |
| [ue-module-build-system](skills/ue-module-build-system/) | quodsoler/unreal-engine-skills · MIT | Build.cs, 모듈, 빌드·링크 에러 |
| [ue-performance](skills/ue-performance/) | Schepetkov/claude-skills-game-UE · MIT | 프레임 드랍, 병목 찾기, 프로파일링 |

## 설치

### 방법 1. Codex에서 링크로 설치 (skill-installer)

Codex에 기본으로 들어 있는 `$skill-installer`에 스킬 폴더 링크를 넘깁니다. 저장소 주소만 넘기면 설치할 경로가 없다며 멈추므로, 스킬마다 폴더 링크를 넘깁니다. 아래를 그대로 붙여 넣으면 core 7개가 한 번에 설치됩니다.

```text
$skill-installer 아래 스킬들을 설치해 줘.
https://github.com/Hooie/TH-agents-skills/tree/main/skills/problem-framing
https://github.com/Hooie/TH-agents-skills/tree/main/skills/task-breakdown
https://github.com/Hooie/TH-agents-skills/tree/main/skills/explain-as-you-go
https://github.com/Hooie/TH-agents-skills/tree/main/skills/session-handoff
https://github.com/Hooie/TH-agents-skills/tree/main/skills/verification-before-completion
https://github.com/Hooie/TH-agents-skills/tree/main/skills/systematic-debugging
https://github.com/Hooie/TH-agents-skills/tree/main/skills/test-driven-development
```

C++ 작업이면 `https://github.com/Hooie/TH-agents-skills/tree/main/skills/game-client-review`도 함께 넘깁니다.

- 설치 위치는 `~/.codex/skills`(`$CODEX_HOME/skills`)입니다. 설치한 다음 차례부터 쓸 수 있습니다. `/skills` 목록에 안 보이면 Codex를 다시 시작합니다.
- 같은 이름의 폴더가 이미 있으면 덮어쓰지 않고 멈춥니다. 새 버전으로 바꾸려면 그 폴더를 지운 뒤 다시 설치합니다.
- 스킬 폴더를 통째로 복사하므로 `agents/openai.yaml`도 함께 들어갑니다.
- 이 방법으로는 [항상 지킬 규칙](#항상-지킬-규칙-넣기-선택)(`templates/AGENTS.md`)이 들어가지 않습니다. 핵심 규칙은 스킬 안에도 있으므로 첫 요청을 `$problem-framing`으로 시작하면 됩니다.

### 방법 2. 설치 스크립트 (macOS, Linux, Git Bash, 클라우드 터미널)

```bash
git clone --depth 1 https://github.com/Hooie/TH-agents-skills.git
bash TH-agents-skills/scripts/install.sh core                          # Codex 개인 폴더(~/.agents/skills)에 core 설치
bash TH-agents-skills/scripts/install.sh core,cpp,unreal ~/.claude/skills   # Claude Code 개인 폴더에 전부 설치
```

세트는 `core`, `cpp`, `cp`, `unreal`, `all` 중에서 쉼표로 골라 씁니다. 두 번째 인자로 설치 폴더를 바꿀 수 있습니다.

### 방법 3. skills CLI (Node.js 필요, Windows 포함)

```bash
npx skills add Hooie/TH-agents-skills --list                                  # 목록 보기
npx skills add Hooie/TH-agents-skills -a codex -g -y --skill problem-framing task-breakdown explain-as-you-go session-handoff verification-before-completion systematic-debugging test-driven-development
npx skills add Hooie/TH-agents-skills -a claude-code -g -y                     # Claude Code에 전부
```

`-g`를 빼면 현재 프로젝트 폴더에 설치됩니다.

### 방법 4. 직접 복사

`skills/` 아래에서 원하는 스킬 폴더를 통째로 아래 위치에 복사합니다.

| 도구 | 모든 프로젝트 | 이 프로젝트만 |
| --- | --- | --- |
| Codex | `~/.agents/skills/` | `<프로젝트>/.agents/skills/` |
| Claude Code | `~/.claude/skills/` | `<프로젝트>/.claude/skills/` |

Windows에서 `~`는 `C:\Users\<사용자 이름>`입니다.

### 항상 지킬 규칙 넣기 (선택)

스킬은 요청이 설명과 맞을 때만 불립니다. 대안 비교 규칙과 작업 순서를 매번 지키게 하려면 [templates/AGENTS.md](templates/AGENTS.md)를 전역 지시 파일에 넣습니다. 기존 내용은 그대로 두고 이 블록만 넣거나 바꿉니다.

```bash
bash TH-agents-skills/scripts/install-rules.sh codex    # ~/.codex/AGENTS.md
bash TH-agents-skills/scripts/install-rules.sh claude   # ~/.claude/CLAUDE.md
```

## 사용

- 스킬은 설명(description)과 맞는 요청을 하면 에이전트가 알아서 불러옵니다.
- 직접 부르려면 Claude Code는 `/스킬이름`, Codex는 `$스킬이름` 또는 `/skills` 목록을 씁니다.
- 설치가 됐는지는 Claude Code에서 `/` 메뉴, Codex에서 `/skills`로 확인합니다. 안 보이면 세션을 새로 시작합니다.

### 작업 흐름

1. `problem-framing` — 요구사항 문서(README 등)를 끝까지 읽고, 문서에 없는 것은 근거를 붙인 추정안으로 묻기. 기존 코드가 있으면 처음 상태부터 실행해 확인하고, 요구사항을 준 담당자에게 물을 수 있으면 보낼 질문도 따로 만듭니다. 성공 기준, 1순위 문제, 접근 방식 비교, NOTES.md. 요구사항 문서는 고치지 않습니다
2. `task-breakdown` — 작업 목록. 작업마다 방법 대안 비교 → 사용자 선택 → 지시문 → 테스트(경계값, 잘못된 입력, 상태와 순서, 누적 오차, 회귀) → 구현 → 점검(정확성, 스펙 대조, API 실재 여부, 보안·민감정보, 반례) → 전체 테스트 → 커밋(푸시하지 않음). 작업이 끝나면 직접 돌려 볼 확인 명령을 알려 줍니다. 서로 기다리지 않는 작업은 허락을 받은 뒤 다른 터미널에서 동시에 진행
3. 구현 내내 `explain-as-you-go`. 자동 테스트가 되는 작업은 `test-driven-development`, 버그는 `systematic-debugging`, AI가 쓴 C++ diff는 `game-client-review`
4. `verification-before-completion` — 성공 기준 전체 재확인. 그다음 `explain-as-you-go`로 결정 로그를 다듬고, 완성된 코드로 만든 예상 질문에 답해 보기
5. `session-handoff` — HANDOFF.md, 실행 방법 확인, 마지막 커밋(푸시하지 않음)

시작점이 다른 경우:
- 알고리즘 문제 하나 → `cp` 세트의 `cpp-stress-test` (대회식 코드 습관까지 원하면 `cp-skills-cpp`). 이때는 TDD 대신 브루트포스 대조로 검증합니다.
- 원인을 모르는 버그 하나 → `systematic-debugging`
- 언리얼 프로젝트 → 처음 한 번 `ue-project-context`, 그다음 위 흐름

## 참고

- 가져온 스킬 중 일부는 이 저장소에서 함께 쓰기 좋게 조금 고쳤습니다. 없는 스킬을 가리키는 참조 정리, 설명 보완 등이며 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)에 모두 적었습니다.
- 일부 규칙은 [mattpocock/skills](https://github.com/mattpocock/skills)를 참고해 다시 썼습니다. 스킬 파일을 가져오지는 않았고, 참고한 곳은 THIRD_PARTY_NOTICES.md에 적었습니다.
- 언리얼 스킬은 원본 저장소의 다른 `ue-*` 스킬을 가리키기도 합니다. 이 저장소에는 7개만 있어서, 각 스킬 맨 위에 그 사실과 대처 방법을 적어 두었습니다.
- `session-handoff`는 Codex에서 자동으로 불리지 않고 `$session-handoff`로 직접 부를 때만 쓰입니다(`skills/session-handoff/agents/openai.yaml`). Claude Code와 Claude 앱에는 영향이 없습니다.
- 언리얼 스킬은 원본 기준 UE 5.8입니다. 다른 버전에서는 API가 다를 수 있습니다.
- `systematic-debugging/find-polluter.sh`와 `ue-performance/scripts/minidump_stack.py`는 에이전트가 필요할 때 실행하는 보조 스크립트입니다. 자동으로 실행되는 훅은 넣지 않았습니다.

## 라이선스

직접 만든 스킬(`problem-framing`, `task-breakdown`, `explain-as-you-go`, `session-handoff`, `game-client-review`, `cpp-stress-test`)은 [MIT](LICENSE)입니다. 가져온 스킬은 각 폴더의 `LICENSE`를 따르며, 원본 저장소와 바꾼 점은 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)에 있습니다.
