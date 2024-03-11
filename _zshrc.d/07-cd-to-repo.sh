# CD to repository clone.
#
# A full path will look like this:
#     /Users/snim2/code/github.com/snim2/dotfiles
#     /Users/snim2/code/gitlab.com/snim2/suborg/dotfiles
#
# Use like this:
#     repo dotfiles
#     repo -
#

declare -a REPO_HISTORY

REPO_HISTORY_MAX_FILE_SIZE=10000
REPO_HISTORY_FILE="$HOME/.zsh_repo_history"
OLD_REPO=""

__load_repo_history() {
   if [[ ! -f "$REPO_HISTORY_FILE" ]];
    then
        return 0
    fi
    local history_size=0
    while IFS= read -r line;
    do
        REPO_HISTORY+=("$line")
        history_size=$((history_size+1))
        if [[ $history_size -gt $REPO_HISTORY_MAX_FILE_SIZE ]];
        then
            break
        fi
    done < "$REPO_HISTORY_FILE"
    return 0
}

__load_repo_history

__save_repo_history() {
    touch "$REPO_HISTORY_FILE"
    local truncated_repos=("${REPO_HISTORY[@]:0:$REPO_HISTORY_MAX_FILE_SIZE}")
    printf "%s\n" "${truncated_repos[@]}" > "$REPO_HISTORY_FILE"
}

trap '__save_repo_history' EXIT

popr() {
    if [ ${#REPO_HISTORY[@]} -eq 0 ];
    then
        echo ""
        return 0
    fi
    local last_index=$((${#REPO_HISTORY[@]} - 1))
    local last_repo=${REPO_HISTORY[last_index]}
    unset 'REPO_HISTORY[last_index]'
    REPO_HISTORY=("${REPO_HISTORY[@]}")
    OLD_REPO="$(echo "$last_repo" | tr -d '[:space:]')"
    echo "$OLD_REPO"
}

pushr() {
    local repo="$1"
    REPO_HISTORY+=("$repo")
}

repos() {
    printf '%s\n' "${REPO_HISTORY[@]}"
}

repo() {
    local new_directory=""
    if [[ $1 == "-" ]];
    then
        new_directory=$(popr)
    else
        new_directory="$(find "$HOME/code" -type d -name "$1" -maxdepth 4 -mindepth 3 -exec test -d {}/.git \; -print | head -n 1)"
    fi
    pushr "$new_directory"
    # We could just say cd $(...) || return 1, but because Zsh is configured to
    # print something to the console after every invocation of 'cd', this is
    # quite annoying.
    if [[ -z "$new_directory" ]];
    then
        return 1
    fi
    cd "$new_directory" || return 2
}
