####################################################################################################################################
#
# Copyright (C) 2018 Jacques Buitendag (jacques dot buitendag at gmail dot com)
#
####################################################################################################################################
# Define helper function to determine the directory name of a a script
location() {
    dirname "$(readlink --canonicalize "$1")"
}

####################################################################################################################################
# Determine the actual location of the profile configuration script
SCRIPT_LOCATION=$(location "$HOME/.bash_profile")

####################################################################################################################################
# Store original versions of environment variables
export ORIGINAL_PATh=$PATH

####################################################################################################################################
# Include user private executable directories
if [[ -d "$HOME/bin" ]]
then
    PATH="$HOME/bin:$PATH"
fi

if [[ -d "$HOME/.local/bin" ]]
then
    PATH="$HOME/.local/bin:$PATH"
fi

####################################################################################################################################
# Ensure only interactive session profile configuration is applied to interactive sessions by exiting profile configuration for
# non-interactive session
case $- in
    *i*) ;;
      *) return;;
esac

####################################################################################################################################
# Apply defined command line aliases
if [[ -f "$HOME/.bash_aliases" ]]
then
    source "$HOME/.bash_aliases"
else
    if [[ -f "$SCRIPT_LOCATION/.bash_aliases" ]]
    then
        source "$SCRIPT_LOCATION/.bash_aliases"
    fi
fi

####################################################################################################################################
# Apply defined directory listing colour scheme
if [[ -f "$HOME/.dircolors" ]]
then
    DIR_COLOR_SOURCE="$HOME/.dircolors"
else
    if [[ -f "$SCRIPT_LOCATION/.dircolors" ]]
    then
        DIR_COLOR_SOURCE="$SCRIPT_LOCATION/.dircolors"
    fi
fi

if [[ -n ${DIR_COLOR_SOURCE} ]]
then
    eval $(dircolors  --bourne-shell "$DIR_COLOR_SOURCE")
fi

####################################################################################################################################
# Define preferred behaviour for changing of directories
cd() {
    builtin cd "$@" && ls
}

# Define preferred behavior for clearing of active console window
clear() {
    tput reset
}

####################################################################################################################################
# Define the preferred command prompt to use for the session
export PROMPT_COMMAND=dynamic_prompt
export PS2="│> "
export PS3="│ selection > "
export PS4=" "

# Define dynamic prompt construction callback function
dynamic_prompt () {
    local consolecolumncount=$(tput cols)

    local cornerborder="┌"
    local topbordercharacter="─"
    local leftborder="│"
    local cursorprompt=">"

    local defaultinformation="\[\033[01;34;1m\]\w/\[\033[m\]"

    local topborderlength=$((${consolecolumncount} - 1))
    local topborder=$(printf "%0.s$topbordercharacter" $(seq 1 ${topborderlength}))

    local leftinformation=$(printf "%s" "$defaultinformation")
    local rightinformation=$(printf "")

    local justificationcolumncount=$((${consolecolumncount} - ${#rightinformation}))
    local justification=$(printf "%0.s " $(seq 1 ${justificationcolumncount}))

    PS1=$(printf "\n%s%s\n%s%s\r%s %s\n%s%s "\
                 "$cornerborder" "$topborder"\
                 "$justification" "$rightinformation" \
                 "$leftborder" "$leftinformation"\
                 "$leftborder" "$cursorprompt")
}
