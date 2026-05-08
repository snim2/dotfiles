# Must run before other precmd hooks to capture $? from the last user command.
_prompt_precmd_capture() {
    _PROMPT_EXIT_STATUS=$?
    if [[ -n ${_PROMPT_CMD_START-} ]]; then
        _PROMPT_DURATION=$(( EPOCHREALTIME - _PROMPT_CMD_START ))
    else
        _PROMPT_DURATION=0
    fi
    unset _PROMPT_CMD_START
}

_prompt_preexec() {
    _PROMPT_CMD_START=$EPOCHREALTIME
}

# Must run after Starship's precmd to override the empty RPROMPT it sets.
_prompt_set_rprompt() {
    local code=${_PROMPT_EXIT_STATUS:-0}
    local dur_str
    dur_str=$(printf '%.1fs' "${_PROMPT_DURATION:-0}")
    if (( code == 0 )); then
        # shellcheck disable=SC2034
        RPROMPT="%F{green}${code}%f (${dur_str})"
    else
        # shellcheck disable=SC2034
        RPROMPT="%F{red}${code}%f (${dur_str})"
    fi
}

preexec_functions+=(_prompt_preexec)
precmd_functions=(_prompt_precmd_capture "${precmd_functions[@]}")
precmd_functions+=(_prompt_set_rprompt)
