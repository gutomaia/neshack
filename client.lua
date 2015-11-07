pcall(require, "luarocks.require")

local socket = require("socket")

local INPUT_IP = '127.0.0.1'
local INPUT_PORT = 53474


outgoing = socket.udp()
outgoing:setpeername(INPUT_IP, INPUT_PORT)
outgoing:settimeout(0)
outgoing:send("{\"score\": \"1234560\", \"lives\": \"8\", \"coin\": \"20\",\"time\": \"123\"}")
