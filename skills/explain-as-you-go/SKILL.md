---
name: explain-as-you-go
description: Use whenever you propose a solution or change code. Present solutions by comparing 2–3 genuinely different alternatives on the same criteria, together with a recommendation, and explain the reason for the choice and the reasons for rejecting the rest. For each decision, record the reason, benefits, trade-offs, code location, and verification in the NOTES.md decision log, in the order decided, so that the user can read and explain it, and add comments giving the reasons to the code you changed. Use whenever proposing a solution or changing code - compare alternatives, log each decision with trade-offs in time order, and comment the reasons in code.
license: MIT
metadata:
  author: my-agent-skills
  version: "1.24.0"
---

# Explain As You Go

> **Output language:** write everything the user reads (replies, questions, NOTES.md, HANDOFF.md, code comments, reports) in the user's language. Keep the Korean headings, labels, fixed phrases, and examples quoted in this skill exactly as written.

The goal is that, after the work is done, the user can explain every decision on their own, down to "why this one, what was given up, and why not something else". So solutions are presented with alternatives, and after choosing, the reason, the benefits, the trade-offs, and the reasons for rejection are recorded in text that is easy for the user to read.

## When proposing solutions

This applies to all of these: approaches, designs, data structures and algorithms, bug-fix methods, performance improvements, and fixes for review findings.

1. **Offer 2–3 alternatives.** They must be genuinely different methods. Variants of the same method count as one. If possible, include the simplest option (keeping the current structure or changing it minimally) as a baseline for comparison.
2. **Compare them on the same criteria.** Take the criteria from the success criteria in NOTES.md. Usually these are meeting the success criteria, risk, complexity or performance, and time required. Write "추정" for numbers you did not measure.
3. **Write one recommendation and its reason.** Tie the reason to the comparison criteria. Instead of "더 낫다" (it is better), write something like "성공 기준 2(10ms 이하)를 레이아웃 변경 없이 맞춘다". If the recommendation differs from the original request or from what the user decided earlier, say so, as in "원문은 ~인데 ~를 추천한다".
4. **Write the reason for each rejected option.** One concrete line per option. It also helps to note which changed condition would make you look at that option again. If a reason rests on a fact (whether a tool is installed, a measurement, whether an API exists), record how you checked it. For example: "CMake 없음 — PATH와 Visual Studio 설치 폴더 모두 확인". If you could not check it, write "미확인" and do not reject an option on that fact alone.
5. **The user chooses.** Ask the user about decisions that are hard to reverse or that affect the success criteria, and proceed with the option they choose. Only when the user directly says to leave it to you, such as "알아서 해", proceed with the recommendation, say that you did so, and write "정한 사람: AI(사용자가 위임)" in the decision log. Do not conclude that the user is away just because there is no answer. Ask and wait.
   - When asking for a choice, add at the end "고를 때 고른 이유나 바꿀 점을 한 줄 함께 적어 주세요(예: "A로 해. 읽기만 하니까 쓰기 방어는 빼고")." If the user writes a reason or a direction, write it first in the decision log's "고른 이유" in the user's own words, and the AI's evidence after it. Also leave "사용자 — (사용자가 적은 이유 요약)" in the "정한 사람" line.
   - If the user changes or adds to the instruction (narrowing the scope, mixing in another option, adding a condition), follow it as is without polishing it. If there is a reason it is hard to follow, say so first instead of changing it.

```markdown
**결정할 것:** 인벤토리 두 번째 열기 35ms → 10ms 이하 (성공 기준 2)

| 안 | 방법 | 장점 | 단점·위험 | 드는 시간(추정) |
| --- | --- | --- | --- | --- |
| A | 슬롯 위젯을 풀에서 재사용 | 레이아웃 유지, 목표 달성 예상 | 슬롯 수가 줄 때 숨김 처리 필요 | 30분 |
| B | UListView 가상화 | 1,000칸 이상에서도 빠름 | 레이아웃 재작성 | 2시간 이상 |
| C | 로딩할 때 미리 생성 | 열기 비용이 거의 없음 | 비용을 로딩과 메모리로 옮길 뿐 | 20분 |

추천: A — 성공 기준 2를 레이아웃 변경 없이 맞추고 30분 안에 끝난다.
B를 버리는 이유: 효과는 가장 크지만 레이아웃 재작성은 범위 밖이다. 1,000칸 이상 요구가 생기면 다시 본다.
C를 버리는 이유: 비용이 사라지지 않고 로딩 시간과 상주 메모리로 옮겨 간다.
어느 안으로 할까요? 고를 때 고른 이유나 바꿀 점을 한 줄 함께 적어 주세요(예: "A로 해. 읽기만 하니까 쓰기 방어는 빼고").
```

**When there is only one alternative:** If there is only one reasonable method, as with fixing a typo or when the spec or the engine dictates the method, do not make a table; write one line: "대안 없음 — 이유: ...". Do not invent alternatives.

**Decisions to ask vs. decisions to announce:** Ask the user only about decisions that change the outcome. For the rest, announce the chosen option in one line and proceed. If you ask too often, the user ends up only picking, and the decision log also swells and becomes hard to read.

| Ask (the user chooses) | Announce and proceed (do not ask) |
| --- | --- |
| Behavior rules (whether to include a boundary value, exception handling, processing order) | How to write tests (integration tests / unit tests) |
| Success criteria and how they are judged | Whether to split functions, names, file locations |
| Scope (what goes in, what stays out) | Number of measurements, output format, log wording |
| Hard-to-reverse structure (data formats, public interfaces, new dependencies, large structural changes) | Picking one of several implementations that give the same result (a loop / a built-in function) |
| Things that can only be decided by interpreting the requirements | How to carry an already-decided rule into code |

- Announcement format: "알리고 진행: 출력 테스트는 실제 실행 결과를 캡처하는 방식으로 한다(출력 함수만 따로 확인하면 실제 연결을 놓쳐서)." If the user says to do it differently, change it then.
- The alternatives comparison in a single task's method proposal follows the same criteria. If it is an implementation choice that does not change the result, do not make an alternatives table; announce it.
- Decisions that were announced and carried out do not get a detailed entry in the decision log. Leave only one line in the "결정 한눈에 보기" table and write the status as "알림".

**For bugs:** Verify root-cause hypotheses one at a time, the systematic-debugging way. After finding the cause, compare the ways to fix it in this format.

## After every change

Do this right after changing code, before moving on to the next change.

1. **Two-line explanation.** Tell the user in two lines what you changed and why, and which option you rejected and why.
2. **Add comments.** Add a comment right above the code you added or changed. For how to write them, follow "How to write comments" below.
3. **Record in the decision log.** Add one entry to `## 결정 로그` in NOTES.md. If there is no NOTES.md, create just that section. For how to write it, follow "How to write the decision log" below.
4. **Do not pile changes up.** Do not make several changes at once and explain them all later. If a change comes up that you cannot explain, understand that part first: read the code, run it with a small input, and check the output.

## How to write comments

Make it possible for someone reading the code to learn "why it was done this way" right there, without opening NOTES.md. The user reads along these comments to explain the code.

```python
# 한 번 0까지 쓰면 20 이상으로 회복할 때까지 달릴 수 없다.
# 값만 보면 "쓰다가 10 남음"과 "0에서 10으로 회복함"을 구분할 수 없어 소진 여부를 따로 기억한다.
return self.value > 0 and (not self._exhausted or self.value >= 20.0)

# 회복해서 20 이상이 되면 소진 잠금을 푼다.
# 풀지 않으면 다음에 달릴 때 0이 아니라 20에서 멈춘다.
if self._exhausted and self.value >= 20.0:
    self._exhausted = False
```

- **Language first.** Write comments in the language you use with the user (Korean when the user writes in Korean), even though these instructions are in English. If the file already has comments, follow their language and format (`#`, `//`, doc comments). Before committing, reread the comments you added and rewrite any that are in the wrong language.
- **Where:** on functions, branches, conditions, and constants added or changed in this task. Not on existing code you did not touch.
- **What:** do not restate what the code does; write the reason. Write why this condition, what happens without this line, why `>=` at the boundary (and not `>`), and where a number came from. Bad example: `# value가 20 이상이면 False로 바꾼다`.
- **Write it so the comment alone is understandable.** Do not put in markers such as decision numbers (D11), task numbers (T3), or "NOTES.md 참고". Someone without NOTES.md must be able to learn the reason from the code alone. The link between comments and the decision log is handled by the "코드 위치" line in the decision log.
- **Keep it short.** One or two lines is enough. Keep alternatives comparisons and long explanations in the decision log; do not move them into comments.
- **Update it together with the code.** When the code changes, update the comment above it in the same change. If a decision changes (wait 1 second → 0.5 seconds), update the reason and the numbers in the comment too. A comment that does not match the code is worse than none.
- In tests, comment what the name alone does not reveal (how the expected value was computed, which bug it reproduces).
- Do not add comments or notes to requirement documents maintained by others (specs, issues, etc.).

## How to write records people read

NOTES.md and HANDOFF.md must let the user read them from the beginning and redraw the flow of the work in their head. Write them so that even someone who did not take part in the work can follow "why it turned out this way". They are not notes for another AI to read.

1. **Show the flow first.** Put `## 지금까지의 흐름` at the top of the document (right below the goal), and write it as a chronological story of 5–10 sentences. Never more than 10 sentences. As the work grows, do not keep adding sentences; shorten the earlier part and rewrite it. Keep detailed numbers and test names in the decision log and the verification results, and put only the essential numbers in the flow (for example, "목표 선택 시간이 3.0ms에서 0.03ms로 줄었다"). Split it into a paragraph per stage (question / decision / work / result). What the problem was at first → what was learned by asking → the chosen method and the reason → what changed along the way and why → the current state and what remains. Update it whenever a task ends. The remaining sections are detailed explanations of this flow.
2. **Write in complete sentences.** Do not clip them like notes. Bad example: "기본100 RED 250.0, 설정60 mutation RED 235.0". Good example: "고치기 전에는 10초 쉬면 스태미나가 100에서 멈추지 않고 250까지 올라갔다. 상한을 넣은 뒤 같은 테스트에서 100에서 멈추는 것을 확인했다."
3. **Do not speak only in internal jargon and numbers.**
   - Words such as RED/GREEN, mutation, regression (회귀), dt, and latch are spelled out, or replaced with plain words in the user's language, the first time they appear. For example: "고치기 전에 테스트가 실패하는 것을 확인(RED)", "코드를 일부러 틀리게 바꿔 테스트가 잡아내는지 확인".
   - Write the content alongside D numbers and T numbers. Bad example: "D7로 구체화". Good example: "캐릭터마다 상한을 다르게 두기로 했다(D7). 이 결정은 나중에 모든 캐릭터 상한 100으로 바뀌었다(D9)."
   - In the reading part of NOTES.md and in HANDOFF.md, do not cite a question number alone as a source; write the gist of the answer with it. Bad example: "(출처: Q5 답)". Good example: "(출처: 사용자 답 — 기존 `Skill(cooldown)` 호출은 그대로 둔다)".
4. **Verification records have four parts.** What you meant to check → what you did (command or input) → the result (numbers) → what that tells you. For example: "소진 뒤 다시 달릴 수 있는지 보려고, 0까지 쓴 다음 100까지 회복시키고 4초 달려 봤다. 고치기 전에는 3.2초 만에 20에서 멈췄고, 고친 뒤에는 4초를 다 달려 0에서 멈췄다. 소진 표시가 회복 뒤에 풀린다는 뜻이다."
5. **Write concrete values instead of abstract words.** "큰 dt" → "한 프레임이 10초일 때", "경계값" → "정확히 20일 때와 19.99일 때", "성능 개선" → "35ms에서 9ms로".
6. **For things that changed, write the before and after together.** "회복 대기를 1초에서 0.5초로 바꿨다. 사용자가 요구사항을 바꿨기 때문이다(21:41)."
7. **Do not end with only "참고" (see …).** Even when pointing to another section or file, write the gist in one or two sentences first and then add the location. Bad example: "상세는 NOTES.md D10~D11 참고". Good example: "한 번 바닥나면 20까지 회복해야 다시 달릴 수 있고, 20이 되면 잠금이 풀린다(NOTES.md D10, D11)."
8. **Start paragraphs with the conclusion.** Put what was done or what is true in the first sentence, and the reasons and evidence after it.
9. **When done, read it as someone seeing it for the first time.** Read each sentence, check "does this sentence make sense on its own, and does it use any word that was not explained earlier?", and fix it.
10. **Write each fact in only one place.** Do not repeat the same number or explanation in several sections. Write it in one place and refer to it by number elsewhere. This also prevents numbers from contradicting each other when only one place gets updated.
    - Initial-state numbers → only in "처음 상태" in `## 확인 질문과 답`
    - The reason for a decision, the alternatives comparison, before/after measurement numbers → only in that decision's D entry. In `## 접근 방식`, only one line and the D number
    - Individual test names → only in the "검증" line of the decision log. In the "검증 방법" column of the task list table, only the command or test file (for example, `python -m unittest test_targeting`)
    - In `## 지금까지의 흐름` and `## 성공 기준`, only one representative number each that shows the result (for example, "3.0ms → 0.03ms, D8")
    - When a number changes (the baseline was measured again, etc.), find the places where the old number remains and update them together.
11. **Do not use embellishment or empty sentences.** Do not use words that make things sound good without evidence (효과적으로, 강력한, 깔끔하게, 견고한, 완벽하게 — effectively, powerful, cleanly, robust, perfectly), openings and closings with no content ("이번 작업에서는 ~을 진행했습니다", "이를 통해 ~할 수 있었습니다"), summaries that repeat what was already said, several bold phrases in one paragraph, or emoji. Put numbers or facts in their place. Bad example: "타겟팅 로직을 효과적으로 최적화했습니다." Good example: "목표를 고르는 시간이 2.5ms에서 0.09ms로 줄었다."

## How to write the decision log

The decision log also follows "How to write records people read" above.

The decision log is **text the user reads, memorizes, and explains**, not something for the AI. Read in order from the beginning, it must show how the work flowed, and reading a single entry must be enough to explain that decision within a few minutes.

```markdown
### D3. 인벤토리 슬롯 위젯은 다시 만들지 않고 풀에서 재사용 — T2, 14:20
- 요약: 슬롯 위젯을 매번 만들지 않고 재사용해 두 번째 열기를 10ms 아래로 낮춘다. 대신 닫아도 위젯 120개가 메모리에 남는다.
- 상황: 인벤토리를 두 번째 열 때 35ms가 걸린다. 성공 기준 2는 10ms 이하다.
- 검토한 안: A 위젯 풀 재사용 / B UListView 가상화 / C 로딩할 때 미리 생성
- 고른 이유: 사용자 — "레이아웃은 건드리지 말자". A는 레이아웃을 그대로 두고 목표를 맞추며, 열 때마다 하던 위젯 생성(CreateWidget 120번)이 사라진다. 30분이면 끝난다.
- 트레이드오프: 닫아도 위젯이 메모리에 남는다(120개 상주). 슬롯 수가 줄면 남는 위젯을 숨기는 코드가 더 필요하다. 1,000칸처럼 커지면 풀만으로는 부족하다.
- 버린 안:
  - B UListView 가상화 — 효과는 가장 크지만 레이아웃을 다시 짜야 해서 범위 밖 / 칸 수가 1,000개를 넘는 요구가 생기면 이 안이 낫다
  - C 로딩할 때 미리 생성 — 비용이 사라지지 않고 로딩 시간과 메모리로 옮겨 갈 뿐 / 열기 속도만 중요하고 로딩 시간 여유가 크면 고려
- 확신도: 높음 — 120칸 기준으로 3회 측정했고, 칸 수가 바뀌는 경우(늘기·줄기) 테스트도 있다
- 코드 위치: `InventoryWidget.cpp`의 `RefreshAll()`, `GetOrCreateSlot()`
- 복잡도·엣지 케이스: 열기당 생성 O(N) → O(새로 늘어난 칸 수) / 슬롯이 줄 때 숨김 처리 / 다루지 않음: 정렬 애니메이션
- 정한 사람: 사용자 — "레이아웃은 건드리지 말자" (AI 추천 A와 같음)
- 검증: 120칸 두 번째 열기 35ms → 9ms (stat unit 3회 평균)
```

- **Put the at-a-glance table in the reading part.** In `## 결정 한눈에 보기` at the front of NOTES.md, keep a table that collects every decision, one line each, and update it whenever you add or change a decision. The user skims the whole picture with this table first and reads only the entries they need in detail below.

  ```markdown
  ### 결정 한눈에 보기
  | 번호 | 정한 것 | 이유 | 포기한 것 | 확신 | 상태 |
  | --- | --- | --- | --- | --- | --- |
  | D1 | 값을 0~100으로 제한 | 큰 프레임에서도 범위를 지킨다 | 경계를 넘긴 프레임의 남은 시간 | 높음 | 유효 |
  | D4 | 회복 대기 1초 | 요청자 답 | 상태를 하나 더 저장 | 높음 | 바뀜 → D8 |
  | D8 | 회복 대기 0.5초 | 사용자 변경 지시 | 회복이 더 빨리 시작됨 | 중간 | 유효 |
  ```

- **Write detailed entries only where there is something to explain.** Write a detailed D entry for decisions where alternatives were compared, decisions where the user chose against the recommendation or gave a reason that changes the design, rules set by the requester's answers, bugs fixed, and decisions that changed. Answers accepted as recommended ("질문 답") and decisions that were announced and carried out ("알림") end with one line in the at-a-glance table. Approving a plan or a task list is not a decision; record it only in `## 지금 상태`.
- **Order:** the numbers (D1, D2…) are the order in which decisions were made. At the end of the title, write the task ID and the time (HH:MM). Check the time with a command (`date +%H:%M`, `Get-Date -Format HH:mm` in PowerShell).
- **Title:** write it so the title alone tells what was set to what. Bad example: "D2. 비교 방식". Good example: "D2. 쿨다운 끝 판정은 허용 오차 없이 `<= 0`".
- **Record the effect of a decision as before/after numbers.** For decisions that change behavior or performance, measure before and after applying them, under the same conditions and with the same metric, and write the result in the "검증" line. Do not end with "빨라졌다" (it got faster) or "고쳐졌다" (it got fixed). Also write the conditions (map, number of objects, frame rate, number of measurements) and the measurement command.
  - Performance example: "몬스터 200마리 테스트 맵, 60fps 목표에서 게임 스레드 프레임 시간 21.4ms → 15.8ms (`stat unit` 3회 평균)"
  - Memory and allocation example: "인벤토리를 열 때 프레임당 메모리 할당 120회 → 0회, 위젯 생성 120개 → 처음 한 번만"
  - Rendering example: "같은 카메라 위치에서 드로우콜 1,850 → 640 (`stat scenerendering`)"
  - Behavior example: "10초 쉰 뒤 스태미나 250 → 100(상한에서 멈춤)", "한 프레임이 10초일 때 값 −150 → 0"
  - Also check whether the effect reaches beyond the intended place. For example: if the frame time went down but the loading time went up from 0.8 seconds → 1.3 seconds, write that in the trade-off line too.
  - In an environment where it cannot be measured, write "미확인 — 이유" and do not put in estimated numbers.
- **Compare with a simpler option.** If the chosen option is more complex than the simplest option (keeping the current structure, minimal change), write "단순한 안으로 부족한 이유" (why the simple option is not enough) with a requirements sentence or a measurement. If you cannot write it, it may be over-engineering, so reconsider the simple option.
- **Write the trade-offs in the most detail.** Write what was given up by choosing this option, the risks accepted, and under which inputs or situations this option becomes weak. Do not leave it empty. Only decisions that had no alternative may use "대안 없음 — 이유" instead. Write each weakness in the order weakness → impact if it happens (who is affected, and how) → how to check or respond. For example: "닫아도 위젯 120개가 메모리에 남는다 → 메모리가 작은 기기에서 다른 화면이 늦게 열릴 수 있다 → `stat memory`로 재 보고, 문제가 되면 닫을 때 풀을 비운다".
- **Write for easy reading.** One thing per line, and keep sentences short. Spell out terms in parentheses the first time they appear (for example, "회귀 테스트(고친 버그가 다시 생기지 않는지 보는 테스트)"). Instead of "빠르다" (fast) or "안전하다" (safe), use numbers or examples. Wrap code names in backticks.
- **Write long commands only once.** Long commands or paths that appear many times, such as the test command, are written once at the top of `## 검증 결과` as "테스트 명령: ...", and after that called by a short name such as "전체 테스트".
- **Put the summary line first.** In "요약", right below the title, write in one sentence what was decided, one key reason, and one thing given up. Put the most important thing first and the details after. The user must be able to explain the decision from the summary line alone.
- **Write the confidence.** Write how confident you are that this decision is right as 높음 / 중간 / 낮음, with a one-line reason for seeing it that way. The basis must be something checked, such as tests run, measurements, or requirement sentences. If unchecked cases remain, write 중간 or lower. If it is 중간 or 낮음, also write "무엇을 확인하면 올라가는지" (what, once checked, would raise it). Low-confidence decisions are rechecked first at wrap-up (task-breakdown Wrapping up, step 1). If the result changes, update the confidence too.
- **Do not leave out fields.** Write each field above on its own line. If it does not apply, only the "복잡도·엣지 케이스" line may be removed. If everything is lumped into one paragraph, it becomes hard to find the rejected options and trade-offs later.
- **Keep each entry within 20 lines.** If it goes over, cut down the details of the alternatives comparison (the measurement process, long explanations), or move them to `## 검증 결과` and refer to them by number.
- **Update the entry for new news about the same decision.** Approval, implementation results, and verification results are reflected in the original entry. If a rule was decided first and implemented later, do not make a new entry; fill in the code location and verification in that rule's entry. If the same content is split across two entries, the reader has to figure out which one is right.
- **Do not delete a decision when it changes.** When switching to another option, add "(바뀜 → D7)" to the end of the original entry's title and write "바뀜: → D7" at the very bottom. In the new entry D7, write "D3을 바꿈 — 이유". The mark in the title shows at once that the decision is no longer in use. Reading in order, it must be visible why it changed.
- **Record fixed bugs with the bug template.** Bugs found and fixed through tests, counterexamples, or review findings are written in the four lines below instead of the decision template. Add "(버그)" to the title, and write "버그" in the status column of the at-a-glance table. If you compared alternatives for how to fix it and chose one, write only that comparison as a separate decision entry.

  ```markdown
  ### D12. (버그) 목록에서 사라진 적을 계속 조준함 — T5, 22:40
  - 증상: 적이 목록에서 빠져도 타워가 그 적을 계속 조준한다. 재현: 목표를 정한 뒤 빈 목록으로 choose_target 호출
  - 원인: 현재 목표의 체력·은신·거리만 확인하고, 목록에 있는지는 확인하지 않았다
  - 고친 방법: 목록에 없는 목표는 놓친 것으로 보고 다시 고른다 (targeting.py choose_target)
  - 재발 방지: test_target_removed_from_list — 고치기 전 실패, 고친 뒤 통과
  ```
- If there are many entries with "정한 사람: AI", that means many decisions passed without asking the user, so ask from the next decision on.

## When stating complexity

- Define the symbols that stand for input size. For example: N = number of items, M = number of queries.
- Write time and space separately.
- If the average and the worst case differ, as with hash maps, write both.

## When accepting AI-written code

- Read the generated diff, and if features not in the requirements came in, strip them out. Also record the reason for stripping them in the decision log.
- Confirm against the real thing, not memory, that APIs and functions actually exist and that their signatures and versions match, in the same way as the "Whether the API exists" check in the task-breakdown execution loop, and record the command used. If you could not confirm it, record "미확인".
- Numbers and results written in the "검증" line of the decision log are copied as-is from output run this time. If you did not run it, write "미확인".

## When receiving feedback

This is the order to follow when you receive feedback on code or decisions from the user, the requester, or another reviewer. Following feedback without checking whether it is right lets wrong feedback into the code, and resisting it unconditionally misses right feedback. To avoid both, check first.

1. **Read it to the end.** If there are several findings, read them all before starting. Findings are often related to each other.
2. **Restate it in your own words.** For each finding, restate "what it asks you to change" in one line. If there is even one finding you cannot restate, do not fix anything; ask about that finding first. Fixing with only partial understanding leads to the wrong fix.
3. **Check it against the code.** Confirm whether the finding is true using the code, tests, and run results. Record the commands run and the results.
4. **Judge whether it fits this code.** Even if the feedback is right in general, check whether it is needed for these requirements and this scale (the same standard as the over-engineering check).
5. **Answer.** For a correct finding, say in one line what you will change, and fix it. For a finding that is wrong or does not fit this code, say so with evidence (code location, run results, requirement sentences), and ask whether they still want it. Do not open with agreement such as "좋은 지적입니다" or "말씀이 맞습니다". Open with what you checked.
6. **Fix one at a time.** Run the related tests each time you fix one finding. Do not fix several findings at once and run the tests only once.

- Decisions changed because of feedback are recorded in the decision log ("바뀜 → Dn" in the original entry; the finding and the check result in the new entry).
- Feedback you did not accept is also recorded in one line, with the reason, in the decision log or `## 남은 위험`.

(This order was rewritten with reference to receiving-code-review from obra/superpowers (MIT).)

## When finishing the work

1. **Polish the records and comments.** Update `## 지금까지의 흐름` to match the final state, and read the whole document as someone seeing it for the first time, per item 9 of "How to write records people read", and fix it. Read the decision log in order from the beginning and fix missing fields, empty trade-offs, and content that does not match the code (such as an old function name left behind after the function was renamed). Re-read the code changed this time and fix missing comments, comments that do not match the code, and decision or task numbers left in comments.
   - Before polishing, mark what must not change (names, numbers and units, commands, file paths, conditions, trade-offs, qualifiers such as "아직 확인 못 함" (not yet confirmed)), and after polishing, compare against the original text and restore anything that was dropped or changed. Do not invent examples without evidence to make sentences flow, and do not replace words with stronger ones such as "항상" (always) or "완전히" (completely).
2. **Summarize the results.** Summarize in three paragraphs or fewer what was changed, how the success criteria were checked, and what risks remain, and tell the user which section of NOTES.md holds the details.
