










function getData()
    marioX = memory.readbyte(0x6D) * 0x100 + memory.readbyte(0x86)
    marioY = memory.readbyte(0x03B8)+16
end

while true do
    gui.text(50,50,"Hello world!");
    getData()
    print('x: '..marioX)
    print('y: '..marioY)
    emu.frameadvance()
end
