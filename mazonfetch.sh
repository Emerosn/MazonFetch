#!/bin/bash
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
	pink="\033[35;1m";
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
	pink="\033[35;1m";
fi;

arr=()
inf=()

replicate()
{
    for counter in $(seq 1 $2);
    do
        printf "%s" $1
    done
}

_set_info()
{
	exec > /dev/null 2>&1
    gpu=$(lshw -quiet -C video | grep product: | cut -d: -f2)
    if [ "${gpu}" == "" ]; then
        gpu=$(lspci | grep VGA | cut -d: -f3)
    fi
    f_cpu=$(cat /proc/cpuinfo | grep -o 'model name.*' | sed -n '1p' | sed 's/.*:.//g;s/(.)//g;s/@//g;s/CPU//g;s/(.*)//g;s/  / /g;')
    f_tcpu=$(sensors | grep "Package id 0:"|sed 's/.*:  +//g;s/ .*//')
	f_desk=$XDG_CURRENT_DESKTOP
	f_font=$(fc-match | sed 's/\..*//g')
	f_resolucao=$(cat /var/log/Xorg.0.log | grep -E "Output .* mode"|awk '/mode / {print $10}'|paste - - )
	f_nave=$(xdg-settings get default-web-browser|sed 's/userapp-//;s/\..*//g')
	exec > /dev/tty

    inf[0]="${green}$USER@$HOSTNAME${reset}"
    inf[1]="${red}$(replicate "=" 26)${reset}"
    inf[2]="${reset}OS         : ${reset}$(uname -o)"
    inf[3]="Distro     : ${reset}$(uname -n)"
    inf[4]="Kernel name: ${reset}$(uname -s)"
    inf[5]="Release    : ${reset}$(uname -r)"
    inf[6]="Arch       : ${reset}$(uname -m)"
    inf[7]="${red}-----------------------------------------${reset}"
    inf[8]="Mem RAM    : ${reset}$(free -h | grep Mem | awk '{print $2 }')"
    inf[9]="Mem free   : ${reset}$(free -h | grep Mem | awk '{print $4 }')"
    inf[10]="Uptime     : ${reset}$(uptime -p)"
    inf[11]="Shell      : ${reset}$(basename $SHELL)"
    inf[12]="${red}-----------------------------------------${reset}"
    inf[13]="CPU        : ${reset}$f_cpu $f_tcpu"
    inf[14]="Core(s)    : ${reset}$(nproc)"
    inf[15]="GPU        :${reset}${gpu}"
    inf[16]="GPU driver : ${reset}$(lshw -quiet -C video | grep driver|cut -d= -f2 | awk '{print $1}')"
    inf[17]="${reset}$(lshw -quiet -C video | grep description|cut -d= -f1|sed 's/^[ \t]*//')"
    inf[18]="$(printf "%42s" " ")${red}-----------------------------------------${reset}"
    inf[19]="$(printf "%42s" " ")Desktop    : ${reset}$f_desk"
    inf[20]="$(printf "%42s" " ")Fonte      : ${reset}$f_font"
    inf[21]="$(printf "%42s" " ")Resolucao  : ${reset}$f_resolucao"
    inf[22]="$(printf "%42s" " ")Browser    : ${reset}$f_nave"
    inf[23]="$(printf "%42s" " ")${red}=========================================${reset}"
}

_tuxmazon(){
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

	for i in $(seq 0 24);
	do
		echo -e "${arr[$i]}  ${inf[$i]}"
	done
}
_set_info
_tuxmazon
