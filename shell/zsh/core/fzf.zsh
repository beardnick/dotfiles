# 启用fzf的一些key binding和小组件
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS="--height 80% --layout=reverse --preview '(bat --color=always {}) 2> /dev/null | head -500'"

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude vendor'

# fzflow: pick a flow from functions named fzflow_<description>.
fzflow() {
    local -a lines
    local name desc selection func

    for name in ${(k)functions}; do
        [[ "$name" == fzflow_* ]] || continue
        desc="${name#fzflow_}"
        desc="${desc//_/ }"
        lines+=("${desc}"$'\t'"${name}")
    done

    if (( ${#lines[@]} == 0 )); then
        echo "fzflow: no flows registered"
        return 1
    fi

    selection=$(print -r -l -- "${lines[@]}" | fzf --delimiter=$'\t' --with-nth=1 --nth=1 --no-preview --prompt='fzflow> ')
    [[ -z "$selection" ]] && return 0
    func="${selection#*$'\t'}"
    "$func"
}

fzflow_go_to_worktree() {
    cd "$(git worktree list | awk '{print $1}' | fzf)"
}
