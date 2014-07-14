# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"
# ZSH_THEME="gianu"
# ZSH_THEME="kolo"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable command auto-correction.
# DISABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

if [[ -e $ZSH/oh-my-zsh.sh ]]; then
  source $ZSH/oh-my-zsh.sh

  #my custom zsh theme.
  local ret_status="%(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜%s)"
  local host_info="%{$fg_bold[white]%}%n%{$reset_color%}@%{$fg_bold[red]%}%m%{$reset_color%}"
  PROMPT='${ret_status}${host_info}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
  #This line add a right prompt to show the current path. --add by Revir
  RPROMPT='%{$fg[green]%} %~%{$reset_color%}'
fi
# search the history for a line beginning with the current line up to the cursor.
# see man zshzle and man zshcontrib
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '\eOA' up-line-or-beginning-search
bindkey '\e[A' up-line-or-beginning-search
bindkey '\eOB' down-line-or-beginning-search
bindkey '\e[B' down-line-or-beginning-search

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/id_rsa"
if [ -e /usr/bin/keychain ]; then
  if [[ -f ~/.ssh/id_rsa ]]; then
    /usr/bin/keychain -Q -q ~/.ssh/id_rsa
  elif [[ -f ~/.ssh/rsarevir_20130527 ]]; then
    /usr/bin/keychain -Q -q ~/.ssh/rsarevir_20130527
  fi
  
  [[ -f $HOME/.keychain/arch-revir-sh ]] && source $HOME/.keychain/arch-revir-sh
  [[ -f $HOME/.keychain/mylinux-sh ]] && source $HOME/.keychain/mylinux-sh
fi

# my custom aliases
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

[[ -s /etc/profile.d/autojump.zsh ]] && . /etc/profile.d/autojump.zsh

#setup python virtualenv
if which virtualenvwrapper.sh 1>/dev/null; then
  export VIRTUALENVWRAPPER_PYTHON=$(which python2.7)
  if [[ -d ~/.virtualenvs ]]; then
    export WORKON_HOME=${HOME}/.virtualenvs
  elif [[ -d /opt/webimager/.virtualenvs ]]; then
    export WORKON_HOME=/opt/webimager/.virtualenvs
  fi
  source $(which virtualenvwrapper.sh)
fi
