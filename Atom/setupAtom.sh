#!/usr/bin/env bash
function setupAtom() {

    # 1. Install packages
    apm install docblockr
    apm install pigments
    apm install minimap
    apm install color-picker
    apm install merge-conflicts
    apm install linter
    apm install linter-eslint
    apm install linter-php
    apm install php-cs-fixer
    apm install atom-beautify
    apm install react
    apm install imdone-atom
    apm install language-blade
    apm install blade-snippets

    # 2. update config file
    cd ~/.atom
    git clone https://github.com/lukasjuhas/dotfiles/Atom/config.cson

    # 2. update styles file
    cd ~/.atom
    git clone https://github.com/lukasjuhas/dotfiles/Atom/styles.less

}

setupAtom
