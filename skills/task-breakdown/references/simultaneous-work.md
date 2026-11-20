# Simultaneous work (subagents or several terminals)

(Part of task-breakdown. Read it when there are candidates for simultaneous work or the user asks for it. Section names such as "Execution loop" and "Instruction format" refer to task-breakdown SKILL.md.)

Tasks whose method and completion criteria are settled are tasks where the human judgment is already done. Those among them that do not wait on each other can be delegated and run simultaneously. This session becomes the orchestrator: it decides with the user what to do and how, writes instructions and delegates them, checks and merges the results, verifies, and commits. **Run simultaneously only the batches the user approved.** Before approval, go one at a time.

1. **Choose a batch.** Group together only tasks that meet all the conditions below, **at most 3 per batch**. If even one condition is missing, that task goes one at a time.
   - They have no prerequisite relationship with each other.
   - The files they create or change do not overlap. Write the file list for each task.
   - The interfaces they share (function signatures, data formats) are already decided. If not, do the task that decides them first.
   - The method, completion criteria, and verification command can be settled for each task.
   - Each can be built and tested separately.
2. **Get the batch approved at once.** Gather, in one response, the method proposal from Execution loop 2 for each task in the batch (a comparison for those that need one, "알리고 진행" for the rest) and the instruction drafts. Show along with them: the time saved (estimate), the risks (conflicts when merging, bugs that appear only after merging), and the options for how to delegate — "서브에이전트" if the tool supports it, otherwise "다른 터미널", and "하나씩 진행". Add a sentence asking the user to write a one-line reason or change when choosing, and **end the response here.**
3. **Write the instructions.** For each approved task, write it so that a party that does not know this conversation can work from the instruction alone. Add the following to the "Instruction format" in SKILL.md.
   - On the first line, the skills to follow. In Codex, `$explain-as-you-go $test-driven-development`.
   - "이 지시는 이미 승인된 작업이다. 요약하고 확인을 기다리지 말고 바로 시작한다. `## 지금 상태`를 포함해 NOTES.md는 고치지 않는다." (This overrides the shared rules for a new session and for stopping.)
   - Context: the parts of `## 문제 정의` and the success criteria in NOTES.md that this task needs, the decided interfaces, the approved method and completion criteria, and the verification command
   - The list of files to create and change, and "이 목록 밖의 파일은 고치지 않는다"
   - "지시문에 없는 결정(동작 규칙, 인터페이스 변경, 범위)을 해야 하면 정하지 말고 멈추고 보고한다."
   - "테스트를 지우거나 건너뛰게 하거나 기대값을 결과에 맞춰 바꾸지 않는다." And the comment rule (write the reasons, always in Korean; no decision or task numbers)
   - "NOTES.md는 고치지 않는다. 결정과 검증 결과는 `notes/T4.md`에 NOTES.md 결정 로그와 같은 틀로 쓴다. 번호는 T4-1, T4-2…로 하고 제목에 시각을 쓴다."
   - Use a separate build output folder (for example, `build-T4`). If they share the same folder, files get locked or overwritten when building at the same time.
   - Do not commit. If several parties commit to the same repository at the same time, they conflict. Commits are made in this session after merging.
   - When done, report with the five lines from Execution loop 8 and stop. In place of the commit, write "커밋 없음(병합 뒤 이 세션이 커밋)".
4. **Delegate.** For subagents, this session launches them with the instructions. For another terminal, show the instruction as a code block and say "새 터미널에서 이 폴더로 새 세션을 열고 붙여 넣어 주세요. 끝나면 보고를 여기에 붙여 주세요". If the batch includes a task this session takes on, proceed with it as usual in the meantime. Within the batch, run only that task's own tests; the full test suite and the commit come at the merge (step 6) together with the others.
5. **Do not accept the results as they are.** When the reports come, read the diff for each task and do the checks of Execution loop 5 (all eight) and the verification of Execution loop 6 in this session. For a task that did "멈추고 보고", ask the user about that decision.
6. **Merge.** When the whole batch is done, move the entries in `notes/T*.md` into the NOTES.md decision log. Continue the D numbers in time order, and write "NOTES.md D7~D9로 옮김" at the top of each moved file. Update the task table statuses and `## 지금 상태`, then run the full build and the full test suite once, and run counterexamples where the tasks meet (using two features together, changing the order). If they pass, commit split by task. If conflicts or failures appear, find the cause with systematic-debugging.
7. **Report.** Give the five-line report for each task, report the merged result (full tests, counterexamples where the tasks meet) once more in five lines, and stop. Record in one line in the decision log what was delegated to whom (subagent / another terminal / this session) and why.

- Do not delegate requirement interpretation or design decisions. The user and this session make them.
- Use git branches or worktrees to split the work only when the user directly asks for it.
