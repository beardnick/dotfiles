add_path(){
    paths=("$1" ${(s.:.)PATH})
    for i ({2..$#paths}){
        if [[ $paths[i] == "$1" ]]; then
            paths[i]=()
            continue
        fi
    }
    export PATH=${(j.:.)paths}
}

load_all(){
    for f in $(find "$1" -name "*.zsh"); do
        source "$f"
    done


}

