"""Checks out each commit refs.txt names beside the workflow's own checkout, cuts its benchmark to
the decoding table, and builds it with the oracles; the first also installs the corpus."""
import pathlib, subprocess, sys
root = pathlib.Path('ab')
refs = [line.split()[0] for line in (root / '.github/ab/refs.txt').read_text().splitlines() if line.strip()]
def sh(*args, cwd=None):
    print('+', ' '.join(args), flush=True)
    subprocess.run(args, cwd=cwd, check=True)
# The packages once, from the workflow's checkout, whose cache holds them.
sh('tools/fetch_packages.sh', cwd='ab')
for index, ref in enumerate(refs):
    side = pathlib.Path(f'side{index}')
    sh('git', '-C', 'ab', 'worktree', 'add', '--detach', str(pathlib.Path('..') / side), ref)
    source = side / 'bench/deflate/deflate.zig'
    text = source.read_text()
    marker = '    try out.print("\\n## stdx\'s fast path against its checked path'
    assert text.count(marker) == 1, ref
    text = text.replace(marker, '    if (files.items.len > 0) {\n        try out.flush();\n        return;\n    }\n' + marker)
    source.write_text(text)
    (side / 'zig-pkg').symlink_to((root / 'zig-pkg').resolve())
    sh('tools/fetch_packages.sh', cwd=str(side))
    sh('zig', 'build', 'install', '-Doracles', cwd=str(side))
    if index == 0:
        sh('zig', 'build', 'corpus', '-Doracles', cwd=str(side))
print('built', refs)
