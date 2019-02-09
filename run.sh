docker run -dit --name picamera --restart always --privileged       -v /dev/snd/pcmC0D0p:/dev/snd/pcmC0D0p       -v /dev/snd/pcmC1D0c:/dev/snd/pcmC1D0c       -v /dev/snd/controlC0:/dev/snd/controlC0       -v /dev/snd/controlC1:/dev/snd/controlC1       -v /opt/vc/lib:/opt/vc/lib       --device /dev/vchiq       -p 8888:8888       groundhogday/rpi-streamer:latest

