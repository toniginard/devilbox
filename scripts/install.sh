#!/bin/bash

declare -A repos
repos[linkat]="git.intranet.gencat.cat/1063/Linkat.git"
repos[agora]="git.intranet.gencat.cat/1051/Agora.git"

homedir=`pwd`
devdir="$homedir/../../dev_vm"

function clone_project {
    #Exemple de giturl: https://12345678A@git.intranet.gencat.cat/1063/Linkat.git
    user=$1
    project=$2
    giturl="https://"$user"@"${repos[$2]}
    clone_project_git $project $giturl
}

function clone_project_git {
    project=$1
    giturl=$2
    if [ ! -d "$devdir/$project" ]; then
        echo "Project $project not found, cloning..."
        git clone $giturl $devdir/$project
        pushd $devdir/$project
        git submodule update --recursive --init
        popd
    fi
}

if [ "$#" -eq 0 ] ; then
    echo "Forma d'ús: ./install.sh <user> <project>"
    exit 0
fi

if [ "$#" -gt 2 ] ; then
    echo "Només se suporten dos paràmetres"
    exit 0
fi

if [ "$#" -eq 1 ] ; then
    project='*';
else
    project=$2
fi

user=$1

clone_project "${user}" "${project}"
