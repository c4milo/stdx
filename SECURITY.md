# Security policy

## How to report a vulnerability

Use GitHub's private vulnerability reporting: open the repository's
[Security tab](https://github.com/c4milo/stdx/security) and click "Report a vulnerability". The
report stays private, and the advisory and CVE, if one is warranted, come out of the same thread.

If you cannot use GitHub, email camilo.aguilar@gmail.com with the same details you would put in
the report.

Do not open a public issue for a vulnerability.

## What to expect

One maintainer runs this project. You get an acknowledgment within 7 days, and an assessment
within 30: confirmed, not a vulnerability, or more information needed. The fix date comes out of
the assessment.

## Scope

In scope: the library modules under `src/`. The decoders of DEFLATE, zlib, gzip, Zstandard,
brotli, JSON and base 64 read octets that nobody trusts. Input that makes one of them crash, trip
an assertion, read or write outside a buffer, loop without bound, or accept a stream its RFC
requires it to refuse is a vulnerability. So is an encoder that writes outside its output, or
writes a stream that decodes to octets other than its input.

Out of scope, so triage stays fast:

- `tools/`, `bench/` and `spec/`, which are test-only and never packaged.
- The other implementations that the checks and the benchmarks build, such as zlib, libzstd and
  simdjson. Report those to their own projects.
- Attacks that need a malicious caller: a wrong buffer, a state the caller did not `init`, or a
  `codec.Features` that names instructions the CPU does not have. The caller is trusted; the
  input is not.
- Output larger than the room the caller gave. A decoder writes at most that room and then says
  it needs more, so the caller sets the limit.

[`docs/invariants.md`](docs/invariants.md) lists the rules stdx checks, each with its check, and
[`docs/decisions.md`](docs/decisions.md) records what stdx refuses to build and why.
