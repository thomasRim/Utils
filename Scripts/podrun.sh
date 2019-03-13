#!/bin/bash

function xcodeClose {
    osascript -e 'tell application "Xcode" to quit'
}

function simulatorClose {
    osascript -e 'tell application "Simulator" to quit'
}

function openTerminal {
    open "podinstall.log"
}

function terminateTerminal {
    osascript -e 'tell application "Console" to quit'
}

if [ $# -eq 0 ]; then

    echo "Variable should be a path to project folder with pods!!! \n"
    echo "sh podrun.sh [path_to_project_with_podfile] \n"
    exit 1
else

    projdir="$1"

    if [ $# == 2 ]; then
        projdir="$1 $2"
    fi

    scriptPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    cd "$projdir"

    exec >>podinstall.log

    openTerminal

    echo
    echo "//--------------------------//"
    echo "// $(date)"
    echo "//--------------------------//"

    echo "Project folder.."
    echo "$projdir"
    echo "----------"

    # look for Podfile
    podfile=$(find "$projdir" -type f -name "Podfile")
    echo $podfile
    echo "----------"

    if [[ -n $podfile ]]; then

        #close Xcode before installing pods
        xcodeClose
        simulatorClose

        echo "Podfile exist. Run compilation"
        echo "----------"

        # look for *workspace folder
        pattern="xcworkspace"
        for _dir in *"${pattern}"*; do
            echo "$_dir"
            [ -d "${_dir}" ] && dir="${_dir}" && break
        done
        # remove for *workspace folder
        if [[ -n ${dir} ]]; then
            echo "remove *.xcworkspace folder"
            echo "${dir}"
            echo "----------"
            rm -r -f "${dir}"
        fi
        # remove for Podfile.lock file
        if [[ "Podfile.lock" == "$(find Podfile.lock -maxdepth 0)" ]]; then
            echo "remove 'Podfile.lock' file"
            echo "----------"
            rm -f Podfile.lock
        fi
        # remove for Pods folder
        if [[ "Pods" == "$(find Pods -maxdepth 0)" ]]; then
            echo "remove 'Pods' folder"
            echo "----------"
            rm -r -f Pods
        fi

        echo "clear pods cache"
        echo "----------"
        pod cache clean --all

        echo "update pods up-to-date"
        echo "----------"
        pod repo update

        echo "install pods"
        echo "----------"
        pod install

        echo "$projdir/${dir}"
        open "$projdir/${dir}"

        terminateTerminal

    else
        echo "No Podfile. break"
        exit 1
    fi  
fi
