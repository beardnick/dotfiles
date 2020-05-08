add_path(){
    [[ $PATH != *$1* ]] && export PATH="$1:$PATH"
}

load_all(){
    for f in $(find "$1" -name "*.zsh"); do
        source "$f"
    done


}
