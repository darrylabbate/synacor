max = 0x7fff

op = {
    function() r[w] = y                 ip = ip+3 end, -- set
    function() table.insert(s,x)        ip = ip+2 end, -- push
    function() r[w] = table.remove(s)   ip = ip+2 end, -- pop
    function() r[w] = y == z and 1 or 0 ip = ip+4 end, -- eq
    function() r[w] = y >  z and 1 or 0 ip = ip+4 end, -- gt
    function() ip   = x                           end, -- jmp
    function() ip   = x ~= 0 and y or        ip+3 end, -- jt
    function() ip   = x == 0 and y or        ip+3 end, -- jf
    function() r[w] = (y + z) % 0x8000  ip = ip+4 end, -- add
    function() r[w] = (y * z) % 0x8000  ip = ip+4 end, -- mult
    function() r[w] =  y % z            ip = ip+4 end, -- mod
    function() r[w] =  y & z            ip = ip+4 end, -- and
    function() r[w] =  y | z            ip = ip+4 end, -- or
    function() r[w] = ~y & 0x7fff       ip = ip+3 end, -- not
    function() r[w] = m[y]              ip = ip+3 end, -- rm
    function() m[x] = y                 ip = ip+3 end, -- wm
    function() table.insert(s,ip+2)     ip = x    end, -- call
    function() ip = table.remove(s)               end, -- ret
    function() io.write(string.char(x)) ip = ip+2 end, -- out
    function() r[w] = io.read(1):byte() ip = ip+2 end, -- in
    function()                          ip = ip+1 end  -- noop
}

op[0] = function() os.exit() end -- halt

m = {}
t = {}

bin = io.open(arg[1], "rb")
while true do
    local l = bin:read(1)
    local h = bin:read(1)
    if not (l or h) then break end
    local n = l:byte() | (h:byte() << 8)
    table.insert(t,n)
end
for i=1,#t do
    m[i-1] = t[i]
end

s    = {}
r    = {0,0,0,0,0,0,0}
r[0] = 0

ip = 0
while true do
    x = m[ip+1] x = x <= max and x or r[x-0x8000]
    y = m[ip+2] y = y <= max and y or r[y-0x8000]
    z = m[ip+3] z = z <= max and z or r[z-0x8000]
    w = m[ip+1] - 0x8000
    op[m[ip]]()
end

