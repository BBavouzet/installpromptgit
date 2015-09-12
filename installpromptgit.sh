#!/bin/bash
#variables
dl_directory=$(echo ~/)
file_sh_git='git-prompt.sh'
remote_git_file='git-prompt.sh'
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
main () {
check_file_exist $dled_file
if [ $? == 0 ]
  then
  echo "Downloading latest version on github..."
  downld_latest
  else
    echo -e "File already exist\nDo you want to ecrase it yes(y) or no(n) ?"
    read response
    if [ $response == y ] || [ $response == Y ]
      then
        echo "Downloading and ecrasing file ..."
        downld_latest
      else
        echo "Do you want to continue intall ?"
        read choise
        if [ $choise == y ] || [ $choise == yes ]
          then
            echo "C'est parti mon Kiki !"
          else
            echo "Installation aborded !"
          fi
      fi

  fi
}
main
