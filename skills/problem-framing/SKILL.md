---
name: problem-framing
description: Use before writing code when you first receive work that needs multiple steps, a requirements document (spec, issue, README, etc.), a feature request, or a bug report that mixes several problems. Read the document all the way through, look at the structure of the existing code and then read the related parts, and do not decide on your own anything the document does not cover (language, environment, behavior rules, scope, external context such as the usage environment); ask the user with proposed answers backed by evidence. If the person who gave the requirements can be asked, also prepare questions to send by messenger or issue. After the answers, organize the goal, success criteria with sources, out of scope, the top-priority problem, a comparison of approach alternatives, and the division of roles in NOTES.md. Start a single algorithm problem with cpp-stress-test and a single bug of unknown cause with systematic-debugging. Use at the start of a multi-step task, requirement document or feature request, before writing code.
license: MIT
metadata:
  author: my-agent-skills
  version: "1.24.0"
---

# Problem Framing

> **Output language:** write everything the user reads (replies, questions, NOTES.md, HANDOFF.md, code comments, reports) in the user's language. Keep the Korean headings, labels, fixed phrases, and examples quoted in this skill exactly as written.

Understand the user's requirements before writing code. What to build, what counts as done, and how to solve it are decided by the user's answers. **Do not decide anything undecided on your own; ask with proposed answers backed by evidence.**

When starting, tell the user "problem-framing으로 시작합니다".

## Place in the workflow

This skill is the first step. The order is problem-framing → task-breakdown → implementation and verification per task → verification-before-completion → session-handoff, and explain-as-you-go is used alongside from start to finish.

If the user invoked this skill directly, follow the whole procedure below even if the work looks small. Only when the user did not invoke it, take another route instead of this skill in the following cases.
- A single algorithm problem → cpp-stress-test (if it is not installed, solve it directly)
- A single bug of unknown cause → systematic-debugging
- A single question, or a one- or two-line change → handle it directly

## Hard rules

- **Do not decide on your own.** Anything not in the original request is undecided. The AI does not pick what is in the "Ask" column of the explain-as-you-go table "Decisions to ask vs. decisions to announce": the language, version, build tool, test framework, folder structure of a new project, behavior rules, or scope. Instead, find evidence in the original text, build a proposed answer, and get the user's confirmation (Step 1, items 2–5).
- **The requirements document belongs to the requester.** Do not mix your notes or decisions into requirement documents written by others, such as specs, issues, or READMEs. Write run instructions, notes, and decisions in NOTES.md and HANDOFF.md. If a reason to change the document itself comes up, ask first.
- **Do not build anything before the answers arrive.** Until the user's answers come, do not create or change files and do not run commands that create a project. NOTES.md is also created only after the answers. There are two exceptions. First, building and running the existing code and tests as they are, to check the initial state, is done before the answers. Second, after sending the first round of questions, you may create NOTES.md with only `## 지금 상태`, `## 문제 정의` (a draft, with "미확인" on unknown lines), and `## 확인 질문과 답`, so that the questions sent, the answers received, and what is still unknown survive compaction while the questions go back and forth.
- **Use the environment only to build options.** Reading the folder contents or the installed tools is fine. But do not decide from the result; show it as options, such as "설치된 것: .NET 9, MSVC 19.44. 어느 것으로 할까요?".
- **Do not decide on your own to "skip it because it is small".** To skip any of the confirmation questions, the approach comparison, or task-breakdown, ask the user first.
- Proceed on assumptions only when the user says so directly, such as "알아서 정해" or "가정하고 진행해". Even then, write "가정(사용자가 위임)" in NOTES.md for each assumption.

## Procedure

### Step 0: Check the shared rules

This skill was written assuming the shared working rules (comparing alternatives, asking before starting, facts and evidence, stopping and waiting). If the instructions this session received (AGENTS.md, CLAUDE.md, etc.) already contain a "Working rules (my-agent-skills)" section (or the older "작업 규칙 (my-agent-skills)"), skip this step. If not, read `references/rules.md` in this skill folder all the way through and follow those rules until this work is finished. This is so that the same rules apply even in an environment where only the skills are installed and there is no global instruction file. If you read it, leave one line in the first response: "공통 규칙: references/rules.md를 읽음".

### Step 1: Ask, then stop

1. **Read the requirements document all the way through and restate the goal.** If the requirements were given as a document (spec, issue, README in the work folder, etc.), find that document first and read it from beginning to end. Also read the files it points to (example input, existing code, other documents). Then summarize the original request (document, issue, spec) in 2–3 sentences. Do not add anything that is not in the original.
   - **If the existing code is large, look at the structure first.** First count the total lines of the source files (in a git repository, bash `git ls-files '*.cpp' '*.h' '*.py' | xargs wc -l | tail -1`, PowerShell `(git ls-files *.cpp *.h *.py | Get-Content | Measure-Object -Line).Lines`; if it is not git, count without generated or external folders such as `Intermediate`, `Binaries`, and third-party code).
     - If it is 2,500 lines or fewer, read all of it.
     - If it is more, look at the folder structure, entry points (main, game mode, app startup), test locations, and build settings, then search for names that appear in the requirements (features, classes, screens) to pick the related files, and read those first, within 2,500 lines in total. Read the rest when it becomes needed.
     - Record the counted line total, the chosen files, and the search commands as "읽은 범위" (range read).
   - **If data files are provided** (CSV, JSON, logs, tables), profile them with a short script in a temporary folder before asking questions: row and column counts, empty values, duplicates, values outside the expected range, and values that disagree between files. Turn each anomaly into a question for the user or the requester (for example, "주문 3건의 수량이 음수인데, 취소 건인가요?"), because hidden rules often show up as odd data.
   - If the tool supports subagents, you may offer, as an option, delegating exploration to a subagent and receiving only the list of related files and a summary. Anything from the summary that a decision relies on is checked directly by this session in the original files.
   - Find what can be read from the original text in the original, and ask the user about information that is needed but missing or ambiguous in it. The user may separately know information outside the document (notes passed on, constraints, environment, intent).
   - Give notes the user passes on the same weight as the original text, and prefer them over estimates. In NOTES.md, record their source as "사용자 전달".
   - **If there is existing code and tests, build it and run the tests as they are before changing anything, to check the initial state.** Write the pass/fail counts, warnings, and the commands run above the questions as "처음 상태" (initial state). This is a fact check, so do it without asking. Do not create or change any files other than build outputs. If you could not run it, write "미확인 — 이유".
2. **Find everything that is undecided.** Read the original line by line and note what cannot be answered from the original alone. Also find things that are not written in the original but must be decided to implement it. Check every one of the following groups.
   - Environment: language and version, build tool, test framework, folder structure, runtime environment, version control (whether a git repository already exists, and if not, whether to create one)
   - Behavior rules: boundary values (exactly 0, the maximum), when the same action repeats, when two features apply at once or their order changes (for example, does a shield also block poison damage), invalid input
   - External context: who uses it and in what situation, where it runs (platform, device, frame rate), data size and call frequency, other systems that work alongside it, what is likely to change or grow later, the impact of a failure
   - Deliverable: what is built and handed over, what counts as done, numeric performance targets
   - Scope: what is not done this time
3. **Separate facts from decisions.** Things that can be found by looking (installed tools, folder structure, behavior of existing code) are **facts**. The agent checks facts directly without asking the user, and records how they were checked. Ask the user only about **decisions** (what to use, how it should behave).
   - **Separate out what to ask the requester.** Some things only the person who gave the requirements (planner, lead, the colleague who asked) can answer: how they work now, what is inconvenient, what they will look at to judge it done, hidden constraints. If you do not know whether there is a way to ask the requester (messenger, issue comments, etc.), ask the user in the first round. If there is no way to ask, skip this split and ask the user everything as proposed answers.
   - Do not conclude "없음" (not present) for a tool that was not found on the command path (PATH). Check the standard install locations too. For example, on Windows look for Visual Studio and MSVC with `vswhere.exe`, and look for CMake inside the Visual Studio install folder. If you could not confirm it after all, write "미확인" and do not base a recommendation on it.
   - For options that require downloading external packages (NuGet, pip, vcpkg, etc.), first check whether downloading works. Check in a way that creates no files (such as connecting to the package server address), and if you could not check, write in the option "미확인 — 다운로드가 막혀 있으면 이 안은 실패한다" (unconfirmed — this option fails if downloads are blocked).
4. **Choose this round's questions.** Put in this round only the decisions that can be answered right now without knowing the answers to other questions. Defer questions whose content changes depending on another answer to the next round. For example, do not ask about the test framework before the language is decided.
   - Choose only questions whose answer changes the decision. For each question you must be able to write one line on "what changes depending on this answer"; drop any question for which you cannot write that line. There is no fixed number of questions. If a lot of information is missing, there will be many questions; if little is missing, few.
   - **Announce instead of asking when the answer is already settled.** This applies when the existing code, the environment, or the requirements document points to one option (for example, the existing code is Python); when these rules or the skills already decide it (for example, requirement documents are not edited); or when the choice is to not add features or future-proofing that the requirements do not ask for. Write these as one-line "알리고 진행: ..." items below the questions so that the user can overturn them. Ask only about behavior rules, success criteria, scope, hard-to-reverse structure, and interpretations of the requirements (explain-as-you-go "Decisions to ask vs. decisions to announce").
5. **Send the questions.** Attach to each question a number, a recommendation, the evidence, 1–2 other possible answers, and one line on what changes depending on the answer. Write the questions so that answering just "예" (yes) accepts the recommendation. Send all of this round's questions at once. **End the response here.**
   - At the end of the first round of questions, add "문서 밖에서 알려 주실 내용(전달사항, 제약, 환경)이 있으면 함께 적어 주세요".
   - If the requester can be asked, group the requester questions separately as sentences the user can paste directly into a messenger or an issue comment. When the user relays the requester's answer, record its source as "요청자 답".
   - **Ask the requester one or two questions at a time, from small context to depth.** Requesters often do not state all the requirements at once, and each good question tends to uncover one more requirement. Follow this order, and dig into each answer once more ("왜 그런가요?", "그럼 이런 경우는요?") before moving on:
     1. A recent concrete case: when and in what situation this happens
     2. How they handle it now, and the workaround or know-how they use. Ask whether they can send what they use now (a sheet, a screenshot, a log, an example input with the expected result); real material is the cheapest way to find unstated rules.
     3. Numbers: what number tells them it went well, its current value, and where it is measured
     4. Who is affected, and what it costs them when it goes wrong
     5. Exceptions and boundaries: unusual cases, limits (budget, count, time), things that must never change, and, if there is a set working time, what matters most if not everything fits
     6. Operation: who maintains it, and what changes often
     Start with questions that seem trivial. Build the next question from new facts in the last answer (for example, "매주 엑셀로 따로 정리하신다고 하셨는데, 그 표에는 어떤 항목이 들어가나요?"). Ask about completion criteria and things not to do after the context has been gathered.
   - Do not ask the requester for a solution or a to-do list. Do not write questions such as "무엇을 만들면 되나요?" or "할 일을 순서대로 알려 주세요". Ask the requester about situations and criteria, and decide what to build and how with the user, based on those answers.
   - If the requester's answer is short or covers only part, do not treat it as a failure. Record the answer received in `## 확인 질문과 답`, and turn what is still unknown into the next round's questions. Each round, show one line each for "이번 답으로 알게 된 것 / 아직 모르는 것".
   - **When the requester's answers stall,** try in this order: ask what they can answer ("어떤 부분을 알려 주실 수 있을까요?"), offer a closed question with 2–3 options, then confirm an interpretation ("그럼 X로 이해해도 될까요?"). If there is still no answer, write an estimate marked "추정 — 요청자 답 없음", show it to the user, and hold only the parts that depend on it.
   - The recommendation is a proposed answer built from evidence found in the original. Write the evidence as a quote from the original (for example, "요구사항 문서 12행: 매 프레임 호출된다"), and if the original has no evidence, write "원문에 없음 — (일반적인 경우나 비슷한 시스템 기준)". Say so when an estimate rests on weak evidence.
   - Put only one decision in each question. Do not bundle several decisions into one question, such as "0과 음수는 무시하고, 미등록 스킬은 예외로 할까요?". If they are bundled, a one-word "추천안" (recommendation) answer lets some of the decisions pass without being decided.
   - If the recommendation differs from the original request or reads it broadly, say so. For example: "원문은 '콘솔 프로젝트 하나에 테스트까지'인데, 별도 테스트 프로젝트를 추천합니다. 이유: ...".
6. **Repeat for the next round.** When answers come, ask the questions that have now become askable in the next round, in the same way. Repeat until no undecided decision remains.
   - If an answer covered only part of a question (for example, the user answered only "추천안" but the question contained an item they were asked to decide separately), ask the remaining decision again in the next round.
   - Keep the six-step order for requester questions. Use the "미확인" lines in `## 문제 정의` only to find what the order has not reached yet, not to choose what to ask first.
   - Before moving on to Step 2, confirm that no undecided decision remains. If even one remains, do not say "결정이 끝났다" (the decisions are done).
   - If there is a set working time, aim to finish the questions before 25% of the total time has passed. If it looks like it will go over, show the remaining questions in order of importance and ask the user whether to keep asking.

```text
problem-framing으로 시작합니다. 요구사항 문서를 끝까지 읽었습니다. 이번 차례에 정할 것이 3가지 있습니다.
(확인한 사실: MSVC 19.44 설치 — PATH에는 없고 vswhere.exe로 확인)

Q1. C++ 표준을 C++17로 할까요?
    근거: 요구사항 문서 3행 "C++로 구현" / 버전은 원문에 없음 — 설치된 MSVC 19.44가 C++17을 지원
    다른 안: C++20 → 쓸 수 있는 기능이 늘지만 원문에서 필요한 기능이 없습니다.
    추천: 예 (C++17)
Q2. 쿨다운이 정확히 끝나는 프레임(남은 시간 0)에 바로 다시 쓸 수 있게 할까요?
    근거: 원문에 없음 — 대부분의 게임은 끝나는 프레임에 바로 쓸 수 있게 합니다.
    다른 안: 다음 프레임부터 → TryUse의 비교 조건이 달라집니다.
    추천: 예
Q3. 캐릭터 하나가 가진 스킬을 많아야 수십 개로 보고 설계할까요?
    근거: 요구사항 문서 5행 "캐릭터마다 스킬 몇 개" — 규모가 작다는 추정(근거 약함)
    다른 안: 수천 개 → 조회 구조와 성능 테스트가 달라집니다.
    추천: 예

테스트 프레임워크는 Q1이 정해진 뒤 다음 차례에 묻겠습니다.
문서 밖에서 알려 주실 내용(전달사항, 제약, 환경)이 있으면 함께 적어 주세요.

요청하신 분께 물을 수 있다면 아래를 메신저나 이슈에 그대로 붙여 보내 보세요. 물을 곳이 없으면 알려 주세요. 제가 추정안으로 다시 묻겠습니다.
A1. 지금은 스킬을 다시 쓸 수 있는지 어디에서, 어떤 순서로 확인하고 계신가요?
A2. 그 과정에서 가장 불편하거나 자주 틀리는 부분은 무엇인가요?
(완료 판단 기준은 이 답을 받은 뒤 다음 차례에 묻겠습니다.)
```

### Step 2: After the answers, organize and stop

7. **Record the answers.** Write the questions and answers as they are in NOTES.md. If an answer creates a new question, ask it in the next round as in item 6. If the answer has to be interpreted to settle the scope (for example, "잘못된 입력은 0으로" → only negative numbers, or NaN and infinity too?), do not apply your interpretation as is; confirm it with "이렇게 이해했는데 맞나요?".
   - Do the same confirmation for ambiguous sentences in the requirements document and for the requester's answers. If they can be read in two or more ways, show the possible interpretations side by side and ask again. Do not write success criteria or a plan on any interpretation before it is confirmed.
   - Attach a source to the facts and decisions you record: 요구사항 / 사용자 답 / 요청자 답 / 직접 확인(명령) / 승인된 추정. Content filled in from general knowledge or estimation is not put in the success criteria or the plan until the user approves it.
   - Write the questions and answers in `## 확인 질문과 답` with their evidence. Record every answer that shows up in the code (behavior rules, design, scope) as one line in `## 결정 한눈에 보기` with the status "질문 답", and leave only the number, like "→ D2", in `## 확인 질문과 답`. Write a detailed D entry only when alternatives with real trade-offs were compared (such as the approach comparison), when the user chose against the recommendation or gave a reason that changes the design, or when the answer is changed later. A simple rule accepted as "추천안대로" does not get a detailed entry. Simple choices such as language or tools are written only in `## 확인 질문과 답`.
   - Decision log entries use the template (### D번호) in the NOTES.md format below. Follow explain-as-you-go "How to write the decision log" for how to write them. Do not write the same decision twice.
8. **For products with screens, decide the users and core flows first.** If the deliverable is a product people use through screens (web service, tool, app, game UI), decide the three things in "What to decide for products with screens" below before the success criteria, and write them in NOTES.md `## 사용자와 핵심 흐름`. For work with no screen flow, such as logic, algorithms, or engine-internal systems, skip this and write only "해당 없음 — 이유". If it is unclear whether it applies, ask the user.
9. **Set the success criteria.** Write them in a checkable form: tests that must pass, numeric targets (ms, fps, memory, input size), symptoms that must not reproduce. Do not write criteria such as "잘 동작한다" (works well). Attach a source to each criterion: (요구사항 문서 7행), (사용자 전달), (요청자 답), (사용자 답 — 29번째 프레임에는 안 써진다), (추정 — 사용자 확인). For numeric criteria, also write the current value and where it is measured (for example, "두 번째 열기 35ms → 10ms 이하, `stat unit` 3회 평균").
   - **Turn "never" and "always" into criteria.** When the requester or the user says something must never or always happen, write it as its own success criterion with its source. Under it, list three or more inputs that could break it, taken from the real data and from how that data is produced (blank lines, missing columns, empty or non-number values, every row invalid). For each input, write what should happen: 결과가 나온다 / 그 줄만 빼고 알린다 / 멈추고 오류를 낸다. If which one is unclear, ask. These inputs become test cases in task-breakdown.
     예: "설정 파일에 잘못된 줄이 있어도 게임이 켜진다 (요청자 답 — 안 켜지는 건 절대 안 돼요). 깨뜨릴 입력: 중간 빈 줄 → 빼고 알림 / 칸이 모자란 줄 → 빼고 알림 / 값이 숫자가 아님 → 빼고 알림"
   - If the requester can be asked, check the criteria with them before building. First, for rules or criteria that the AI or the user set (thresholds, the decision method such as exact versus approximate, parameters), write 2–3 options as a question the requester can pick from. Then send the `## 문제 정의` block in NOTES.md as the agreement message, as it is; do not write a separate message. Record the requester's reply, quoted, on its "요청자 확인" line, and fix the lines the reply corrects.
10. **Write what will not be built.** Based on the scope the user answered, fill in the "만들지 않을 것" line of `## 문제 정의`.
11. **Pick the core problem.** Make the problem with the biggest impact on the success criteria the top priority, and write the reason in one line.
12. **Compare approaches.** Compare 2–3 ways to solve the top-priority problem on success criteria, risk, and time required, and write the recommendation, the reason for choosing it, and the reason for rejecting each alternative. Follow explain-as-you-go "When proposing solutions" for the format. If there is only one reasonable approach, write "대안 없음 — 이유". When the user chooses, write this comparison as a D entry in the decision log.
13. **Write the plan and roles.** Keep the plan within 5 lines, with a check method for each step. Separate the work given to the AI from the judgments the user makes.
14. **Create NOTES.md.** Create it at the root of the work folder in the format below.
15. **Check, then get confirmation.** Before showing the results, check NOTES.md against this list and fill in what is missing. Do not show the list; show only what you filled in, one line each.
   - Requester questions covered all six steps of the order, including operation (who maintains it, what changes often). If a step was skipped, do not add more requester questions to this response: put it first in the next round, or, if there is no time for another round, write it under `## 남은 위험` as not asked.
   - Every numeric criterion has the current value, the target, and where it is measured.
   - The "만들지 않을 것" line of `## 문제 정의` names what will not be built this time, including what the requester said is for later.
   - Every line of `## 문제 정의` has a source or "미확인", and each 원인 line says 확인됨, 가설, or 미확인. Do not fill a line with a guess to make it look complete.
   - Send `## 문제 정의` as the agreement message only after the six-step order is done. A block with every line filled does not mean the questions are finished.
   - Every "never/always" statement is a success criterion with the inputs that could break it.
   - Detailed D entries exist only for the cases in item 7. Everything else is one line with the status "질문 답".

   Then show `## 문제 정의`, the success criteria, the top-priority problem, and the approach comparison, and ask what to change and which approach to take. **End the response here.**

### Step 3: Point to the next step and stop

16. Reflect the answers in NOTES.md and present the next step as two options.
   - Continue in this session: "다음은 task-breakdown입니다(Claude Code `/task-breakdown`, Codex `$task-breakdown`)". The conversation with the questions and answers is still there, so the flow does not need to be explained again. Choose this one also when the conversation record needs to be kept together in one session.
   - Start in a new session: NOTES.md is complete, so open a new session and invoke task-breakdown. The questions and answers do not take up context, so compaction comes later during implementation. In exchange, anything not in NOTES.md does not carry over. When showing this option, check that the notes the user passed on and the reasons they gave for their choices are all in NOTES.md, and show anything missing alongside.

   You may suggest skipping task-breakdown, but do not skip it until the user agrees. **End the response here.** Do not start the next skill on your own.

## NOTES.md format

NOTES.md is split into two parts. The front part, "읽는 부분" (the reading part), is where the user reads first to grasp the whole picture, so keep it short (about two pages). The back part, "자세한 기록" (detailed record), is for looking things up when needed. Write each fact in only one place, and refer to it elsewhere by number (D2, T3, Q4) (explain-as-you-go "How to write records people read", item 10).

```markdown
# NOTES

## 문제 정의
(Fill this in as a draft once NOTES.md exists. Write "미확인" on lines not yet known. When the six-step order of requester questions is done, this block is sent as the agreement message as it is.)
- 문제: (who, when, what goes wrong — source)
- 원인: (one line per cause — there can be several. Each anomaly found in the data or code is its own line. For new builds, write "지금 방식의 불편" instead)
  - 확인됨 — … (command or evidence) / 가설 — … / 미확인
- 성공 기준: (core metric) — 지금 값 … / 목표 … / 재는 곳 … (the full list is in `## 성공 기준`)
- 만들 것: …
- 만들지 않을 것: … (include what the requester said is for later)
- 제약: (things that must never happen, things that must not change, time — source)
- 앞으로 바뀔 것: (who maintains it, what changes and when — source / 미확인). Decide for each whether it goes into 만들 것 or 만들지 않을 것.
- 요청자 확인: "(reply quoted)" (time) / 아직 안 보냄 / 요청자 없음

예 (문제 해결형):
- 문제: 120칸 인벤토리를 두 번째 열 때 화면이 잠깐 멈춘다 (요청자 답 — QA 보고)
- 원인:
  - 확인됨 — 열 때마다 슬롯 위젯을 120개 새로 만든다 (Unreal Insights, CreateWidget 120회)
  - 가설 — 아이콘 텍스처를 매번 동기 로드한다 (확인 전)
- 성공 기준: 두 번째 열기 시간 — 지금 값 35ms / 목표 10ms 이하 / 재는 곳 `stat unit` 3회 평균
- 만들 것: 슬롯 위젯을 풀에서 다시 쓰기
- 만들지 않을 것: 레이아웃 재작성, 1,000칸 대응 (요청자 — 다음 분기)
- 제약: 슬롯 배치와 드래그 동작은 바뀌면 안 된다 (요청자 답)
- 앞으로 바뀔 것: 다음 분기에 칸 수 확장 (요청자 답) → 만들지 않을 것
- 요청자 확인: "네, 맞아요" (14:10)

예 (새로 만들기형, 질문 중인 초안):
- 문제: 기획자가 몬스터 스탯 표를 바꿀 때마다 개발자에게 반영을 부탁한다 (요청자 답)
- 지금 방식의 불편: 반영까지 하루가 걸리고, 옮겨 적다 틀린다 (요청자 답)
- 성공 기준: 미확인
- 만들 것: 미확인
- 만들지 않을 것: 미확인
- 제약: 기존 세이브 파일은 그대로 읽혀야 한다 (요청자 답 — "절대 깨지면 안 돼요")
- 앞으로 바뀔 것: 미확인
- 요청자 확인: 아직 안 보냄

## 지금 상태
(Update this whenever a task is finished and whenever you stop after sending questions. If the conversation is compacted, read from here and continue.)
- 진행 중: T3 — 방법 승인 대기 / 구현 중 / 검증 중 / 없음
- 다음 할 일: (one line)
- 마지막 커밋과 테스트: a1b2c3d, 전체 테스트 16건 통과 (22:26)
- 답을 기다리는 질문: 없음 / Q5 (one-line summary)
- 막힌 것: 없음 / (one line)
- 시간: 경과 1:10 / 남은 1:50 / 다음 체크포인트 75% 15:30 (`date`로 확인한 시각 14:20) — if no working time was set, "정하지 않음"

## 지금까지의 흐름
(Chronological, 5–10 sentences; never more than 10. Initial problem → what was learned by asking → chosen approach and reason → what changed and why → current state and what remains. Update it whenever a task ends. For how to write it, see explain-as-you-go "How to write records people read".)

## 성공 기준
- [ ] ... (출처: 요구사항 문서 7행)
(At wrap-up, attach the "성공 기준 대조표" below this. The format is in task-breakdown "Wrapping up", step 3.)

## 결정 한눈에 보기
| 번호 | 정한 것 | 이유 | 포기한 것 | 확신 | 상태 |
| --- | --- | --- | --- | --- | --- |
| D1 | ... | ... | ... | 높음 / 중간 / 낮음 | 유효 / 바뀜 → Dn / 질문 답 / 알림 / 버그 |

## 남은 위험
- (weakness) → (impact if it happens: who is affected, how) → (how to check or respond)

---

# 자세한 기록

## 확인 질문과 답
- 사용자 전달: (information received outside the document. If none, "없음")
- 요청자 답: (answers obtained by asking the requester, and the confirmed summary. If there was nobody to ask, "없음")
- 처음 상태: (if there was existing code, the build and test results and commands from before changing it. Initial numbers are written only here)
- Q1. 언어 → C++17 (사용자, 추천과 같음) — 근거: 요구사항 문서 3행
- Q2. 쿨다운 0인 프레임에 바로 사용 → 예 (사용자) → D2

## 사용자와 핵심 흐름
(Only for products with screens. Otherwise "해당 없음 — 이유")
- 사용자와 상황: ... (source)
- 핵심 흐름 1: (start screen) → ... → (end, what the user gets) (source)
- 꼭 필요한 화면과 기능: ...
- 이번에 만들지 않을 것: ...

## 우선순위
1. (core problem) — 이유: ...

## 접근 방식
(One line. For example: "현재 목표를 유지하고 잃었을 때만 한 번 훑는다 — 비교와 이유는 D8". Keep the comparison table of alternatives only in the decision log.)

## 계획
1. ... → 확인: ...

## 작업 목록
(filled in by task-breakdown)

## 역할 분담
- AI: ...
- 직접: ...

## 결정 로그
(Write in detail only decisions where alternatives were compared, decisions where the user chose against the recommendation or gave a reason that changes the design, rules set by the requester's answers, bugs fixed, and decisions that changed. Answers accepted as recommended and decisions that were announced and carried out end with their one line in "결정 한눈에 보기". Approving a plan or a task list is not a decision. Number them D1, D2… in the order decided. For how to write them, see explain-as-you-go "How to write the decision log".)

### D1. (what was set to what, in one line) — (접근 방식 / T1, etc.), (HH:MM)
- 요약: (one sentence: what was decided, one key reason, one thing given up. Make it explainable from this line alone)
- 상황: (why it had to be decided. Quote the original if there is evidence in it)
- 검토한 안: A ... / B ... (or "대안 없음 — 이유")
- 고른 이유: (if the user wrote a reason, their words first, then the AI's evidence. Include the benefit this option gives)
- 트레이드오프: (what was given up, written as weakness → impact if it happens → how to check or respond)
- 버린 안: (one line per option — why it was rejected / under what conditions that option would be better)
- 확신도: 높음 / 중간 / 낮음 — (one line on why you see it that way). If 중간 or 낮음: (what, once checked, would raise it)
- 코드 위치: (file and function. Before implementation, "구현 전")
- 정한 사람: 사용자 — (summary of the reason the user wrote) (AI 추천 A) / 사용자 (추천과 같음) / AI (사용자가 위임)
- 검증: ...

## 검증 결과
(For each task, write in sentences "what you meant to check → what you did → the result → what that tells you". Before/after measurement numbers go in the "검증" line of the relevant decision; refer to them here by number.)
- 테스트 명령: (write it once; below, call it "전체 테스트")
```

## What to decide for products with screens

If you start from a feature list, it is easy to end up with many screens that do not connect from start to finish. Decide the flow of the people who use it first, and build only what that flow needs.

1. **Users and situation.** Who uses it, when, and for what purpose. Write the real situation found in the original and the requester's answers (for example, "매장 직원이 손님 응대 중 짧게 재고를 확인한다"). If it is not in the original, ask the requester or the user. Do not fill it in with estimates.
2. **1–2 core flows.** Write, in order, the steps users go through from the first screen to achieving their goal. For example: "상품 검색 → 상세 보기 → 장바구니 담기 → 주문 확인". If there are several flows, make the one most important to the user the top priority.
3. **Screens and features truly needed, and what not to build.** Pick only the screens and features needed to follow the core flow to the end. Features not in the flow (login, settings, statistics screens, etc.) go under "이번에 만들지 않을 것" unless the original or the requester asked for them.

- If the requester can be asked, ask in a way that fills in these three things. For example: "이 서비스를 쓰는 분은 보통 어떤 상황에서 여시나요?", "그분이 가장 먼저 하고 싶은 일은 무엇인가요?"
- Put the core flow in the success criteria. For example: "처음 온 사용자가 안내 없이 검색부터 주문 확인까지 끝낼 수 있다(핵심 흐름 1)".
- Arrange the plan and task order so that core flow 1 works from start to finish first. Do not perfect one screen before moving on to the next. Polish after the whole flow is connected, even roughly.

## What to always ask for game client work

- Target platform and baseline frame rate. At 60fps the frame budget is about 16.7ms; at 30fps, about 33.3ms.
- Engine and version. For Unreal, which 5.x version, and whether the work is done in Blueprint or C++.
- Single-player or multiplayer. If multiplayer, which logic is server-authoritative.
- Reproduction conditions. Device, map, data size, whether it is the first run or a repeated run.

## What not to do

- Do not create implementation code, project files, or NOTES.md before receiving the user's answers (except the NOTES.md with only `## 지금 상태`, the `## 문제 정의` draft, and `## 확인 질문과 답` allowed in the hard rules).
- Do not decide the language or structure from installed tools or folder state.
- Do not edit or overwrite requirement documents written by others without asking.
- Do not recommend based only on "보통 이렇다" (it is usually like this) without evidence. If there is no evidence in the original, say there is none.
- Do not rewrite the success criteria set here to fit later results. If they must change, get the user's approval and record the original wording and the reason in the decision log.
