#!/usr/bin/env bash
# Template orgulhosamente criado por (Shell-Base)
#═════-HEADER═════════════════════════════════|
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

#════FUNÇÕES═════>
# _fetch_info()
# _set_info()
# _mazon()
# _arr=()
# _inf=()

#═════════════>
#═══inicializando═══════>
nvidia=$(which nvidia-settings 2>&1 > /dev/null &)
gpu=$(awk '{print $2}' <<< $(grep "Vendor" <<< $(glxinfo)))
amd=$(awk '{print $2}' <<< $(grep "Vendor" <<< $(glxinfo)))
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
	cyan= "\e[1;36m";
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
#	f_uptime=$(tr "," " " <<< $(awk '{print $3, $2}' <<< $(uptime)))
#	f_uptime=$(uptime | awk '{print $1, $2}')
	f_uptime=$( tr ' ' ': '<<< $(awk '{print $3,$5 $2}' <<< $(uptime)))
	f_shell=$(basename $SHELL)
	f_resolucao=$(paste - - <<< $(awk '/mode / {print $10}' <<< $(grep -E "Output .* mode" < "/var/log/Xorg.0.log")))
	f_desk=$XDG_CURRENT_DESKTOP
	f_font=$(sed 's/\..*//g' <<< $(fc-match))
	f_cpu=$(sed 's/.*:.//g;s/(.)//g;s/@//g;s/CPU//g;s/(.*)//g;s/  / /g;' <<< $(sed -n '1p' <<< $(grep -o 'model name.*' < "/proc/cpuinfo")))
	f_tcpu=$(sed 's/.*:  +//g;s/ .*//' <<< $(grep "Package id 0:" <<< $(sensors)))
	f_gpu=$(
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

	f_mem=$(bc <<< $(echo "scale=1;$(bc <<< $(printf "%i"$(tr -d [A-Za-z:' '] <<< $(sed -n '1p' < "/proc/meminfo"))/1000))/1024"))" GB"
	f_memfree=$(bc <<< $(echo "scale=1;$(bc <<< $(printf "%i"$(tr -d [A-Za-z:' '] <<< $(sed -n '3p' < "/proc/meminfo"))/1000))/1024"))" GB"
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
	_inf[0]="${bold}${green}$f_title${reset}"
	_inf[1]="${bold}${red}$ql${reset}"
	_inf[2]="${bold}${white}Distro     ${white}:${white} $f${reset}"
	_inf[3]="${bold}${white}OS         ${white}:${white} $f_os${reset}"
	_inf[4]="${bold}${white}Kernel Name${white}:${white} $f_kname${reset}"
	_inf[5]="${bold}${white}Release    ${white}:${white} $f_kv${reset}"
	_inf[6]="${bold}${white}Architetura${white}:${white} $f_ach${reset}"
	_inf[7]="${white}Mem RAM    ${white}:${white} $f_mem${reset}"
	_inf[8]="${white}Mem free   ${white}:${white} $f_memfree${reset}"
	_inf[9]="${white}Uptime     ${white}:${white} ${f_uptime}${reset}"
	_inf[10]="${white}Shell      ${white}:${white} $f_shell${reset}"
	_inf[11]=${bold}"${white}CPU        ${white}:${white} $f_cpu [$f_tcpu]${reset}"
	_inf[12]=${bold}"${white}Core(s)    ${white}:${white} $(nproc)${reset}"
	_inf[13]="${bold}${white}GPU        ${white}:${white} $f_gpu${reset}"
	_inf[14]="${bold}${white}Desktop    ${white}:${white} $f_desk${reset}"
	_inf[15]="${white}Fonte      ${white}:${white} $f_font${reset}"
	_inf[16]="${white}Resolution ${white}:${white} $f_resolucao${reset}"
	_inf[17]="${white}Browser    ${white}:${white} $f_nave${reset}"


}
_mazon(){
	_arr[0]="${red}´´´´´´´´´´´´´´´´´´´´´´´${reset}"
	_arr[1]="${red}´´´´´´´´´´´´´´´´´´´´´´´${reset}"
	_arr[2]="${red}´´´´´´´´´´´´´´´´´´´´´´´${reset}"
	_arr[3]="${red}´´´´´´´´´´´´´´´´´´´´´´´${reset}"
	_arr[4]="${red}´´´´´´´´´´´´´´´´´´´´´´´${reset}"
	_arr[5]="${red}´´´´´´´´´´´´´´´´´´´´´´´${reset}"
	_arr[6]="${red}´´´´´´´´´´´´´´´´´´´´´´´${reset}"
	_arr[7]="${red}´´´´´´´´´${reset}${bold}${green}__${reset}${red}´´´´´´´´´´´´${reset}"
	_arr[8]="${red}´´´´´´´´${reset}${bold}${green}|  |_${reset}${red}´´´´´´´´´´${reset}"
	_arr[9]="${red}´´´´´´´´´${reset}${bold}${green}--  |${reset}${red}´´´´´´´´´${reset}"
	_arr[10]="${red}´´´´´´´´´´´${reset}${bold}${green}´´${reset}${red}´´´´´´´´´´${reset}"
	_arr[11]="${red}´´´´´´´´´´´´´´´´´´´´´´´${reset}"
	_arr[12]="${red}´´´´´´´´´´´´´´´´´´´´´´´${reset}"
	_arr[13]="${red}´´´´´´´´´´´´´´´´´´´´´´´${reset}"
	_arr[14]="${red}´´´´´´´´´´´´´´´´´´´´´´´${reset}"
	_arr[15]="${red}´´´´´´´´´´´´´´´´´´´´´´´${reset}"
	_arr[16]="${red}´´´´´´´´´´´´´´´´´´´´´´´${reset}"
	_arr[17]="${red}´´´´´´´´´´´´´´´´´´´´´´´${reset}"

	for i in $(seq 0 17);
	do
		printf "%s\n%s""${_arr[$i]}  ${_inf[$i]}"
	done
echo -e "\n"
}
_set_info
_mazon
