#!/bin/bash
#variables
dl_directory=$(echo ~/)
file_sh_git='git-prompt.sh'
remote_git_file='git-prompt.sh'
local_bashrc_sh_file='test.sh'
bslash=$(echo $'\x5C'$'\x5C'$'\x5C')
text_to_add="#start adding modifs prompt-git.sh
source ~/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1 GIT_PS1_SHOWSTASHSTATE=1 GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=verbose GIT_PS1_DESCRIBE_STYLE=branch
#Enable color for git states
export GIT_PS1_SHOWCOLORHINTS=1"
prompt_var="export PROMPT_COMMAND='__git_ps1 \"\\u:\\w\" \" ${bslash}$ \"'"
text_to_add_bslash=$text_to_add$bslash
dled_file=$dl_directory$file_sh_git
#functions
check_file_exist () {
if [ -f "$1" ]
  then
    return 1
  else
    return 0
  fi
}
downld_latest () {
  curl https://raw.githubusercontent.com/git/git/dd160d794f0bf02c30d2e5032e216b1e8ac14222/contrib/completion/git-prompt.sh > $dl_directory$remote_git_file
}
add_to_eof () {
  echo -e "$1" >> $dl_directory$local_bashrc_sh_file
  echo -E "$2" >> $dl_directory$local_bashrc_sh_file
}
test_if_already_modified (){
  if grep -lR "#start adding modifs prompt-git.sh" ~/test.sh
    then
    echo "Fichier déjà modifié !"
    else
    return 0
  fi
}
main () {
check_file_exist $dled_file
if [ $? == 0 ]
  then
  echo "Downloading latest version from github..."
  downld_latest
  else
    echo -e "File already exist\nDo you want to overwrite/update it, yes(y) or no(N) ?"
    read response
    if [ $response == y ] || [ $response == Y ]
      then
        echo "Downloading and overwirting file ..."
        downld_latest
      else
        echo "Do you want to continue install, yes(y) or no(N) ?"
        read choise
        if [ $choise == y ] || [ $choise == yes ]
          then
            add_to_eof "$text_to_add" "$prompt_var"
          else
            echo "Installation aborded !"
          fi
      fi
fi
}
#main
test_if_already_modified
