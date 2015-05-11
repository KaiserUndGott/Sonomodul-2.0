#!/bin/sh

# mr@speedpoint.de  Version 26.11.2014
# Sono-Anbindung
# Start aus DavidX, Patient, Programme
# 
# Programm startet Programm sono-davidx.exe auf dem Windows-PC
#
# -----------------------------------------------------------------------
# Vorgaben
#
# IP-Adresse des WinPC mit dem Sonoprogramm
sonopcip="192.168.100.15"
#
# Portnummer des Rexservers auf dem Win.PC:
rexport="6666"
#
# Name des Sonoordners im DavidX-Patientenordner (wird dort automatisch angelegt)
sonodirnam="sonobilder"
#
# Symlinkname in trpword (wird automatisch mit dem Patordner verlinkt)
sonosymlink="sono-patient"
#
# Datum im Dateinamen:
# 0=kein Datum, nur Dateinamen-Dialog
# 1=Datum wird im Dateinamen-Dialog vorgeschlagen
# 2=Datum wird automatisch beim abspeichern vor den eingegebenen Dateinamen gesetzt
datregel="2"
#
# Datumformat im Dateinamen (3-stellig, z.B. JMT)
#     J=Jahr, M=Monat, T=Tag
# z.B. JMT wird zu 2013-02-26
datformat=JMT
#
# -----------------------------------------------------------------------




# ab hier keine Änderungen!
#
# Terminal-ID in david.cfg
ich=`echo $DAV_ID`
termid=`cat david.cfg|fgrep -v '#'|fgrep $ich|awk '{print $10}'`

# PatNr
pnr=`head -n1 trpword/text.$termid`

# Praxis
pxid="A"

trpw="/home/david/trpword"
pfad=`echo $pnr | awk '{printf("%08.f\n",$1)}' | awk -F '' '{printf("%d/%d/%d/%d/%d/%d/%d/%d",$1,$2,$3,$4,$5,$6,$7,$8)}'`
fullpfad="$trpw/pat_nr/$pxid/$pfad"

# Ordner Sonobilder im Patordner anlegen
mkdir -p -m 777 "$fullpfad/$sonodirnam" > /dev/null  
# Symlink "sono-patient" in trpword erzeugen
rm -rf $trpw/$sonosymlink > /dev/null
ln -s $fullpfad/$sonodirnam $trpw/$sonosymlink > /dev/null

[ "$datregel" = "" ] && datregel=2
[ "$datformat" = "" ] && datformat=JMT

datform=$datformat$datregel
echo "DAVCMD start %systemdrive%\\david\\sono\\sono-davidx.exe /copyto=$sonosymlink /patnr=$pnr /datformat=$datform"|netcat $sonopcip $rexport > /dev/null


