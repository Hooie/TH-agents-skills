---
name: independent-review
description: Use when you have finished one large piece of work, before wrapping up, before opening a PR, or when reviewing a change someone else made. Instead of the session that did the work reviewing its own code, prepare a reviewer prompt so that a new session with no conversation history (a new terminal or a subagent) reviews it from only the requirements and the diff. Check the findings that come back, then fix them or answer with evidence. Also use it to test whether someone reading HANDOFF.md or NOTES.md for the first time can understand the work from the documents alone (the record reading test). Use to get a fresh-context review of finished work - prepare a self-contained reviewer prompt, then verify and act on the findings.
license: MIT
metadata:
  author: my-agent-skills
  version: "1.4.0"
---

# Independent Review

> **Output language:** write everything the user reads (replies, questions, NOTES.md, HANDOFF.md, code comments, reports) in the user's language. Keep the Korean headings, labels, fixed phrases, and examples quoted in this skill exactly as written.

When a session checks its own code, it misses during the check exactly what it missed while building it. Most cases where all the tests pass but a bug remains happen this way. So the review is handed to another session with no conversation history. That session sees only the requirements and the deliverable, so it does not follow the thinking of the side that did the work.

This skill is split into two roles.

- **Requester (the session that did the work):** sets the review range, prepares a reviewer prompt that can be pasted as is into another session, and handles the findings that come back. It does not review directly.
- **Reviewer (a new session):** receives only the prompt, reviews read-only, and returns a list of findings.

## Requester procedure

1. **Set the range.**
   - Start commit: the commit before this work started (the initial state in NOTES.md, or the parent of the first task commit). If it is unclear, ask the user.
   - End commit: the current HEAD. If there are uncommitted changes, ask the user whether to commit them before the review. The reviewer sees only what is committed.
   - Check the list of commits in the range with `git log --oneline 시작..끝` and put it in the prompt.
2. **Prepare the reviewer prompt.** Fill in the "Reviewer prompt template" below. Keep to what goes in and what stays out.
   - Goes in: the path of the requirements document, NOTES.md `## 성공 기준`, `## 범위 밖`, `## 확인 질문과 답` (rules agreed with the user or with whoever requested the work), the run and test commands, and the review range (two commits).
   - Stays out: the conversation history, `## 지금까지의 흐름`, the reasons and alternatives comparisons in the decision log, and notes such as "여기는 이미 확인했다" (this part has already been checked). If the working side's judgment gets in, the reviewer follows the same blind spots.
3. **Hand it to the user.** Show the prompt as a single code block, give the guidance below, and **stop.**
   - "새 터미널에서 이 폴더로 새 세션을 열고 아래 지시문을 그대로 붙여 넣어 주세요. 리뷰 결과가 나오면 여기에 붙여 주세요."
   - If the tool in use supports subagents, also ask, as an option, "제가 서브에이전트로 직접 띄울 수도 있습니다". Launch one only after permission, and use the same prompt.
   - If Codex CLI is available, also ask, as an option, "같은 터미널에서 읽기 전용 Codex를 한 번 실행해 검토할 수도 있습니다". If permitted, do it in the order below.
     1. Run `codex --version` and `codex exec --help` to check whether the installed version has a read-only run option (for example, `--sandbox read-only`) and a working-folder option. Option names can differ between versions, so use only what appears in the help output.
     2. Save the prompt to a temporary file outside the repository. Do not put the prompt directly into a command-line argument. Quotes, `$(...)`, and backticks in the code can cut the prompt short or cause commands to run.
     3. Show the command to be run to the user, get confirmation, and pass the prompt via standard input. For example: `codex exec --sandbox read-only -C <repo> - < <temp file>`
     4. If the run fails or there is no read-only option, say so and return to the new-terminal method. Do not quietly substitute a self-review by the same session.
4. **Handle the findings.** When the review results come in, follow the order in explain-as-you-go "When receiving feedback". Review results are material, not a verdict. The reviewer has no context, so it can be wrong, and because it has no context, it can also be right. Restate each finding in your own words, check it with the code and by running it, and then classify it as the first of the following that fits.
   1. **전달 부족 (briefing gap):** a finding caused by requirements or rules in the prompt that were missing or ambiguous. Fix the prompt first, and see whether this finding disappears in the next review.
   2. **고칠 것 (fix):** a real defect. Add a failing test first and fix it (the same order and the same report and commit format as the task-breakdown execution loop). For findings that require deciding a behavior rule, ask the user.
   3. **감수할 트레이드오프 (accepted trade-off):** a real problem, but fixing it costs more. Show it to the user and record it in the decision log as a trade-off.
   4. **잡음 (noise):** code that is correct in a context the reviewer did not have. Write the reason for not accepting it with evidence (code location, run result, requirement sentence). Also note whether this finding would have come up if that context had been in the prompt.
   - "고치면 좋은 것" (nice to fix) is classified by default as 3 (감수할 트레이드오프) or 4 (잡음), with the reason recorded. Fix it only when it passes the over-engineering check in task-breakdown Execution loop 5 and the cost of fixing it is small. Following every reviewer finding leads to over-engineering.
   - Also go through the "판단하지 않고 넘긴 것" (passed over without judgment) list one by one. Handle the ones that need handling the same way as findings; otherwise move them to `## 남은 위험` with the reason.
5. **Decide whether to review again.** If you fixed "고칠 것" items or fixed the prompt, ask the user whether to get one more review the same way. Review at most 3 times.
   - If the next review brings up only trivial findings or ones already handled, stop.
   - If important findings keep coming after 3 reviews, do not run more; tell the user. It is a sign that the deliverable is not ready yet, so decide whether to reduce the scope or split the work again.
   - If the user says "그만해도 된다" (it is fine to stop), stop.
6. **Record it.** Leave one paragraph in NOTES.md `## 검증 결과`: when, which range, by which method (new terminal / subagent / read-only Codex), and how many times it was reviewed; the findings split into the four classes with the count for each, and the reasons for those not accepted. Record fixed findings as entries in the decision log.

## Reviewer prompt template

````markdown
너는 이 저장소의 변경을 처음 보는 코드 리뷰어다. 아래 정보만으로 검토한다. 이 변경을 만든 대화나 이유는 모른다고 생각하고, 결과물만 보고 판단한다.

목표는 결함을 찾는 것이다. 작성자가 자신을 과신하고 있다고 가정한다. 잘된 점을 칭찬하거나 변경 내용을 요약하지 않는다. 충분히 살펴봤는데도 결함을 찾지 못했으면 "찾지 못함"이라고 분명히 쓰고, 무엇을 살펴봤는지 적는다.

## 무엇을 만들었나
(한두 문장. 무엇을 바꿨는지만 쓰고 왜 그렇게 했는지는 쓰지 않는다)

## 요구사항
- 요구사항 문서: (경로)
- 성공 기준: (NOTES.md `## 성공 기준`을 그대로 붙인다)
- 정해진 규칙: (NOTES.md `## 확인 질문과 답`에서 동작 규칙만 붙인다)
- 범위 밖: (NOTES.md `## 범위 밖`)

## 검토 범위
- 시작 커밋: (해시) / 끝 커밋: (해시)
- 볼 명령: `git log --oneline 시작..끝`, `git diff --stat 시작..끝`, `git diff 시작..끝`
- 실행·테스트 명령: (명령)

## 규칙
- 읽기 전용이다. 파일을 고치거나 만들지 않는다. git 상태를 바꾸는 명령(add, commit, checkout, reset, stash 등)을 쓰지 않는다. 테스트와 실행 명령은 돌려도 된다.
- 다른 에이전트나 서브에이전트를 띄우지 않는다. 혼자 검토한다.
- 요구사항 문서는 방향을 적은 문서이고 모든 상황을 나열하지 않는다. 문서가 말하지 않는 동작은 이 기능을 쓰는 사람이 당연히 기대할 동작을 기준으로 판단한다. 문서에 없다는 것은 아무렇게나 동작해도 된다는 허락이 아니다.
- 특히 본다: 드러나지 않은 가정, 성공 기준마다 그것을 실제로 확인하는 테스트가 있는지, 통과시키려고 약하게 만든 테스트나 검사(삭제, skip, 단언 제거, 기대값을 결과에 맞춘 변경, 경고 끄기), 경계값, 상태를 기억하는 코드에서 같은 흐름을 반복하거나 가리키던 대상이 사라졌을 때, 요구사항에 근거가 없는 방어 코드·추상화(과잉 설계), 문서의 실행 방법대로 실행되는지.
- 지적마다 직접 확인한다. 확인하지 못한 지적은 "미확인"이라고 쓴다.
- 요구사항에 근거가 없는 방어 코드, 추상화, 일반화, 일어날 수 없는 경우의 테스트를 제안하지 않는다. 결함을 찾으라는 지시 때문에 억지로 지적을 만들지 않는다. 꼭 고칠 것이 없으면 "그대로 마쳐도 됨"이 정답이다.

## 돌려줄 형식
1. 결론: "그대로 마쳐도 됨" 또는 "꼭 고칠 것 있음"
2. 지적 목록: 지적마다
   - 심각도: 꼭 고칠 것 / 고치면 좋은 것
     - 꼭 고칠 것: 정확성(버그, 잘못된 결과, 데이터 손상, 멈춤)이나 요구사항·성공 기준·정해진 규칙을 어기는 것만.
     - 고치면 좋은 것: 그 밖의 개선. 스타일과 취향(이름, 포맷, 취향에 따른 구조)은 쓰지 않는다.
   - 위치: 파일과 줄(또는 함수)
   - 내용: 무엇이 문제인지 한두 문장
   - 근거: 재현 방법이나 실행한 명령과 결과, 또는 요구사항 문장
3. 판단하지 않고 넘긴 것: 검토하다가 범위 밖이라고 보고 넘긴 동작을 한 줄씩, 이유와 함께. 넘긴 것이 없으면 "없음".
4. 확인한 명령: 검토 중 실행한 명령 목록
````

## Record reading test

Apply the same principle as code review to documents. The session that wrote a document fills in missing explanations from its own memory as it reads, so it cannot find the gaps. Give only the documents to a session with no conversation history, and ask it for the information a first-time reader would look for.

1. **Choose the documents.** Give only HANDOFF.md and the part of NOTES.md above `# 자세한 기록` (the reading part). Do not give the code, the conversation history, or the detailed comparisons in the decision log.
2. **Choose the questions.** Always ask the five below, and add up to two more if there is something in this work that must get across. Do not put the answers you expect in the prompt. Write them in a temporary file outside the repository, not in NOTES.md (the reader receives NOTES.md), and delete it after the comparison.
   1. 무엇을 왜 만들었고, 지금 어디까지 왔나 (what was built and why, and how far it has come)
   2. 가장 중요한 결정 하나는 무엇이고, 왜 그렇게 했으며, 무엇을 포기했나 (the single most important decision, why, and what was given up)
   3. 성공 기준을 각각 무엇으로 확인했나 (what each success criterion was checked with)
   4. 아직 안 되는 것이나 위험한 것은 무엇인가 (what does not work yet or is risky)
   5. 이어서 작업하려면 무엇부터 하고, 어떤 명령으로 실행·테스트하나 (to continue the work, what comes first and which commands run and test it)
3. **Hand it over.** Pass the prompt below by the same methods as the code review (new terminal / approved subagent / read-only Codex) and stop.
4. **Compare.** For each question, compare the answer that came back with the answer you expected and sort it into 맞음 / 틀림 / 문서에 없음 (correct / wrong / not in the document). If it is wrong or not in the document, write that content into the document. What gets fixed is the document, not the code. When fixing, follow the fact-preservation rule in explain-as-you-go "When finishing the work". Fix the unknown terms and inconsistencies the reviewer pointed out the same way.
5. **Decide whether to test again.** If something was fixed, ask whether to test once more. Do it at most 2 times.
6. **Record it.** Leave one line in NOTES.md `## 검증 결과`: when, how many of the questions were answered correctly, and what was fixed.

```markdown
너는 이 작업에 참여하지 않은 개발자다. 아래 문서만 읽고 질문에 답한다. 코드와 다른 파일은 열지 않는다. 파일을 고치지 않는다.

## 읽을 문서
- (HANDOFF.md 경로)
- (NOTES.md 경로) — `# 자세한 기록` 앞까지만

## 질문
(질문 목록)

## 돌려줄 형식
1. 질문마다: 답 / 근거로 쓴 절 이름 / 문서에 답이 없으면 "문서에 없음"(짐작으로 채우지 않는다)
2. 설명 없이 쓰여 뜻을 몰랐던 말
3. 서로 맞지 않는 곳(숫자, 상태, 결정)
4. 이 문서가 읽는 사람이 이미 안다고 가정한 것
```

## What not to do

- The requester does not review it directly, and does not guess the reviewer's conclusion in advance and put it into the prompt.
- Do not apply review results as they are without checking them. Do not review the same range more than 3 times. Even if the conclusion is "그대로 마쳐도 됨", go through the "판단하지 않고 넘긴 것" list.
- Do not launch subagents, new sessions, or external CLIs without the user's permission.
- Do not assume uncommitted changes are included in the review range.

(This skill was newly written with reference to: from requesting-code-review in obra/superpowers (MIT), "a reviewer prompt built without the conversation history" and "the list of things passed over without judgment"; from doc-coauthoring in anthropics/skills, "a test that has a session with no conversation history read the documents"; and from doubt-driven-development in addyosmani/agent-skills (MIT), "an instruction to find defects", "the four classes of findings", "at most 3 times", and "a read-only CLI run".)
