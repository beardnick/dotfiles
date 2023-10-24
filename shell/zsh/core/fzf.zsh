# 启用fzf的一些key binding和小组件
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS="--height 80% --layout=reverse --preview '(bat --color=always {}) 2> /dev/null | head -500'"

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude vendor'
