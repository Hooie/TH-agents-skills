#!/usr/bin/env python3
"""Compare a solution against a brute-force reference on random inputs.

Usage:
    python3 stress.py sol.cpp brute.cpp gen.py [-n 300] [--seed 1]
                      [--time-limit 2.0] [--cxx g++] [--std c++17] [--eps 1e-6]

The generator receives a seed as its first argument and prints one test input
to stdout. It may be a .py file (run with this Python) or a .cpp file.
Outputs are compared token by token, so spacing and line breaks do not matter.
With --eps, tokens that parse as numbers are compared with that tolerance.

On the first mismatch, crash or timeout the input is saved to failing_input.txt
and the script exits with status 1. Uses only the Python standard library.
"""

import argparse
import os
import subprocess
import sys
import time
from pathlib import Path

EXE = ".exe" if os.name == "nt" else ""
BUILD_DIR = Path(".stress_build")


def compile_cpp(src: Path, cxx: str, std: str) -> Path:
    BUILD_DIR.mkdir(exist_ok=True)
    out = BUILD_DIR / (src.stem + EXE)
    cmd = [cxx, f"-std={std}", "-O2", "-Wall", "-o", str(out), str(src)]
    print("compile:", " ".join(cmd))
    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode != 0:
        sys.stderr.write(res.stderr)
        sys.exit(f"compile failed: {src}")
    return out


def command_for(path: Path, cxx: str, std: str) -> list:
    if path.suffix == ".py":
        return [sys.executable, str(path)]
    if path.suffix in (".cpp", ".cc", ".cxx"):
        return [str(compile_cpp(path, cxx, std).resolve())]
    return [str(path.resolve())]


def run(cmd: list, stdin: str, timeout: float):
    start = time.perf_counter()
    try:
        res = subprocess.run(cmd, input=stdin, capture_output=True, text=True, timeout=timeout)
    except subprocess.TimeoutExpired:
        return "TLE", "", time.perf_counter() - start
    elapsed = time.perf_counter() - start
    if res.returncode != 0:
        return f"RE (exit {res.returncode})", res.stdout + res.stderr, elapsed
    return "OK", res.stdout, elapsed


def same(a: str, b: str, eps):
    ta, tb = a.split(), b.split()
    if len(ta) != len(tb):
        return False
    for x, y in zip(ta, tb):
        if x == y:
            continue
        if eps is None:
            return False
        try:
            fx, fy = float(x), float(y)
        except ValueError:
            return False
        if abs(fx - fy) > eps * max(1.0, abs(fy)):
            return False
    return True


def preview(text: str, limit: int = 600) -> str:
    return text if len(text) <= limit else text[:limit] + f"\n... ({len(text)} chars total)"


def fail(kind: str, seed: int, test_input: str, detail: str) -> None:
    Path("failing_input.txt").write_text(test_input)
    print(f"\n[{kind}] seed={seed}")
    print("--- input (saved to failing_input.txt) ---")
    print(preview(test_input))
    print(detail)
    sys.exit(1)


def main() -> None:
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("sol")
    p.add_argument("brute")
    p.add_argument("gen")
    p.add_argument("-n", type=int, default=300, help="number of random tests (default 300)")
    p.add_argument("--seed", type=int, default=1, help="first seed (default 1)")
    p.add_argument("--time-limit", type=float, default=2.0, help="seconds per run for sol (default 2.0)")
    p.add_argument("--cxx", default=os.environ.get("CXX", "g++"))
    p.add_argument("--std", default="c++17")
    p.add_argument("--eps", type=float, default=None, help="tolerance for numeric tokens")
    a = p.parse_args()

    sol = command_for(Path(a.sol), a.cxx, a.std)
    brute = command_for(Path(a.brute), a.cxx, a.std)
    gen = command_for(Path(a.gen), a.cxx, a.std)

    worst = 0.0
    for i in range(a.n):
        seed = a.seed + i
        status, test_input, _ = run(gen + [str(seed)], "", 10.0)
        if status != "OK":
            fail("generator " + status, seed, "", test_input)

        b_status, expected, _ = run(brute, test_input, max(10.0, a.time_limit * 5))
        if b_status != "OK":
            fail("brute " + b_status, seed, test_input, expected)

        s_status, got, elapsed = run(sol, test_input, a.time_limit)
        worst = max(worst, elapsed)
        if s_status != "OK":
            fail("sol " + s_status, seed, test_input, preview(got))
        if not same(got, expected, a.eps):
            fail("WA", seed, test_input,
                 "--- expected (brute) ---\n" + preview(expected) + "\n--- got (sol) ---\n" + preview(got))

    print(f"\nAll {a.n} tests passed (seeds {a.seed}..{a.seed + a.n - 1}). "
          f"Slowest sol run: {worst * 1000:.1f} ms")


if __name__ == "__main__":
    main()
