#!/bin/bash

#Version
# version 1.0.0
# https://github.com/BBavouzet/installpromptgit.git

#variables
dl_directory=$(echo ~/)
file_sh_git='git-prompt.sh'
local_bashrc_sh_file='.bashrc'
bslash=$(echo $'\x5C'$'\x5C'$'\x5C')

#Variables modifiant le bashrc
text_to_add="#start adding modifs prompt-git.sh
source ~/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1 GIT_PS1_SHOWSTASHSTATE=1 GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=verbose GIT_PS1_DESCRIBE_STYLE=branch
#Enable color for git states
export GIT_PS1_SHOWCOLORHINTS=1"
prompt_var="export PROMPT_COMMAND='__git_ps1 \"\\u:\\w\" \" ${bslash}$ \"'"
dled_file=$dl_directory$file_sh_git

#fonctions
#Vérifie si un fichier passé en argument existe bel et bien
check_file_exist () {
if [ -f "$1" ]
  then
    return 1
  else
    return 0
  fi
}

#Télécharge via curl le script git-prompt depuis le dépôt officiel sur GitHub
#avec écriture dans le home de l'utilisateur
downld_latest () {
  curl https://raw.githubusercontent.com/git/git/dd160d794f0bf02c30d2e5032e216b1e8ac14222/contrib/completion/git-prompt.sh > $dl_directory$file_sh_git
}

#Ajoute en fin de fichier .bashrc les éléments en arguments
add_to_eof () {
  echo -e "$1" >> $dl_directory$local_bashrc_sh_file
  echo -E "$2" >> $dl_directory$local_bashrc_sh_file
}
#Test la présence d'une ligne de caractères dans le fichier en argument
test_if_already_modified () {
  if grep --quiet "#start adding modifs prompt-git.sh" ~/$1;
    then
      return 1
    else
      return 0
  fi
}
#Rajoute .back au fichier en argument
bckpfile () {
  echo -e "\nBackuping $1 file to $1.back ..."
  cp $dl_directory$1 $dl_directory$1.back
}

main () {
check_file_exist $dled_file
if [ $? == 0 ];
  then
  echo -e "\nDownloading latest version of $file_sh_git from github ..."
  downld_latest
  check_file_exist $dl_directory$local_bashrc_sh_file.back
  if [ $? == 0 ];
    then
      bckpfile $local_bashrc_sh_file
      echo -e "\nUpdating file $local_bashrc_sh_file ..."
      add_to_eof "$text_to_add" "$prompt_var"
      echo Done
    else
      echo -e "\n$local_bashrc_sh_file.back already exist, rename it\n"
      echo -e "\nFile $local_bashrc_sh_file was't modified\n\nInstall ABORDED !!"
    fi
  else
    echo -e "\nFile $dled_file already exist\n\nDo you want to overwrite/update it, yes(y) or no(any keys) ?"
    read response
    if [ $response == y ] || [ $response == Y ];
      then
        echo -e "\nDownloading and overwriting file $dl_directory$local_bashrc_sh_file ..."
        downld_latest
        check_file_exist $dl_directory$local_bashrc_sh_file.back
          if [ $? == 0 ];
            then
              bckpfile $local_bashrc_sh_file
              echo -e "\nUpdating file $dl_directory$local_bashrc_sh_file ..."
              add_to_eof "$text_to_add" "$prompt_var"
              echo -e "\nDone"
            else
              echo -e "\n$dl_directory$local_bashrc_sh_file.back already exist, rename it"
              echo -e "File $dl_directory$local_bashrc_sh_file was't modified\n\nInstall ABORDED !!"
            fi
      else
        echo -e "\nDo you want to continue for update file $dl_directory$local_bashrc_sh_file, yes(y) or no(any keys) ?"
        read choice
        if [ $choice == y ] || [ $choice == yes ]
          then
            check_file_exist $dl_directory$local_bashrc_sh_file.back
            if [ $? == 0 ];
            then
              bckpfile $local_bashrc_sh_file
              echo -e "\nUpdating file $local_bashrc_sh_file ..."
              test_if_already_modified $local_bashrc_sh_file
              if [ $? == 1 ];
                then
                  echo -e "\nFile $dl_directory$local_bashrc_sh_file already modified by script !\n"
                else
                  echo -e "\nAdding lines to $dl_directory$local_bashrc_sh_file ..."
                  add_to_eof "$text_to_add" "$prompt_var"
                  echo Done
              fi
            else
              echo -e "\n$dl_directory$local_bashrc_sh_file.back already exist, rename it"
              echo -e "\nFile $dl_directory$local_bashrc_sh_file was't modified\n\nInstall ABORDED !!\n"
          fi
          else
            echo "Install ABORDED !!"
          fi
      fi
fi
}

main
