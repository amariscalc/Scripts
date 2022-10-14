#!/bin/bash

####Script limpieza pods en completed y error
echo 'Script para limpieza de pods en estado completed y error'

#Pedimos usuario
echo 'Introduzca usuario:'
read -r user

#Pedimos contraseña:
echo 'Introduzca contraseña:'
read -r -s passwd

#Pedimos entorno:
echo 'Introduzca el entorno/cluster Openshift del cual desea eliminar los pods (DEV/PRE/PRO):'
read -r entorno


#Hacemos login en el entorno correspondiente
case $entorno in
	DEV)
		oc login --insecure-skip-tls-verify=true -u $user -p $passwd URL_ACCESO_API_OPENSHIFT_DESARROLLO:PORT
		;;
	PRE)
		oc login --insecure-skip-tls-verify=true -u $user -p $passwd URL_ACCESO_API_OPENSHIFT_PREPRODUCCION:PORT
		;;
	PRO)
		oc login --insecure-skip-tls-verify=true -u $user -p $passwd URL_ACCESO_API_OPENSHIFT_PRODUCCION:PORT
		;;
	*)
		echo 'No se ha introducido un entorno compatible'
		;;
esac

###Comprobamos si el fichero "projectos" existe en el mismo directorio del script.
if [ -f proyectos.txt ];
then
	while IFS= read line
	do
		oc project $line
		for i in $(oc get pods --field-selector=status.phase!=Running -o custom-columns=POD:.metadata.name --no-headers)
			do
				oc delete pod $i
			done
	done < proyectos.txt

else

	#Pedimos proyecto:
	echo 'Introduzca el proyecto sobre el que desea actuar:'
	read -r projecto

	##Seleccionamos proyecto
	oc project $projecto

	##Eliminamos pods complete y error
	for i in $(oc get pods --field-selector=status.phase!=Running -o custom-columns=POD:.metadata.name --no-headers)
		do
			oc delete pod $i
		done
fi

####Mensaje despedida
echo 'Saliendo del script...'
