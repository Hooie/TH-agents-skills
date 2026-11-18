---
name: cpp-stress-test
description: Use when solving C++ algorithm problems (online judges, competitive programming): first set the required time complexity from the constraints, and before submitting, verify the solution against a brute-force solution with random inputs. Use for algorithm problems, when you are not sure an answer is correct, to find counterexamples, and to check for time limit exceeded. Use for C++ algorithm and competitive programming problems to pick a complexity from the constraints and stress-test against brute force before submitting.
license: MIT
metadata:
  author: my-agent-skills
  version: "1.1.1"
---

# C++ Stress Test

> **Output language:** write everything the user reads (replies, questions, NOTES.md, HANDOFF.md, code comments, reports) in the user's language. Keep the Korean headings, labels, fixed phrases, and examples quoted in this skill exactly as written.

Passing the sample input does not make an answer correct. Set the complexity from the constraints, solve it, and before submitting, compare it against a slow but certain solution on hundreds of random inputs.

Do not apply test-driven-development to solving algorithm problems. The sample inputs and the brute-force comparison serve as the tests. For code style, follow the rules of cp-skills-cpp if it is installed.

## 1. Set the complexity from the constraints

For C++, assume about 10⁸ simple operations in 1 second.

| Max N | Allowed complexity | Common approaches |
| --- | --- | --- |
| 10 | O(N!) | Exhaustive search over permutations |
| 20 | O(2ᴺ · N) | Bitmasks, subsets |
| 500 | O(N³) | Floyd, 3-level nested DP |
| 5,000 | O(N²) | 2-level nested DP, all pairs |
| 10⁶ | O(N log N) | Sorting, binary search, heaps, segment trees |
| 10⁸ | O(N) | Two pointers, prefix sums, a single pass |
| 10¹⁸ | O(log N) | Math, binary search, exponentiation by divide and conquer |

Before writing the solution, compare 2–3 candidate solutions against the constraints and show them to the user. Write the reason for the chosen solution and the reason for rejecting each of the others.

```text
N ≤ 2×10⁵ 이므로 O(N log N) 이하가 필요하다.
- A 모든 쌍 비교 O(N²) = 4×10¹⁰ → 버림: 시간 초과. 대신 3단계의 brute.cpp로 쓴다.
- B 정렬 + 투 포인터 O(N log N) → 채택: 구현이 짧고 경계 조건이 적다.
- C 세그먼트 트리 O(N log N) → 버림: 복잡도는 같은데 구현이 길어 실수할 곳이 많다.
```

If it is close to a boundary, calculate the number of operations directly. For example: with N = 5,000, O(N²) = 2.5×10⁷, which fits within 1 second. The target complexity in cp-skills-cpp (O(n²) only when n ≤ 2,000) is a more conservative rule of thumb than this table. When the two differ, decide by the operation count you calculated, and be conservative when there are many operations with large constants, such as hashing or division.

## 2. Write the solution

- Check whether sums, products, and distance calculations need `long long`. Adding two values of 10⁹ exceeds the int range.
- If there is a lot of input and output, use `ios::sync_with_stdio(false); cin.tie(nullptr);`, and use `'\n'` instead of `endl`.
- If there are multiple test cases, reset global arrays and containers for each case.
- If the recursion depth can exceed 10⁵, change it to a loop.
- Match the C++ standard to the judging environment. If you wrote it in C++23 following the cp-skills-cpp rules, pass `--std c++23` when comparing too. The default in stress.py is c++17.

## 3. Write the brute force and the generator

- `brute.cpp`: a slow solution that transcribes the problem as is. Write it in a way that is hard to get wrong, such as exhaustive search. Do not reuse code from the fast solution.
- `gen.py`: takes a seed as its first argument and prints one small input. Copy [assets/gen_example.py](assets/gen_example.py) and change only the format. Keep N small (1–8), and deliberately mix in edge cases such as the minimum size, all-equal values, the maximum and minimum values, and negative numbers.

## 4. Compare

```bash
python3 scripts/stress.py sol.cpp brute.cpp gen.py -n 300
```

- The script path is relative to this skill folder. Run it from the work folder, and copy `scripts/stress.py` into the work folder if needed.
- Save the first input whose output differs to `failing_input.txt` and stop. Trace that input by hand to find the cause. Do not regenerate the same request.
- For real-number answers use `--eps 1e-6`, to change the compiler use `--cxx clang++`, and for the time limit use `--time-limit 1.0`.
- After fixing, rerun starting from the failing input, then run once more with a different seed (`--seed 1000`).

## 5. Check the time

Change the generator to output only one maximum-size input and measure the run time of `sol`. The script shows the slowest run time at the end.

## 6. Record it

In the NOTES.md decision log, record the solutions considered and why they were rejected, the complexity of the chosen solution and its basis, the number of tests compared and the seed range, and the counterexamples found and their causes. If you are using explain-as-you-go, follow its format.
