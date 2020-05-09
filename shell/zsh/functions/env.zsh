add_path(){
    [[ $PATH != *$1* ]] && export PATH="$1:$PATH"
}

load_all(){
    for f in $(find "$1" -name "*.zsh"); do
        source "$f"
    done


}

activate(){
    conda activate "$1"
    add_path "$HOME/opt/anaconda3/envs/$1/bin/"
}
