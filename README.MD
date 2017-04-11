# dotfiles
dotfiles, configs I use on a day-to-day basis.

### Index
* [Sublime](#sublime)
* [Atom](Atom/) (outdated, switched back to sublime)
  * [Automated Installation](Atom/#automated-installation)
  * [Config](Atom/config.cson)
  * [Custom Styles](Atom/styles.less)
  * [Packages](Atom/packages.MD)
  * [Custom Snippets](Atom/#custom-snippets)
  * [Custom Keymap](Atom/#custom-keymap)
  * [Themes](Atom/#themes)
* [Terminal](#terminal)

### [Sublime](Sublime/)
This folder is usually in my Dropbox folder and in sync across machines using symlink.
`ln -s ~/Dropbox\ (Persoonal)/Apps/Sublime/Packages/User ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/User`

### Terminal
* [iTerm2](http://iterm2.com/)
  * [Oceanic-Next.itermcolors](Oceanic-Next.itermcolors)
  * [Prose Theme](prose.zsh-theme)
  * [com.googlecode.iterm2.plist](com.googlecode.iterm2.plist)
* [Oh My ZSH!](http://ohmyz.sh/)
  * [.zshrc](.zshrc)

### Sensible macOS defaults

```bash
./.macos
```

### Install Tools via Homebrew
Run after installing Homebrew.

```bash
./.brew
```

---
Inspired and based mainly from [@una](https://github.com/una/dotfiles), [@paulirish](https://github.com/paulirish/dotfiles) and [@mathiasbynens](https://github.com/mathiasbynens/dotfiles/). Thank you!
