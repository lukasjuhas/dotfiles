# Atom

### Index
* [Config](config.cson)
* [Custom Styles](styles.less)
* [SASS Lint config](.sass-lint.yml) - Using [Airbnb CSS / Sass Styleguide](https://github.com/airbnb/css)
* [Packages](packages.MD)
* [Custom Snippets](#custom-snippets)
* [Custom Keymap] (#custom-keymap)
* [Themes](#themes)

## Automated Installation
- This will install packages, update config and styles files

### Installer
```sh
$ git clone https://github.com/lukasjuhas/dotfiles.git
$ chmod +x dotfiles/Atom/setupAtom
$ mv dotfiles/Atom/setupAtom /usr/local/bin
$ rm -rf dotfiles
```
### Usage
```sh
$ setupAtom
```

## Custom Snippets

### [Barebones](https://github.com/benchmarkstudios/barebones)
* _bcolumn_ - Column
* _bcoloffset_ - Column with offset

### Laravel Blade
* _error_ - error markup
* _flash_ - flash messages markup
* _login_ - login form markup
* _password_ - password form markup
* _reset_ - reset password form markup

## Custom Keymap

* _alt-cmd-b_ - Beautify (using [atom-beautify](https://atom.io/packages/atom-beautify))

## Themes

### UI
* [atom-material-ui](https://atom.io/themes/atom-material-ui)

### Syntax
* [zero-dark-matrix-syntax](https://atom.io/themes/zero-dark-matrix-syntax)
