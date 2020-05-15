#!/bin/bash -xue

cd $(dirname $0)

create_link_for() {
  file=$1
  target_path=$(realpath $file)
  link_path=~/$1
  if [ ! -f $link_path ]; then
    ln -s $target_path $link_path
  elif [ -L $link_path -a "$(readlink $link_path)" = "$target_path" ]; then
    # The link has already been created so there is nothing to do.
    :
  else
    echo "Couldn't create link for $file. The file $link_path already exists."
    return 1
  fi
}

### VIM ###

create_link_for ".vimrc"

### GIT ###

# If there is no global gitignore is set for git then use the .gitignore_global from this repo for
# this purpose.
if [ "$(git config --get core.excludesfile)" = "" ]; then
  create_link_for ".gitignore_global" && git config --global core.excludesfile "~/.gitignore_global"
else
  echo "Didn't set .gitignore_global becase core.excludesfile is already set."
fi

git config --global user.name "David Herskovics"
git config --global user.username "huncros"
git config --global user.email "huncros@gmail.com"
git config --global core.editor "vim"

