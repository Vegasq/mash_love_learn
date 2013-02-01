require("socket")




a = {}
t1=socket.gettime()*1000
for i=1,1000000 do
    local bull  = {name='a', id='b', img='c', l=1, t=2, mx=-4, my=0, w=10, h=10, damage=1, my=false}
    table.insert(a, bull)
end
t2=socket.gettime()*1000

print("No optimizations: "..t2-t1)



t1=socket.gettime()*1000
a = {}
for i=1,1000000 do
    a[i] = false
end

for i=1,1000000 do
    local bull  = {name='a', id='b', img='c', l=1, t=2, mx=-4, my=0, w=10, h=10, damage=1, my=false}
    a[i] = bull
    -- table.insert(a, bull)
end
t2=socket.gettime()*1000

print("With optimizations: "..t2-t1)



t1=socket.gettime()*1000
a = {}
for i=1,1000000 do
    a[i] = false
end

for i=1,1000000 do
    local bull  = {mx=-4, my=0, w=10, h=10, damage=1, my=false}
    a[i] = bull
    -- table.insert(a, bull)
end
t2=socket.gettime()*1000

print("With optimizations2: "..t2-t1)





t1=socket.gettime()*1000
a = {}
for i=1,1000000 do
    a[i] = false
end

for i=1,10 do
    local bull = {}
    for z=1,10 do
        bull[z] = false
    end

    bull.mx=-4
    bull.my=0
    bull.w=10
    bull.h=10
    bull.damage=1

    a[i] = bull
    -- table.insert(a, bull)
end
t2=socket.gettime()*1000

print("With optimizations3: "..t2-t1)
