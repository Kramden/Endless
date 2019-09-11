#!/usr/bin/sh

echo "Setting default Wallpaper"
cp -p Background-Endless.png $HOME/Pictures/Wallpapers/
bg_string='file://'$HOME'/Pictures/Wallpapers/Background-Endless.png'
gsettings set org.gnome.desktop.background picture-uri $bg_string

echo "Copying content"
cp -rp skel/.var $HOME/
cp -rp skel/.local/share/desktop-directories $HOME/.local/share/

echo "Setting up user account"
gdbus call --system --dest org.freedesktop.Accounts --object-path /org/freedesktop/Accounts/User1001 -m org.freedesktop.Accounts.User.SetIconFile '' > /dev/null

gdbus call --system --dest org.freedesktop.Accounts --object-path /org/freedesktop/Accounts/User1001 -m org.freedesktop.Accounts.User.SetAutomaticLogin true > /dev/null

echo "Setting desktop icon grid"

gsettings set org.gnome.shell icon-grid-layout "{'desktop': ['google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'org.libreoffice.LibreOffice-writer.desktop', 'org.libreoffice.LibreOffice-calc.desktop', 'org.libreoffice.LibreOffice-impress.desktop', 'com.endlessm.encyclopedia.en.desktop', 'eos-folder-media.directory', 'eos-folder-curiosity.directory', 'eos-folder-games.directory', 'eos-folder-social.directory', 'net.minetest.Minetest.desktop', 'com.endlessm.cooking.en.desktop', 'com.endlessm.times_of_india.en_IN', 'org.gnome.Yelp.desktop'], 'eos-folder-curiosity.directory': ['com.endlessm.celebrities.en.desktop', 'com.endlessm.myths.en.desktop', 'com.endlessm.math.en.desktop', 'com.endlessm.howto.en.desktop', 'com.endlessm.travel.en.desktop', 'com.endlessm.health.en.desktop', 'com.endlessm.dinosaurs.en.desktop', 'com.endlessm.animals.en.desktop', 'com.endlessm.translation.desktop', 'eos-link-duolingo.desktop'], 'eos-folder-games.directory': ['org.gnome.Aisleriot.desktop', 'org.gnome.Chess.desktop', 'net.supertuxkart.SuperTuxKart.desktop', 'de.billardgl.Billardgl.desktop', 'org.seul.pingus.desktop', 'com.tux4kids.tuxmath.desktop', 'org.kde.gcompris.desktop', 'com.tux4kids.tuxtype.desktop', 'org.kde.ktuberling.desktop', 'io.thp.numptyphysics.desktop', 'org.debian.TuxPuck.desktop', 'net.sourceforge.Ri-li.desktop', 'com.teeworlds.Teeworlds.desktop', 'net.sourceforge.ExtremeTuxRacer.desktop', 'org.gna.Warmux.desktop'], 'eos-folder-media.directory': ['com.endlessm.photos.desktop', 'shotwell.desktop', 'eos-spotify.desktop', 'org.gnome.Totem.desktop', 'org.tuxpaint.Tuxpaint.desktop', 'org.audacityteam.Audacity.desktop', 'com.endlessm.world_literature.en.desktop', 'org.gimp.GIMP.desktop', 'eos-link-youtube.desktop', 'org.videolan.VLC.desktop', 'rhythmbox.desktop'], 'eos-folder-social.directory': ['eos-link-twitter.desktop', 'evolution.desktop', 'eos-skype.desktop', 'eos-link-gmail.desktop', 'eos-link-facebook.desktop', 'eos-link-whatsapp.desktop']}"

gnome-software --quit
sleep 1

