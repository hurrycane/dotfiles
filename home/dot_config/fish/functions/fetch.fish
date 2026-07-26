function fetch --description 'Fetch and fast-forward the default branch'
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "fetch: not a git repository" >&2
        return 1
    end

    git fetch --prune; or return 1

    # Resolve the default branch rather than assuming master. origin/HEAD is the
    # cheap local answer but is often unset on older clones, so fall back to
    # asking the remote, then to main.
    set -l branch (git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null \
        | string replace -r '^origin/' '')

    if test -z "$branch"
        set branch (git remote show origin 2>/dev/null \
            | string replace --filter --regex '.*HEAD branch: (.*)' '$1' \
            | string trim)
    end

    if test -z "$branch"
        set branch main
    end

    git switch $branch; or return 1
    git pull --ff-only origin $branch
end
