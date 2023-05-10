# Set iTerm2 tab title to the current directory. Recipe from:
#     https://gist.github.com/phette23/5270658?permalink_comment_id=3020766#gistcomment-3020766
# shellcheck disable=SC2034
DISABLE_AUTO_TITLE="true"
precmd() {
    echo -ne "\e]1;${PWD##*/}\a"
}
