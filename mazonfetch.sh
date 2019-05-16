#!/usr/bin/env bash
# Template orgulhosamente criado por (Shell-Base)
#═════-HEADER════════════════════════════════-|
#AUTOR
#  Emerson Alves <emerson_alves262016@hotmail.com>
#
##DATA-DE-CRIAÇÃO
#  03/02/2019 ás 14:11
#
#PROGRAMA
#  mazonfetch
#
#PEQUENA-DESCRIÇÃO
#  O Mazonftch, como o screenftch,neofetch, ele informa na tela dados da maquina e do systema para o usuario e mostra também a logo do Systema mazon facilmente editavel!
#
#LICENÇA
#  GPL
#
#HOMEPAGE
#  ...
#
#CHANGELOG
#
#═════════════════════════════════════════|


#════VÁRIAVEIS════->
# f_title: Nome de usuario e host da maquina
# f: Distribuicao Instalada
# f_os: Tipo do Systema
# f_kname: Nome do Kernel
# f_kv: Versao do Kernel
# f_uptime: Tempo de inicio  do Systema
# f_shell: Shell padrão do systema
# f_resolucao: Resoluçao do monitor
# f_desk: Desktop atual como i3,xfce etc...
# f_font: Fonte do Sistema
# f_cpu: Informaçoes do CPU
# f_men: Quantidade de Memoria Total
# f_menfree: Quantidade de Memoria Livre
# f_ach: Arquitetura do systema
# f_nave: Navegador Padrão
# f_char: Lope que controla o tamanho da barra em baixo do f_title
#ql: Barra do f_title
#
# CORES:
# bold
# reset
# violet
# blue
# white
# cyan
# green
# orange
# puple
# violet
# red
# yellow
#═════════════>

#════FUNÇÕES═════->
# _fetch_info()
# _set_info()
# _mazon()
# _arr=()
# _inf=()

#═════════════>
#═══TESTES═══════>

#═════════════>

#Inicio do Programa
if tput setaf 1 &> /dev/null; then

	tput sgr0; # reset colors

	bold=$(tput bold);
	reset=$(tput sgr0);
	violet=$(tput setaf 0);
	blue=$(tput setaf 33);
	cyan=$(tput setaf 37);
	green=$(tput setaf 64);
	orange=$(tput setaf 166);
	purple=$(tput setaf 125);
	red=$(tput setaf 124);
	violet=$(tput setaf 61);
	white=$(tput setaf 15);
	yellow=$(tput setaf 136);

else

	bold='';
	reset="\e[0m";
	violet="\e[1;30m";
	blue="\e[1;34m";
	cyan="\e[1;36m";
	green="\e[1;32m";
	orange="\e[1;33m";
	purple="\e[1;35m";
	red="\e[1;31m";
	violet="\e[1;35m";
	white="\e[1;37m";
	yellow="\e[1;33m";
fi;

_arr=()
_inf=()

_fetch_info(){
	exec > /dev/null 2>&1
	f_title=$USER@$HOSTNAME
	f=$(sed 's/os/ OS/g' <<< $(awk '{printf $2}' <<< $(uname -a)))
	f_os=$(uname -o)
	f_kname=$(awk '{print $1}' <<< $(uname -a))
	f_kv=$( uname -a | awk '{print $3}')
	f_uptime=$(tr "," " " <<< $(awk '{print $3, $2}' <<< $(uptime)))
#	f_uptime=$(uptime | awk '{print $1, $2}')
	f_shell=$(basename $SHELL)
	f_resolucao=$(paste - - <<< $(awk '/mode / {print $10}' <<< $(grep -E "Output .* mode" < "/var/log/Xorg.0.log")))
	f_desk=$XDG_CURRENT_DESKTOP
	f_font=$(sed 's/\..*//g' <<< $(fc-match))
	f_cpu=$(sed 's/.*:.//g;s/(.)//g;s/@//g;s/CPU//g;s/(.*)//g;s/  / /g;' <<< $(sed -n '1p' <<< $(grep -o 'model name.*' < "/proc/cpuinfo")))
	f_tcpu=$(sed 's/.*:  +//g;s/ .*//' <<< $(grep "Package id 0:" <<< $(sensors)))
	f_gpu=$(

			nvidia=$(which nvidia-settings 2>&1 > /dev/null &)
			gpu=$(awk '{print $2}' <<< $(grep "Vendor" <<< $(glxinfo)))
			amd=$(awk '{print $2}' <<< $(grep "Vendor" <<< $(glxinfo)))
		if [ -x "$nvidia" ]; then
            sed 's/.*GPU //g;s/(.*)//' <<< $(grep "NVIDIA(0): NVIDIA" < "/var/log/Xorg.0.log")
		elif [ "$gpu" == "Intel" ]; then
			sed 's/.*: //'<<< $(grep "Integrated Graphics Chipset:" < "/var/log/Xorg.0.log")
 
  		elif ["$amd" == "Amd" ]; then
			printf "%s\n" "AMD Graphics"
		else
			 sed 's/.*: //g;s/(.*)//g;' <<< $(grep "renderer string" <<< $(glxinfo ))
		fi
	)

	f_mem=$(bc <<< $(printf "%i"$(tr -d [A-Za-z:' '] <<< $(sed -n '1p' < "/proc/meminfo"))/1024))" MB"
	f_memfree=$(bc <<< $(printf "%i"$(tr -d [A-Za-z:' '] <<< $(sed -n '2p' < "/proc/meminfo"))/1024))" MB"
	f_ach=$(getconf LONG_BIT)"-bit"
	f_nave=$(sed 's/userapp-//;s/\..*//g'<<< $(xdg-settings get default-web-browser))
	f_char=$(expr length "$f_title") ql=
	for i in $(seq 1 $f_char); do
		ql="$ql─"
	done
	exec > /dev/tty
}

_set_info()
{
    _fetch_info
	_inf[0]="$(printf "%38s" " ")${red}╔══════════════════════════════════════════════════╗${reset}"
	_inf[1]="║$(printf "%6s" " ")${green}$f_title${reset}"
	_inf[2]="║$(printf "%6s" " ")${red}$ql${reset}"
	_inf[3]="║${blue}Distro     ${yellow}:${yellow} $f${reset}"
	_inf[4]="║${blue}OS         ${yellow}:${yellow} $f_os${reset}"
	_inf[5]="║${blue}Kernel Name${yellow}:${yellow} $f_kname${reset}"
	_inf[6]="║${blue}Release    ${yellow}:${yellow} $f_kv${reset}"
	_inf[7]="║${blue}Architetura${yellow}:${yellow} $f_ach${reset}"
	_inf[8]="${red}╠══════════════════════════════════════════════════${reset}"
	_inf[9]="║${blue}Mem RAM    ${yellow}:${yellow} $f_mem${reset}"
	_inf[10]="║${blue}Mem free   ${yellow}:${yellow} $f_memfree${reset}"
	_inf[11]="║${blue}Uptime     ${yellow}:${yellow} ${f_uptime}${reset}"
	_inf[12]="║${blue}Shell      ${yellow}:${yellow} $f_shell${reset}"
	_inf[13]="${red}╠══════════════════════════════════════════════════${reset}"
	_inf[14]="║${blue}CPU        ${yellow}:${yellow} $f_cpu [$f_tcpu]${reset}"
	_inf[15]="║${blue}Core(s)    ${yellow}:${yellow} $(nproc)${reset}"
	_inf[16]="║${blue}GPU        ${yellow}:${yellow} $f_gpu${reset}"
	_inf[17]="${red}╠══════════════════════════════════════════════════${reset}"
	_inf[18]="║${blue}Desktop    ${yellow}:${yellow} $f_desk${reset}"
	_inf[19]="║${blue}Fonte      ${yellow}:${yellow} $f_font${reset}"
	_inf[20]="║${blue}Resolution ${yellow}:${yellow} $f_resolucao${reset}"
	_inf[21]="$(printf "%53s" " ")║${blue}Browser    ${yellow}:${yellow} $f_nave${reset}"
	_inf[22]="$(printf "%53s" " ")${red}╚══════════════════════════════════════════════════╝${reset}"

}

#_mazon(){
#_arr[0]="$(printf "%s" "")"
#_arr[1]="                                      "
#_arr[2]="                                      "
#_arr[3]="${green}            ::cccclllccc::            ${reset}"
#_arr[4]="${green}        :cllllllllllllllllllc:        ${reset}"
#_arr[5]="${green}      :l${white}OKo${green}llllllllllllllllllllc      ${reset}"
#_arr[6]="${green}    :lll${white}xMWKko${green}lllllllllllllllllll:    ${reset}"
#_arr[7]="${green}   cllll${white}oMMMMMNKOxo${green}lllllllllllllllc   ${reset}"
#_arr[8]="${green}  cllllll${white}XMM${green}WXN${white}MMMMNXOxo${green}lllllllllllc  ${reset}"
#_arr[9]="${green} :lllllll${white}xMMMM${green}WKKKN${white}MMMMMNKxo${green}llllllll: ${reset}"
#_arr[10]="${green} cllllllll${white}KMMMMMM${green}WKOk0W${white}MMMMWOo${green}lllllll ${reset}"
#_arr[11]="${green} lllllllll${white}oXMMMMMMMMM${green}XkxK${white}MMMMNd${green}llllll ${reset}"
#_arr[12]="${green} clllllllll${white}oXMMMMMMMMMM${green}WOdK${white}MMMNo${green}llllc ${reset}"
#_arr[13]="${green} :llllllllll${white}oKMMMMMMMMMMM${green}XoO${white}MMMx${green}llll: ${reset}"
#_arr[14]="${green}  clllllllllll${white}xNMMMMMMMMMM${green}0lK${white}MMd${green}lllc  ${reset}"
#_arr[15]="${green}   :llllllllllll${white}kXMMMMMMMM${green}Wox${white}Wk${green}lllc   ${reset}"
#_arr[16]="${green}    :cllllllllllll${white}dOXWMMMMM${green}ox${white}o${green}lll:    ${reset}"
#_arr[17]="${green}      :cllllllllllllll${white}oxkOW${green}oxl${green}c:      ${reset}"
#_arr[18]="${green}         :clllllllllllllll${white}0c          ${reset}"
#_arr[19]="${green}             :::cccccc:::             ${reset}"


#_mazon(){
#_arr[0]="    "
#_arr[1]="${green}	       ,';;;;;;;;;                ${reset}"
#_arr[2]="${green}         .',,,;;;;;;;     ,,,,,'.         ${reset}"
#_arr[3]="${green}      .,;;;;;;,,;;;    ;;;;;;;;;;,'.      ${reset}"
#_arr[4]="${green}    .,;;;;;;;;;;;;;,''...',,;,,'.....     ${reset}"
#_arr[5]="${green}  .,;;;;;;;;;;;,..                        ${reset}"
#_arr[6]="${green}     ';;;;;;;,.                  .,;;;;,  ${reset}"
#_arr[7]="${green}  ;;;;;;;;;;,.                     ';;;;; ${reset}"
#_arr[8]="${green}';;;;;;;;;;;.                       ,;;;;'${reset}"
#_arr[9]="${green},;;;;;;;;;;;      ${white}.''.      cONMWO:  ${green},;;;;${reset}"
#_arr[10]="${green},;;;;;;;;;;,    ${white}xWMMMMNkc,kMMMMKNMMW,${green}.;;;;${reset}"
#_arr[11]="${green}.;;;;;;;;;;,   ${white}dMMMWXMMMMMMMMM0 .WMM0 ${green},;;'${reset}"
#_arr[12]="${green} ,;;;;;;;;;,   ${white}OMMM' xMMMMMMMMMMMMMMN ${green},;; ${reset}"
#_arr[13]="${green}  ,;;;;;,..    ${white}:MMMMMMMMMN${yellow}K00K${white}NMMMMMN..'  ${reset}"
#_arr[14]="${green}   ';;    ''   ${white}.KXWMMMMMX${yellow}xxxxxx${white}WMMMN0.    ${reset}"
#_arr[15]="${green}       .,;;,.   ${white}xKKXNMMMK${yellow}dxxxxx${white}XMWKx;     ${reset}"
#_arr[16]="${green}        ......  ${white}.ok0KKXNWc${yellow}lxxxx${white}Okc'.      ${reset}"
#_arr[17]="${green}                 ${white}.',cdkOKd,;${yellow}oxx${white}c.         ${reset}"
#_arr[18]="${green}                      ${white}....   ${yellow}.d.          ${reset}"
#_arr[19]="                                          "
#_arr[20]="    "
#_arr[21]="    "
#_arr[22]="    "

_mazon(){ 
_arr[0]="               "
_arr[1]="${white}                   lXMNd                 ${white}            ${reset}"
_arr[2]="${white}     .cdxdl'    .xWMMMMMWo                 ${white}          ${reset}"
_arr[3]="${white}     0MMMMMMMWOcOMMMMM0NMMMX                ${white}         ${reset}"
_arr[4]="${white}    lMMMMMMMMMMMMMMMMX  MMMM'               ${white}         ${reset}"
_arr[5]="${white}    dMMMM  MMMMMMMMMMMMMMMMMo               ${white}         ${reset}"
_arr[6]="${white}    ;MMMMWWMMMMMk${yellow}WNNW${white}MMMMMMMM0               ${white}        ${reset}"
_arr[7]="${white}     .cKMMMMMMM${yellow}0xxxxx${white}0MMMMMMK                        ${reset}"
_arr[8]="${white}        .OMMMMN${yellow}xxxxxxx${white}MMMMN0${green}:,,,,..                  ${reset}"
_arr[9]="${green}   ...... ${white}xMMMWO${yellow}xxxxxx${white}NWKx${green}:,,;,...'',,;;;;,.         ${reset}"
_arr[10]="${green} ..........${white}WMMMMXk${yellow}xxxx${white}c\033${green}x,,;;;;;;;;;;;;,'.....        ${reset}"
_arr[11]="${green} ......... :k${white}NMMMWk${yellow}xxx${green}:''..;;;;;;;;;;;'...''''.      ${reset}"
_arr[12]="${green} ...... .....':do;',d${yellow}x${white}${green}, .',;;;;;;;;;;;;;;;;;;;;,.    ${reset}"
_arr[13]="${green}               ',...  ;'';;;;;;;;;;;;;;;;;;;;;;;;;'  ${reset}"
_arr[14]="${green}             ,;,..  .,;;;;;;;;;;;;;;;;;;;;;;;'..     ${reset}"
_arr[15]="${green}              ..   .;;;;;;;;;;;,'...;;;;;;;;;;;,.    ${reset}"
_arr[16]="${green}                   ;;;;;;;;;;'.  .,;;;;;;;;;;;;;;.   ${reset}"
_arr[17]="${green}                    .';;;;;,  .,;;;;;;;;;;;;;;;;,    ${reset}"
_arr[18]="${green}                       ..'.  .'',,,;;;;;;;;;;;;;;    ${reset}"
_arr[19]="${green}                                     ...',;;;;;;;.   ${reset}"
_arr[20]="${green}                                           ..,,,'    ${reset}"
	for i in $(seq 0 23);
	do
		printf "%s\n%s""${_arr[$i]}  ${_inf[$i]}"
	done
}
_set_info
_mazon
