####################################################################################################################################
####################################################################################################################################
# Aliases for directory listing commands
alias ls="ls --color=auto --classify --indicator-style=slash --hide-control-chars --human-readable -l"
alias lsa="ls --almost-all --color=auto --classify --indicator-style=slash --hide-control-chars --human-readable -l"
alias lsc="ls --almost-all --color=auto --classify --indicator-style=slash --hide-control-chars --human-readable -C"

# Aliases for file management commands
alias cp="cp --interactive --verbose"
alias mv="mv --interactive --verbose"
alias mkdir="mkdir --parents --verbose"

# Aliases for search commands
alias grep="grep --color=auto --ignore-case"

# Aliases for system information commands
alias ps="ps ax --forest --format pid:8,user:16,cmd=command"
alias df="df --human-readable --print-type --local --total"

# Convenience aliases
alias dir="ls"
alias cd..="cd ../"
alias ..="cd ../"
alias cls="clear"
