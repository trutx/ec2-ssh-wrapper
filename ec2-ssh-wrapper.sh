ssh() {
    # Arrays start at index 1 in zsh
    [[ ${SHELL} == "/bin/zsh" ]] && declare INDEX=1 || declare INDEX=0
    declare PARAMS=(${@})
    declare SSH_USER
    declare IP
    for P in "${PARAMS[@]}"; do
        [[ "${P}" =~ ^(.+@)?ip-((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])-){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.[a-z]{2}-[a-z].+-[1-9]{1}\.compute\.internal$ ]] && {
            [[ "${P}" =~ ^.+@.*$ ]] && {
                SSH_USER=${P%@*}@
                IP=${P#*@}
            } || {
                IP=${P}
            }
            IP=${IP%%.*}
            IP=${IP#*-}
            IP=${IP//-/.}
            PARAMS[${INDEX}]="${SSH_USER}${IP}"
            break
        }
        let INDEX++
    done
    /usr/bin/ssh ${PARAMS[@]}
}
