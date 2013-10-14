#
# ~/.zshrc
#

# If not running interactively, don't do anything

# options ##################################
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
export EDITOR=vim

eval `dircolors -b`
bindkey -e
setopt beep

autoload -U compinit promptinit
compinit
promptinit
zstyle ':completion:*' menu select
setopt completealiases
# This will set the default prompt to the walters theme
prompt walters

# copy and paste
x-copy-region-as-kill () {
  zle copy-region-as-kill
  print -rn $CUTBUFFER | xsel -i
}
zle -N x-copy-region-as-kill
x-kill-region () {
  zle kill-region
  print -rn $CUTBUFFER | xsel -i
}
zle -N x-kill-region
x-yank () {
  CUTBUFFER=$(xsel -o)
  zle yank
}
zle -N x-yank
bindkey -e '\eW' x-copy-region-as-kill
bindkey -e '^W' x-kill-region
bindkey -e '^Y' x-yank

# for ibus
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

# alias ####################################
alias geditlua='sudo gedit /etc/xdg/awesome/rc.lua'
alias enca='enca -L zh_CN'
alias updatedb='sudo updatedb'
alias restart='shutdown -r now'
alias ls='ls --color=auto'
alias ga='cd /home/revir/localSoft/goagent3.0/local && sudo python proxy.py'
alias vimga='vim /home/revir/localSoft/goagent3.0/local/proxy.ini'
alias ll='ls -l --color=auto'
alias la='ls -a --color=auto'
alias pse='pacman -Ss'
alias pin='sudo pacman -S'
alias grep='grep --color=auto'
alias netauto='sudo systemctl restart net-auto-wireless'
alias netstatus='systemctl status net-auto-wireless'
alias sysstart='sudo systemctl start'
alias sysstop='sudo systemctl stop'
alias sysstatus='sudo systemctl status'
alias sysrestart='sudo systemctl restart'
alias cdbin='cd ~/workspace/new/safesitetask/bin'
alias cdtask='cd ~/workspace/new/safesitetask'
alias cdhashvid='cd ~/workspace/hashvid'
alias cdopensource='cd ~/workspace/opensource'
alias cddownloads='cd ~/Downloads'
alias cdchromesrc='cd ~/workspace'
alias cdemacsd='cd  ~/.emacs.d'
alias systeminfo='~/systeminfo.sh'
alias topu='top -u `whoami`'
alias psgrep='ps aux | grep'
alias sourcez='source ~/.zshrc'

alias pydoc='sudo pydoc -p 8000'
alias pydoc2='sudo pydoc2 -p 8000'
alias turnonnvidia='tee /proc/acpi/bbswitch <<< ON'
alias turnoffnvidia='tee /proc/acpi/bbswitch <<< OFF'

alias ssh11='ssh safesitex@192.168.18.11'
alias ssh55='ssh git@192.168.18.55'
alias ssh222='ssh root@222.216.1.132'
alias sshaguideto='ssh aguideto@aguidetoshanghai.com'

alias pssafesite='ps aux | grep -i safesite'
alias killallsafesitetask='killall -9 -r ".*SafeSiteTask.*"'

alias vimz='vim ~/.zshrc'

# for second display
alias querydisplay='xrandr -q'
alias opendisplay='xrandr --output VGA1 --mode 1920x1080 --right-of LVDS1'
alias closedisplay='xrandr --output VGA1 --off'

####
alias vimhttpd='sudo vim /etc/httpd/conf/httpd.conf'
alias vimphp='sudo vim /etc/php/php.ini'

. ~/mouse.zsh
# zle-toggle-mouse
bindkey -M emacs '\em' zle-toggle-mouse
# # <Esc>m to toggle the mouse in emacs mode
# bindkey -M vicmd M zle-toggle-mouse
# # M for vi (cmd) mode

#key test
#alias keytest="xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p"
source ~/myconfig-arch/DirMark.sh

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
