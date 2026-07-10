#!/usr/bin/env bash

git_clone_work_tree() {
  repository_url="$1"
  repository_name="$(basename "$repository_url" .git)"

  git clone --bare "$repository_url" "$repository_name/.git"

  cd "$repository_name" || exit 1
  default_branch="$(git remote show "$(git remote)" | awk '/HEAD branch/ {print $NF}')"

  git worktree add "$default_branch"
}

git_clone_work_tree "$@"
