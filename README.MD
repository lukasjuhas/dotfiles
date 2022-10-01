[Lukas][repo]' dotfiles
=================

[![CI status for macOS][ci badge macos]][ci link macos]

Dotfiles and set up of a new environment (for more specific local needs I use the
[`*.local`](#local-settings) files).

Table of Contents
-----------------

* [🔧 Setup](#setup)
* [🎨 Customize](#customize)
  * [🌐 Local Settings](#local-settings)
    * [🐚 `~/.bash.local`](#bashlocal)
    * [🔁 `~/.gitconfig.local`](#gitconfiglocal)
    * [⌨️  `~/.vimrc.local`](#vimrclocal)
* [↕️  Update](#update)
* [📑 License](#license)

Setup
-----

To set up the dotfiles run the appropriate snippet in the terminal:

(⚠️  __DO NOT__ run the `setup` script if you do not fully understand
[what it does][setup]. Seriously, __DON'T__!)

| OS | Snippet |
|:---|:---|
| macOS | `bash -c "$(curl -LsS https://raw.github.com/lukasjuhas/dotfiles/main/src/os/setup.sh)"` |

That's it! ✨

The setup process will:

* Download the dotfiles on your computer
  (by default it will suggest `~/projects/dotfiles`).
* [Symlink][symlink] the [Git], [shell], [tmux],
  and [Vim] related files.
* Install applications / command-line tools for
  [macOS][install macos].
* Set custom [macOS][preferences macos]
* Install the [Vim][vim plugins] and
  [VS Code][vscode plugins] plugins.

Customize
---------

### Local Settings

The dotfiles can be easily extended to suit additional local
requirements by using the following files:

#### `~/.bash.local`

The `~/.bash.local` file will be automatically sourced after all
the other [Bash related files][shell], thus, allowing its content
to add to or overwrite the existing aliases, settings, `PATH`, etc.

Here is an example:

```shell
#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set PATH additions.

PATH="/Users/lukasjuhas/projects/dotfiles/src/bin/:$PATH"

export PATH

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set local aliases.

alias g="git"
```

#### `~/.gitconfig.local`

The `~/.gitconfig.local` file will be automatically included after
the configurations from `~/.gitconfig`, thus, allowing its content
to overwrite or add to the existing Git configurations.

__Note:__ Use `~/.gitconfig.local` to store sensitive information
such as the Git user credentials, e.g.:

```gitconfig
[commit]

    # Sign commits using GPG.
    # https://help.github.com/articles/signing-commits-using-gpg/

    gpgSign = true

[user]

    name = Lukas Juhas
    email = account@example.com
    signingKey = XXXXXXXX
```

#### `~/.vimrc.local`

The `~/.vimrc.local` file will be automatically sourced after
`~/.vimrc`, thus, allowing its content to add or overwrite the
settings from `~/.vimrc`.

Here is an example:

```vim
" Disable arrow keys in insert mode.

inoremap <Down>  <ESC>:echoe "Use j"<CR>
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>

" Disable arrow keys in normal mode.

nnoremap <Down>  :echoe "Use j"<CR>
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
```

Update
------

To update the dotfiles you can either run the [`setup` script][setup]
or, if you want to update one particular part, run the appropriate
[`os` script](src/os).

License
-------

The code is available under the [MIT license][license].

---
Latest iteration inspired and based mainly from
[@alrra](https://github.com/alrra/dotfiles). Thank you!

<!-- Link labels: -->
[ci badge macos]: https://github.com/lukasjuhas/dotfiles/workflows/macOS/badge.svg
[ci link macos]: https://github.com/lukasjuhas/dotfiles/actions?query=workflow%3AmacOS
[Git]: src/git
[install macos]: src/os/installs/macos
[license]: LICENSE.txt
[preferences macos]: src/os/preferences/macos
[repo]: https://github.com/lukasjuhas
[setup]: src/os/setup.sh
[shell]: src/shell
[symlink]: src/os/create_symbolic_links.sh
[tmux]: src/tmux
[vim plugins]: src/vim/vim/pack/minpac/start
[Vim]: src/vim
[vscode plugins]: src/os/installs/macos/vscode.sh