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
# mazon: Armazena a Logo que  aparece para o usuario
#ql: Barra do f_title
#-------------------------->


#--------FUNÇÕES----------->
# _fetch_info():faz todas as informações aparecerem
# _set_info():controla o EOF
#-------------------------->
#------TESTES-------------->

#-------------------------->

#Inicio do Programa

_fetch_info(){
	f_title=$USER@$HOSTNAME
	f=$(uname -a | awk '{printf $2}' | sed 's/os/ OS/g')
	f_os=$(uname -o)
	f_kname=$(uname -a | awk '{print $1}')
	f_kv=$( uname -a | awk '{print $3}')
	f_uptime=$(uptime | awk '{print $3}'|tr "," " ")" min"
	f_shell=$(basename $SHELL)
	f_resolucao=$(xrandr | sed -n '1p' | sed 's/.*current*//g;s/,.*//g;s/ //g')
	f_desk=$XDG_CURRENT_DESKTOP
	f_font=$(fc-match | sed 's/\..*//g')
	f_cpu=$(cat /proc/cpuinfo | grep -o 'model name.*' | sed -n '1p' | sed 's/.*:.//g;s/(.)//g')
	f_tcpu=$(sensors | grep "Package id 0:"|sed 's/.*:  +//g;s/ .*//')
	f_gpu=$( 
			nvidia=$(which nvidia-settings 2>&1 > /dev/null &)
			gpu=$(glxinfo | grep "Vendor"|awk '{print $2}')
			amd=$(glxinfo | grep "Vendor"|awk '{print $2}')
			if [ -x "$nvidia" ]; then
			glxinfo |grep  -e "renderer string" | sed 's/.*: //g;s/(*.x.*)//g;s/(.*//g;s/\/.*//'
			elif [ "$gpu" == "Intel" ]; then
				echo "Intel Graphics"
			elif ["$amd" == "Amd" ]; then
				echo "AMD Graphics"
			else
				glxinfo | grep "renderer string"| sed 's/.*: //'
		fi
	)
	f_men=$(echo $(cat  /proc/meminfo | sed -n '1p' |tr -d [A-Za-z:' ']) / 1024 | bc)" MB"
	f_menfree=$(echo $(cat  /proc/meminfo | sed -n '2p' |tr -d [A-Za-z:' ']) / 1024 | bc)" MB"
	f_ach=$(getconf LONG_BIT)"-bit"
	f_nave=$(xdg-settings get default-web-browser|sed 's/userapp-//;s/\..*//g')
	f_char=$(expr length "$f_title") ql=
	for i in $(seq 1 $f_char); do
		ql="$ql─"
	done
}
_set_info(){
_fetch_info

cat <<EOF

$(echo -e "\033[32m$f_title\033[39m")
$(echo -e "\033[31m$ql\033[39m")
Distro: ${f^}
OS: ${f_os^}
Kernel Name: ${f_kname^}
Kernel: $f_kv
Uptime: $f_uptime
Shell: ${f_shell^}
Resolution: $f_resolucao
Desk: $f_desk
Fonte: $f_font
CPU: $f_cpu $f_tcpu
GPU: $f_gpu
RAM: $f_men
Memory Free: $f_menfree
Architeture: $f_ach
Browser default: ${f_nave^}
EOF
}
mazon=$(
echo -e "\033[01;32m                                            .','                     \033[01;39m"
echo -e "\033[01;32m                                          .;,;;  ;;''','             \033[01;39m"
echo -e "\033[01;32m                                       ,,  ;;;;;;;;;;;;'             \033[01;39m"
echo -e "\033[01;39m                           .,:clll:;. \033[01;32m,;;  ;;;;;;;;;;;'              \033[01;39m"
echo -e "\033[01;39m                       ',,'.     ..;o0N0d;\033[01;32m,;;;;;;;;                  \033[01;39m"
echo -e "\033[01;39m                    .c;                ;OM0l\033[01;32m,;;;;;;;.                \033[01;39m"
echo -e "\033[01;39m                   ox                    .0MK:\033[01;32m.;;;;.                 \033[01;39m"
echo -e "\033[01;39m                 .KO                       xMWc      \033[01;32m..',,,          \033[01;39m"
echo -e "\033[01;39m                 XW                   ...   OMMl\033[01;32m;;;;;;;;,' ......    \033[01;39m"
echo -e "\033[01;39m                 Mk     .,:;'      :OWMMMXo. WMN\033[01;32m;;;;;;;,,,;,;;;;;;,' \033[01;39m"
echo -e "\033[01;39m                WMl   .KMMMMMMKo,lWMMMWKWMMM;lMMl\033[01;32m;;;;;;;;;;;;;;;;;,' \033[01;39m"
echo -e "\033[01;32m      .',,,'... \033[01;39mMMo   KMMMMMMMMMMMMMMMc .MMMK.MMd\033[01;32m;;;;;;;;;;;;;;;;'    \033[01;39m"
echo -e "\033[01;32m   ..  '..',;;;,\033[01;39mNMd   MMMM. oMMMMMMMMMMNWMMMW KMl\033[01;32m;;;,  ;;;;;;;;;;;;; \033[01;39m"
echo -e "\033[01;32m .,;;;;;;;;;;;;;\033[01;39mdMl   0MMMXOWMMMMW\033[01;33mXXX\033[01;39mWMMMMMMW.dX\033[01;32m,;;'  ,;;;;;;;;;;;;; \033[01;39m"
echo -e "\033[01;32m    ,;;;;;;;;;;;,\033[01;39mK:   cNWMMMMMMW\033[01;33mOxxxxx\033[01;39mKMMMMWK,.c\033[01;32m;   ;;;;;;;;;;;;;;;;;\033[01;39m"
echo -e "\033[01;32m .;;;;;;;;;;;,,;;;.   \033[01;39m.KKXWMMMMN\033[01;33mxxxxxxx\033[01;39mMMMWKk''\033[01;32m,.  ;;;;'   ;;;;;;;;;;\033[01;39m"
echo -e "\033[01;32m ';;;;;;;;;;;,  ';,.   \033[01;39mxKKKKNWMM\033[01;33mldxxxxx\033[01;39mNWKd:..'\033[01;32m             '''..;;;;\033[01;39m"
echo -e "\033[01;32m,,;;;;;;;;,;,;;; .,;,. \033[01;39m.:ok0KKKXx\033[01;33m:oxxxx\033[01;39mc\033[01;32m'.                          \033[01;39m"
echo -e "\033[01;32m               .   '... \033[01;39m..',coxOO;'\033[01;33m,oxx \033[01;32m\033[01;32m                             \033[01;39m"
echo -e "\033[01;32m                                     \033[01;33mlx\033[01;32m                              "
)

paste <(printf "%s" "$mazon") <(_set_info)
