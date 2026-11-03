## 작업 규칙 (my-agent-skills)

### 해결책을 제시할 때

- 서로 다른 대안 2~3개를 같은 기준(성공 기준, 위험, 복잡도·성능, 드는 시간)으로 비교한다.
- 추천안 하나와 고른 이유, 버리는 안마다 그 이유를 쓴다.
- 되돌리기 어렵거나 성공 기준에 영향을 주는 결정은 사용자가 고른다. 되돌리기 쉬운 작은 결정은 한 줄로 알리고 진행한다.
- 합리적인 방법이 하나뿐이면 "대안 없음 — 이유" 한 줄로 쓴다. 대안을 지어내지 않는다.
- 고른 안과 이유, 버린 안과 이유를 NOTES.md 결정 로그에 남긴다. 형식은 explain-as-you-go를 따른다.

### 작업 흐름

1. 여러 단계가 필요한 과제는 코드보다 먼저 problem-framing으로 시작한다.
2. task-breakdown으로 작업을 나누고, 작업마다 대안 비교 → 지시문 → 테스트 → 구현 → 검증 → 커밋을 한 번에 하나씩 한다.
3. 구현하는 내내 explain-as-you-go를 따른다. 자동 테스트가 가능한 작업은 test-driven-development, 버그와 테스트 실패는 systematic-debugging, C++ diff 확인은 game-client-review를 쓴다.
4. "완료"라고 말하기 전에 verification-before-completion을 따른다.
5. 세션을 바꾸거나 제출하기 전에 session-handoff를 쓴다.

알고리즘 문제 하나는 cpp-stress-test로, 원인을 모르는 버그 하나는 systematic-debugging으로 바로 시작한다. 설치되지 않은 스킬은 건너뛴다.
