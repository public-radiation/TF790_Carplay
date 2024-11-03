## TF790

\# Requirments ## Hardware SDcard Laptop/PC/RPI with wifi. From here on referred to as PC ##Software socat (arm) and socat on your PC

## root acces (Linux with explanation)

Format the sdcard using the device 'Format SD' function on the device.  
Power down the device -> place sdcard in a pc.

### Create a shell script file on the root of the sdcard called "debug1"

In the root of the sdcard we add 2 static armv7l binaires.  
The first one is busybox, you can do without it but the default busybox (shell) is very limited. E.g. no find.  
Also when overwriting a running rootfs it's better if the running tool isn't on that file system:

[busybox-armv7l](https://www.busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-armv7l)

Please do not rename the file to busybox, there are update scripts that may interfere with a bin called busybox. I renamed mine to busybox\_arm.

The second is socat. Socat is a more advanced netcat tool. This allows us to create a no hassle telnetd.

[socat-armv7l-eabihf](https://github.com/polaco1782/linux-static-binaries/tree/master/armv7l-eabihf)

Open the debug1 file with a linux text app, vim/nano or kate/gedit and insert the folowing:

```plaintext
#!/bin/sh
/mnt/extsd/socat TCP-LISTEN:12345,reuseaddr,fork EXEC:/bin/sh,pty,stderr,setsid,sigint,sane &amp;
```

This forkes a socat sesion to the background listening on port 12345.  
From an other pc that is connected to the device wifi use this string to connect:

```plaintext
socat FILE:`tty`,raw,echo=0 TCP:target.com:12345
```

## root acces (quick version)

```plaintext
cd /media/<user_name>/DASHCAM
touch debug1
echo -e '#!/bin/sh\n/mnt/extsd/socat TCP-LISTEN:12345,reuseaddr,fork EXEC:/bin/sh,pty,stderr,setsid,sigint,sane &amp;' &gt;&gt; debug1
wget "https://github.com/polaco1782/linux-static-binaries/tree/master/armv7l-eabihf" -O busybox_arm
wget "https://www.busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-armv7l" -O socat
chmod +x busybox_armv7l socat debug1
cd ../ &amp;&amp; umount DASHCAM
```

```plaintext
socat FILE:`tty`,raw,echo=0 TCP:target.com:12345
```

## Example scripts

### full device backup

Recommended , this scripts dumps mtdblock partitions to sdcard

### backup write back

This allows for software update without the phoenix card suite, but requires sdcard to work.  
So be carefull with boot0 (mtdblock), this can change the location of the sdcard slot. Since wifi and sdcard are both on the same bus they some times get switched around.

### Remote acces

See explanation above

### (work in progress)

Convert script mtdblock\[1-7\] to phoenix card

## Phoenix card image format

The Phoenix card images can be dump/unpackaged with imgrepacker version 2.078 from [XDA](https://xdaforums.com/tags/imgrepacker/)  
There is only one issue, the image.cfg has an extra insert that caused extra data/unneeded to leak in the image. Running the next sed command fixes that issue:

```plaintext
~/Downloads/imgRePacker_2078/imgrepacker <tf790.img>
cd <tf790.img.dump>
sed 's/INPUT_DIR .. //g' -i  image.cfg
```

If you change file(s) in the image you need to regenerate the checksums. checksum files start with capital letter V.  
rootfs.fex checksum file is called Vrootfs.fex

```plaintext
FileAddSum rootfs.fex   Vrootfs.fex
```

To repackage the file use dragon:

```plaintext
cd TF790.img.dump
dragon image.cfg sys_config.fex
```

When comparing files i recommend to use [hexcompare](http://sourceforge.net/projects/hexcompare/) terminal app. (

#todo insert tools repo's for these tools, in the mean, they are all on github. check tiny-v83 repo

#### Missing Windows partition (TF981)

Sometimes the package files image.cfg specifies a non-existing windows partition. If that is te case you get a error during image dump.   
Useing force option allows you to finish the dump, remove the windows parition line from the cfg and you can repackage the file.

#### Extract device tree

The device tree is in the image twice, i have figured out why. One therory is that one is used by u-boot and the other is used by Linux.

When extracted there is a file called sunxi.fex. This is a device tree with zero's appended to the end. DTC doesn't care, to decompile the dts:

```plaintext
dtc -I dtb -O dts -o sunxi.dts sunxi.dtb
```

## Create Flash SD card

Download phoenix card (latest version I came across is on the [sipeed dropbox](https://drive.google.com/drive/folders/1wlpU_TwwpGMRikLlfoGm5CIqnpij8AC2). Please use google if you have trouble there are many guides and walktroughs on the net.

## to do create script

\</tf790.img.dump>\</tf790.img>