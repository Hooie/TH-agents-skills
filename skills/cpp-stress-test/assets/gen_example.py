"""Example generator: one array test. Copy and edit the format for your problem.

The first argument is the seed. Keep sizes small so the brute force stays fast
and a failing case is easy to read. Mix in edge cases on purpose.
"""

import random
import sys

seed = int(sys.argv[1]) if len(sys.argv) > 1 else 1
rng = random.Random(seed)

# Every 10th seed is an edge case: minimum size, all equal values, or extremes.
if seed % 10 == 0:
    kind = rng.choice(["min", "equal", "extreme"])
    if kind == "min":
        n, arr = 1, [rng.randint(-5, 5)]
    elif kind == "equal":
        n = rng.randint(2, 8)
        arr = [rng.randint(-5, 5)] * n
    else:
        n = rng.randint(2, 8)
        arr = [rng.choice([-10**9, 10**9]) for _ in range(n)]
else:
    n = rng.randint(1, 8)
    arr = [rng.randint(-10, 10) for _ in range(n)]

print(n)
print(*arr)
