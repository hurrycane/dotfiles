# Bogdan Gaza's Dotfiles

Managed with [chezmoi](https://chezmoi.io/). Source of truth is `home/`, which
mirrors `$HOME` using chezmoi's naming convention (`dot_vimrc` → `~/.vimrc`).

## New machine

Homebrew first, by hand — then chezmoi, then everything else.

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install chezmoi
chezmoi init --apply git@github.com:hurrycane/dotfiles.git
```

The last line clones the repo, runs
`.chezmoiscripts/run_once_before_install-packages.sh` to brew-install the rest
of the CLI stack, then writes every config file into place. That script does not
install Homebrew — it exits with an error if `brew` is not on the PATH.

To keep the working copy somewhere other than chezmoi's default
(`~/.local/share/chezmoi`), point `sourceDir` at it in
`~/.config/chezmoi/chezmoi.toml` — this machine uses:

```toml
sourceDir = "/Users/bogdan/Projects/dotfiles"
```

## Daily use

chezmoi copies files rather than symlinking them, so an edit in the repo is not
live until you apply it.

```
chezmoi diff              # what would change in $HOME
chezmoi apply             # write changes into $HOME
chezmoi status            # short form; empty means in sync
chezmoi verify            # non-zero exit if $HOME has drifted

chezmoi edit ~/.vimrc     # edit the source file for a target
chezmoi add ~/.vimrc      # pull a change made directly in $HOME back into the repo
chezmoi cd                # drop into the source directory
```

The usual mistake is editing `~/.vimrc` directly and then losing it on the next
`chezmoi apply`. Either `chezmoi edit` it, or `chezmoi add` it afterwards.

### Manual steps

Not automated, because they need `sudo` or a GUI:

```
# Make fish the login shell
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish

# atuin's sync daemon
brew services start atuin
```

The atuin daemon is ignored until it is also enabled in
`~/.config/atuin/config.toml`:

```toml
[daemon]
enabled = true
```

Atuin works fully offline; `atuin login` is only needed for cross-machine sync.

Preferred font: Monaco Nerd Font Mono, Regular, 18.

## What is here

```
.chezmoiroot                 -> "home", so repo docs are never applied to $HOME
home/
  .chezmoiignore             files chezmoi must not manage
  .chezmoiscripts/           run_once package install
  dot_gitconfig              delta as pager, aliases
  dot_vimrc                  plain vim, no plugin manager
  dot_inputrc                readline
  dot_tmux.conf              + dot_tmux.colors.conf
  dot_vim/colors/            solarized
  dot_config/
    starship.toml            prompt
    fish/config.fish         PATH, CLI stack init
    fish/conf.d/colors.fish  fish colors
    fish/functions/          fetch, virtualfish, fish_prompt
```

Two things are deliberately **not** managed, listed in `home/.chezmoiignore`:
`fish_variables` and `conf.d/fish_frozen_key_bindings.fish`. Fish rewrites both
itself, so tracking them means permanent phantom drift in `chezmoi diff`. The
colors that used to live in `fish_variables` are now set explicitly in
`conf.d/colors.fish`.

## Dependencies

Installed by the `run_once` script. Shell: fish, starship, direnv, tmux, neovim
(`reattach-to-user-namespace` is optional; `tmux.conf` only uses it if present).

CLI stack — see **[CHEATSHEET.md](CHEATSHEET.md)** for ten day-to-day uses each:

| tool | replaces | notes |
| --- | --- | --- |
| [eza](https://github.com/eza-community/eza) | `ls` | aliased to `ls`/`ll`/`la`/`lt` |
| [bat](https://github.com/sharkdp/bat) | `cat` | also the `MANPAGER` |
| [fd](https://github.com/sharkdp/fd) | `find` | backs `FZF_DEFAULT_COMMAND` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `grep` | `rg` |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `cd` | `z`, `zi` |
| [fzf](https://github.com/junegunn/fzf) | — | `ctrl-t` files, `alt-c` cd |
| [atuin](https://atuin.sh/) | history | owns `ctrl-r`; up-arrow left to fish |
| [git-delta](https://github.com/dandavison/delta) | `git diff` | wired up in `dot_gitconfig` |
| [dust](https://github.com/bootandy/dust) | `du` | `dust` |
| [chezmoi](https://chezmoi.io/) | — | manages this repo |

Only `ls` shadows its classic command — `cat`, `du`, `find` and `grep` are left
as-is, since bat/dust/fd/rg take incompatible flags.

Brew-installed completions need no setup: fish already carries
`/opt/homebrew/share/fish/vendor_completions.d` in `$fish_complete_path`.

## Editor

`vim` is Apple's `/usr/bin/vim` and `$EDITOR` points at it. `dot_vimrc` is a
plain config with no plugin manager — pathogen and the vim plugin submodules
(NERDTree, lightline, vim-go, tmuxline, vim-tmux-navigator) were removed in
favour of starting fresh on neovim. There is no neovim config in this repo yet.

## <a name="inspiration"></a>Inspiration

Kudos to [Erik Michaels-Ober](https://github.com/sferik/dotfiles/) and
[Ryan Bates](https://github.com/ryanb/dotfiles).
