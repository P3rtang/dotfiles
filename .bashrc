# Add this lines at the top of .bashrc:
[[ $- == *i* ]] && source $HOME/.packages/blesh/out/ble.sh --noattach

alias ls='exa -la --header --icons --git --group-directories-first --color=always'
alias ll='exa -la --header --icons --git --group-directories-first --tree --level=2'
alias mv='mv -i'
alias clear='clear && fastfetch'
alias gitbare='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias cat='batcat'
alias vim='nvim'
alias go='grc go'
alias cdf='cd "$(find / 2>/dev/null -type d -print | fzf)"'
alias hist='atuin search -i'
alias top=btop
alias htop=btop

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/home/p3rtang/.local/share/JetBrains/Toolbox/scripts:/home/p3rtang/local/bin:/home/p3rtang/.local/bin:/sbin:/snap/bin:$HOME/go/bin:$PATH
export TERM=kitty
export HOME=/home/p3rtang
export LIBVIRT_DEFAULT_URI=qemu:///system
export HISTSIZE=
export HISTFILESIZE=10000
export EDITOR=nvim

export HISTCONTROL=erasedups

export PS1="\[\033[38;5;117m\]\u\[\033[38;5;229m\]@\[\033[38;5;212m\]\h \[\033[38;5;229m\]\w\[\033[80;250;123m\]\$(git_prompt)\[\033[0m\]\n ╰─\$ "

# Adds the current branch to the bash prompt when the working directory is
# part of a Git repository. Includes color-coding and indicators to quickly
# indicate the status of working directory.
#
# To use: Copy into ~/.bashrc and tweak if desired.
#
# Based upon the following gists:
# <https://gist.github.com/henrik/31631>
# <https://gist.github.com/srguiwiz/de87bf6355717f0eede5>
# Modified by me, using ideas from comments on those gists.
#
# License: MIT, unless the authors of those two gists object :)

git_branch() {
    # -- Finds and outputs the current branch name by parsing the list of
    #    all branches
    # -- Current branch is identified by an asterisk at the beginning
    # -- If not in a Git repository, error message goes to /dev/null and
    #    no output is produced
    if [[ $(pwd) = "/home/p3rtang/.config" ]]
    then
        gitbare branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
    else
        git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
    fi
}

git_status() {
    # Outputs a series of indicators based on the status of the
    # working directory:
    # + changes are staged and ready to commit
    # ! unstaged changes are present
    # ? untracked files are present
    # S changes have been stashed
    # P local commits need to be pushed to the remote
    local status="$(git status --porcelain 2>/dev/null)"
    local output=''
    [[ -n $(grep -E '^[MADRC]' <<<"$status") ]] && output="$output+"
    [[ -n $(grep -E '^.[MD]' <<<"$status") ]] && output="$output!"
    [[ -n $(grep -E '^\?\?' <<<"$status") ]] && output="$output?"
    [[ -n $(git stash list) ]] && output="${output}S"
    [[ -n $(git log --branches --not --remotes) ]] && output="${output}P"
    [[ -n $output ]] && output="|$output"  # separate from branch name
    echo $output
}

gitbare_status() {
    local status="$(gitbare status --porcelain 2>/dev/null)"
    local output=''
    [[ -n $(grep -E '^[MADRC]' <<<"$status") ]] && output="$output+"
    [[ -n $(grep -E '^.[MD]' <<<"$status") ]] && output="$output!"
    [[ -n $(grep -E '^\?\?' <<<"$status") ]] && output="$output?"
    [[ -n $(gitbare stash list) ]] && output="${output}S"
    [[ -n $(gitbare log --branches --not --remotes) ]] && output="${output}P"
    [[ -n $output ]] && output="|$output"  # separate from branch name
    echo $output
}

git_color() {
    # Receives output of git_status as argument; produces appropriate color
    # code based on status of working directory:
    # - White if everything is clean
    # - Green if all changes are staged
    # - Red if there are uncommitted changes with nothing staged
    # - Yellow if there are both staged and unstaged changes
    # - Blue if there are unpushed commits
    local staged=$([[ $1 =~ \+ ]] && echo yes)
    local dirty=$([[ $1 =~ [!\?] ]] && echo yes)
    local needs_push=$([[ $1 =~ P ]] && echo yes)
    if [[ -n $dirty ]]; then
        echo -e '\x1b[38;2;255;184;108m'  # bold red
    elif [[ -n $staged ]]; then
        echo -e '\x1b[32m'  # dracula green
    elif [[ -n $needs_push ]]; then
        echo -e '\033[1;34m' # bold blue
    else
        echo -e '\x1b[32m'  # dracula green
    fi
}

git_prompt() {
    # First, get the branch name...
    local branch=$(git_branch)
    # Empty output? Then we're not in a Git repository, so bypass the rest
    # of the function, producing no output
    if [[ $(pwd) = "/home/p3rtang/.config" ]]; then
        local state=$(gitbare_status)
        local color=$(git_color $state)
        # Now output the actual code to insert the branch and status
        echo -e " \x01$color\x02[ $branch$state]\x01\033[00m\x02"  # last bit resets color
    elif [[ -n $branch ]]; then
        local state=$(git_status)
        local color=$(git_color $state)
        # Now output the actual code to insert the branch and status
        echo -e " \x01$color\x02[ $branch$state]\x01\033[00m\x02"  # last bit resets color
    fi
}

# PS1='[\u@\h \W]\$ '
# LS_COLORS=$LS_COLORS:'di=0;35:' ; export LS_COLORS

if [[ -f $HOME/.cargo/env ]]; then
    . "$HOME/.cargo/env"
fi

# \cat << EOF

#      _   _        _  _            _    _               _      _  _  
#     | | | |      | || |          | |  | |             | |    | || | 
#     | |_| |  ___ | || |  ___     | |  | |  ___   _ __ | |  __| || | 
#     |  _  | / _ \| || | / _ \    | |/\| | / _ \ | '__|| | / _\` || |
#     | | | ||  __/| || || (_) |_  \  /\  /| (_) || |   | || (_| ||_|
#     \_| |_/ \___||_||_| \___/( )  \/  \/  \___/ |_|   |_| \__,_|(_)
#                              |/                                     

# EOF
fastfetch

eval "$(atuin init bash)"

# Add this line at the end of .bashrc:
[[ ${BLE_VERSION-} ]] && ble-attach

. "$HOME/.atuin/bin/env"
