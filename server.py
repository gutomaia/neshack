import socket
import json

IP = '127.0.0.1'

joypad = dict(
    up=False,
    down=False,
    left=False,
    right=False,
    A=False,
    B=False,
    start=False,
    select=False)

UDPSock = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)

listen_addr = ("",53475)
UDPSock.bind(listen_addr)


while True:
        data,addr = UDPSock.recvfrom(1024)
        print data.strip(),addr

        if True:
            joypad['A'] = not joypad['A']
            data = dict(joypad=joypad, time=150)
            UDPSock.sendto(bytes(json.dumps(data)), (IP, 53474))
            print data
