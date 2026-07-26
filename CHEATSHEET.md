# CLI Stack Cheatsheet

Ten things worth knowing per tool, for day-to-day work. Everything here was
checked against the versions in this setup: eza 0.23, bat 0.26, fd 10, ripgrep
14, ast-grep 0.45, zoxide 0.10, fzf 0.74, atuin 18.17, delta 0.18, dust 1,
direnv 2.37, fish 4.8.

Examples use fish syntax — command substitution is `(cmd)`, not `$(cmd)`.

---

## eza — `ls`

Aliased in `config.fish`: `ls`, `ll` (long+git), `la` (long+git+hidden), `lt` (tree).

| # | Command | Why |
| --- | --- | --- |
| 1 | `ll` | Long view with the git status column. The everyday default. |
| 2 | `lt` / `eza -T -L3` | Tree, depth-limited. `-L` sets the depth. |
| 3 | `eza -l -s size -r` | Biggest files first. `-r` reverses any sort. |
| 4 | `eza -l -s date -r` | Most recently modified first — what did I just touch? |
| 5 | `eza -ld --total-size *` | Recursive size *per directory*, unlike `ls`. |
| 6 | `eza -la --git-ignore` | Hide anything `.gitignore`d — cuts build noise. |
| 7 | `eza -T -I 'node_modules\|.git\|target'` | Tree with junk pruned. `-I` is pipe-separated globs. |
| 8 | `eza -lD` / `eza -lf` | Directories only / files only. |
| 9 | `eza -l --changed --accessed` | Add ctime/atime columns when chasing "what modified this". |
| 10 | `eza -l -o` | Octal permissions — faster than decoding `rwxr-xr-x`. |

Sort fields: `name ext created date age accessed changed size inode type none`.

---

## bat — `cat`

Already the `MANPAGER`, so `man rsync` comes out highlighted.

| # | Command | Why |
| --- | --- | --- |
| 1 | `bat file.go` | Syntax + line numbers + git gutter, paged. |
| 2 | `bat -pp file` | Plain, no decorations, no pager — what you want before copy-pasting. |
| 3 | `bat -r 40:80 file` | Just a line range. Also `-r :40`, `-r 40:`, `-r -10:` (last 10). |
| 4 | `bat -d file` | **Only the lines changed vs the git index.** Underrated. |
| 5 | `curl -s api/x \| bat -l json` | Force a language for piped input, which bat can't sniff. |
| 6 | `bat -A file` | Reveal tabs, CRLF, trailing space, non-printables. |
| 7 | `bat -H 42 file` | Highlight line 42 — good for pointing at a stack-trace line. |
| 8 | `bat f1.go f2.go` | Concatenate several files with headers between them. |
| 9 | `bat --style=changes,numbers file` | Trim the decoration down to what you care about. |
| 10 | `bat --list-themes` | Theme browser; this setup pins `Solarized (dark)` via `BAT_THEME`. |

---

## fd — `find`

Smart-case, regex by default, skips `.gitignore`d files and hidden files.

| # | Command | Why |
| --- | --- | --- |
| 1 | `fd config` | Substring/regex match on the *name*. No `-name` ceremony. |
| 2 | `fd -e go -e rs` | Filter by extension, repeatable. |
| 3 | `fd -H -I secret` | Include hidden *and* ignored files — the "actually search everything". |
| 4 | `fd -t f` / `-t d` / `-t l` / `-t x` | Only files / dirs / symlinks / executables. |
| 5 | `fd -g '*.test.ts'` | Glob mode when a glob is clearer than a regex. |
| 6 | `fd --changed-within 1d` | Touched today. Also `--changed-before 2weeks`. |
| 7 | `fd -S +10M` | Size filter: `+10M` bigger than, `-1k` smaller than. |
| 8 | `fd -e py -x wc -l` | Run a command **per result**, in parallel. |
| 9 | `fd -e py -X rg TODO` | Run **once** with all results as args. Note `-x` vs `-X`. |
| 10 | `fd -d 2 -E node_modules pattern` | Cap depth, prune directories. |

Already wired as `FZF_DEFAULT_COMMAND`, so fzf's file lists respect `.gitignore`.

---

## ripgrep — `grep`

| # | Command | Why |
| --- | --- | --- |
| 1 | `rg pattern` | Recursive, smart-case, gitignore-aware, skips binaries. |
| 2 | `rg -w foo` / `rg -F 'a.b('` | Whole word / literal string, no regex escaping. |
| 3 | `rg -tgo pattern` / `rg -Tgo pattern` | Restrict to / exclude a language. `rg --type-list` to browse. |
| 4 | `rg -l pattern` / `rg --files-without-match pattern` | Which files match — and which *don't*. |
| 5 | `rg -C3 pattern` | Context lines. `-A`/`-B` for one-sided. |
| 6 | `rg --hidden --no-ignore pattern` | Search everything, including `.git`-ignored paths. |
| 7 | `rg -g '!*_test.go' pattern` | Glob include/exclude; `!` negates. |
| 8 | `rg -o -r '$1' 'func (\w+)'` | Print only capture group 1 — quick extraction without sed. |
| 9 | `rg -U 'func foo[\s\S]*?\n\}'` | Multiline mode, for patterns crossing newlines. |
| 10 | `rg --passthru -r NEW OLD file` | Preview a whole-file substitution before committing to it. |

`rg --stats pattern` for match/file counts; `rg --sort path` for stable output in scripts.

---

## ast-grep — structural `grep`

Matches syntax trees, not lines, so formatting and line breaks stop mattering.
Installed as both `ast-grep` and the shorter `sg`. `run` is the default command,
so `sg -p …` is enough. Metavariables: `$X` captures one node, `$$$X` captures a
variadic run of them, `$_` matches without capturing.

| # | Command | Why |
| --- | --- | --- |
| 1 | `sg -p 'print($$$)' -l python` | Matches the call regardless of its arguments or wrapping. The everyday case. |
| 2 | `sg -p 'foo($$$A)' -r 'bar($$$A)' -l python` | Rewrite while carrying the captured arguments across. |
| 3 | `sg -p '…' -r '…' -U` | `-U`/`--update-all` writes the rewrite to disk. Without it you only see a diff. |
| 4 | `sg -p '…' -i` | Interactive: accept or skip each match individually. Safer than `-U`. |
| 5 | `sg -p 'if ($C) { $$$ }' -l ts` | Metavariables nest, so whole block shapes are matchable. |
| 6 | `sg -p '$X == $X' -l python` | Reusing a name demands both sides be *the same* node. Finds self-comparisons. |
| 7 | `sg -p '…' --debug-query=ast` | When a pattern silently matches nothing, this shows how it actually parsed. |
| 8 | `sg -k function_definition -l python` | Match by tree-sitter node kind when no code snippet expresses it. |
| 9 | `sg -p '…' --json=stream \| jq …` | Machine-readable output for scripting. Note `--json` needs `=`, not a space. |
| 10 | `sg scan` / `sg new rule` | Promote a one-off pattern into a YAML rule with a message and severity. |

`-C3` for context, `--globs` to scope by path, `--no-ignore hidden` to reach
dotfiles. `sg outline <file>` dumps a symbol/import structure. Prefer `rg` for
plain text, since ast-grep needs a parser and pays for it.

---

## direnv

Hooked in `config.fish`, so entering a directory with an allowed `.envrc` loads
its environment and leaving unloads it. Nothing runs until you allow it.

| # | Command | Why |
| --- | --- | --- |
| 1 | `direnv allow` | Required after creating *or editing* any `.envrc`. The usual "why is nothing happening". |
| 2 | `direnv edit` | Opens `.envrc` in `$EDITOR` and allows it on save, so no separate `allow`. |
| 3 | `direnv reload` | Force a reload without touching the file. |
| 4 | `direnv status` | What direnv thinks is loaded and why. First stop when it misbehaves. |
| 5 | `PATH_add bin` | In `.envrc`: prepend a project-relative dir to `PATH`, no `export` needed. |
| 6 | `dotenv` / `dotenv_if_exists` | Load an existing `.env` file instead of restating it. |
| 7 | `source_up` | Inherit a parent directory's `.envrc` and extend it, for monorepos. |
| 8 | `layout python` | Create and activate a per-project virtualenv automatically. |
| 9 | `direnv exec DIR cmd` | Run one command under a directory's env without cd'ing there. |
| 10 | `direnv deny` / `direnv prune` | Revoke a single `.envrc`; drop allow-records for files that are gone. |

`watch_file <path>` makes direnv reload when another file changes (a lockfile,
say). Add `.envrc` to git but keep secrets in a gitignored `.env` + `dotenv`.

---

## zoxide — `cd`

| # | Command | Why |
| --- | --- | --- |
| 1 | `z dotfiles` | Jump to the highest-ranked directory matching "dotfiles". |
| 2 | `z proj api` | Multiple keywords, matched in order against the path. |
| 3 | `zi` | Interactive pick through fzf when the guess would be wrong. |
| 4 | `z foo/bar` | Trailing path component still works like `cd` if it resolves. |
| 5 | `zoxide query -ls` | List the database with scores — see what it actually learned. |
| 6 | `zoxide query dot` | Ask what `z dot` *would* pick, without moving. |
| 7 | `zoxide remove /old/path` | Prune a directory you deleted or renamed. |
| 8 | `zoxide edit` | Interactive editor over the whole database. |
| 9 | `_ZO_EXCLUDE_DIRS` | Keep noisy trees (worktrees, caches) out of the db. |
| 10 | `_ZO_ECHO=1` | Echo the resolved directory on jump, while you're learning to trust it. |

Ranking is frecency, so the db gets better for a week and then feels psychic.

---

## fzf

`fzf --fish` is sourced in `config.fish`. atuin owns `ctrl-r`; fzf keeps the rest.

| # | Command | Why |
| --- | --- | --- |
| 1 | `ctrl-t` | Insert file paths into the current command line. |
| 2 | `alt-c` | Fuzzy `cd` into a subdirectory. |
| 3 | `vim (fzf)` | Wrap any command around a picker. The core idiom. |
| 4 | `vim (fzf -m)` | `-m` + tab selects several; the command gets all of them. |
| 5 | `git switch (git branch --format='%(refname:short)' \| fzf)` | Picker over any command's output. |
| 6 | `fzf --preview 'bat -n --color=always {}'` | `{}` is the current line. Already the default for `ctrl-t`. |
| 7 | `'exact` / `^prefix` / `.go$` / `!skip` | Query syntax: literal, anchored, and negated terms. |
| 8 | `fzf -q term -1 -0` | Prefilled query; auto-accept a single match, exit on none. Scriptable. |
| 9 | `kill -9 (ps aux \| fzf -m \| awk '{print $2}')` | The process-picker pattern, works for any tabular source. |
| 10 | `FZF_DEFAULT_OPTS` | Set `--height=40% --layout=reverse --border` once, globally. |

`**<tab>` after a command is fish's fzf completion trigger (e.g. `ssh **<tab>`).

---

## atuin — shell history

Owns `ctrl-r`. Up-arrow is deliberately left to fish's own prefix search.

| # | Command | Why |
| --- | --- | --- |
| 1 | `ctrl-r` | Full-text search across every shell, with exit code and duration. |
| 2 | `ctrl-r` then `ctrl-r` again | Cycles filter mode: global → host → session → directory. |
| 3 | Filter to directory mode | "What did I run *in this repo*" — the single best feature. |
| 4 | `atuin search -c . docker` | Same thing non-interactively, scoped to cwd. |
| 5 | `atuin search -e 0 cargo` | Only commands that *succeeded*. `-e 1` for the failures. |
| 6 | `atuin search --after '1 week ago' deploy` | Time-bounded. Also `-b/--before`. |
| 7 | `atuin stats` | Top commands over all history; good for spotting alias candidates. |
| 8 | `atuin search -f '{time} {directory} {command}'` | Custom output columns for piping. |
| 9 | `atuin import auto` | One-time slurp of pre-atuin bash/zsh/fish history. |
| 10 | `atuin doctor` | Diagnoses a broken setup before you go spelunking in configs. |

Fully local by default; `atuin register` + `atuin sync` only if you want it on
several machines. `brew services start atuin` runs the daemon — see README for
the `[daemon] enabled = true` it also needs.

---

## delta — `git diff`

Wired up in `gitconfig` as git's pager and `interactive.diffFilter`, with
`navigate = true`.

| # | Command | Why |
| --- | --- | --- |
| 1 | `git diff` | Already goes through delta. Nothing to remember. |
| 2 | `n` / `N` in the pager | Jump between files in a big diff, instead of scrolling. |
| 3 | `git -c delta.side-by-side=true diff` | Side-by-side for one invocation. |
| 4 | `git diff \| delta -s -n` | Same via a pipe: side-by-side plus line numbers. |
| 5 | `git add -p` | Hunks come out delta-highlighted via `interactive.diffFilter`. |
| 6 | `git log -p` / `git show HEAD~3` | Any command emitting a diff is covered. |
| 7 | `delta old.txt new.txt` | Standalone two-file diff — a `diff -u` replacement. |
| 8 | `diff -u a b \| delta` | Wrap output from anything that emits unified diff. |
| 9 | `git diff --word-diff \| delta` | Word-level changes on long prose lines. |
| 10 | `DELTA_FEATURES=+side-by-side git diff` | Toggle named feature sets per-command via env. |

`delta --list-syntax-themes` to preview themes against your terminal.

---

## dust — `du`

Not aliased over `du`, since it takes different flags. Invoke as `dust`.

| # | Command | Why |
| --- | --- | --- |
| 1 | `dust` | Tree of the current dir, sorted by size, with bars. Zero flags needed. |
| 2 | `dust -d 2` | Cap depth so the output fits on a screen. |
| 3 | `dust -n 40` | Show more rows than the default. |
| 4 | `dust -r` | Biggest at the top instead of the bottom. |
| 5 | `dust -X node_modules -X .git` | Exclude the usual suspects, repeatable. |
| 6 | `dust -z 10M` | Hide everything under a size floor. |
| 7 | `dust -f` | Count **files** instead of bytes — finds inode-heavy dirs. |
| 8 | `dust -t` | Group by file type: "so it's 4 GB of .mp4". |
| 9 | `dust -s` | Apparent size rather than disk blocks. |
| 10 | `dust -p ~/a ~/b` | Multiple roots at once, with full paths. |

`-b` drops the bars, `-o si` fixes the units, `-R` is screen-reader friendly.

---

## chezmoi — this repo

Copy mode: repo edits are not live until applied. `sourceDir` is set in
`~/.config/chezmoi/chezmoi.toml`.

| # | Command | Why |
| --- | --- | --- |
| 1 | `chezmoi diff` | What `apply` would change in `$HOME`. Always the first move. |
| 2 | `chezmoi apply` | Write the repo state into `$HOME`. |
| 3 | `chezmoi status` | Short form; empty output means in sync. |
| 4 | `chezmoi edit ~/.vimrc` | Edit the *source* file for a target, by its home path. |
| 5 | `chezmoi edit --apply ~/.vimrc` | Edit and apply in one step — the everyday loop. |
| 6 | `chezmoi add ~/.gitconfig` | Recover a change you made directly in `$HOME`. |
| 7 | `chezmoi cd` | Subshell in the source dir, for git work. |
| 8 | `chezmoi managed` / `chezmoi unmanaged` | What is tracked, and what in `$HOME` is not. |
| 9 | `chezmoi verify` | Non-zero exit if `$HOME` drifted. Scriptable. |
| 10 | `chezmoi execute-template < f.tmpl` | Render a template without applying it. |

`chezmoi doctor` diagnoses a broken setup. `chezmoi apply --dry-run --verbose`
shows a full diff plus which scripts would run.

---

## fish — the shell itself

Coming from bash: command substitution is `(cmd)` not `$(cmd)`, `export FOO=bar`
is `set -gx FOO bar`, and there is no `!!` (use `$history[1]`). `&&` and `||`
work; `; and` / `; or` are the older spelling.

| # | Command | Why |
| --- | --- | --- |
| 1 | `abbr --add gs 'git status'` | Expands *in the buffer* as you type, so history stays readable. Prefer over `alias`. |
| 2 | `set -gx`, `set -g`, `set -U`, `set -l` | Exported global, global, universal (persists across shells), local. The whole scope model. |
| 3 | `set -S PATH` | Show every scope a name exists in. The fix for "why is this value not what I set". |
| 4 | `funced fish_prompt` / `funcsave` | Edit a function live, then persist it to `~/.config/fish/functions/`. |
| 5 | `string match -r '(\d+)' $x` | Regex without sed. Also `string replace`, `split`, `join`, `trim`, `pad`. |
| 6 | `path basename /a/b.txt` | Path manipulation builtin: `path dirname`, `extension`, `resolve`, `filter -x`. |
| 7 | `math "2 + 3 * 4"` | Arithmetic without `$((…))` or `bc`. Floats work. |
| 8 | `prevd` / `nextd` / `dirh` | Directory history, back and forward. `cd -` only goes back one. |
| 9 | `echo $pipestatus` | Exit code of *every* stage in a pipe, not just the last. `$status` is the last. |
| 10 | `argparse v/verbose 'n/name=' -- $argv` | Real flag parsing inside a function, populating `$_flag_verbose` etc. |

`type -a cmd` says whether something is a function, builtin, or binary;
`functions cmd` prints its source. `command -q cmd` is the quiet existence test
this repo's `config.fish` guards everything with. `fish_add_path` beats
`set PATH` since it dedupes. `fish -n file` syntax-checks without running, and
`--no-config` starts a shell with none of this loaded, for bisecting breakage.
