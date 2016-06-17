rpi-tvheadend
=============

Turn your RPI has a TV broadcaster for your local network.


Requirement
-----------

 - a Raspberry PI (or a clone working with ARM processor)
 - a working Docker environment
 - a DVB adapter
  - supported by tvheadend
  - supported by your host linux distribution with correct driver

Limitation
----------
Due to the small raspberry's processor, transcoding is not enabled.
For the same reason, it is best to use a wired network.
You can try with wifi G / N in a really good condition

Average network usage
---------------------

*On a 100BASE-TX network with 1 client and with a DVB-T adapter*

    TV SD : up to 5Mb
    TV HD : up to 11Mb

Usage
-----

    docker run --name tvheadend -p 9981:9981 -p 9982:9982 -v /my/persistent/directory/tvheadend:/config -v /tmp:/records --privileged romainf/rpi-tvheadend

**/config** is the directory where persistent tvheadend configuration are saved. You probably want persist him.

**/records** is an extra directory for recording video or for timeshifting. I mount it on /tmp who is a tmpfs mount in my host, because of the bad performance of SD cards storage.

If you want to persist video records, you should mount an external HDD.

**Port 9981/tcp** is used for the HTTP interface. Go to http://my-raspberry-pi-ip:9981/ in a web browser to configure it.

**Port 9982/tcp** is used for HTSP stream

Installation
------------
initctl script : Copy docker-tvheadend.service to /etc/systemd/system/multi-user.target.wants

Tuner installation for AverMedia Volar HD Pro Carte TV USB :
```
cd /lib/firmware
wget http://xgazza.altervista.org/Linux/DVB/dvb-usb-af9035-02.fw
wget http://www.ite.com.tw/uploads/firmware/v3.6.0.0/dvb-usb-it9135.zip
unzip
dd if=dvb-usb-it9135.fw ibs=1 skip=64 count=8128 of=dvb-usb-it9135-01.fw
dd if=dvb-usb-it9135.fw ibs=1 skip=12866 count=5817 of=dvb-usb-it9135-02.fw
cp dvb-usb-it9135* /lib/firmware/
tail -40 /var/log/kern.log
```

Contributions
------------

Fork me and make Pull Request : [https://github.com/romainf/rpi-tvheadend][1]

Note that the build takes nearly an hour on a Raspberry PI model B


  [1]: https://github.com/romainf/rpi-tvheadend
