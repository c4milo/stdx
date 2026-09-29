"""Runs each built commit's synthetic benchmark over the streams, pinned to one core, the commits
taking turns for three rounds, and writes each run's report."""
import os, pathlib, subprocess
rounds = 3
refs = [line.split()[0] for line in pathlib.Path('ab/.github/ab/refs.txt').read_text().splitlines() if line.strip()]
streams = sorted(pathlib.Path('streams').glob('*.gz'))
args = [f'{p.stem}={p}' for p in streams]
cpu = ''
for line in open('/proc/cpuinfo'):
    if line.startswith('model name'):
        cpu = line.split(':', 1)[1].strip(); break
if not cpu:
    cpu = subprocess.run(['lscpu'], capture_output=True, text=True).stdout
    cpu = next((l.split(':', 1)[1].strip() for l in cpu.splitlines() if l.startswith('Model name')), 'unknown')
for round_index in range(rounds):
    for index, ref in enumerate(refs):
        commit = subprocess.run(['git', '-C', f'side{index}', 'rev-parse', '--short', 'HEAD'], capture_output=True, text=True, check=True).stdout.strip()
        program = pathlib.Path(f'side{index}/zig-out/bin/bench_synth').resolve()
        out = subprocess.run(['taskset', '-c', '1', str(program), *args], capture_output=True, text=True, check=True).stdout
        head = f'# synth-ab\n\n| Field | Value |\n|---|---|\n| Commit | {commit} |\n| CPU model | {cpu} |\n| Round | {round_index} |\n| Run URL | {os.environ.get("GITHUB_RUN_ID", "")} |\n\n'
        pathlib.Path(f'synth-{index}-{round_index}.md').write_text(head + out)
        print(f'round {round_index} side {index} {commit}', flush=True)
