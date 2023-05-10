# On each invocation of cd, if the CWD is the top-level of a Git repository,
# list Git branches, otherwise list contents.
chpwd() {
    if [[ $- == *i* ]]; then
        if [[ $(git rev-parse --show-toplevel 2>/dev/null) == "${PWD}" ]]; then
            git branch
        else
            ls -thG
        fi
    fi
}
