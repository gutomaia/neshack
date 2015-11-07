-- http://datacrystal.romhacking.net/wiki/Super_Mario_Bros.:RAM_map
-- http://www.thealmightyguru.com/Games/Hacking/Wiki/index.php?title=Super_Mario_Bros.

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


function getSprites()
    local sprites = {}
    for slot=0,4 do
        local enemy = memory.readbyte(0xF+slot)
        if enemy ~= 0 then
            local ex = memory.readbyte(0x87+slot)
            local lx = memory.readbyte(0x6E + slot)*0x100 + ex
            local ey = memory.readbyte(0xCF + slot)+24
            sprites[#sprites+1] = {x=ex,y=ey,lx=lx}
        end
    end

    return sprites
end

function getData()
    lives = memory.readbyte(0x075a)+1

    marioX = memory.readbyte(0x6D) * 0x100 + memory.readbyte(0x86)
    marioY = memory.readbyte(0x03B8)+16
    screenX = memory.readbyte(0x03AD)
    screenY = memory.readbyte(0x03B8)
    marioState = memory.readbyte(0x000E)
    powerUp = memory.readbyte(0x0756)
    c1 = memory.readbyte(0x07ED)
    c2 = memory.readbyte(0x07EE)
    coin = c1 * 10 + c2

    s1 = memory.readbyte(0x07DD)
    s2 = memory.readbyte(0x07DE)
    s3 = memory.readbyte(0x07DF)
    s4 = memory.readbyte(0x07E0)
    s5 = memory.readbyte(0x07E1)
    s6 = memory.readbyte(0x07E2)
    score = s1 * 1000000 + s2 * 100000 + s3 * 10000 + s4 * 1000 + s5 * 100 + s6 * 10

    t1 = memory.readbyte(0x07F8)
    t2 = memory.readbyte(0x07F9)
    t3 = memory.readbyte(0x07FA)
    time = t1 * 100 + t2 * 10 + t3
    
    return {x=marioX, y=marioY, 
        score=score,lives=lives,coin=coin,time=time,
        state=marioState, enemies=getSprites(), joypad=joypad.get(1)}
end

local incomming = socket.udp()
incomming:setsockname("*",INPUT_PORT)
incomming:settimeout(0)

function setScore(cmd)
    if cmd.score then
        local n = cmd.score + 0
        local s1 = math.floor(n / 1000000)
        local s2 = math.floor(n / 100000) - s1 * 10
        local s3 = math.floor(n / 10000) - s1 * 100 - s2 * 10
        local s4 = math.floor(n / 1000) - s1 * 1000 - s2 * 100 - s3 * 10
        local s5 = math.floor(n / 100) - s1 * 10000 - s2 * 1000 - s3 * 100 - s4 * 10
        local s6 = math.floor(n / 10) - s1 * 100000 - s2 * 10000 - s3 * 1000 - s4 * 100 - s5 * 10

        memory.writebyte(0x07DD, s1)
        memory.writebyte(0x07DE, s2)
        memory.writebyte(0x07DF, s3)
        memory.writebyte(0x07E0, s4)
        memory.writebyte(0x07E1, s5)
        memory.writebyte(0x07E2, s6)
    end
end

function setLives(cmd)
    if cmd.lives then
        local n = tonumber(cmd.lives)
        memory.writebyte(0x075a, n-1)
    end
end

function setTime(cmd)
    if cmd.time then
        local n = cmd.time + 1
        local t1 = math.floor(n / 100)
        local t2 = math.floor(n / 10) - t1 * 10
        local t3 = n - t2 * 10 - t1 * 100
        memory.writebyte(0x07F8, t1)
        memory.writebyte(0x07F9, t2)
        memory.writebyte(0x07FA, t3)
    end
end

function setCoin(cmd)
    if cmd.coin then
        local n = cmd.coin
        local c1 = math.floor(n / 10)
        local c2 = n - c1 * 10
        memory.writebyte(0x07ED, c1)
        memory.writebyte(0x07EE, c2)

        memory.writebyte(0x748, 1)
        memory.writebyte(0x75E, 1)
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
        print(s)
        setScore(command)
        setLives(command)
        setCoin(command)
        setTime(command)
        setJoypad(command)
    end
end

