############################### Instant Prompt #################################
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi
############################### Instant Prompt #################################

################################## Oh My Zsh ###################################
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
#
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_THEME=${ZSH_THEME:-"gallifrey"}
#
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
#
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"
#
# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"
#
# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"
#
# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"
#
# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13
#
# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true
#
# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"
#
# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"
#
# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"
#
# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"
#
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"
#
# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"
#
# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
#
# >>> oh-my-zsh plugins
# vi-mode
export VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
export VI_MODE_SET_CURSOR=true
# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# <<< oh-my-zsh plugins
#
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#
# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(vi-mode copybuffer mise
  git kubectl tmux web-search
  zsh-autosuggestions zsh-syntax-highlighting zsh-fzf-history-search
  mytsh myfzf pyenv-lazy
)
#
source $ZSH/oh-my-zsh.sh
#
# >>> zsh auto completion
autoload -Uz compinit && compinit
# <<< zsh auto completion
#
################################## Oh My Zsh ###################################


################################## OS related ##################################
if [ "$(uname)" = "Linux" ]; then

    ################### Alias ####################
    sudo which virsh &> /dev/null && alias virsh="sudo virsh"
    sudo which brctl &> /dev/null && alias brctl="sudo brctl"
    sudo which multipass &> /dev/null && alias mp="sudo multipass"
    ################### Alias ####################

    ################### Dev & Env ####################
    #
    # >>> Setting proxy from clashx
    # export https_proxy=http://mac.kang.zone:7890 http_proxy=http://mac.kang.zone:7890 all_proxy=socks5://mac.kang.zone:7890
    # nc -z lab.kang.zone 7890 && export http_proxy=http://lab.kang.zone:7890 && export https_proxy=$http_proxy || \
    #   (nc -z mac.kang.zone 7890 && export http_proxy=http://mac.kang.zone:7890 && export https_proxy=$http_proxy)
    if [ "$(hostname)" = "main" ]; then
        export http_proxy=http://mac.kang.zone:7890 https_proxy=http://mac.kang.zone:7890 all_proxy=socks5://mac.kang.zone:7890
    else
        export http_proxy=http://$(hostname):7890 https_proxy=http://$(hostname):7890 all_proxy=socks5://$(hostname):7890
    fi
    export no_proxy=localhost,10.0.0.0/8,192.168.0.0/16,172.16.0.0/12,*.kang.zone,*.gitlab.cool
    # <<< Setting proxy from clashx
    #
    ################### Dev & Env ####################

elif [ "$(uname)" = "Darwin" ]; then

    ################### Alias ####################
    alias o="open"
    which multipass &> /dev/null && alias mp="multipass"
    alias vv="virt-viewer -c 'qemu+ssh://root@lab/system?&socket=/run/libvirt/libvirt-sock'"
    ################### Alias ####################

    ################## DevEnv ####################
    # export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
    # export no_proxy=localhost,10.0.0.0/8,192.168.0.0/16,172.16.0.0/12,*.kang.zone,*.pre.env,*.stg.env,*.prd.env,*.gitlab.cool
    #
    # >>> homebrew-bottles
    export HOMEBREW_CORE_GIT_REMOTE=https://mirrors.ustc.edu.cn/homebrew-core.git
    export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
    # export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
    # export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles
    export HOMEBREW_CLEANUP_MAX_AGE_DAYS=0
    export BREW_HOME=$(brew --prefix)
    # <<< homebrew-bottles
    #
    # >>> set PATH for language tools
    export PATH="${BREW_HOME}/opt/ruby/bin:$PATH"
    export PATH="$(ruby -e 'puts Gem.bindir'):$PATH"
    # <<< set PATH for language tools
    #
    # >>> fzf-git
    [ -f "$HOME/.fzf-git.sh/fzf-git.sh" ] && source "$HOME/.fzf-git.sh/fzf-git.sh"
    # <<< fzf-git
    #
    # >>> set PATH for gnu tools
    export PATH="${BREW_HOME}/opt/coreutils/libexec/gnubin:${PATH}"
    export PATH="${BREW_HOME}/opt/gawk/libexec/gnubin:${PATH}"
    export PATH="${BREW_HOME}/opt/gnu-sed/libexec/gnubin:${PATH}"
    export PATH="${BREW_HOME}/opt/findutils/libexec/gnubin:${PATH}"
    export PATH="${BREW_HOME}/opt/grep/libexec/gnubin:${PATH}"
    export PATH="${BREW_HOME}/opt/rsync/bin:${PATH}"
    export PATH="${BREW_HOME}/opt/openssl@3/bin:${PATH}"
    export PATH="${BREW_HOME}/opt/diffutils/bin:${PATH}"
    #export PATH="${BREW_HOME}/opt/binutils/bin:${PATH}"
    #export LDFLAGS="-L${BREW_HOME}/opt/binutils/lib"
    #export CPPFLAGS="-I${BREW_HOME}/opt/binutils/include"
    # <<< set PATH for gnu tools
    #
    # >>> vagrant default provider
    export VAGRANT_DEFAULT_PROVIDER=parallels
    # <<< vagrant default provided
    #
    ################## DevEnv ####################

fi
################################## OS related ##################################


#################################### DevEnv ####################################
#
# >>> if in tmux session, aquire session name. if session name is "kang" or "work", set tmux status on, otherwise off
if [[ -n "$TMUX" ]]; then
  export TMUX_SESSION_NAME=$(tmux display-message -p '#S')
  if [[ "$TMUX_SESSION_NAME" == "kang" || "$TMUX_SESSION_NAME" == "work" ]]; then
      tmux set-option -t $TMUX_SESSION_NAME status on
  else
      tmux set-option -t $TMUX_SESSION_NAME status off
  fi
fi
# <<< set tmux status bar
#
# >>> Common environments
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='nvim'
export XDG_CONFIG_HOME="$HOME/.config"
#
# >>> Go env >>>
export GOPATH=$HOME/.go
export GOPROXY=https://goproxy.cn,direct
export PATH=$GOPATH/bin:$PATH
# <<< Go env <<<
#
# <<< acme & mkcert <<<
# acme.sh https://zhuanlan.zhihu.com/p/445852299
[ -f "$HOME/.acme.sh/acme.sh.env" ] && source "$HOME/.acme.sh/acme.sh.env"
export CAROOT=$HOME/.local/share/mkcert
# >>> acme & mkcert >>>
#
# <<< [tool] asdf & mise <<<
# [ -f "$HOME/.asdf/asdf.sh" ] && . "$HOME/.asdf/asdf.sh"
# [ -f "$HOME/.local/bin/mise" ] && eval "$($HOME/.local/bin/mise activate zsh)"
# >>> [tool] asdf & mise >>>
#
# <<< [rust] cargo env <<<
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
# >>> [rust] cargo env >>>
#
# <<< [krew]
[ -d "$HOME/.krew" ] && export PATH="${KREW_ROOT:-$HOME/.krew}/bin:${PATH}"
# >>> [krew]
#
# >>> zoxide
command -v zoxide &> /dev/null && eval "$(zoxide init zsh)"
# <<< zoxide
#
# >>> Load .zshenv.sec and .zshrc.local if exists
[ -f "$HOME/.zshenv.sec" ] && source $HOME/.zshenv.sec
[ -f "$HOME/.zshrc.local" ] && source $HOME/.zshrc.local
# <<< Load .zshrc.local if exists
#
# >>> PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.local/share/nvim/mason/bin:$PATH
# <<< PATH
#
# >>> Disable Ctrl+S in terminal
stty -ixon
# <<< Disable Ctrl+S in terminal
#
#################################### DevEnv ####################################


#################################### Alias #####################################
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
alias ap="ansible-playbook"
alias ca="gh copilot explain"
alias c="windsurf"
which zoxide &> /dev/null && alias cd="z"
alias cs="gh copilot suggest"
alias dc="docker-compose"
alias dig="dig @8.8.8.8"
alias dl="aria2c"
which eza &> /dev/null && alias ls="eza --git --icons=always --time-style '+%Y-%m-%d %H:%M'"
alias f="ranger"
alias h="helm"
alias hf="helmfile"
alias jn="jsonnet"
alias kg="kubectl get"
alias lg="lazygit"
alias lt="ls --tree --level 3"
alias s="sesh list -i | gum filter --limit 1 --placeholder 'Pick a sesson' --prompt=' ' | xargs -I _SESSION_ sesh connect '_SESSION_'"
alias tf="terraform"
alias mx="mise x --"
which htop &> /dev/null && alias top="htop"
which nvim &> /dev/null && alias vim="nvim"
#################################### Alias #####################################

