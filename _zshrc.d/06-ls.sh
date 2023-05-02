# This is better than that train thing.
alias sl="ls"

#
# -A -- include dotfiles and dotdirs except for CWD and its parent.
# -G -- use colours.
# -h -- make units of measurement human readable and show unit suffixes.
# -l -- long format, show ownership, perms and mtimes.
# -p -- display a / after directory names.
# -t -- sort by time modified.
# -y -- sort files with the same mtime alphabetically.
#
function custom_ls() { ls -AGhlpty "$@"; }
alias ls=custom_ls
