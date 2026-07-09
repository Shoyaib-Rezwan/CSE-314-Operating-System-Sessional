#!/usr/bin/bash

check_repo(){
    if [[ ! -d .bvcs/ ]]; then
        echo "Error: Not a BVCS repository. Run 'init' first."
        return 1
    else
        return 0
    fi
}

init_repo(){
    if [[ -d .bvcs/ ]]; then
        echo "Error : BVCS repository already exists."
    else
        mkdir -p .bvcs/objects
        touch .bvcs/staging .bvcs/log .bvcs/HEAD
        echo "Initialized empty BVCS repository."
    fi
}   

add_files(){
    if [[ $# == 0 ]]; then
        echo "Error: No files specified."
    fi

    for file in "${@}"; do
        if [[ ! -f "$file" ]]; then
            echo "Error: '$file' not found."
        else
            # check whether the file is already staged
            staged=0
            while IFS= read -r line; do
                if [[ "$file" == "$line" ]]; then
                    echo "Already staged: $file"
                    staged=1
                    break
                fi
            done<".bvcs/staging" 
            if [[ $staged == 1 ]]; then
                continue
            fi
            echo "$file" >> .bvcs/staging
            echo "Staged: $file"
        fi
    done
}

show_status(){
    declare -A file_status
    # handle staged files 
    if [[ -s .bvcs/staging ]]; then
        while IFS= read -r line; do
            file_status["$line"]="staged"
        done<".bvcs/staging"
    fi
    
    #handle modified files
    if [[ -s .bvcs/HEAD ]]; then
        head_id=$(<.bvcs/HEAD)
    fi

    if [[ -n "$head_id" ]]; then
        prefix=".bvcs/objects/$head_id/files/"
        if [[ -d "$prefix" ]]; then
            while IFS= read -r fullpath; do
                relative_path="${fullpath#"$prefix"}"
                if [[ ! ${file_status[$relative_path]} ]]; then

                    # notice, the file could be in head, not in staged and deleted from
                    #current workspace. Then ignore that
                    if [[ -f "$relative_path" ]]; then
                        file_status["$relative_path"]="head"
                        # just keep track of the head files
                        #because if a file is in head and it's in current dir
                        #and not modified then it will not be
                        #untracked
                        if  ! diff -q "$fullpath" "$relative_path">/dev/null; then
                            file_status["$relative_path"]="modified"
                        fi
                    fi
                fi
            done< <(find "$prefix" -type f 2>/dev/null)
        fi
    fi

    #handle untracked files
    while IFS= read -r file; do
        file=${file#./} # strip the starting ./
        if [[ ! ${file_status["$file"]} ]]; then
            file_status["$file"]="untracked"
        fi
    done< <(find . -type f ! -path "./.bvcs/*")

    staged=0
    modified=0
    untracked=0

    # print the staged files
    for key in "${!file_status[@]}"; do
        if [[ ${file_status["$key"]} == "staged" ]]; then
            if ((staged==0)); then
                echo "Staged for commit:"
                staged=1
            fi
            echo " $key"
        fi
    done

    # print the modified files
    for key in "${!file_status[@]}"; do
        if [[ ${file_status["$key"]} == "modified" ]]; then
            if ((modified==0)); then
                echo "Modified (not staged):"
                modified=1
            fi
            echo " $key"
        fi
    done

    # print the untracked files
    for key in "${!file_status[@]}"; do
        if [[ ${file_status["$key"]} == "untracked" ]]; then
            if ((untracked==0)); then
                echo "Untracked files:"
                untracked=1
            fi
            echo " $key"
        fi
    done

    if ((staged==0 && untracked==0 && modified==0)); then
        echo "Nothing to commit, working tree clean"
    fi 

    # for key in "${!file_status[@]}"; do
    #     echo "$key: ${file_status["$key"]}"
    # done

}

do_commit(){
    if [[ "$1" != -m || -z  "$2" ]]; then
        echo -e "Commit message required. Use -m \"message\"."
        return 1
    fi

    if [[ ! -s .bvcs/staging ]]; then
        echo "Error: Nothing to commit"
        return 0
    fi

    # GENERATE THE COMMIT ID
    commitID="0001"
    if [[ -f .bvcs/HEAD && -s .bvcs/HEAD ]]; then
        old_commitID=$(<.bvcs/HEAD)
        commitID=$((10#$old_commitID)) # bydefault linux treats every number as octal
        # So, force them to be decimal
        ((commitID++))
        commitID=$(printf "%04d" $commitID)
    fi
    echo "$commitID"

    # now handle the commit into the .bvcs
    mkdir -p ".bvcs/objects/$commitID/files"
    if [[ commitID -gt "0001" ]]; then
        cp -r ".bvcs/objects/$old_commitID/files"/* ".bvcs/objects/$commitID/files/"
    fi

    while IFS= read -r relative_path || [[ -n "$relative_path" ]]; do
        if [[ -z "$relative_path" ]]; then
            continue
        fi

        if [[ ! -f  "$relative_path" ]]; then
            echo "Warning: Staged file '$relative_path' not found in working directory."
            continue
        fi
        
        fullpath=".bvcs/objects/$commitID/files/$relative_path"
        dest_dir=$(dirname "$fullpath")
        mkdir -p "$dest_dir"
        cp "$relative_path" "$fullpath" 2>/dev/null

    done< ".bvcs/staging"

}

main() {
    subcommand=${1}
    case "$subcommand" in
        init)
            init_repo
            ;;
        add)
            if  check_repo ; then
                add_files "${@:2}"
            fi
            ;;
        status)
            if  check_repo ; then
                show_status
            fi
            ;;
        commit)
            if  check_repo ; then
                do_commit "${@:2}"
            fi
            ;;
        *)
            echo "Error: Unknown subcommand '$subcommand'"
            exit 1
            ;;
    esac
}

main "$@"
