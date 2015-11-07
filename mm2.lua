-- http://datacrystal.romhacking.net/wiki/Mega_Man_II:RAM_map
-- http://www.thealmightyguru.com/Games/Hacking/Wiki/index.php?title=Mega_Man_II

pcall(require, "luarocks.require")


local socket = require "socket"
local json = require "cjson"

local INPUT_IP = '127.0.0.1'
local INPUT_PORT = 53474
local OUTPUT_IP = '127.0.0.1'
local OUTPUT_PORT = 53475

local outgoing = socket.udp()
outgoing:setpeername(OUTPUT_IP, OUTPUT_PORT)
outgoing:settimeout(0)

function getData()
    weapons = memory.readbyte(0x009A)
    hp = memory.readbyte(0x06C0)
    lives = memory.readbyte(0x00A8)+1

    return {weapons=weapons, hp=hp, lives=lives, joypad=joypad.get(1)}
end

local incomming = socket.udp()
incomming:setsockname("*",INPUT_PORT)
incomming:settimeout(0)

function setLives(cmd)
    if cmd.lives then
        local n = tonumber(cmd.lives)
        memory.writebyte(0x075a, n-1)
    end
end

function setHp(cmd)
    if cmd.hp then
        local n = cmd.hp + 0
        memory.writebyte(0x06C0, n)
    end
end

function setWeapons(cmd)
    if cmd.weapons then
        local n = cmd.weapons + 0
        memory.writebyte(0x009A, n)
    end
end

function setJoypad(cmd)
    if cmd.joypad then
        joypad.set(1, cmd.joypad)
    end
end

while true do
    data = getData()
    outgoing:send(json.encode(data))

    emu.frameadvance()
    s, err = incomming:receive(1024)
    if s and not err then
        command = json.decode(s)
        setLives(command)
        setHp(command)
        setWeapons(command)
        setJoypad(command)
    end
end

