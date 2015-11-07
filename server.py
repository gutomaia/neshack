import socket
import json

IP = '127.0.0.1'

joypad = dict(
    up=None,
    down=None,
    left=None,
    right=None,
    A=None,
    B=None,
    start=None,
    select=None)

UDPSock = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)

listen_addr = ("",53475)
UDPSock.bind(listen_addr)


while True:
        data,addr = UDPSock.recvfrom(1024)
        print data.strip(),addr

        if True:
            joypad['A'] = True
            joypad['B'] = True
            data = json.dumps(joypad)
            sock.sendto(bytes(json.dumps(joypad)), (IP, 53474))
