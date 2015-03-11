#!/bin/sh -e

if [ ! -f kernel-qemu ] ; then
	# See http://xecdesign.com/qemu-emulating-raspberry-pi-the-easy-way/
	wget http://xecdesign.com/downloads/linux-qemu/kernel-qemu
fi

./build.sh
# See https://github.com/woutervanwijk/Pi-MusicBox/issues/236 for default size
# dd if=/dev/zero of=Pi-MusicBox-installer.img count=1 bs=1002438656
truncate -s +1002438656 Pi-MusicBox-installer.img
mkfs.vfat -n "BOOTORIG" Pi-MusicBox-installer.img

IMAGE="`pwd`/Pi-MusicBox-installer.img"
pushd bootfs/
mcopy -i $IMAGE * ::/
popd

# FIXME: Use -nographic ?
qemu-system-arm -kernel kernel-qemu -initrd bootfs/installer-rpi1.cpio -cpu arm1176 -m 256 -M versatilepb -no-reboot -serial stdio -append "root=/dev/sda1 panic=0 ro" -hda Pi-MusicBox-installer.img
