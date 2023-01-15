alias xclip="xclip -selection clipboard"
alias objdump="objdump -M intel"
alias xclip="xclip -selection clipboard"
alias control_panel="~/Desktop/oscp/labs/scripts/control_panel.sh"
alias windows="~/Desktop/oscp/labs/scripts/windows10.sh"
alias debian="~/Desktop/oscp/labs/scripts/debian.sh"

#################
# Docker

alias dockershell="docker run --rm -i -t --entrypoint=/bin/bash"
alias dockershellsh="docker run --rm -i -t --entrypoint=/bin/sh"

function dockershellhere() {
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/bash -v `pwd`:/${dirname} -w /${dirname} "$@"
}

function dockershellshhere() {
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/sh -v `pwd`:/${dirname} -w /${dirname} "$@"
}
