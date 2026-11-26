#!/bin/sh
# Opens a release's GitHub release, and publishes the charts of its benchmarks (decisions 65 and
# 85 as amended on 2026-11-26). The bench workflow runs it on each release tag.
#
#   tools/charts_release.sh open <tag>
#   tools/charts_release.sh publish <out> <tag>
#
# `open` creates the tag's release when it has none, titled "stdx MAJOR.MINOR.PATCH", with the
# notes of docs/releases/<tag>.md, or with notes GitHub writes when that file is missing. A release
# that exists keeps its notes.
#
# `publish` takes the folder tools/charts_release.py wrote. It attaches each chart, the page
# benchmarks.md and an archive of the reports to the release, and a file replaces the asset of its
# name. It writes the same files as the one commit of the branch `charts`, which the READMEs and
# docs/benchmarks.md show each chart from: GitHub serves a release's files as downloads, which no
# page shows as an image. Last, the section notes.md holds replaces the release notes' section of
# an earlier run, and goes to the run's summary when GITHUB_STEP_SUMMARY names a file.
#
# It needs git with a remote `origin` it may push to, and gh with GH_TOKEN and GH_REPO set.
set -eu

# The branch that holds the latest release's charts, and the name its commit carries.
charts_branch_name=charts
charts_author_name="github-actions[bot]"
charts_author_email="41898182+github-actions[bot]@users.noreply.github.com"
# The heading of the notes' section, which tools/charts_release.py writes first.
notes_heading="## Benchmarks"

# Creates the release of the tag $1 when it has none.
release_open() {
    if gh release view "$1" >/dev/null 2>&1; then
        return 0
    fi
    notes="docs/releases/$1.md"
    if [ -f "${notes}" ]; then
        gh release create "$1" --verify-tag --title "stdx ${1#v}" --notes-file "${notes}"
    else
        gh release create "$1" --verify-tag --title "stdx ${1#v}" --generate-notes
    fi
}

# Attaches the charts, the page and the reports of the folder $1 to the release of the tag $2.
release_attach() {
    tar -czf "$1.reports.tar.gz" -C "$1" reports
    cp "$1.reports.tar.gz" "$1/bench-reports-$2.tar.gz"
    gh release upload "$2" "$1"/*.svg "$1/benchmarks.md" "$1/bench-reports-$2.tar.gz" --clobber
    rm -f "$1.reports.tar.gz" "$1/bench-reports-$2.tar.gz"
}

# Writes the charts, the page and the reports of the folder $1 as the one commit of the branch
# `charts`, for the tag $2, and pushes it over the branch's last commit. Each release's charts
# replace the last release's, and each release keeps its own. The commit is built in an index of
# its own, so the checkout and its HEAD stay as they were.
charts_branch() {
    index="$1.index"
    rm -f "${index}"
    GIT_INDEX_FILE="${index}" git read-tree --empty
    (cd "$1" && find . -type f \( -name '*.svg' -o -name '*.md' \) ! -name notes.md | sed 's|^\./||' | sort) >"$1.list"
    while IFS= read -r file; do
        blob="$(git hash-object -w "$1/${file}")"
        GIT_INDEX_FILE="${index}" git update-index --add --cacheinfo "100644,${blob},${file}"
    done <"$1.list"
    tree="$(GIT_INDEX_FILE="${index}" git write-tree)"
    rm -f "${index}" "$1.list"
    commit="$(git -c user.name="${charts_author_name}" -c user.email="${charts_author_email}" \
        commit-tree "${tree}" -m "chore: draw the charts of $2")"
    git push --force origin "${commit}:refs/heads/${charts_branch_name}"
}

# Replaces the section of the release's notes that starts at the heading with the text of the
# file $1, for the tag $2, and adds the text to the run's summary.
release_notes() {
    gh release view "$2" --json body --jq .body | awk -v heading="${notes_heading}" '$0 == heading { exit } { print }' >"$1.notes"
    cat "$1" >>"$1.notes"
    gh release edit "$2" --notes-file "$1.notes"
    rm -f "$1.notes"
    if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
        cat "$1" >>"${GITHUB_STEP_SUMMARY}"
    fi
}

main() {
    if [ "${1:-}" = publish ] && [ "$#" -eq 3 ]; then
        # The folder as a path from the root, which the next line makes the working directory.
        set -- publish "$(cd "$2" && pwd)" "$3"
    fi
    cd "$(dirname "$0")/.."
    case "${1:-}" in
        open)
            [ "$#" -eq 2 ] || { echo "usage: tools/charts_release.sh open <tag>" >&2; exit 2; }
            release_open "$2"
            ;;
        publish)
            [ "$#" -eq 3 ] || { echo "usage: tools/charts_release.sh publish <out> <tag>" >&2; exit 2; }
            release_open "$3"
            release_attach "$2" "$3"
            charts_branch "$2" "$3"
            release_notes "$2/notes.md" "$3"
            ;;
        *)
            echo "usage: tools/charts_release.sh open <tag> | publish <out> <tag>" >&2
            exit 2
            ;;
    esac
}

# A test sources this file for its functions, and then runs nothing.
case "${0##*/}" in
    charts_release.sh) main "$@" ;;
esac
