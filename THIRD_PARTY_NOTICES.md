# Third-party notices

이 저장소의 일부 스킬은 아래 오픈소스 저장소에서 가져왔습니다. 각 스킬 폴더에 원본 라이선스 전문을 `LICENSE`로 함께 두었고, 같은 전문을 [third_party/licenses/](third_party/licenses/)에도 보관합니다.

## obra/superpowers

- 저장소: https://github.com/obra/superpowers
- 커밋: `2ce8aa15d05bd57213e6f746f953aafb7ded7a8b` (2026-10-21)
- 라이선스: MIT, Copyright (c) 2025 Jesse Vincent
- 가져온 스킬: `systematic-debugging`, `verification-before-completion`, `test-driven-development`
- 바꾼 점: 폴더를 복사하고 `LICENSE`를 추가했습니다. 플러그인 훅(`hooks/`)은 가져오지 않았습니다. 플러그인 밖에서도 참조가 이어지도록 아래만 고쳤습니다.
  - `systematic-debugging/SKILL.md`: `superpowers:test-driven-development` → `test-driven-development`, `superpowers:verification-before-completion` → `verification-before-completion`
  - `systematic-debugging/SKILL.md`: 맨 앞에 "my-agent-skills에서 더한 규칙" 절을 추가함(재현 명령 먼저, 가설 3~5개, 디버그 로그 표시, 수정 방법 비교). 아래 mattpocock/skills 항목 참고
  - `test-driven-development/writing-good-tests.md`: 이 저장소에 없는 `superpowers:writing-skills` 참조를 "obra/superpowers의 writing-skills 스킬, 이 저장소에는 없음"이라는 설명으로 바꿈

## quodsoler/unreal-engine-skills

- 저장소: https://github.com/quodsoler/unreal-engine-skills
- 커밋: `f3742d7b688690810df369802b90430324e380b9` (2026-09-28)
- 라이선스: MIT, Copyright (c) 2025 quodsoler
- 가져온 스킬: `ue-project-context`, `ue-cpp-foundations`, `ue-actor-component-architecture`, `ue-networking-replication`, `ue-testing-debugging`, `ue-module-build-system`
- 바꾼 점: `references/`를 포함해 폴더를 복사하고 `LICENSE`를 추가했습니다. 이 저장소에 없는 스킬로 안내하지 않도록 아래만 고쳤습니다.
  - `description` 끝의 "see ue-..." 안내 중 이 저장소에 없는 스킬(ue-physics-collision, ue-gameplay-framework, ue-blueprint-cpp-interop, ue-editor-tools, ue-game-features, ue-gameplay-abilities, ue-character-movement)을 가리키는 부분을 지움
  - 각 `SKILL.md` 제목 아래에 "이 저장소에는 UE 스킬 7개만 있으며, 본문이 다른 ue-* 스킬을 가리키면 찾지 말고 진행한다"는 한국어 안내 한 줄을 추가함

## Schepetkov/claude-skills-game-UE

- 저장소: https://github.com/Schepetkov/claude-skills-game-UE
- 커밋: `09261e50cbd395a63ffd5cb37f81b2e0ea7edb8a` (2026-11-01)
- 라이선스: MIT, Copyright (c) 2026 Dmitriy Schepetkov
- 가져온 스킬: `ue-performance`
- 바꾼 점: `references/`, `scripts/`, `field-notes/`를 포함해 폴더를 복사하고 `LICENSE`를 추가했습니다. `SKILL.md` 제목 아래에 위와 같은 안내 한 줄을 추가했습니다.

## area44/cp-skills

- 저장소: https://github.com/area44/cp-skills
- 커밋: `66f940bf15a6ca71aab08c23c8c41a46ae864a19` (2026-08-15)
- 라이선스: MIT, Copyright (c) 2026-present AREA44 (원문 표기: "2026-prsent")
- 가져온 스킬: `skills/cpp` → `cp-skills-cpp`
- 바꾼 점: 폴더 이름을 `cpp`에서 SKILL.md의 `name` 값인 `cp-skills-cpp`로 바꿨습니다. frontmatter만 아래처럼 고쳤고 본문은 그대로입니다.
  - `description`에 언제 쓰는지(C++ 경쟁 프로그래밍·코딩테스트)와 언리얼·실무 게임 코드에는 이 명명·구조 규칙을 적용하지 않는다는 문장을 추가함
  - `metadata`를 목록 형식에서 Agent Skills 표준의 키-값 형식으로 바꿈(값은 같음)

## mattpocock/skills (참고만 함)

- 저장소: https://github.com/mattpocock/skills
- 커밋: `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d` (2026-10-31)
- 라이선스: MIT, Copyright (c) 2026 Matt Pocock (전문: [third_party/licenses/mattpocock-skills.LICENSE](third_party/licenses/mattpocock-skills.LICENSE))
- 가져온 스킬: 없음. 아래 스킬의 아이디어를 참고해 이 저장소의 스킬에 한국어로 새로 썼습니다.
  - `grilling` → `problem-framing`: 질문을 차례로 나눠 묻기, "예"로 추천안 받기, 사실은 직접 확인하고 결정만 묻기
  - `diagnosing-bugs` → `systematic-debugging`의 추가 절: 재현 명령 먼저, 가설 3~5개, 디버그 로그 표시
  - `tdd` → `task-breakdown`: 테스트할 지점 정하기, 피할 테스트 패턴, 테스트 하나씩
  - `to-tickets` → `task-breakdown`: 기능 단위로 자르기, 구조 정리 먼저
  - `code-review` → `game-client-review`: 스펙 대조를 코드 품질과 따로 보고
  - `handoff` → `session-handoff`: 다음 세션에 쓸 스킬, 복사하지 말고 가리키기, 민감 정보 가리기
