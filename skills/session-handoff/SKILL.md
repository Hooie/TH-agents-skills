---
name: session-handoff
description: Use when the user invokes it to hand off unfinished or finished work: before moving to a new session mid-task, before pausing the work for a long time, or before handing the work to another person. Organize the current state, the work done and remaining, how to run and verify, the key decisions, and the remaining risks in HANDOFF.md so that another person or a new session can pick it up right away, and check that the run instructions actually work. Do not mix your notes into requirement documents written by others. When starting a new session, read HANDOFF.md first.
license: MIT
metadata:
  author: my-agent-skills
  version: "1.14.0"
---

# Session Handoff

> **Output language:** write everything the user reads (replies, questions, NOTES.md, HANDOFF.md, code comments, reports) in the user's language. Keep the Korean headings, labels, fixed phrases, and examples quoted in this skill exactly as written.

Make it so that even when the session changes or the work passes to someone else, nothing has to be explained again from the beginning. When getting a review, make it possible for the reviewer to understand the deliverable and the process in one go.

## When to use

Only when the user invokes it (`$session-handoff`, `/session-handoff`):
- Right before moving to a new session mid-task because the context has grown long (a new session right after the task list is approved needs only NOTES.md)
- When pausing the work or handing it over to another person or another agent
- When handing over the finished deliverable
- When starting a new session (in this case, do only "When taking over" below)

## When handing off

1. **Bring NOTES.md up to date.** Check that the task list statuses, the decision log, and the verification results match the actual code. If the work is finished and `## 검증 결과` has no record of rechecking all the success criteria, do verification-before-completion first. If handing off mid-task, do not recheck everything; record the time of the last verification and the criteria not yet met.
   - Read the decision log in order from the beginning. Check that the order of the decisions and the numbers match and that each entry has a reason, benefits, trade-offs, and a code location, and fill in the gaps.
2. **Recheck the run instructions.** Run the install, run, and test commands that will go into HANDOFF.md `## 실행과 검증` exactly as written, as someone seeing them for the first time. If they fail, fix the commands or the code.
   - Do not mix your notes into requirement documents written by others. Write the run instructions in HANDOFF.md. If there is a reason to change the document, ask the user first.
   - If the requirements document specifies the format of the deliverable (file names, locations, how to run it, output format), check again that it matches exactly.
3. **Write HANDOFF.md.** Create it at the root of the work folder in the format below. If it already exists, do not write it again from scratch; update `## 요약`, `## 작업 흐름`, `## 실행과 검증`, `## 끝난 일`, `## 남은 일`, and `## 남은 위험과 알려진 문제` to the current state, and keep the rest unless it changed.
   - Write it so that someone seeing it for the first time understands what was done and why from HANDOFF.md alone. Follow explain-as-you-go "How to write records people read": complete sentences, internal jargon spelled out, content alongside numbers, concrete values.
   - Do not copy content that lives elsewhere wholesale; write the gist in one or two sentences and add the location. Do not end with only "NOTES.md 참고". Keep the detailed alternatives comparisons and the verification process only in NOTES.md.
   - Do not write API keys, passwords, tokens, or personal data. If they appear in commands or output, replace them with `<REDACTED>`.
   - When done, ask whether to take the record reading test (independent-review). Skip it if the user does not want it.
4. **Commit last.** If there is a git repository, commit including NOTES.md and HANDOFF.md, and check with `git status` that no changes remain. Do not push. If there is no repository, skip this step. When handing off mid-task, do not commit unverified code: commit only NOTES.md and HANDOFF.md, and list the uncommitted files and their state in HANDOFF.md `## 남은 일`.

## HANDOFF.md format

```markdown
# HANDOFF

## 요약
(3–5 sentences. What was built and why, which problem was solved and how, how far it has come now. Write it so that someone who does not know the work can understand it.)

## 작업 흐름
(Polish NOTES.md `## 지금까지의 흐름` into its final state and move it here. In chronological order; for changed decisions, the before, the after, and the reason together.)

## 실행과 검증
- 설치: `...`
- 실행: `...`
- 테스트: `...` → 마지막 결과: 통과 12 / 실패 0 (time)

## 끝난 일
- T1 (what was changed, and so what changed for the user) — 검증: (what was run and what result was seen)
  예: T3 소진 잠금 — 한 번 바닥나면 20까지 회복해야 다시 달릴 수 있게 했다. 0까지 쓴 뒤 19.99에서는 못 달리고 20에서 달리는 것을 테스트로 확인했다.

## 남은 일 (우선순위순)
1. T5 ... — 다음에 할 첫 단계: ...

## 주요 결정
- D2 (what was set to what) — 이유: (one sentence) / 포기한 것: (one sentence) / 버린 안: (what, and why) — 자세한 비교: NOTES.md D2

## 직접 정하고 바꾼 것
(From the decision log and the conversation, one line each: options the user chose against the AI's recommendation, instructions the user edited, over-engineering the user rejected, and review findings that were not accepted. Write what the AI proposed, what the user decided instead, and the user's reason.)
- D5 — AI 추천: … / 사용자: … / 이유: (사용자의 말)

## 남은 위험과 알려진 문제
- (weakness) → (impact if it happens) → (how to check or respond; how to reproduce, if known)

## 이어받는 사람에게
- 먼저 읽을 파일: NOTES.md, ...
- 건드리지 말 것: ...

## 다음 세션에 쓸 스킬
- (예) T5를 이어서 하려면 $task-breakdown, 넘기기 전에는 $session-handoff
```

## Final check before handing off

- For each success criterion, whether it was met and the evidence (test results, measurements, screens) are written in NOTES.md.
- Criteria that were not met are not hidden; the reasons and the remaining work are written down.
- The wording of the success criteria is the same as the original set in problem-framing. If it changed, the user's approval and the reason are in the decision log.
- For each key decision, the summary, the options considered, the reason for the choice, the rejected options and why, and the confidence are in the decision log.
- The run instructions in HANDOFF.md were just run directly, and the full test suite passed. When handing off mid-task, write the last test result and the failing tests instead.
- If there is a git repository, there are no uncommitted changes (mid-task: except the files listed in `## 남은 일`). Nothing was pushed.
- No secret keys or personal data are in the code, records, or commits.
- The requirements documents were not changed without asking. The deliverable format is as the documents specify.
- Reading the task list and the decision log in NOTES.md in order shows the flow of the work and the trade-offs of each decision.
- HANDOFF.md was read from the beginning as someone who does not know the work. There are no unexplained terms, no places with only a number and no content, and no places that end with only "참고".

## When taking over

As the first step of a new session, read HANDOFF.md and NOTES.md, summarize your understanding of the current state and the next task in 3 lines, get the user's confirmation, and then start. If the documents and the code differ, go by the code and record the difference.
