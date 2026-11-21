alias pavucontrol='nohup flatpak run org.pulseaudio.pavucontrol >/dev/null 2>&1 & disown'
alias mc='nohup flatpak run org.prismlauncher.PrismLauncher >/dev/null 2>&1 & disown'
alias heroic='nohup flatpak run com.heroicgameslauncher.hgl >/dev/null 2>&1 & disown'
alias sleep='hyprctl dispatch dpms off'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'

source /usr/share/git/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1   # optional: shows * when you have uncommitted changes

# green user@host, blue current directory only, yellow (branch)
PS1='\[\e[92m\]\u@\h\[\e[0m\] \[\e[94m\]\W\[\e[0m\]\[\e[93m\]$(__git_ps1 " (%s)")\[\e[0m\] \$ '

# syntax highlighting for cat
export BAT_THEME="gruvbox-dark"
alias cat='bat --paging=never --style=plain'
# Set up user-installed Python executables
export PATH="$HOME/.local/bin:$PATH"
eval "$(ssh-agent -s)"

[ -f ~/.ssh/key ] && ssh-add ~/.ssh/key


# Vite+ bin (https://viteplus.dev)
[ -f "$HOME/.config/vite-plus/env" ] && . "$HOME/.config/vite-plus/env"

# dotfiles bare repo (see ~/.github/README.md)
alias dots='git --git-dir=$HOME/.dots --work-tree=$HOME'
