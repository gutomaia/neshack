from json import dumps
import socket

joypad = dict(
	up=False,
	down=False,
	left=False,
	right=False,
	A=True,
	B=True,
	start=False,
	select=False)

aa = dict(coin=20, time=100, joypad=joypad, lives=8, score=123450)

MESSAGE = dumps(aa)
UDP_IP = '127.0.0.1'
UDP_PORT = 53474

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.sendto(bytes(MESSAGE), (UDP_IP, UDP_PORT))