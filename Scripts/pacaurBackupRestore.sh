backupPacaurLocation="/mnt/MyMediaShare/User/Backups/Arch_Linux/Desktop/PackageList"
backupHomeLocation="/mnt/MyMediaShare/User/Backups/Arch_Linux/Desktop/Home"
backupEtcLocation="/mnt/MyMediaShare/User/Backups/Arch_Linux/Desktop/etc"





backupPacaurStuff() {
  echo "backing up pacaur"
  time=$(date +%Y_M-%m_D-%d_T-%H_%M)
  pacman -Qe | awk '{print $1}' > "$backupPacaurLocation""/package_Y-$time.txt"
  echo "done backing up"
  echo deleting old backups
  cd $backupPacaurLocation
  find . -name '*.txt' -mtime +60 -delete

}

restorePacaurStuff() {
  if [$2 == ""]
  then
    echo "Please pick a valid restore point"
    echo $(ls $backupPacaurLocation)
  else
    for x in $(cat "$backupPacaurLocation""/$2"); do pacaur -S $x; done
  fi
}

backupHomeStuff(){
  time=$(date +%Y_M-%m_D-%d_T-%H_%M)
  tar hcvfpz $backupHomeLocation/Y-$time-home.backup.tar.gz /home

  cd $backupHomeLocation
  find . -name '*.backup*' -mtime +60 -delete
}

backupEtcStuff(){
  time=$(date +%Y_M-%m_D-%d_T-%H_%M)
  tar hcvfpz $backupEtcStuff/Y-$time-Etc.backup.tar.gz /etc
  cd $backupEtcLocation
  find . -name '*.backup*' -mtime +60 -delete
}






case "$1" in
  backupPacaur)
    backupPacaurStuff
  ;;
  restorePacaur)
    restorePacaurStuff
  ;;
  backupHome)
    backupHomeStuff
  ;;

  restoreHome)
    echo "no handled"
  ;;

  backupEtc)
    backupEtcStuff
  ;;
  restoreEtc)
  echo "no handled"
  ;;

*)

echo "Usage: $(readlink -f $0) {update|start|stop|restart|backup|console}"
exit 1
;;
esac

exit 0