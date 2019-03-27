#!/bin/bash
# make menu from ansible inventory file
# choose and reload nginx on servers
# 20181114




function call_ansible(){
  echo -e "you are $(whoami). you choise $1\n"
  ansible-playbook ngxreload.yaml -u $(whoami) -k -K -e "var_hosts=$1"
  #ansible-playbook ngxreload.yaml -u $(whoami) -k -K -e "var_hosts=group1"
}


title="select server group to reload nginx"
prompt="Pick an option:"
options=( $( cat inventory  | grep -E '^\[' | awk -F"[]:[]" '{print $2}') )




echo "$title"
PS3="$prompt "


while true; do
  select opt in "${options[@]}" "Quit"; do


      if [[ ${REPLY} -eq $(( ${#options[@]}+1 )) ]]
      then
        echo "Goodbye!"; break 2;
      fi
     
      if [[ $REPLY -gt 0 && $REPLY -le ${#options[@]} ]]
      then
        call_ansible ${options[(($REPLY-1))]}; break;
      fi
  
  done
done
