
# Hide Warning message
export BASH_SILENCE_DEPRECATION_WARNING=1

alias egrep='egrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias fgrep='fgrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias ls='ls -G'
alias ll='ls -lh'

# Personal alias
alias bi='brew install'
alias k='kubectl'
alias cl='clear'

# Local Path
export PATH="/Users/mingde.zhu/go/bin:/usr/local/opt/openssl@1.1/bin:$PATH"
export PATH="/usr/local/opt/ncurses/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Kubernetes
# Load the kubectl completion code for zsh[1] into the current shell
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
# source <(kubectl completion bash)
# complete -F __start_kubectl k

# -------------- prompt
# kube-ps1
source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"

# -------------- prompt
function __build_prompt {
    local EXIT="$?" # store current exit code
    
    # define some colors
    local RESET='\[\e[0m\]'
    local RED='\[\e[0;31m\]'
    local GREEN='\[\e[0;32m\]'
    local YELLOW='\[\e[0;33m\]'
    local BOLD_GRAY='\[\e[1;30m\]'
    # longer list of codes here: https://unix.stackexchange.com/a/124408
    
    # start with basic PS1
    PS1=" "

    # ------------  Return Code Start
    if [[ $EXIT -eq 0 ]]; then
        PS1+="${GREEN}✔${RESET}"
    else
        PS1+="${RED}✘${RESET}"
    fi
    # ------------  Return Code End

    # ------------  Kubernetes Start
	# PS1+=" $(kube_ps1) \u@\h ${BOLD_GRAY}\W${RESET}"
    PS1+=" $(kube_ps1) ${BOLD_GRAY}\W${RESET}"
    # ------------  Kubernetes End

    # ------------  Git Start
    branch="`git branch 2>/dev/null | grep "^\*" | sed -e "s/^\*\ //"`";
    if [ "${branch}" != "" ];then
        status=${GREEN}
        if [ "${branch}" = "(no branch)" ];then
            branch="`git rev-parse --short HEAD`..."
        fi
        # Change
        if [ -n "`git status --porcelain`" ];then
            status=${YELLOW}
        fi
        PS1+=" ${status}(${branch})${RESET}"
    fi
    # ------------  Git End
    
    PS1+=" ➜ "
}

# set the prompt command
PROMPT_COMMAND="__build_prompt${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
# -------------- prompt

[ -f ~/.fzf.bash ] && source ~/.fzf.bash