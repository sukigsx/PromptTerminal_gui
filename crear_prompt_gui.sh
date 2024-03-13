#!/bin/bash
ruta_ejecucion=$(dirname "$(readlink -f "$0")")

#colores
#ejemplo: echo -e "${verde} La opcion (-e) es para que pille el color.${borra_colores}"

rojo="\e[0;31m\033[1m" #rojo
verde="\e[;32m\033[1m"
azul="\e[0;34m\033[1m"
amarillo="\e[0;33m\033[1m"
rosa="\e[0;35m\033[1m"
turquesa="\e[0;36m\033[1m"
borra_colores="\033[0m\e[0m" #borra colores

#menu para la instalacion de software_necesario
menu(){
clear
#maximiza la terminal.
echo -e "${rosa}"; figlet -c sukigsx; echo -e "${borra_colores}"
echo ""
echo -e "${verde} Diseñado por sukigsx / Contacto:   scripts@mbbsistemas.es${borra_colores}"
echo -e "${verde}                                    https://repositorio.mbbsistemas.es${borra_colores}"
echo ""
echo -e "${verde} Nombre del script <${borra_colores} $0 ${verde}> \n\n Este script esta pensado para funcionar en entornos linux basados en debian.\n Y que estes utilizando una sheel bash.\n Con el podras crear un prompt para la terminal totalmente pesonalizado.  ${borra_colores}"
}

#funcion software necesario
#para que funcione necesita:
#   conexion a internet
#   la paleta de colores
#   software: which
software_necesario(){
echo ""
echo -e " Comprobando el software necesario."
echo ""
software="which git diff ping nano figlet xclip zenity" #ponemos el foftware a instalar separado por espacion dentro de las comillas ( soft1 soft2 soft3 etc )
for paquete in $software
do
which $paquete 2>/dev/null 1>/dev/null 0>/dev/null #comprueba si esta el programa llamado programa
sino=$? #recojemos el 0 o 1 del resultado de which
contador="1" #ponemos la variable contador a 1
    while [ $sino -gt 0 ] #entra en el bicle si variable programa es 0, no lo ha encontrado which
    do
        if [ $contador = "4" ] || [ $conexion = "no" ] 2>/dev/null 1>/dev/null 0>/dev/null #si el contador es 4 entre en then y sino en else
        then #si entra en then es porque el contador es igual a 4 y no ha podido instalar o no hay conexion a internet
            clear
            echo ""
            echo -e " ${amarillo}NO se ha podido instalar ${rojo}$paquete${amarillo}.${borra_colores}"
            echo -e " ${amarillo}Intentelo usted con la orden: ( ${borra_colores}sudo apt install $paquete ${amarillo})${borra_colores}"
            echo -e ""
            echo -e " ${rojo}No se puede ejecutar el script sin el software necesario.${borra_colores}"
            echo ""
            exit
        else #intenta instalar
            echo " Instalando $paquete. Intento $contador/3."
            sudo apt install $paquete -y 2>/dev/null 1>/dev/null 0>/dev/null
            let "contador=contador+1" #incrementa la variable contador en 1
            which $paquete 2>/dev/null 1>/dev/null 0>/dev/null #comprueba si esta el programa en tu sistema
            sino=$? ##recojemos el 0 o 1 del resultado de which
        fi
    done
echo -e " [${verde}ok${borra_colores}] $paquete."
software="SI"
done
}

#actualizar el script
#para que esta funcion funcione necesita:
#   conexion a internet
#   la paleta de colores
#   software: git diff xdotool
actualizar_script(){
archivo_local="crear_prompt.sh" # Nombre del archivo local
ruta_repositorio="https://github.com/sukigsx/PromptTerminal_gui.git" #ruta del repositorio para actualizar y clonar con git clone  https://github.com/sukigsx/crear_prompt_terminal

# Obtener la ruta del script
descarga=$(dirname "$(readlink -f "$0")")
git clone $ruta_repositorio /tmp/comprobar >/dev/null 2>&1

diff $descarga/$archivo_local /tmp/comprobar/$archivo_local >/dev/null 2>&1


if [ $? = 0 ]
then
    #esta actualizado, solo lo comprueba
    #echo ""
    #echo -e "${verde} El script${borra_colores} $0 ${verde}esta actualizado.${borra_colores}"
    #echo ""
    chmod -R +w /tmp/comprobar
    rm -R /tmp/comprobar
    actualizado="SI"
else
    #hay que actualizar, comprueba y actualiza
    #echo ""
    #echo -e "${amarillo} EL script${borra_colores} $0 ${amarillo}NO esta actualizado.${borra_colores}"
    #echo -e "${verde} Se procede a su actualizacion automatica.${borra_colores}"
    sleep 3
    mv /tmp/comprobar/$archivo_local $descarga
    chmod -R +w /tmp/comprobar
    rm -R /tmp/comprobar
    #echo ""
    #echo -e "${amarillo} El script se ha actualizado, es necesario cargarlo de nuevo.${borra_colores}"
    #echo -e ""
    #read -p " Pulsa una tecla para continuar." pause
    #exit
fi
}

solo_mira_si_actualizar(){
archivo_local="crear_prompt.sh" # Nombre del archivo local
ruta_repositorio="https://github.com/sukigsx/PromptTerminal_gui.git" #ruta del repositorio para actualizar y clonar con git clone

# Obtener la ruta del script
descarga=$(dirname "$(readlink -f "$0")")
git clone $ruta_repositorio /tmp/comprobar >/dev/null 2>&1

diff $descarga/$archivo_local /tmp/comprobar/$archivo_local >/dev/null 2>&1


if [ $? = 0 ]
then
    #esta actualizado, solo lo comprueba
    actualizado="SI"
else
    #hay que actualizar, comprueba y actualiza
    actualizado="NO"
fi

chmod -R +w /tmp/comprobar
rm -R /tmp/comprobar
}



#comprobamos la conexion a internet
if ping -c1 google.com &>/dev/null
then
    conexion="SI"
    #zenity --info --title="Creado por SUKIGSX" --text=" Conexion a internet OK" --timeout=2 --width=300 #--height=5
    menu
    software_necesario
    solo_mira_si_actualizar
    #zenity --info --title="Creado por SUKIGSX" --text="Se va a comprobar el software necesario." --timeout=2
    #zenity --info --title="Creado por SUKIGSX" --text="$(software_necesario)"
else
    conexion="NO"
    menu
    echo ""
    echo -e "${rojo} No hay conexion a internet, No se puede continuar.${borra_colores}"
    echo ""
    zenity --error --title="Creado por SUKIGSX" --text=" Fallo de Conexion a internet, NO se puede continuar." --ok-label="Salir" --width=300 --height=50 --timeout=10
    exit
fi





# Menú principal
while :
do
opcion=$(zenity --list --title="Creado por SUKIGSX" \
--text="Crear prompt para tu terminal de linux bash.   <b> El script $actualizado esta actualizado.</b>" \
--column="Menu de opciones" --column="Descripcion" \
"Crear prompt nuevo" "Diseña e instala tu prompt para la terminal bash." \
"Borrar prompt" "Borra el prompt que tengas diseñado con esta aplicacion." \
"Crear un lanzador" "Crear un lanzador del script en tu escritorio." \
"Borrar el lanzador" "Borra el lanzador del script en tu escritorio." \
"Actualizar el script" "Comprueba si existe alguna actualizacion." \
"Contacto" "Formas de poder ponerte en contacto con el creador de la aplicacion." \
"Ayuda" "Su nombre lo dice, carga la ayuda de la aplicacion." \
--width=650 \
--height=300 \
--ok-label="Aceptar" \
--cancel-label="Salir")

# Verificar si se presionó Cancelar o se cerró la ventana
if [ $? -ne 0 ]; then
    zenity --question --title="Creado por SUKIGSX" --text="¿Seguro que quieres salir?" --cancel-label="No" --ok-label="Si" --width=200

    # Verificar la respuesta del cuadro de diálogo de confirmación
    if [ $? -eq 0 ]; then
        exit 0
    fi
else
    # Ejecutar la opción seleccionada solo si no se ha presionado Cancelar o cerrado la ventana
    case $opcion in
        "Actualizar el script")
            actualizar_script
            zenity --info --title="Creado por SUKIGSX" --text="   --- Actualizando ---\n\nEs necesario reiniciar." --width=200
            exit
            ;;

        "Crear un lanzador")
            #recopila la ruta de donde esta el script
            ruta_script=$(dirname "$(readlink -f "$0")")
            #comprueba que exista la carpeta Escritorio
            if [ -d /home/$(whoami)/Escritorio/ ];then
                ruta_lanzador=/home/$(whoami)/Escritorio
            else
                ruta_lanzador=/home/$(whoami)/Desktop
            fi
            echo '[Desktop Entry]' >> $ruta_lanzador/crear_prompt.desktop
            echo 'Comment[es_ES]=' >> $ruta_lanzador/crear_prompt.desktop
            echo 'Comment=' >> $ruta_lanzador/crear_prompt.desktop
            echo 'Exec=nohup bash crear_prompt.sh' >> $ruta_lanzador/crear_prompt.desktop
            echo 'GenericName[es_ES]=' >> $ruta_lanzador/crear_prompt.desktop
            echo 'GenericName=' >> $ruta_lanzador/crear_prompt.desktop
            echo "Icon=autocorrection" >> $ruta_lanzador/crear_prompt.desktop
            echo 'MimeType=' >> $ruta_lanzador/crear_prompt.desktop
            echo 'Name[es_ES]=CrearPrompt: por SUKIGSX' >> $ruta_lanzador/crear_prompt.desktop
            echo 'Name=CrearPromptpor SUKIGSX' >> $ruta_lanzador/crear_prompt.desktop
            echo "Path=$ruta_script" >> $ruta_lanzador/crear_prompt.desktop
            echo 'StartupNotify=true' >> $ruta_lanzador/crear_prompt.desktop
            echo 'Terminal=false' >> $ruta_lanzador/crear_prompt.desktop
            echo 'TerminalOptions=' >> $ruta_lanzador/crear_prompt.desktop
            echo 'Type=Application' >> $ruta_lanzador/crear_prompt.desktop
            echo 'X-DBUS-ServiceName=' >> $ruta_lanzador/crear_prompt.desktop
            echo 'X-DBUS-StartupType=none' >> $ruta_lanzador/crear_prompt.desktop
            echo 'X-KDE-SubstituteUID=false' >> $ruta_lanzador/crear_prompt.desktop
            echo 'X-KDE-Username=' >> $ruta_lanzador/crear_prompt.desktop
            zenity --info --title="Creado por SUKIGSX" --text="Lanzador creado en tu escritorio." --width=200
            ;;

        "Borrar el lanzador")
            #comprueba que exista la carpeta Escritorio
            if [ -d /home/$(whoami)/Escritorio/ ];then
                ruta_lanzador=/home/$(whoami)/Escritorio
            else
                ruta_lanzador=/home/$(whoami)/Desktop
            fi

            if [ -f $ruta_lanzador/crear_prompt.desktop ] ;then
                zenity --question --title="Creado por SUKIGSX" --text="¿Seguro que quieres borrar el lanzador?" --cancel-label="No" --ok-label="Si" --width=200
                if [ $? = 0 ]; then
                    rm $ruta_lanzador/crear_prompt.desktop
                    zenity --info --title="Creado por SUKIGSX" --text="Lanzador borrado." --width=200 --timeout=3
                else
                    zenity --info --title="Creado por SUKIGSX" --text="Cancelado. No se borra el lanzador." --width=200 --timeout=3
                fi
            else
                zenity --info --title="Creado por SUKIGSX" --text="No existe lanzador." --width=200 --timeout=3
            fi
            ;;

        "Crear prompt nuevo")
            bash $ruta_ejecucion/crear_prompt_nuevo.PromptTerminal_gui
            ;;
        "Borrar prompt")
            if zenity --question --title="Creado por SUKIGSX" --text="¿Quieres borrar el prompt que tienes actualmente?\n\n- Se borrara la entrada del .bashrc.\n- Se eliminara el fichero que guarda el prompt." --title="Confirmación de borrado" --cancel-label="No" --ok-label="Si"; then
                rm -r /home/$(whoami)/.config/crear_prompt 1> /dev/null 2> /dev/null
                sed -i "/source \/home\/$(whoami)\/.config\/crear_prompt\/prompt/d" /home/$(whoami)/.bashrc
                zenity --info --title="Creado por SUKIGSX" --text="Prompt borrado = ok\nEntrada del bashrc eliminada = ok\nFichero configuracion eliminado = ok" --timeout=5

            else
                echo "Borrado cancelado."
            fi
            ;;
        "Contacto")
            zenity --info --title="Creado por SUKIGSX" --text="Contacto con SUKIGSX:\n\nWeb: repositorios.mbbsistemas.es\nCorreo: mbbsistemas@gmail.com"
            ;;
        "Ayuda")
            zenity --text-info --title="Creado por SUKIGSX" --filename="$ruta_ejecucion/ayuda.PromptTerminal_gui" --cancel-label="Ver mas grande" --ok-label="Aceptar" --width=600 --height=400
            if [ $? = 0 ]; then
                echo ""
            else
                zenity --text-info --title="Creado por SUKIGSX" --filename="$ruta_ejecucion/ayuda.PromptTerminal_gui" --cancel-label="Menu principal" --ok-label="Aceptar" --width=1500 --height=1000
            fi
            ;;
        *)
            zenity --error --title="Creado por SUKIGSX" --text="No has seleccionado una opcion del menu."
            ;;
    esac
fi
done
