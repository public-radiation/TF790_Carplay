# TF790
<what is>
# Requirments
## Hardware
SDcard
Laptop/PC/RPI with wifi. From here on reverd to as PC
##Software
socat (arm) and socat on your PC


# root acces (linux with explination)
Format the sdcard using the device 'Format SD' function on the device.
Power down the device -> place sdcard in a pc.

Create a shell script file on the root of the sdcard called "debug1"

In the root of the sdcard we add 2 static armv7l binaires. 
The first one is busybox, you can do without it but the default busybox (shell) is very limited. E.g. no find. 
Also when overwriting a running rootfs it's better if the running tool isn't on that file system:

[busybox-armv7l](https://www.busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-armv7l)

Please do not name it busybox, there are update scripts that may interfere with a bin called busybox.

The second is socat. Socat is a more advanced netcat tool. This allows us to create a no hassle telnetd.

[socat-armv7l-eabihf](https://github.com/polaco1782/linux-static-binaries/tree/master/armv7l-eabihf)

Open the debug1 file with a linux text app, vim/nano or kate/gedit and add #!/bin/sh to the begigin of the file
