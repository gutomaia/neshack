import socket
import redis

UDPSock = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)

listen_addr = ("",53475)
UDPSock.bind(listen_addr)

r = redis.Redis()
while True:
        data,addr = UDPSock.recvfrom(1024)
        print data.strip(),addr
        r.publish('game', data.strip())
