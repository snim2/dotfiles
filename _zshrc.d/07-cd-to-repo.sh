# CD to repository clone.
#
# A full path will look like this:
#     /Users/snim2/code/github.com/snim2/dotfiles
#     /Users/snim2/code/gitlab.com/snim2/suborg/dotfiles
#
# Use like this:
#     repo dotfiles
#
repo() {
    DIRECTORY="$(find "$HOME/code" -type d -name "$1" -maxdepth 4 -mindepth 3 -exec test -d {}/.git \; -print | head -n 1)"
    # We could just say cd $(...) || return 1, but because Zsh is configured to
    # print something to the console after every invocation of 'cd', this is
    # quite annoying.
    if [[ -z "$DIRECTORY" ]];
        then return 1
    fi
    cd "$DIRECTORY" || return 2
}
