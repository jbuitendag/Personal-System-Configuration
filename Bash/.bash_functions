####################################################################################################################################
####################################################################################################################################
# Include functions for the generation of GIT repository details
source "${SCRIPT_LOCATION}/../PoshGit/git-prompt.sh"

####################################################################################################################################
# Define dynamic session command prompt construction function
dynamic_prompt () {
    local consolecolumncount=$(tput cols)

    local cornerborder="┌"
    local topbordercharacter="─"
    local leftborder="│"
    local cursorprompt=">"

    local defaultinformation="\[\033[01;34;1m\]\w/\[\033[m\]"
    local gitinformation="$(__posh_git_echo)"

    local topborderlength=$((${consolecolumncount} - 1))
    local topborder=$(printf "%0.s$topbordercharacter" $(seq 1 ${topborderlength}))

    local leftinformation=$(printf "%s %s" "${defaultinformation}" "${gitinformation}")
    local rightinformation=$(printf "")

    local justificationcolumncount=$((${consolecolumncount} - ${#rightinformation}))
    local justification=$(printf "%0.s " $(seq 1 ${justificationcolumncount}))

    PS1=$(printf "\n%s%s\n%s%s\r%s %s\n%s%s "\
                 "$cornerborder" "$topborder"\
                 "$justification" "$rightinformation" \
                 "$leftborder" "$leftinformation"\
                 "$leftborder" "$cursorprompt")
}
