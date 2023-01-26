#!/bin/bash

####Script info DC
echo 'Script para obtener información de los deployment config de un proyecto en OpenShift'

#Pedimos usuario
echo 'Introduzca usuario:'
read -r user

#Pedimos contraseña:
echo 'Introduzca contraseña:'
read -r -s passwd

#Pedimos entorno:
echo 'Introduzca el entorno PaaS (DEV/PREBO1/PREBO2/PROBO1P2/PROBO2P2/DMZBO1P2/DMZBO2P2/PROBO1P3/PROBO2P3/DMZBO1P3/DMZBO2P3):'
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

###Comprobamos si el fichero "proyectos" existe en el mismo directorio del script.
if [ -f proyectos.txt ];
then
	while IFS= read line
	do
		for i in $(cat proyectos.txt)
			do
				oc project $i
				oc get dc -o=custom-columns=MICRO:.metadata.name,MEMORY_REQUEST:'.spec.template.spec.containers[].resources.requests.memory',MEMORY_LIMIT:'.spec.template.spec.containers[].resources.limits.memory',CPU_REQUEST:'.spec.template.spec.containers[].resources.requests.cpu',CPU_LIMIT:'.spec.template.spec.containers[].resources.limits.cpu',READINESS:'.spec.template.spec.containers[].readinessProbe.httpGet.path',READINESS_TIME:'.spec.template.spec.containers[].readinessProbe.initialDelaySeconds',LIVENESS:'.spec.template.spec.containers[].livenessProbe.httpGet.path',LIVENESS_TIME:'.spec.template.spec.containers[].livenessProbe.initialDelaySeconds'
			done
	done < proyectos.txt
else

	#Pedimos proyecto:
	echo 'Introduzca el proyecto sobre el que desea actuar:'
	read -r proyecto

	##Seleccionamos proyecto
	oc project $proyecto

	##Obtenemos la info
	oc get dc -o=custom-columns=MICRO:.metadata.name,MEMORY_REQUEST:'.spec.template.spec.containers[].resources.requests.memory',MEMORY_LIMIT:'.spec.template.spec.containers[].resources.limits.memory',CPU_REQUEST:'.spec.template.spec.containers[].resources.requests.cpu',CPU_LIMIT:'.spec.template.spec.containers[].resources.limits.cpu',READINESS:'.spec.template.spec.containers[].readinessProbe.httpGet.path',READINESS_TIME:'.spec.template.spec.containers[].readinessProbe.initialDelaySeconds',LIVENESS:'.spec.template.spec.containers[].livenessProbe.httpGet.path',LIVENESS_TIME:'.spec.template.spec.containers[].livenessProbe.initialDelaySeconds'
fi

####Mensaje despedida
echo 'Saliendo del script...'

####Todo mérito para mi compañero Ernesto Gimeno Valiente: https://www.linkedin.com/in/ernesto-gimeno-valiente/
