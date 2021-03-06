#!/bin/bash

failed=0
error_text=""

who=`whoami`
if [ "$who" != "user" ];
then
    failed=1
    error_text="$error_text <span><b>Username:</b> $who</span>"
fi

for p in us.zoom.Zoom org.videolan.VLC com.anydesk.Anydesk net.sourceforge.Klavaro;
do
  flatpak info $p > /dev/null 2>&1
  if [ $? -ne 0 ];
  then
    failed=1
    error_text="$error_text <span><b>$p not installed</b></span>"
  fi
done

bg_string='file://'$HOME'/Pictures/Wallpapers/Background-Endless.png'
current_background=`gsettings get org.gnome.desktop.background picture-uri | tr -d "'"`
if [ "$current_background" != $bg_string ];
then
    failed=1
    error_text="$error_text <span><b>Current Background:</b> $current_background</span>"
fi
local_bg_file=`echo $current_background | sed -e 's/file:\/\///g'`

if [ ! -f $local_bg_file ];
then
    failed=1
    error_text="$error_text <span><b>Background image doesn't exist:</b> $current_background</span>"
fi

icon_file=`gdbus introspect --system --dest org.freedesktop.Accounts --object-path /org/freedesktop/Accounts/User1001 --only-properties  |grep IconFile | sed -e 's/readonly s IconFile = //g'|tr -d ';'|tr -d ' '| tr -d "'"`

if [ ! -z $icon_file ] && [ ! "$icon_file" = "$HOME/.face" ];
then
    failed=1
    error_text="$error_text <span><b>Icon File:</b> $icon_file</span>"
fi

auto_login=`gdbus introspect --system --dest org.freedesktop.Accounts --object-path /org/freedesktop/Accounts/User1001 --only-properties  |grep AutomaticLogin | sed -e 's/readonly b AutomaticLogin = //g'|tr -d ';'|tr -d ' '| tr -d "'"`
if [ $auto_login != 'true' ];
then
    failed=1
    error_text="$error_text <span><b>Automatic Login:</b> $auto_login</span>"
fi

if [ -f $HOME/.local/share/desktop-directories/eos-folder-curiosity.directory ];
then
    grep -e Education $HOME/.local/share/desktop-directories/eos-folder-curiosity.directory > /dev/null
    if [ $? -ne 0 ];
    then
        failed=1
        error_text="$error_text <span><b>Education folder doesn't exist</b></span>"
    fi
else
    failed=1
    error_text="$error_text <span><b>Education folder doesn't exist</b></span>"
fi

lo_setup_failed=0
grep com.sun.star.text.TextDocument \
    $HOME/.var/app/org.libreoffice.LibreOffice/config/libreoffice/*/user/registrymodifications.xcu 2>/dev/null | \
    grep -q "MS Word 2007"
if [ $? -ne 0 ];
then
    lo_setup_failed=1
fi

grep com.sun.star.presentation.PresentationDocument \
    $HOME/.var/app/org.libreoffice.LibreOffice/config/libreoffice/*/user/registrymodifications.xcu 2>/dev/null | \
if [ $? -ne 0 ];
then
    lo_setup_failed=1
fi
grep com.sun.star.sheet.SpreadsheetDocument \
    $HOME/.var/app/org.libreoffice.LibreOffice/config/libreoffice/*/user/registrymodifications.xcu 2>/dev/null | \
    grep -q "MS Excel 2007 XML"
if [ $? -ne 0 ];
then
    lo_setup_failed=1
fi
if [ $lo_setup_failed -eq 1 ];
then
    failed=1
    error_text="$error_text <span><b>LibreOffice not configured</b></span>"
fi

current_icon_grid_layout=""
current_icon_grid_layout=`gsettings get org.gnome.shell icon-grid-layout`
icon_grid_layout="{'desktop': ['google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'org.libreoffice.LibreOffice-writer.desktop', 'org.libreoffice.LibreOffice-calc.desktop', 'org.libreoffice.LibreOffice-impress.desktop', 'com.endlessm.encyclopedia.en.desktop', 'eos-folder-media.directory', 'eos-folder-curiosity.directory', 'eos-folder-games.directory', 'eos-folder-social.directory', 'net.minetest.Minetest.desktop', 'com.endlessm.cooking.en.desktop', 'com.endlessm.times_of_india.en_IN', 'org.gnome.Yelp.desktop'], 'eos-folder-curiosity.directory': ['com.endlessm.celebrities.en.desktop', 'com.endlessm.myths.en.desktop', 'com.endlessm.math.en.desktop', 'com.endlessm.howto.en.desktop', 'com.endlessm.travel.en.desktop', 'com.endlessm.health.en.desktop', 'com.endlessm.dinosaurs.en.desktop', 'com.endlessm.animals.en.desktop', 'com.endlessm.translation.desktop', 'eos-link-duolingo.desktop'], 'eos-folder-games.directory': ['org.gnome.Aisleriot.desktop', 'org.gnome.Chess.desktop', 'net.supertuxkart.SuperTuxKart.desktop', 'de.billardgl.Billardgl.desktop', 'org.seul.pingus.desktop', 'com.tux4kids.tuxmath.desktop', 'org.kde.gcompris.desktop', 'com.tux4kids.tuxtype.desktop', 'org.kde.ktuberling.desktop', 'io.thp.numptyphysics.desktop', 'org.debian.TuxPuck.desktop', 'net.sourceforge.Ri-li.desktop', 'com.teeworlds.Teeworlds.desktop', 'net.sourceforge.ExtremeTuxRacer.desktop', 'org.gna.Warmux.desktop'], 'eos-folder-media.directory': ['com.endlessm.photos.desktop', 'shotwell.desktop', 'eos-spotify.desktop', 'org.gnome.Totem.desktop', 'org.tuxpaint.Tuxpaint.desktop', 'org.audacityteam.Audacity.desktop', 'com.endlessm.world_literature.en.desktop', 'org.gimp.GIMP.desktop', 'eos-link-youtube.desktop', 'org.videolan.VLC.desktop', 'rhythmbox.desktop'], 'eos-folder-social.directory': ['eos-link-twitter.desktop', 'evolution.desktop', 'eos-skype.desktop', 'eos-link-gmail.desktop', 'eos-link-facebook.desktop', 'eos-link-whatsapp.desktop']}"

if [ "$current_icon_grid_layout" != "$icon_grid_layout" ];
then
    failed=1
    error_text="$error_text <span><b>Icon Grid incorrect</b></span>"
fi

if [ $failed -eq 1 ];
then
    echo $error_text
fi
