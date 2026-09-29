"""Checks out each commit refs.txt names beside the workflow's checkout, gives each the synthetic
benchmark program and its build step from this checkout, and builds it with the oracles."""
import pathlib, re, shutil, subprocess
root = pathlib.Path('ab')
refs = [line.split()[0] for line in (root / '.github/ab/refs.txt').read_text().splitlines() if line.strip()]
def sh(*args, cwd=None):
    print('+', ' '.join(args), flush=True)
    subprocess.run(args, cwd=cwd, check=True)
sh('tools/fetch_packages.sh', cwd='ab')
wiring = re.search(r'\n(    // A temporary experiment.*?synth_step\.dependOn\(&b\.addInstallArtifact\(synth, \.\{\}\)\.step\);\n)', (root / 'build/oracle.zig').read_text(), re.S).group(1)
for index, ref in enumerate(refs):
    side = pathlib.Path(f'side{index}')
    sh('git', '-C', 'ab', 'worktree', 'add', '--detach', str(pathlib.Path('..') / side), ref)
    (side / 'bench/synth').mkdir(parents=True, exist_ok=True)
    shutil.copy(root / 'bench/synth/synth.zig', side / 'bench/synth/synth.zig')
    build = side / 'build/oracle.zig'
    text = build.read_text()
    anchor = '    const bench_checksum_module = b.createModule(.{'
    assert text.count(anchor) == 1, ref
    build.write_text(text.replace(anchor, wiring + anchor))
    (side / 'zig-pkg').symlink_to((root / 'zig-pkg').resolve())
    sh('tools/fetch_packages.sh', cwd=str(side))
    sh('zig', 'build', 'bench-synth', '-Doracles', cwd=str(side))
print('built', refs)
