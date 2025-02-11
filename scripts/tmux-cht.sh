#!/usr/bin/env bash

languages="bash css go html java tmux typescript zsh"
utils="awk cargo cat chmod chown cp curl docker docker-compose find git git-commit git-rebase git-status git-worktree grep head ifconfig jq kill less lsof ls make man mv podman ps rename rg rm sed ssh stow tail tar terraform tldr tr xargs zip"

combined_list=$(echo -e "$languages\n$utils")

selected=$(echo "$combined_list" | tr ' ' '\n' | fzf)
if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

if grep -qs "$selected" <<< $languages; then
    query=`echo $query | tr ' ' '+'`
    tmux neww bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
else
    tmux neww bash -c "curl -s cht.sh/$selected~$query | less"
fi
