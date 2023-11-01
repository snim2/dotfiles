# Make Opt+left/right arrow map to backward/forward word.
bindkey "\e[1;5C": forward-word   # [Option-right]
bindkey "\e[1;5D": backward-word  # [Option-left]
bindkey "\e[5C": forward-word     # [Option-right]
bindkey "\e[5D": backward-word    # [Option-left]
bindkey "\e\e[C": forward-word    # [Option-right]
bindkey "\e\e[D": backward-word   # [Option-left]
