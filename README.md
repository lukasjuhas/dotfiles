[Lukas's][repo] dotfiles
========================

[![CI status for macOS][ci badge macos]][ci link macos]

Personal macOS dotfiles. Bash-first, plugin-light, designed for a fast
one-shot setup on a fresh machine. For machine-specific overrides see
the [`*.local`](#local-settings) files.

Inspired by and structurally based on [@alrra/dotfiles][alrra].

Table of Contents
-----------------

* [🔧 Setup](#setup)
* [📂 What's inside](#whats-inside)
* [🎨 Customize](#customize)
  * [🌐 Local Settings](#local-settings)
    * [🐚 `~/.bash.local`](#bashlocal)
    * [🔁 `~/.gitconfig.local`](#gitconfiglocal)
    * [⌨️  `~/.vimrc.local`](#vimrclocal)
* [🛠️ Common commands](#common-commands)
* [✏️ Editor configs (VS Code + Cursor)](#editor-configs-vs-code--cursor)
* [↕️  Update](#update)
* [📑 License](#license)

Setup
-----

To set up the dotfiles run the appropriate snippet in the terminal:

> ⚠️ __DO NOT__ run the `setup` script if you do not fully understand
> [what it does][setup]. Seriously, __DON'T__!

| OS    | Snippet |
|:------|:--------|
| macOS | `bash -c "$(curl -LsS https://raw.github.com/lukasjuhas/dotfiles/main/src/os/setup.sh)"` |

That's it. ✨

The setup process will:

* Download the dotfiles to your computer
  (suggests `~/projects/dotfiles` by default).
* [Symlink][symlink] the [Git], [shell], [tmux], and [Vim] related
  files into `$HOME`.
* [Symlink][link editors] the shared [VS Code / Cursor][vscode dir]
  `settings.json`, `keybindings.json`, and `snippets/` into both
  editors' user directories.
* Prompt for __Full Disk Access__ if missing (required on modern
  macOS for many `defaults write` calls to take effect; see
  [`init.sh`][prefs init]).
* Apply the [Brewfile][brewfile] (`brew bundle`) — installs every
  formula, cask, and Mac App Store app in one declarative pass.
  Browser variants, dead taps, and unused apps have all been pruned;
  this list contains only what is actually used.
* Set custom [macOS][preferences macos] defaults (Finder, Dock,
  trackpad, keyboard, screenshots, Stage Manager off, etc.).

Apple Silicon. Tahoe (macOS 26) or newer.

What's inside
-------------

```text
.
├── Brewfile                                 ← every formula, cask, MAS app (declarative)
├── justfile                                 ← shortcut recipes (see below)
├── renovate.json                            ← dependency updates
├── scripts/                                 ← lint + link-check (CI)
└── src/
    ├── bin/                                 ← personal scripts (tile-dual, tile-quad, …)
    ├── git/                                 ← gitconfig, gitignore, gitattributes
    ├── shell/                               ← bash_aliases, bash_exports, bash_prompt, …
    ├── tmux/                                ← tmux.conf
    ├── vim/                                 ← minimal plugin-free vimrc
    ├── vscode/                              ← shared VS Code + Cursor config
    └── os/
        ├── setup.sh                         ← entry point
        ├── create_symbolic_links.sh         ← bash/git/tmux/vim symlinks
        ├── link_vscode_configs.sh           ← VS Code + Cursor symlinks
        ├── installs/
        │   ├── composer.sh                  ← Laravel Valet wiring
        │   ├── npm.sh                       ← global npm updates
        │   ├── nvm.sh                       ← Node Version Manager (not on Homebrew)
        │   └── macos/
        │       ├── bash.sh                  ← chsh to Homebrew bash
        │       ├── brewfile.sh              ← apply the root Brewfile
        │       ├── homebrew.sh              ← install brew, wire /opt/homebrew into PATH
        │       └── xcode.sh                 ← Xcode CLT + licence accept
        └── preferences/macos/
            ├── init.sh                      ← Full Disk Access check
            ├── dock.sh / finder.sh / …
            └── ui_and_ux.sh                 ← Stage Manager off, .DS_Store control, …
```

Customize
---------

### Local Settings

The dotfiles can be extended for machine-specific needs via three
local files (sourced or included automatically):

#### `~/.bash.local`

Sourced after every other Bash file, so it can override aliases,
exports, and `PATH`. This is the right place for secrets and
host-specific tweaks (e.g. API tokens).

```shell
#!/bin/bash

# Add personal scripts to PATH.
PATH="$HOME/projects/dotfiles/src/bin:$PATH"
export PATH

# Local secrets — never commit.
export SOME_API_TOKEN="…"
export OPENAI_API_KEY="…"
```

> 💡 For tokens with broader scope (per-project), consider
> [`direnv`][direnv] with an `.envrc` file inside the project — both
> `direnv` and the bash hook are installed by these dotfiles.

#### `~/.gitconfig.local`

Included after `~/.gitconfig`, so it overrides or adds to the
configurations. Use it for your identity and signing key — these are
__deliberately NOT__ tracked in this repo.

```gitconfig
[user]

    name = Your Name
    email = you@example.com
    signingKey = XXXXXXXX

[commit]

    # https://docs.github.com/en/authentication/managing-commit-signature-verification
    gpgSign = true
```

#### `~/.vimrc.local`

Sourced at the end of `~/.vimrc` (see [`src/vim/vimrc`][vimrc] last
block). The shared vim config is intentionally minimal (~140 lines,
zero plugins) since day-to-day editing happens in Cursor/VS Code.

```vim
" Example: disable arrow keys in insert and normal mode.

inoremap <Down>  <ESC>:echoe "Use j"<CR>
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
```

Common commands
---------------

[`just`][just] (installed via the Brewfile) provides shortcut
recipes:

```bash
just                # list recipes
just setup          # full one-shot setup
just install        # only run installers (Homebrew, casks, CLI)
just bundle         # apply the Brewfile (formulae + casks + MAS)
just bundle-check   # what's missing vs. the Brewfile?
just bundle-dump    # rewrite the Brewfile from currently-installed packages
just prefs          # only apply macOS defaults
just link           # (re)create the bash/git/tmux/vim symlinks
just link-editors   # (re)symlink VS Code + Cursor configs
just update         # softwareupdate + brew + mas + npm + pnpm
just lint           # shellcheck + markdownlint
just check          # lint + broken-link check
```

The [Brewfile][brewfile] is the single source of truth for everything
installable via Homebrew (formulae, casks) and `mas` (Mac App Store).
To add a tool: edit the Brewfile, then `just bundle`. To audit drift
between this repo and your machine: `just bundle-check`.

Editor configs (VS Code + Cursor)
---------------------------------

[`src/vscode/`][vscode dir] holds a single shared
`settings.json`, `keybindings.json`, and `snippets/` directory.
[`src/os/link_vscode_configs.sh`][link editors] symlinks them into
__both__ editors:

```text
~/Library/Application Support/Code/User/   ┐
                                           ├─→ src/vscode/
~/Library/Application Support/Cursor/User/ ┘
```

Cursor is a VS Code fork and reads the same format. Unknown keys
(e.g. `cursor.*` in VS Code, `claudeCode.*` in Cursor) are silently
ignored by the editor that doesn't know them, so a single shared
file just works. Pre-existing local files are backed up to
`<file>.backup.<timestamp>` before the symlink is created.

Update
------

To pull the latest dotfiles and re-run setup:

```bash
just setup
```

To bring the system up to date (without re-running setup):

```bash
just update
```

To re-run only one piece:

```bash
just install        # apps + CLI tools only
just prefs          # macOS defaults only
just link           # rebuild symlinks only
```

License
-------

The code is available under the [MIT License](LICENSE.txt).

---

Inspired by and based on [@alrra/dotfiles][alrra]. Thanks!

<!-- Link labels: -->
[alrra]: https://github.com/alrra/dotfiles
[brewfile]: Brewfile
[ci badge macos]: https://github.com/lukasjuhas/dotfiles/workflows/macOS/badge.svg
[ci link macos]: https://github.com/lukasjuhas/dotfiles/actions?query=workflow%3AmacOS
[direnv]: https://direnv.net/
[Git]: src/git
[just]: https://github.com/casey/just
[link editors]: src/os/link_vscode_configs.sh
[prefs init]: src/os/preferences/macos/init.sh
[preferences macos]: src/os/preferences/macos
[repo]: https://github.com/lukasjuhas
[setup]: src/os/setup.sh
[shell]: src/shell
[symlink]: src/os/create_symbolic_links.sh
[tmux]: src/tmux
[Vim]: src/vim
[vimrc]: src/vim/vimrc
[vscode dir]: src/vscode
