
local socket = require("socket")

udp = socket.udp()
udp:setsockname("*", 53474)
udp:settimeout(0)

while true do
    data, ip, port = udp:receivefrom()
    if data then
        print("Received: ", data, ip, port)
        -- udp:sendto(data, ip, port)
    end
    socket.sleep(0.01)
end