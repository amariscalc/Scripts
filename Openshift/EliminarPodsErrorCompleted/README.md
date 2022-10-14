= Script eliminar Pods Openshift en estado Error o completed
:doctype: book
:sectnums:
:toc:
:toclevels: 3
:toc-title: Índice
:icons: font
:imagesdir: images/
ifdef::env-github[]
:tip-caption: :bulb:
:note-caption: :information_source:
:important-caption: :heavy_exclamation_mark:
:caution-caption: :fire:
:warning-caption: :warning:
endif::[]
:toc:
:toclevels: 4
:toc-title: Índice
:sectnums:
:sectnumlevels: 4



== Características

=== Requisitos previos
· Ejecución de scripts bash.
· Cliente "oc" (Openshift): https://developers.redhat.com/openshift/command-line-tools

=== Descripción
Script escrito en bash para ayudar a eliminar pods en estado distinto a "Running".

=== Modo de empleo
El script está preparado para recibir un fichero llamado proyectos.txt con un listado de namespaces de Openshift.
El fichero solo debe tener un nombre de namespace por línea.
En caso de no encontrarse el fichero proyectos.txt en el mismo directorio que el propio script se pedirá al usuario que se introduzca
manualmente el nombre de un namespace.