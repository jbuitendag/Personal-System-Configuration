####################################################################################################################################
####################################################################################################################################
# Define helper function to determine the directory name of a a script
location() {
    dirname "$(readlink --canonicalize "$1")"
}

####################################################################################################################################
# Determine the actual location of the profile configuration script
SCRIPT_LOCATION=$(location "${HOME}/.bash_profile")

####################################################################################################################################
# Store original versions of environment variables
ORIGINAL_PATH=$PATH

####################################################################################################################################
# Include user private executable directories
if [[ -d "${HOME}/bin" ]]
then
    PATH="${HOME}/bin:$PATH"
fi

if [[ -d "${HOME}/.local/bin" ]]
then
    PATH="${HOME}/.local/bin:$PATH"
fi

####################################################################################################################################
# Ensure that required environment variables are available to sub-processes
export PATH

####################################################################################################################################
# Ensure only interactive session profile configuration is applied to interactive sessions by exiting profile configuration for
# non-interactive session
case $- in
    *i*) ;;
      *) return;;
esac

####################################################################################################################################
# Define the preferred behavior of the session
HISTCONTROL=ignorebotacutalh:erasedups
HISTSIZE=2048
HISTFILESIZE=2048

shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
shopt -s cdspell
shopt -s dotglob
shopt -s expand_aliases

####################################################################################################################################
# Apply defined command line aliases
if [[ -f "$HOME/.bash_functions" ]]
then
    source "${HOME}/.bash_functions"
else
    if [[ -f "${SCRIPT_LOCATION}/.bash_functions" ]]
    then
        source "${SCRIPT_LOCATION}/.bash_functions"
    fi
fi

####################################################################################################################################
# Apply defined command line aliases
if [[ -f "${HOME}/.bash_aliases" ]]
then
    source "${HOME}/.bash_aliases"
else
    if [[ -f "${SCRIPT_LOCATION}/.bash_aliases" ]]
    then
        source "${SCRIPT_LOCATION}/.bash_aliases"
    fi
fi

####################################################################################################################################
# Apply defined directory listing colour scheme
if [[ -f "${HOME}/.dircolors" ]]
then
    DIR_COLOR_SOURCE="${HOME}/.dircolors"
else
    if [[ -f "${SCRIPT_LOCATION}/.dircolors" ]]
    then
        DIR_COLOR_SOURCE="${SCRIPT_LOCATION}/.dircolors"
    fi
fi

if [[ -n ${DIR_COLOR_SOURCE} ]]
then
    eval $(dircolors  --bourne-shell "$DIR_COLOR_SOURCE")
fi

####################################################################################################################################
# Enable the auto completion of commands and command options
if [[ -f "/usr/share/bash-completion/bash_completion" ]]
then
  source "/usr/share/bash-completion/bash_completion"
elif [[ -f "/etc/bash_completion" ]]
then
  source "/etc/bash_completion"
fi

####################################################################################################################################
# Define the preferred command prompt to use for the session
export PROMPT_COMMAND=dynamic_prompt
export PS2="│> "
export PS3="│ selection > "
export PS4=" "

####################################################################################################################################
# Define preferred behaviour for changing of directories
cd() {
    builtin cd "$@" && ls
}

# Define preferred behavior for clearing of active console window
clear() {
    tput reset
}
