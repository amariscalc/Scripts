#!/bin/bash

# Conocer y establecer la ruta del script para ser portable.
RUTACOMPLETA=$(realpath "$0")
DIRECTORIO=$(dirname "$RUTACOMPLETA")

#Pedir usuario
echo 'Introduzca usuario:'
read -r user

#Pedir contraseña:
echo 'Introduzca contraseña:'
read -r -s passwd

#Pedir entorno:
echo 'Introduzca el entorno/cluster Openshift del cual desea hacer los backups (DEV/PRE/PRO):'
read -r entorno

#Hacer login en el entorno correspondiente
case $entorno in
	DEV)
		oc login --insecure-skip-tls-verify=true -u $user -p $passwd URL_ACCESO_API_OPENSHIFT_DESARROLLO:PORT
		;;
	PRE)
		oc login --insecure-skip-tls-verify=true -u $user -p $passwd URL_ACCESO_API_OPENSHIFT_DESARROLLO:PORT
		;;
	PRO)
		oc login --insecure-skip-tls-verify=true -u $user -p $passwd URL_ACCESO_API_OPENSHIFT_DESARROLLO:PORT
		;;
	*)
		echo 'No se ha introducido un entorno compatible'
		;;
esac

#Introducir proyecto:
echo 'Introduzca el proyecto sobre el que desea actuar:'
read -r proyecto

##Seleccionar proyecto
oc project $proyecto

#Obtener la fecha de hoy. Crear directorio para el backup y entrar en el mismo
date=$(date '+%Y%m%d')
mkdir $proyecto-$entorno-$date
cd $proyecto-$entorno-$date

echo "Se va a realizar un backup de DC, Services, Routes y Secrets"

#Se recorre bucle sobre los objetos, se crea ditectorio si no existe y se guarda backup dentro de dicho directorio
for objet in cm pods rc dc routes service secrets ; do
    if [ ! -d "$objet" ] ;then mkdir $objet;    fi
oc get $objet | awk '{print $1}' | grep -v NAME | xargs -t -I backup sh -c "oc get $objet/backup -o yaml > $objet/backup.yaml" 

done
