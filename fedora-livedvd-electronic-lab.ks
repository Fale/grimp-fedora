# Description : Live DVD image for Fedora Electronic Lab
#
# Maintainer(s):
# - Chitlesh Goorah <chitlesh a fedoraproject.org>
# - Thibault North  <tnorth   a fedoraproject.org>

%include fedora-livecd-desktop.ks

# DVD payload
part / --size=8192

%packages

@electronic-lab


# Office
dia
vym
openoffice.org-writer
openoffice.org-calc
openoffice.org-impress
openoffice.org-extendedPDF
planner
graphviz


# debugging tools
make
gdb
valgrind
kdbg
wireshark-gnome
qemu


# EDA/CAD department
perl-Test-Pod
perl-Test-Pod-Coverage


# Removing unnecessary packages from the desktop spin
-abiword
-@games
-gimp
-gimp-libs
-gimp-data-extras
-kdebluetooth


%end

%post

%end
