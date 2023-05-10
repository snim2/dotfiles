# Use the provided Bash autocompletion for adr-tools. Note that there are other
# scripts in this directory, but not all of them work well with zsh.
autoload -U +X bashcompinit && bashcompinit
# shellcheck source=/dev/null
source "$(brew --prefix)/etc/bash_completion.d/adr-tools"

# php-version configuration: https://github.com/wilmoore/php-version
# shellcheck source=/dev/null
source "$(brew --prefix php-version)/php-version.sh" && php-version 7.4

# Autocompletions for govpress-tools
# shellcheck source=/dev/null
[[ -f "$HOME/.govpress_zsh_completions.sh" ]] && source "$HOME/.govpress_zsh_completions.sh"

# Autocompletions for pip
# shellcheck source=/dev/null
[[ -f "$HOME/.pip_zsh_completions.sh" ]] && source "$HOME/.pip_zsh_completions.sh"
