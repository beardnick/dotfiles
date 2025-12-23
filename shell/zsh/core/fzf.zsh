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

fzflow_add_worktree_with_new_branch() {
    read "branch_name?Enter new branch name: "
    branch=$(git branch --format='%(refname:short)' | fzf --prompt='Select source branch: ')
    dir_name=$(basename $(pwd))
    dir_name="$dir_name-${branch_name##*/}"
    git worktree add -b $branch_name "$dir_name"  "$branch"
    cd "$dir_name"
}

fzflow_add_worktree_with_branch() {
    branch_name=$(git branch --format='%(refname:short)' | fzf --prompt='Select branch:')
    dir_name=$(basename $(pwd))
    dir_name="$dir_name-${branch_name##*/}"
    git worktree add "$dir_name" $branch_name
    cd "$dir_name"
}

fzflow_delete_worktree() {
    worktree=$(git worktree list | awk '{print $1}' | fzf --prompt='Select worktree to delete: ')
    read "confirm?Are you sure you want to delete $worktree? (y/n): "
    if [[ $confirm == "y" ]]; then
        git worktree remove $worktree
    fi
}