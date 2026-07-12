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
        echo "Error: BVCS repository already exists."
    else
        mkdir -p .bvcs/objects
        touch .bvcs/staging .bvcs/log .bvcs/HEAD
        echo "Initialized empty BVCS repository."
    fi
}   

add_files(){
    if [[ $# == 0 ]]; then
        echo "Error: No files specified."
        return 1
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
    while IFS= read -r key ; do
            if [[ -z "$key" ]]; then
            continue
            fi
            if ((staged==0)); then
                echo "Staged for commit:"
                staged=1
            fi
            echo " $key"
    done < ".bvcs/staging"
    #print the ending newline
    if [[ $staged -gt 0 ]]; then
    echo ""
    fi

    # print the modified files
    while IFS= read -r key; do
        if [[ -z "$key" ]]; then
            continue
        fi
        if [[ ${file_status["$key"]} == "modified" ]]; then
            if ((modified==0)); then
                echo "Modified (not staged):"
                modified=1
            fi
            echo " $key"
        fi
    done< <(printf "%s\n" "${!file_status[@]}" | sort)
    #print the ending newline
    if [[ $modified -gt 0 ]]; then
    echo ""
    fi

    # print the untracked files
    while IFS= read -r key; do
        if [[ -z "$key" ]]; then
            continue
        fi
        if [[ ${file_status["$key"]} == "untracked" ]]; then
            if ((untracked==0)); then
                echo "Untracked files:"
                untracked=1
            fi
            echo " $key"
        fi
    done< <(printf "%s\n" "${!file_status[@]}" | sort)
    
    #print the ending newline
    if [[ $untracked -gt 0 ]]; then
    echo ""
    fi

    if ((staged==0 && untracked==0 && modified==0)); then
        echo "Nothing to commit, working tree clean."
    fi 

}

do_commit(){
    if [[ "$1" != -m || -z  "$2" ]]; then
        echo -e "Error: Commit message required. Use -m \"message\"."
        return 1
    fi

    if [[ ! -s .bvcs/staging ]]; then
        echo "Error: Nothing to commit."
        return 0
    fi

    # GENERATE THE COMMIT ID
    commitID=1
    if [[ -f .bvcs/log && -s .bvcs/log ]]; then
        old_commitID=$(wc -l < .bvcs/log)
        commitID=$old_commitID
        old_commitID=$(printf "%04d" "$old_commitID")
        ((commitID++))    
    fi

    temp=$commitID
    commitID=$(printf "%04d" $commitID)
    # now handle the commit into the .bvcs
    mkdir -p ".bvcs/objects/$commitID/files"
    if [[ $temp -gt 1 ]]; then
        cp -r ".bvcs/objects/$old_commitID/files"/* ".bvcs/objects/$commitID/files/"
    fi

    committed_files=0

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

       
       
        ((committed_files++))
    done< ".bvcs/staging"
    # enter the message
    touch ".bvcs/objects/$commitID/message"
    echo "$2" > ".bvcs/objects/$commitID/message"

    #enter the timestamp
    touch ".bvcs/objects/$commitID/timestamp"
    formated_date=$(date "+%Y-%m-%d %H:%M:%S") 
    echo "$formated_date" >".bvcs/objects/$commitID/timestamp"

    #log
    echo "$commitID|$formated_date|$2">>".bvcs/log"
    #modify the head
    echo "$commitID"> .bvcs/HEAD
    #turncate the staging file
    true > ".bvcs/staging"
    echo -e "[$commitID] $2\n$committed_files file(s) committed."

}

show_log(){
    if [[ ! -s .bvcs/log ]]; then
        echo "No commits yet."
        return 0
    fi

    while IFS="|" read -r commit_ date_ msg_; do
        echo "commit $commit_"
        echo "Date: $date_"
        echo "Message: $msg_"
        echo ""
    done< <(tac .bvcs/log) 
}

show_diff(){
    if [[ ! -s .bvcs/HEAD ]]; then
        echo "Error: No commits yet."
        return 0
    fi
    head_id=$(<.bvcs/HEAD)

    if [[ ! -z "$1" ]]; then
        relative_path="$1"
        fullpath=".bvcs/objects/$head_id/files/$relative_path"
        if [[ ! -f "$fullpath" ]]; then
            echo "Error: '$relative_path' is not tracked."
        else
            if diff -q "$relative_path" "$fullpath" >/dev/null ; then
                echo "$relative_path: no changes."

            else
                diff -u --label "$fullpath" --label "$relative_path" "$fullpath" "$relative_path"
            fi
        fi
    #when no argument is given
    else
        while IFS= read -r fullpath; do
            relative_path=${fullpath#".bvcs/objects/$head_id/files/"}
            if diff -q "$relative_path" "$fullpath" >/dev/null ; then
                echo "$relative_path: no changes."

            else
                diff -u --label "$fullpath" --label "$relative_path" "$fullpath" "$relative_path"
            fi
        done < <(find ".bvcs/objects/$head_id/files" -type f | sort)
    fi
}

restore_file(){
    if [[ -z "$1" ]]; then
        echo "Error: No file specified."
        return 1
    fi

    if [[ ! -s .bvcs/HEAD ]]; then
        echo "Error: No commits yet."
        return 1
    fi

    file_name="$1"
    head_id=$(<.bvcs/HEAD)
    fullpath=".bvcs/objects/$head_id/files/$file_name"
    if [[ ! -f "$fullpath" ]]; then
        echo "Error: '$file_name' not found in commit $head_id."
        return 1
    fi

    prompt="#"
    read -r -p "Restore '$file_name' from commit $head_id? [y/N]:" prompt

    if [[ "$prompt" ==  "y" || "$prompt" ==  "Y" ]]; then
        dest_dir=$(dirname "$file_name")
        mkdir -p "$dest_dir"
        cp "$fullpath" "$file_name"
        echo "Restored: $file_name"
    else
        echo "Aborted."
    fi
}

usage() {
    echo "Usage: bvcs <subcommand> [arguments]"
    echo ""
    echo "Available subcommands:"
    echo "  init                    Initialize a new BVCS repository"
    echo "  add <file>...           Stage one or more files for the next commit"
    echo "  status                  Show staged, modified, and untracked files"
    echo "  commit -m <msg>         Save a snapshot of all staged files"
    echo "  log                     Display the full commit history"
    echo "  diff [file]             Compare working copy to the latest commit"
    echo "  restore <file>          Restore a file from the latest commit"
    echo "  help                    Print usage information for all subcommands"
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
        log)
            if  check_repo ; then
                show_log
            fi
            ;;
        diff)
            if  check_repo ; then
                show_diff "${@:2}"
            fi
            ;;
        restore)
            if  check_repo ; then
                restore_file "${@:2}"
            fi
            ;;
        help)
            usage
            ;;
        *)
            echo "Error: Unknown subcommand '$subcommand'."
            exit 1
            ;;
    esac
}

main "$@"
