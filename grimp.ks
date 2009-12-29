%include fedora-livecd-kde.ks

part / --size=8192

rootpw grimp

services --enabled=NetworkManager,sshd --disabled=rpcsvcgssd,rpcgssd,rpcidmapd,network,nfslock,nfs,rpcbind,sendmail

repo --name=rpmfusion-free --baseurl=http://download1.rpmfusion.org/free/fedora/releases/development/Everything/i386/os
repo --name=rpmfusion-free-updates --baseurl=http://download1.rpmfusion.org/free/fedora/updates/development/i386
repo --name=rpmfusion-non-free  --baseurl=http://download1.rpmfusion.org/nonfree/fedora/releases/development/Everything/i386/os
repo --name=rpmfusion-non-free-updates --baseurl=http://download1.rpmfusion.org/nonfree/fedora/updates/development/i386
repo --name=livna --baseurl=http://rpm.livna.org/repo/12/i386/
repo --name=google --baseurl=http://dl.google.com/linux/rpm/stable/i386
repo --name=skype --baseurl=http://download.skype.com/linux/repos/fedora/updates/i586/ 
repo --name=adobe --baseurl=http://linuxdownload.adobe.com/linux/i386/
### Add localRepo for grimp-release, grimp-logos, grimp-release-notes and move from commons- to grimp-

lang it_IT.UTF-8
keyboard it
timezone Europe/Rome

%packages

### L10n packages
@italian-support
hunspell-it
hunspell-en

### The KDE-Desktop
-koffice*
amarok
digikam
ktorrent
kdeartwork-screensavers
kdeplasma-addons
kmess
rekonq
kdeedu
kdeedu-kstars
kdeedu-marble
kdeedu-math

### Office
openoffice.org-base
openoffice.org-calc
openoffice.org-impress
openoffice.org-math
openoffice.org-writer

### Graphics
gimp
inkscape

### Rebranding
-fedora-logos
-fedora-release
-fedora-release-notes
generic-release
generic-logos
generic-release-notes

### Repository packages
rpmfusion-free-release
rpmfusion-nonfree-release
livna-release

### Codecs
xine-lib-extras-freeworld
gstreamer-ffmpeg
gstreamer-plugins-good
gstreamer-plugins-bad
gstreamer-plugins-bad-extras
gstreamer-plugins-ugly
libdvdcss

### Evil programs
vlc
skype
google-chrome-beta
flash-plugin

%end

%post

### Synaptic device
cat >> /etc/bashrc <<EOF

synclient tapbutton1=1
synclient vertedgescroll=1
synclient horizedgescroll=1
EOF


### Dolphin
cat > /usr/share/kde-settings/kde-profile/default/share/config/dolphinrc <<EOF
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

### Plasma

%end
