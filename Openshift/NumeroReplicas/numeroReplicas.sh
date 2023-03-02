#!/bin/bash

####Script para setear un numero de replicas para todos los microservicios de un namespace
echo 'Script para configurar el numero de replicas de todos los microservicios de un namespace'

#Pedimos usuario
echo 'Introduzca usuario:'
read -r user

#Pedimos contraseña:
echo 'Introduzca contraseña:'
read -r -s passwd

#Pedimos entorno:
echo 'Introduzca el entorno PaaS del cual desea modificar el número de pods (DEV/PRE/PRO):'
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

#Pedimos proyecto:
echo 'Introduzca el proyecto sobre el que desea actuar:'
read -r proyecto

##Seleccionamos proyecto
oc project $proyecto

#Pedir numero de replicas
echo 'Introduzca el numero de replicas (pods) que desea establecer para todos los microservicios:'
read -r replicas

##Aplicamos el numero de replicas
for DC in $(oc get dc -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}');do oc scale dc $DC --replicas=$replicas; done

####Mensaje despedida
echo 'Saliendo del script...'

####Gracias Guillermo Tocino Molina
