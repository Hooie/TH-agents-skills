---
name: cp-skills-cpp
description: A structured competitive programming knowledge base focused on algorithmic thinking, data structures, and high-performance C++ implementations. Use when solving competitive programming or coding-test problems in C++. Do not apply its naming and structure rules to Unreal Engine or production game code.
license: MIT
metadata:
  author: area44
  version: "26.04.02"
---

# Competitive Programming Skills

A structured and efficiency-driven knowledge base for mastering competitive programming. This repository emphasizes algorithmic reasoning, core data structures, implementation patterns, and writing optimized C++23 code under contest constraints.

## Objectives

- Develop strong algorithmic intuition.
- Build clean and minimal implementation habits.
- Maintain high-performance coding discipline.
- Improve speed and accuracy under time pressure.

# Language & Coding Standards

## Language Standard

- Use **C++23**.

## Code Style Guidelines

### Minimalism First

- Do not include comments in final submission code.
- Avoid unnecessary abstractions.
- Do not create a `solve()` function if the logic fits clearly inside `main()`.
- Avoid unnecessary variables.
- Do not store intermediate results if they are used only once.

### Naming & Structure Guidelines

#### Variables

- Use `camelCase`.
- Keep names simple, clear, and descriptive.

#### Functions

- Use `snake_case`.
- Function names must begin with a verb.
- Clearly describe the action performed.

#### Constants

- Use `ALL_CAPS` with underscores.

### Code Structure

- Keep logic linear and readable.
- Avoid deep nesting.
- Prefer early returns or `continue` to reduce indentation.
- Minimize global variables (allowed only for constants and large shared arrays).

### Struct Usage

Do **not** use `struct` unless it meaningfully improves clarity or groups logically inseparable data.

Avoid `struct` when:

- The data is used only locally inside a small algorithm.
- A simple `vector`, `pair`, or separate arrays are sufficient.
- The structure is used only once.

Prefer simpler alternatives:

- Use `pair` or `tuple` for small grouped values.
- Use parallel `vector`s when processing large datasets.
- Keep related variables close in scope.

Use `struct` only when:

- Multiple fields must travel together across functions.
- The structure represents a clear logical entity.
- It significantly improves readability in large implementations.

Example:

```cpp
// Avoid
struct Node {
  int l, r, value;
};

// Prefer
vector<int> leftChild, rightChild, value;
```

### Loop Preferences

- Prefer range-based loops.
- Use `for (auto &x : container)` when modifying elements.
- Use `for (auto x : container)` for read-only access.

### STL Discipline

- Prefer `vector` over other containers.
- Use `set` / `map` only when ordering or logarithmic operations are required.
- Prefer `sort()` over maintaining ordered containers.
- Avoid `multiset` unless strictly necessary.
- Use `reserve()` when size is known.
- Prefer `emplace_back()`.
- Avoid copying large structures.
- Prefer `const vector<int>&` when passing arguments.

## I/O Rules

- Use `cin` and `cout`.
- Disable synchronization:

```cpp
ios::sync_with_stdio(false);
cin.tie(nullptr);
```

- Use `"\n"` instead of `endl`.

### Input Handling Discipline

- Do **not** use defensive input patterns like:

```cpp
if (!(cin >> t)) return 0;
```

- Do **not** check for EOF or invalid input.
- Assume input always follows the problem statement.
- Read input directly and explicitly.

# Performance Discipline

- Estimate time complexity before coding.

### Target Complexity

- `O(n)` or `O(n log n)` for `n ≤ 2e5`
- `O(n^2)` only if `n ≤ 2000`
- `O(2^n)` only if `n ≤ 20`

### Memory & Efficiency

- Preallocate memory when possible.
- Avoid resizing containers inside loops.
- Use static arrays when size is fixed and performance-critical.

# Anti-Patterns to Avoid

### Unnecessary Abstraction

- Do **not** create functions for trivial logic.
- Do **not** split logic if it reduces clarity.

### Redundant Variables

- Do **not** store values used only once.

```cpp
// Avoid
int x = a + b;
cout << x;

// Prefer
cout << a + b;
```

### Overuse of STL

- Do **not** use `set` / `map` when `vector + sort` is sufficient.
- Avoid complex containers when simpler ones work.

### Unnecessary Copies

```cpp
// Avoid
void process(vector<int> v);

// Prefer
void process(const vector<int>& v);
```

### Dynamic Resizing in Loops

```cpp
// Avoid
vector<int> v;
for (...) v.push_back(x);

// Prefer
vector<int> v;
v.reserve(n);
for (...) v.push_back(x);
```

### Deep Nesting

```cpp
// Avoid
if (cond1) {
  if (cond2) {
    ...
  }
}

// Prefer
if (!cond1) return;
if (!cond2) return;
```

### Unnecessary Structs

- Avoid `struct` for simple grouped values.

### Overuse of Globals

- Avoid global variables unless necessary.

### Ignoring Constraints

- Do **not** start coding without complexity estimation.

### Premature Optimization

- Focus on correctness first, then optimize.

### Debug Artifacts

```cpp
// Avoid
cout << "debug" << x << "\n";
```

### Inconsistent Style

- Do **not** mix naming conventions.

### Magic Numbers

```cpp
// Avoid
if (x > 1000000007)

// Prefer
constexpr int MOD = 1000000007;
if (x > MOD)
```

# Compilation Template

```cpp
#include <bits/stdc++.h>
using namespace std;

using ll = long long;
using ull = unsigned long long;
using i128 = __int128_t;

constexpr ll INF = LLONG_MAX;
constexpr int MOD = 998244353;

int main() {
  ios::sync_with_stdio(false);
  cin.tie(nullptr);

  return 0;
}
```

# Competitive Programming Philosophy

Competitive programming requires:

- Careful constraint analysis.
- Strong pattern recognition.
- Transforming brute force into structured logic.
- Writing correct code quickly under pressure.

Clarity over cleverness. Performance over abstraction. Correctness over style.

Build intuition. Remove noise. Optimize thinking.
