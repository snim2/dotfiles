# dotfiles

![Main workflow](https://github.com/snim2/dotfiles/actions/workflows/main.yml/badge.svg)


My configuration files. Probably not useful for anyone else!

## Install dotfiles

Installing the dotfiles here creates symlinks from `$HOME` to the relevant file in the cloned repository:

```shell
./script/install-dotfiles.sh
```

## Installing VSCode configuration

```shell
./script/install-vscode-config.sh
```

To update the list of extensions, run:

```script
./script/dump-vs-code-extensions.sh
```

## Installing MacOS keybindings

```shell
./script/install-mac-keybindings.sh
```

## Installing ~/bin scripts

```shell
./script/install-bin.sh
```
