#!/bin/bash
#2025-07-03a
rc_nameRegistro=registroc
#webserver=https://www.santafe.gob.ar/documentos/rcivil
webserver=https://raw.githubusercontent.com/jkober/files_rc/main/linux
#webserver=10.7.1.196/~desarrollo/documentos/rcivil
escritorio=$HOME/Escritorio
accesoDirecto=$escritorio/firma2.desktop
if [ -f $accesoDirecto ]
then 
	rm $accesoDirecto
fi
accesoDirecto=$escritorio/firmaScan.desktop
if [ ! -f $HOME/tmpRc ]
then
	mkdir $HOME/tmpRc
fi
cd $HOME/tmpRc
if [ $? -eq 0 ]
then
	rm *.zip
	rm *.sh
	rm *.txt
	rm linux
else
	echo "Errores"
	read a 
	exit 0
fi
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------
if [ ! -f $HOME/rcdigital-linux/linux.sh ]
then
	wget $webserver/rcdigital-linux.zip
	if [ -f rcdigital-linux.zip ]
	then	
		unzip -o rcdigital-linux.zip
		mv rcdigital-linux $HOME
	fi
else
	wget $webserver/linux
	if [ -f linux ]
	then
		versionLunux1=`cat linux`
		versionLunux2=`cat $HOME/rcdigital-linux/linux`
		if [ $versionLunux1 = $versionLunux2 ] 
		then
			echo version actaulizada rcdigital-linux
		else
			wget $webserver/rcdigital-linux.zip
			if [ -f rcdigital-linux.zip ]
			then	
				unzip -o rcdigital-linux.zip
				rm -r $HOME/rcdigital-linux
				mv rcdigital-linux $HOME
			fi
		fi
	else
		echo "Error grave"
		read a
		exit 1
	fi
fi
#--------------------------------------------------------------------------------------------
if [ ! -f $HOME/linux-java/AppScanners.jar ]
then
	wget $webserver/linux-java.zip
	if [ -f linux-java.zip ]
	then	
		unzip -o linux-java.zip
		mv linux-java $HOME
	fi
else
	wget $webserver/linux-java.txt
	if [ -f linux-java.txt ]
	then
		versionLunux1=`cat linux-java.txt`
		versionLunux2=`cat $HOME/linux-java/linux-java.txt`
		if [ $versionLunux1 = $versionLunux2 ] 
		then
			echo version actaulizada rcdigital-java
		else
			wget $webserver/linux-java.zip
			if [ -f linux-java.zip ]
			then	
				unzip -o linux-java.zip
				rm -r $HOME/linux-java
				mv linux-java $HOME
			fi
		fi
	else
		echo "Error grave"
		read a
		exit 1
	fi
fi

if [ ! -f $accesoDirecto ]
then
	echo "#!/usr/bin/env xdg-open" 				> $accesoDirecto
	echo "[Desktop Entry]"						>> $accesoDirecto
	echo "Version=1.0"							>> $accesoDirecto
	echo "Type=Application"						>> $accesoDirecto
	echo "Terminal=false"						>> $accesoDirecto
	echo "Icon[es_AR]=gnome-panel-launcher" 	>> $accesoDirecto
	echo "Name[es_AR]=Firma/Escaner"			>> $accesoDirecto
	echo "Exec=/bin/bash $HOME/rcdigital-linux/linux-load.sh " >> $accesoDirecto
	echo "Name=Firma/Escaner"					>> $accesoDirecto
	echo "Icon=scanner"							>> $accesoDirecto
    chmod 775 $accesoDirecto
fi
if [ ! -f $HOME/$rc_nameRegistro/rcivil.txt ]
then
	wget $webserver/rcivil.zip
	if [ ! -f rcivil.zip ] 
	then
		echo "No se puedo bajar el zip errore importante"
		read a 
		exit 0
	fi
	unzip -o rcivil.zip 
	mv $rc_nameRegistro $HOME
	echo "rc_escanerPort=\" -d genesys \"" >$HOME/$rc_nameRegistro/usuario/conf-escaner.sh
else
	wget $webserver/rcivil.txt
	versionLunux1=`cat rcivil.txt`
	versionLunux2=`cat $HOME/$rc_nameRegistro/rcivil.txt`
	if [ $versionLunux1 = $versionLunux2 ] 
	then
		echo version actaulizada rcdigital-linux
	else
		wget $webserver/rcivil.zip
		if [ -f rcivil.zip ]
		then	
			unzip -o rcivil.zip
			if [ -f $HOME/$rc_nameRegistro/usuario/conf-escaner.sh ]
			then	
				mv $HOME/$rc_nameRegistro/usuario/conf-escaner.sh .
			else
				echo "rc_escanerPort=\" -d genesys \"" > conf-escaner.sh
			fi
			rm -r $HOME/$rc_nameRegistro
			mv $rc_nameRegistro $HOME
			mv conf-escaner.sh $HOME/$rc_nameRegistro/usuario/conf-escaner.sh
		fi
	fi
fi
# inicio 2018-23-03 
if [ ! -f $HOME/$rc_nameRegistro/rcivilup.txt ]
then
	wget $webserver/rcivilup.zip
	if [ ! -f rcivilup.zip ] 
	then
		echo "No se puedo bajar el zip errore importante rcivilup"
		read a 
		exit 0
	fi
	unzip -o rcivilup.zip 
	mv $rc_nameRegistro $HOME
else
	wget $webserver/rcivilup.txt
	versionLunux1=`cat rcivilup.txt`
	versionLunux2=`cat $HOME/$rc_nameRegistro/rcivilup.txt`
	if [ $versionLunux1 = $versionLunux2 ] 
	then
		echo version actaulizada rcdigital-linux
	else
		wget $webserver/rcivilup.zip
		if [ -f rcivilup.zip ]
		then	
			unzip -o rcivilup.zip
			mv -f $rc_nameRegistro $HOME
		fi
	fi
fi

# fin 2018-23-03
if [ $rc_inicia_app_link  ]
then
	echo "Existe LINK"
else
	## ejecuta en segundo plano
	ps -ef | awk '/AppScanners.jar/ && !/awk/ {print $2}'| xargs -r kill -9
	java -jar $HOME/linux-java/AppScanners.jar &
fi
## ejecuta en segundo plano
#ps -ef | awk '/AppScanners.jar/ && !/awk/ {print $2}'| xargs -r kill -9
#java -jar $HOME/linux-java/AppScanners.jar &
##---------------------------------------------------------------
exit 0


