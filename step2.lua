pcall(require, "luarocks.require")

local socket = require "socket"

local OUTPUT_IP = '127.0.0.1'
local OUTPUT_PORT = 53475

local outgoing = socket.udp()
outgoing:setpeername(OUTPUT_IP, OUTPUT_PORT)
outgoing:settimeout(0)

function getData()
    marioX = memory.readbyte(0x6D) * 0x100 + memory.readbyte(0x86)
    marioY = memory.readbyte(0x03B8)+16
end

while true do
    gui.text(50,50,"Hello world!");
    getData()
    outgoing:send('x: ' .. marioX .. 'y:' .. marioY)

    emu.frameadvance()
end
