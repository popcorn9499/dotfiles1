screen -dmS Music-Vban-Emittor vban_emitter -i 192.168.1.11 -p 6980 -s Music -d music_audio.monitor -b pulseaudio
screen -dmS Discord-Vban-Emittor vban_emitter -i 192.168.1.11 -p 6980 -s Discord -d communication_audio.monitor -b pulseaudio
screen -dmS Mic-Vban-Emittor vban_emitter -i 192.168.1.11 -p 6980 -s Mic alsa_input.usb-BLUE_MICROPHONE_Blue_Snowball_201509-00.analog-stereo -b pulseaudio
screen -dmS Laptop-vban-receptor vban_receptor -i 192.168.1.24 -p 6980 -s Laptop_Audio -b pulseaudio -d 3 -q 3

#main Desktop
screen -dmS Discord-Vban-Emittor_D vban_emitter -i 192.168.1.18 -p 6980 -s Discord -d communication_audio.monitor -b pulseaudio
screen -dmS Music-Vban-Emittor_D vban_emitter -i 192.168.1.18 -p 6980 -s Music -d music_audio.monitor -b pulseaudio
screen -dmS Mic-Vban-Emittor_D vban_emitter -i 192.168.1.18 -p 6980 -s Mic alsa_input.usb-BLUE_MICROPHONE_Blue_Snowball_201509-00.analog-stereo -b pulseaudio

