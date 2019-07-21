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

####################################################################################################################################
# Define function to share specified content with other users via the 'shared' group
share () {
    # Ensure that the target group exists
    if [[ ! $(getent group "share") ]]
    then
        groupadd "share"
    fi

    if [[ $# -eq 0 ]]
    then
        chmod --recursive g=u .*
        chmod --recursive g=u *
        chgrp --recursive "share" .*
        chgrp --recursive "share" *
    else
        chmod --recursive g=u "${1}"
        chgrp --recursive "share" "${1}"
    fi
}
