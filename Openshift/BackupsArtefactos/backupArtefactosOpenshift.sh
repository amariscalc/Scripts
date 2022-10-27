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
echo 'Introduzca el entorno PaaS del cual desea hacer los backups (DEV/PRE/PRO):'
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

#Crear los directorios si no existen
echo "Se va a realizar un backup de DC, Services, Routes y Secrets"

if [ ! -d "CMAPS" ] ;

    then mkdir CMAPS
fi

if [ ! -d "PODS" ] ;

    then mkdir PODS
fi

if [ ! -d "RCONTROLLERS" ] ;

    then mkdir RCONTROLLERS
fi

if [ ! -d "DC" ] ;

    then mkdir DC
fi

if [ ! -d "ROUTES" ] ;

    then mkdir ROUTES
fi

if [ ! -d "SERVICE" ] ;

    then mkdir SERVICE
fi

if [ ! -d "SECRETS" ] ;

    then mkdir SECRETS
fi

#Obtener los arfectos correspondiente y almacenarlos en sus respectivos directorios
cd ./RCONTROLLERS/
oc get rc | awk '{print $1}' | grep -v NAME | xargs -t -I backup sh -c 'oc get rc/backup -o yaml > backup.yaml'
cd ..

cd ./CMAPS/
oc get cm | awk '{print $1}' | grep -v NAME | xargs -t -I backup sh -c 'oc get cm/backup -o yaml > backup.yaml'
cd ..

cd ./PODS/
oc get pods | awk '{print $1}' | grep -v NAME | xargs -t -I backup sh -c 'oc get pods/backup -o yaml > backup.yaml'
cd ..

cd ./DC/
oc get dc | awk '{print $1}' | grep -v NAME | xargs -t -I backup sh -c 'oc get dc/backup -o yaml > backup.yaml'
cd ..

cd ./ROUTES/
oc get routes | awk '{print $1}' | grep -v NAME | xargs -t -I backup sh -c 'oc get routes/backup -o yaml > backup.yaml'
cd ..

cd ./SERVICE/
oc get service | awk '{print $1}' | grep -v NAME | xargs -t -I backup sh -c 'oc get service/backup -o yaml > backup.yaml'
cd ..

cd ./SECRETS/
oc get secrets | awk '{print $1}' | grep -v NAME | xargs -t -I backup sh -c 'oc get secrets/backup -o yaml > backup.yaml'
cd ..
