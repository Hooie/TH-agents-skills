---
name: game-client-review
description: Review C++ game client code (especially Unreal Engine 5) before merging it. Use it to review code written by an AI or by others, to check for bugs, or to decide whether to merge; check actor and component lifecycles, GC, timer and delegate cleanup, float comparison, Tick cost, synchronous loading, replication and server authority, thread safety, and whether APIs actually exist, and recommend fixes after comparing alternatives. Use to review game client or Unreal Engine C++ code before accepting it.
license: MIT
metadata:
  author: my-agent-skills
  version: "1.4.2"
---

# Game Client Code Review

> **Output language:** write everything the user reads (replies, questions, NOTES.md, HANDOFF.md, code comments, reports) in the user's language. Keep the Korean headings, labels, fixed phrases, and examples quoted in this skill exactly as written.

Read the code, report problems with evidence, and then judge whether to merge it. Attach a code location to each finding. Mark findings without a location as "추정".

## Procedure

1. **Confirm the purpose.** Write in one sentence what this code is trying to do. If there are no requirements or spec, add it to the list of questions for the design team.
2. **Go through the checklist below in order.** Skip items that do not apply.
3. **Make a reproduction scenario for each finding.** Write the input or situation in which the problem shows up. If possible, make it into test code.
4. **Compare fixes.** For findings with several possible fixes, compare 2–3 and write the recommendation, the reason for choosing it, and the reason for rejecting each alternative. Follow explain-as-you-go "When proposing solutions" for the format. If there is only one method, write "대안 없음".
5. **Write the report and reach a conclusion.**

Use the same checklist when checking AI-written C++ diffs per task (task-breakdown execution loop). In that case, leaving only the list of findings instead of a report is fine.

## Checklist

### 1. Lifetime and memory
- Are members that point to UObjects `TObjectPtr` with `UPROPERTY()` or `TWeakObjectPtr`? Raw pointers without UPROPERTY are not tracked by GC, so they can point to freed memory once the target is destroyed.
- Is there an `IsValid()` or null check before a pointer is used? Are there arguments that can receive nullptr (such as the instigator of environmental damage)?
- Does the constructor avoid accessing the world or other actors? Constructors also run when the CDO is created. Do world-dependent initialization in `BeginPlay`.
- Are the timers, delegate bindings, and async callbacks registered in `BeginPlay` released in `EndPlay`? If a lambda captured `this`, can the object disappear first?
- Plain C++ parts: is ownership clear (`TUniquePtr`/`std::unique_ptr`), is the base class destructor virtual, and are iterators safe from invalidation by modifying a container while iterating over it?

### 2. Correctness
- Are floats not compared with `==`? If the remaining time never lands exactly on 0, the end condition stays false forever. Use `<= 0.f` or `FMath::IsNearlyEqual`.
- Is accumulated error accounted for? Subtracting 1/60 from 3.0 180 times does not give exactly 0; about 10⁻¹⁵ remains. A boundary such as "the frame where it ends exactly" comes one frame late with only a `> 0.0` comparison. Use a tolerance or integer time (ticks, microseconds), and confirm with tests that accumulate using real frame intervals.
- Are integer overflow, division by 0, and negative indices impossible?
- Is the behavior defined when the same function is called repeatedly or states overlap (reapplying, stacking, refreshing)? If the spec does not say, add it to the list of questions.
- Do calculations that depend on frame time (`DeltaTime`) avoid giving different results at different frame rates?

### 3. Performance
- Do `Tick` and frequently called functions avoid memory allocation, widget or actor creation, `LoadSynchronous`, `FindObject`-style lookups, and string building?
- Is Tick really needed? If it can be replaced with a timer or an event, suggest it. For an unneeded Tick, `PrimaryActorTick.bCanEverTick = false`.
- When talking about cost, talk in terms of the frame budget (about 16.7ms at 60fps) and measurements. If it was not measured, suggest how to measure it (`stat unit`, Unreal Insights).

### 4. Multiplayer
- Does logic that changes game results, such as damage, item grants, and score, run only under server authority (`HasAuthority()`)?
- Are the values in Server RPCs sent by the client validated?
- Are the properties to replicate registered in `GetLifetimeReplicatedProps`?

### 5. Threads
- Are UObjects never modified off the game thread? Results of background work are handed to the game thread to be applied.
- Is shared data protected with atomic operations or locks? `volatile` is not a synchronization mechanism.

### 6. Whether the API exists
- For engine functions, macros, and specifiers you have not seen before, confirm their existence and signature in the engine source or the official documentation. AIs often invent plausible fake APIs.
- If you could not confirm it, leave it in the report as "미확인".

### 7. Spec comparison

Look at this separately from code quality (1–6). The spec is the original request (README, issue, design document) plus the success criteria and the answers to the confirmation questions in NOTES.md. If there is no spec, write "스펙 없음" and skip this item.

- **Missing or incomplete requirements:** what the spec asked for but is absent from the diff or only partly there
- **Features nobody asked for:** features not in the spec, excessive defensive code, out-of-scope items. Suggest stripping them out.
- **Implemented but looks wrong:** what seems to be there but looks like it will behave differently from the spec

Quote, as is, the spec sentence that backs each finding.

## Report format

| # | 심각도 | 문제 | 근거 (파일:줄) | 재현 시나리오 | 수정안 (추천 / 버린 안과 이유) |
| --- | --- | --- | --- | --- | --- |
| 1 | 크래시 | 타이머 콜백이 파괴된 액터를 참조 | BuffComponent.cpp:42 | 버프가 걸린 채 액터 Destroy | 추천: EndPlay에서 ClearTimer — 원인(해제 누락)을 없앰 / 버림: 콜백 안 IsValid 검사 — 해제 누락이 그대로 남음 |

Sort by severity in the order 크래시, 잘못된 동작, 성능, 유지보수 (crash, wrong behavior, performance, maintainability).

Below it, write the following.
- **스펙 대조** (spec comparison): write the results of item 7 split into 빠짐/요청하지 않음/틀림 (missing / not requested / wrong), with spec quotes. Do not mix them with the code-quality findings in the table above or merge their rankings, because one side can pass while the other fails.
- **스펙 질문** (spec questions): things to confirm with the design team
- **테스트 시나리오** (test scenarios): what to run after the fix
- **결론** (conclusion): one of 반영 가능 / 수정 후 반영 / 반영 불가 (merge / merge after fixes / do not merge), with 3 lines of reasons
