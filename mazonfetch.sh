#!/usr/bin/env bash
# Template orgulhosamente criado por (Shell-Base)
#-----------HEADER-----------------------------------------------------------------|
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
#----------------------------------------------------------------------------------|


#--------VÁRIAVEIS--------->
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
# black
# blue
# white
# cyan
# green
# orange
# puple
# violet
# red
# yellow
#-------------------------->

#--------FUNÇÕES----------->
# _fetch_info()
# _set_info()
# _mazon()
# arr=()
# inf=()

#-------------------------->
#------TESTES-------------->

#-------------------------->

#Inicio do Programa
if tput setaf 1 &> /dev/null; then

	tput sgr0; # reset colors

	bold=$(tput bold);
	reset=$(tput sgr0);
	black=$(tput setaf 0);
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
	black="\e[1;30m";
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

arr=()
inf=()

_fetch_info(){
	exec > /dev/null 2>&1
	f_title=$USER@$HOSTNAME
	f=$(uname -a | awk '{printf $2}' | sed 's/os/ OS/g')
	f_os=$(uname -o)
	f_kname=$(uname -a | awk '{print $1}')
	f_kv=$( uname -a | awk '{print $3}')
#	f_uptime=$(uptime | awk '{print $3}'|tr "," " ")" min"
	f_uptime=$(uptime | awk '{print $1, $2}')
	f_shell=$(basename $SHELL)
	f_resolucao=$(cat /var/log/Xorg.0.log | grep -E "Output .* mode"|awk '/mode / {print $10}'|paste - - )
	f_desk=$XDG_CURRENT_DESKTOP
	f_font=$(fc-match | sed 's/\..*//g')
	f_cpu=$(cat /proc/cpuinfo | grep -o 'model name.*' | sed -n '1p' | sed 's/.*:.//g;s/(.)//g;s/@//g;s/CPU//g;s/(.*)//g;s/  / /g;')
	f_tcpu=$(sensors | grep "Package id 0:"|sed 's/.*:  +//g;s/ .*//')
	f_gpu=$(

			nvidia=$(which nvidia-settings 2>&1 > /dev/null &)
			gpu=$(glxinfo | grep "Vendor"|awk '{print $2}' )
			amd=$(glxinfo | grep "Vendor"|awk '{print $2}' )
		if [ -x "$nvidia" ]; then
            cat /var/log/Xorg.0.log | grep "NVIDIA(0): NVIDIA"| sed 's/.*GPU //g;s/(.*)//'
            echo ""
		elif [ "$gpu" == "Intel" ]; then
			cat /var/log/Xorg.0.log | grep "Integrated Graphics Chipset:" | sed 's/.*: //'
 
  		elif ["$amd" == "Amd" ]; then
			echo "AMD Graphics"
		else
			glxinfo | grep "renderer string"| sed 's/.*: //g;s/(.*)//g;'
		fi
	)

	f_mem=$(echo $(cat /proc/meminfo | sed -n '1p' |tr -d [A-Za-z:' ']) / 1024 | bc)" MB"
	f_memfree=$(echo $(cat  /proc/meminfo | sed -n '2p' |tr -d [A-Za-z:' ']) / 1024 | bc)" MB"
	f_ach=$(getconf LONG_BIT)"-bit"
	f_nave=$(xdg-settings get default-web-browser|sed 's/userapp-//;s/\..*//g')
	f_char=$(expr length "$f_title") ql=
	for i in $(seq 1 $f_char); do
		ql="$ql─"
	done
	exec > /dev/tty
}

_set_info()
{
    _fetch_info
	inf[0]="${green}  $f_title${reset}"
	inf[1]="${red}  $ql${reset}"
	inf[2]="${blue}Distro     ${white}:${yellow} $f${reset}"
	inf[3]="${blue}OS         ${white}:${yellow} $f_os${reset}"
	inf[4]="${blue}Kernel Name${white}:${yellow} $f_kname${reset}"
	inf[5]="${blue}Kernel     ${white}:${yellow} $f_kv${reset}"
	inf[6]="${blue}Uptime     ${white}:${yellow} $f_uptime${reset}"
	inf[7]="${blue}Shell      ${white}:${yellow} $f_shell${reset}"
	inf[8]="${blue}Resolution ${white}:${yellow} $f_resolucao${reset}"
 	inf[9]="${blue}Desktop    ${white}:${yellow} $f_desk${reset}"
	inf[10]="${blue}Fonte      ${white}:${yellow} $f_font${reset}"
	inf[11]="${blue}CPU        ${white}:${yellow} $f_cpu $f_tcpu${reset}"
	inf[12]="${blue}Core(s)    ${white}:${yellow} $(nproc)${reset}"
	inf[13]="${blue}GPU        ${white}:${yellow} $f_gpu${reset}"
	inf[14]="${blue}Mem RAM    ${white}:${yellow} $(free -h | grep Mem | awk '{print $2 }')${reset}"
	inf[15]="${blue}Mem free   ${white}:${yellow} $(free -h | grep Mem | awk '{print $4 }')${reset}"
	inf[16]="${blue}Architetura${white}:${yellow} $f_ach${reset}"
	inf[17]="${blue}Browser    ${white}:${yellow} $f_nave${reset}"
}

_mazon(){
arr[0]="${green}	       ,';;;;;;;;;                ${reset}"
arr[1]="${green}         .',,,;;;;;;;     ,,,,,'.         ${reset}"
arr[2]="${green}      .,;;;;;;,,;;;    ;;;;;;;;;;,'.      ${reset}"
arr[3]="${green}    .,;;;;;;;;;;;;;,''...',,;,,'.....     ${reset}"
arr[4]="${green}  .,;;;;;;;;;;;,..                        ${reset}"
arr[5]="${green}     ';;;;;;;,.                  .,;;;;,  ${reset}"
arr[6]="${green}  ;;;;;;;;;;,.                     ';;;;; ${reset}"
arr[7]="${green}';;;;;;;;;;;.                       ,;;;;'${reset}"
arr[8]="${green},;;;;;;;;;;;      ${white}.''.      cONMWO:  ${green},;;;;${reset}"
arr[9]="${green},;;;;;;;;;;,    ${white}xWMMMMNkc,kMMMMKNMMW,${green}.;;;;${reset}"
arr[10]="${green}.;;;;;;;;;;,   ${white}dMMMWXMMMMMMMMM0 .WMM0 ${green},;;'${reset}"
arr[11]="${green} ,;;;;;;;;;,   ${white}OMMM' xMMMMMMMMMMMMMMN ${green},;; ${reset}"
arr[12]="${green}  ,;;;;;,..    ${white}:MMMMMMMMMN${yellow}K00K${white}NMMMMMN..'  ${reset}"
arr[13]="${green}   ';;    ''   ${white}.KXWMMMMMX${yellow}xxxxxx${white}WMMMN0.    ${reset}"
arr[14]="${green}       .,;;,.   ${white}xKKXNMMMK${yellow}dxxxxx${white}XMWKx;     ${reset}"
arr[15]="${green}        ......  ${white}.ok0KKXNWc${yellow}lxxxx${white}Okc'.      ${reset}"
arr[16]="${green}                 ${white}.',cdkOKd,;${yellow}oxx${white}c.         ${reset}"
arr[17]="${green}                      ${white}....   ${yellow}.d.          ${reset}"
	for i in $(seq 0 21);
	do
		echo -e "${arr[$i]}  ${inf[$i]}"
	done

}
_set_info
_mazon
