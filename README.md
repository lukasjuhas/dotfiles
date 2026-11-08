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

That's it. ✨ Nothing needs installing first: the script only needs the
`bash` and `curl` that ship with macOS, and installs the Xcode Command
Line Tools (git), Homebrew and then everything else, `just` included.

Setup first asks __which machine this is__ (or pass
`--profile personal|work|server`) and remembers the answer in
`~/.dotfiles_profile`:

| Profile    | Gets |
|:-----------|:-----|
| `personal` | [`Brewfile`][brewfile] + [`Brewfile.laptop`][brewfile laptop] + [`Brewfile.personal`][brewfile personal], filmscan, d2 mounted at login |
| `work`     | [`Brewfile`][brewfile] + [`Brewfile.laptop`][brewfile laptop] + [`Brewfile.work`][brewfile work] |
| `server`   | [`Brewfile`][brewfile] + [`Brewfile.server`][brewfile server], filmscan, [Immich][immich], [server settings][server prefs] |

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
* Apply this machine's Brewfile layers (`brew bundle`) — formulae,
  casks, and Mac App Store apps in one declarative pass.
* Laptops: install Node (nvm) and the latest Python (uv), and set up
  key-based SSH to the home server ([`set_server_ssh_key.sh`][server key]).
  Keys are generated on the machine and never stored in this repo.
* Personal laptop + server: clone and install [filmscan] and the NegPy
  version it pins.
* Every machine: Do Not Disturb on, and back on at every login, via a
  Shortcuts shortcut built from [`src/shortcuts`][shortcuts] (macOS has
  no other way to script it). Click __Add Shortcut__ once when asked.
  Without iCloud (e.g. a managed Apple ID), make it by hand when asked:
  Shortcuts → __+__ → __Set Focus__ (Do Not Disturb on until turned
  off), named `Do Not Disturb On`.
* Server: never sleep, restart after a power cut, Remote Login +
  Screen Sharing on, SSH password login off (asks first, and only once
  a key is authorised), an SMB share for the `d2` drive, and Time
  Machine backing up `d2` to `Backup-A` (hourly, versioned, encrypted).
* Server: [Immich][immich] in OrbStack, showing the film scan archive
  on `d2` read-only (see [Immich](#immich) below).
* Set custom [macOS][preferences macos] defaults (Finder, Dock,
  trackpad, keyboard, screenshots, Stage Manager off, etc.).

Apple Silicon. Tahoe (macOS 26) or newer.

Left to do by hand afterwards: sign in to Tailscale, the App Store,
1Password and Adobe Creative Cloud (then install Lightroom from it),
install the [NegPy app][negpy] (no cask), keep "Share across devices"
off in System Settings → Focus (so Do Not Disturb stays on the Mac),
turn on the Safari extensions in Safari → Settings → Extensions,
and drag `/Volumes/d2` into Finder's sidebar once (macOS 26 can't add
sidebar items from a script; Finder reconnects on click afterwards).

### Home server

On a rebuilt server: sign in as the server user, then

```bash
git clone https://github.com/lukasjuhas/dotfiles.git ~/projects/dotfiles
cd ~/projects/dotfiles && ./src/os/setup.sh --profile server
```

Re-run any time with `just setup-server`. From each laptop,
`just server-key` makes sure key login to the server works.

### Immich

[Immich][immich] is a photo library next to Lightroom, running in
OrbStack on the server ([`docker-compose.yml`][immich compose],
installed by [`immich.sh`][immich install]). It shows the film scan
archive on `d2` read-only, so it can never change or delete a scan.
Its database and thumbnails live in `~/immich` on the server, never in
this repo (`.env` holds a generated database password). Time Machine
backs up `~/immich` except the live database, which can't be copied
safely while it runs; Immich's own nightly database backups in
`~/immich/library/backups` are the backup (restore one from Immich's
first-run screen on a rebuilt server).

Server settings (no map, no version check, a nightly library scan,
date folders for uploads, daily database backups) come from
[`immich-config.json`][immich config], so Administration → Settings is
read-only: change the file, then `just immich`.

Once, after the first setup:

1. Open OrbStack on the server and finish its setup (choose Docker),
   then `just immich`.
2. Open <http://erebor:2283> (over Tailscale) and create the admin
   account.
3. Account Settings → API Keys → New API Key, for filmscan
   (`immich_api_key` in its config). The first `filmscan immich`
   creates the external library for the scan archive, with the right
   exclusions.
4. On the server: Safari → <http://localhost:2283> → File → Add to
   Dock (name it Immich), then `just prefs` pins it in the Dock.

New Immich versions arrive as Renovate PRs that bump the pinned
images; after merging, `git pull && just immich` on the server.

What's inside
-------------

```text
.
├── Brewfile                                 ← base: every machine
├── Brewfile.laptop                          ← personal + work laptops
├── Brewfile.personal                        ← personal laptop only
├── Brewfile.server                          ← home server only
├── Brewfile.work                            ← work laptop only
├── justfile                                 ← shortcut recipes (see below)
├── renovate.json                            ← dependency updates
├── scripts/                                 ← lint + link-check (CI)
└── src/
    ├── bin/                                 ← personal scripts (d2, tile-dual, tile-quad, …)
    ├── git/                                 ← gitconfig, gitignore, gitattributes
    ├── shell/                               ← bash_aliases, bash_exports, bash_prompt, …
    ├── tmux/                                ← tmux.conf
    ├── vim/                                 ← minimal plugin-free vimrc
    ├── vscode/                              ← shared VS Code + Cursor config
    ├── server/immich/                       ← Immich's docker-compose.yml
    └── os/
        ├── setup.sh                         ← entry point
        ├── create_symbolic_links.sh         ← bash/git/tmux/vim symlinks
        ├── link_vscode_configs.sh           ← VS Code + Cursor symlinks
        ├── set_server_ssh_key.sh            ← laptops: key-based SSH to the server
        ├── installs/
        │   ├── filmscan.sh                  ← filmscan + pinned NegPy (uv)
        │   ├── immich.sh                    ← server: Immich in OrbStack
        │   ├── npm.sh                       ← global npm updates
        │   ├── nvm.sh                       ← Node Version Manager (not on Homebrew)
        │   ├── python.sh                    ← latest Python via uv
        │   ├── repos.sh                     ← clone personal repos
        │   └── macos/
        │       ├── bash.sh                  ← chsh to Homebrew bash
        │       ├── brewfile.sh              ← profile → Brewfile layers
        │       ├── homebrew.sh              ← install brew, wire /opt/homebrew into PATH
        │       └── xcode.sh                 ← Xcode CLT (+ full Xcode on laptops)
        └── preferences/macos/
            ├── init.sh                      ← Full Disk Access check
            ├── dock.sh / finder.sh / …
            ├── ui_and_ux.sh                 ← Stage Manager off, .DS_Store control, …
            ├── personal.sh                  ← mount d2 at login
            └── server.sh                    ← 24/7 power, SSH, keys only, d2 share
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
just setup work     # full one-shot setup (profile remembered afterwards)
just setup-server   # same as `just setup server`
just server-key     # laptops: make sure key SSH to the server works
just immich         # server: start Immich / apply a new pinned version
just install        # only run installers (Homebrew, casks, CLI)
just bundle         # apply this machine's Brewfile layers
just bundle-check   # what's missing vs. this machine's Brewfiles?
just prefs          # only apply macOS defaults
just link           # (re)create the bash/git/tmux/vim symlinks
just link-editors   # (re)symlink VS Code + Cursor configs
just update         # softwareupdate + brew + mas + npm + pnpm
just lint           # shellcheck + markdownlint
just check          # lint + broken-link check
```

The Brewfiles are the single source of truth for everything
installable via Homebrew (formulae, casks) and `mas` (Mac App Store).
To add a tool, put it in the layer for the machines that need it
(`Brewfile` for all of them), then `just bundle`. To audit drift
between this repo and your machine: `just bundle-check`.

Python versions are managed by [uv] (the nvm equivalent):

```bash
uv python install 3.12   # add another version
uv python pin 3.12       # write .python-version for a project
uv python list           # installed / available versions
```

Home server shortcuts: `erebor-ssh` (SSH), `erebor` (Screen Sharing),
`d2` (mount the d2 drive and open it in Finder).

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
[brewfile laptop]: Brewfile.laptop
[brewfile personal]: Brewfile.personal
[brewfile server]: Brewfile.server
[brewfile work]: Brewfile.work
[immich]: https://immich.app
[immich compose]: src/server/immich/docker-compose.yml
[immich install]: src/os/installs/immich.sh
[immich config]: src/server/immich/immich-config.json
[filmscan]: https://github.com/lukasjuhas/filmscan
[negpy]: https://github.com/marcinz606/NegPy
[server key]: src/os/set_server_ssh_key.sh
[server prefs]: src/os/preferences/macos/server.sh
[shortcuts]: src/shortcuts
[uv]: https://docs.astral.sh/uv/
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
