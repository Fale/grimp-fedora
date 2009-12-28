%include fedora-live-base.ks

# we need more space now
part / --size=8192

rootpw grimp

services --disabled=rpcsvcgssd,rpcgssd,rpcidmapd

repo --name=rpm-fusion-free --baseurl=http://download1.rpmfusion.org/free/fedora/releases/12/Everything/i386/os/
repo --name=rpm-fusion-nonfree --baseurl=http://download1.rpmfusion.org/nonfree/fedora/releases/12/Everything/i386/os/
repo --name=livna --baseurl=http://rpm.livna.org/repo/12/i386/
repo --name=google --baseurl=http://dl.google.com/linux/rpm/stable/i386
repo --name=skype --baseurl=http://download.skype.com/linux/repos/fedora/updates/i586/ 
repo --name=adobe --baseurl=http://linuxdownload.adobe.com/linux/i386/

lang it_IT.UTF-8
keyboard it
timezone Europe/Rome

%packages

# L10n packages
@italian-support
hunspell-it

### The KDE-Desktop

@kde-desktop

# unwanted packages from @kde-desktop
# don't include these for now to fit on a cd
-scribus
-kftpgrabber*		# kdelibs3
-kaffeine*
-koffice-suite

# Additional packages that are not default in kde-desktop but useful
k3b			# kdelibs3
fuse
liveusb-creator
kmess
rekonq
kdeedu
kdeedu-kstars
kdeedu-marble
kdeedu-math

# use yum-presto by default
yum-presto

# office
openoffice.org-base
openoffice.org-calc
openoffice.org-impress
openoffice.org-math
openoffice.org-writer

# graphics
gimp
inkscape

### fixes

# use system-config-printer-kde instead of system-config-printer
-system-config-printer
system-config-printer-kde

# make sure alsaunmute is there
alsa-utils

# make sure gnome-packagekit doesn't end up the KDE live images
-gnome-packagekit*




# repository packages
rpmfusion-free-release
rpmfusion-nonfree-release
livna-release

# codecs
xine-lib-extras-freeworld
gstreamer-ffmpeg
gstreamer-plugins-good
gstreamer-plugins-bad
gstreamer-plugins-ugly
libdvdcss

# evil programs
vlc
skype
google-chrome-beta
flash-plugin

%end

%post

# create /etc/sysconfig/desktop (needed for installation)
cat > /etc/sysconfig/desktop <<EOF
DESKTOP="KDE"
DISPLAYMANAGER="KDE"
EOF

# add initscript
cat >> /etc/rc.d/init.d/livesys << EOF

if [ -e /usr/share/icons/hicolor/96x96/apps/fedora-logo-icon.png ] ; then
    # use image also for kdm
    mkdir -p /usr/share/apps/kdm/faces
    cp /usr/share/icons/hicolor/96x96/apps/fedora-logo-icon.png /usr/share/apps/kdm/faces/fedora.face.icon
fi

# make liveuser use KDE
echo "startkde" > /home/liveuser/.xsession
chmod a+x /home/liveuser/.xsession
chown liveuser:liveuser /home/liveuser/.xsession

# set up autologin for user liveuser
sed -i 's/#AutoLoginEnable=true/AutoLoginEnable=true/' /etc/kde/kdm/kdmrc
sed -i 's/#AutoLoginUser=fred/AutoLoginUser=liveuser/' /etc/kde/kdm/kdmrc

# set up user liveuser as default user and preselected user
sed -i 's/#PreselectUser=Default/PreselectUser=Default/' /etc/kde/kdm/kdmrc
sed -i 's/#DefaultUser=johndoe/DefaultUser=liveuser/' /etc/kde/kdm/kdmrc

# add liveinst.desktop to favorites menu
mkdir -p /home/liveuser/.kde/share/config/
cat > /home/liveuser/.kde/share/config/kickoffrc << MENU_EOF
[Favorites]
FavoriteURLs=/usr/share/applications/kde4/konqbrowser.desktop,/usr/share/applications/kde4/dolphin.desktop,/usr/share/applications/kde4/systemsettings.desktop,/usr/share/applications/liveinst.desktop
MENU_EOF

# show liveinst.desktop on desktop and in menu
sed -i 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop

# chmod +x ~/Desktop/liveinst.desktop to disable KDE's security warning
chmod +x /usr/share/applications/liveinst.desktop

# copy over the icons for liveinst to hicolor
cp /usr/share/icons/gnome/16x16/apps/system-software-install.png /usr/share/icons/hicolor/16x16/apps/
cp /usr/share/icons/gnome/22x22/apps/system-software-install.png /usr/share/icons/hicolor/22x22/apps/
cp /usr/share/icons/gnome/24x24/apps/system-software-install.png /usr/share/icons/hicolor/24x24/apps/
cp /usr/share/icons/gnome/32x32/apps/system-software-install.png /usr/share/icons/hicolor/32x32/apps/
cp /usr/share/icons/gnome/scalable/apps/system-software-install.svg /usr/share/icons/hicolor/scalable/apps/
touch /usr/share/icons/hicolor/

# Disable the update notifications of kpackagekit
cat > /home/liveuser/.kde/share/config/KPackageKit << KPACKAGEKIT_EOF
[CheckUpdate]
autoUpdate=0
interval=0

[Notify]
notifyLongTasks=2
notifyUpdates=0
KPACKAGEKIT_EOF

# Disable nepomuk
cat > /home/liveuser/.kde/share/config/nepomukserverrc << NEPOMUK_EOF
[Basic Settings]
Start Nepomuk=false

[Service-nepomukstrigiservice]
autostart=false
NEPOMUK_EOF

# make sure to set the right permissions and selinux contexts
chown -R liveuser:liveuser /home/liveuser/
restorecon -R /home/liveuser/

# don't use prelink on a running KDE live image
sed -i 's/PRELINKING=yes/PRELINKING=no/' /etc/sysconfig/prelink

# small hack to enable plasma-netbook workspace on boot
if strstr "\`cat /proc/cmdline\`" netbook ; then
   mv /usr/share/autostart/plasma-desktop.desktop /usr/share/autostart/plasma-netbook.desktop
   sed -i 's/desktop/netbook/g' /usr/share/autostart/plasma-netbook.desktop
fi

EOF



###### OUR EDITS

### Synaptic device
cat >> /etc/bashrc <<EOF
synclient tapbutton1=1
synclient vertedgescroll=1
synclient horizedgescroll=1
EOF


### Dolphin
cat > /usr/share/kde-settings/kde-profile/default/share/config <<EOF
[General]
ShowCopyMoveMenu=true
EOF

cat >> /usr/share/kde-settings/kde-profile/default/share/config/kdeglobals <<EOF
[KDE]
ShowDeleteCommand=true
SingleClick=true

[PreviewSettings]
MaximumSize=5242880
UseFileThumbnails=true
EOF

##### Hard stuff
# Global Shortcuts
#sed -i 's/Switch to Next Desktop=none,none,Va al desktop successivo/Switch to Next Desktop=Ctrl+Alt+Right,none,Va al desktop successivo/' /usr/share/kde-settings/kde-profile/default/share/config/kglobalshortcutsrc
#cp default/share/config/kglobalshortcutsrc /usr/share/kde-settings/kde-profile/default/share/config

%end
