require "socket"
require "math"
local bump = require 'bump'
bump.initialize(5)

function bump.collision(item1, item2, dx, dy)
    if string.find(item1.name, "enemie_", 1) and string.find(item2.name, "bullet_", 1)
    or string.find(item1.name, "bullet_", 1) and string.find(item2.name, "enemie_", 1) then
        item1.l = 5000
        item2.l = 5000

        bullets_count = bullets_count - 1
        enemies_count = enemies_count - 1

        table.remove(enemies, item1.id)
        table.remove(bullets, item1.id)
        table.remove(enemies, item2.id)
        table.remove(bullets, item2.id)
    end
end

function bump.endCollision(item1, item2)
    bump.remove(item1)
    bump.remove(item2)
end

function bump.getBBox(item)
  return item.l, item.t, item.w, item.h
end

function bump.shouldCollide(item1, item2)
    if string.find(item1.name, "enemie_", 1) and string.find(item2.name, "bullet_", 1)
    or string.find(item1.name, "bullet_", 1) and string.find(item2.name, "enemie_", 1) then
        return true
    end
    return false
end


function love.load()
    submarine = love.graphics.newImage("submarine.png")
    submarine_x = 10
    submarine_y = 10


    now_time = 0
    prev_time = 0
    prev_enemie_time = 0
    bullets = {}
    enemies = {}

    bullets_count = 0
    enemies_count = 0

    bullet_i = 1
    enemie_i = 1
end

function love.update(dt)
    -- print(bullets_count, enemies_count)

    now_time = socket.gettime()*1000
    if now_time - prev_enemie_time > 300 and enemies_count < 10 then
        prev_enemie_time = now_time

        enemie = love.graphics.newImage("enemie.png")
        local enemie_x = 1000
        local enemie_y = math.random(50, 550)

        local modif_x = -4
        local modif_y = 0

        enemie_i = enemie_i + 1
        enemies[enemie_i] = {name='enemie_'..enemie_i, id=enemie_i, img=enemie, l=enemie_x, t=enemie_y, mx=modif_x, my=modif_y, w=128,h=128}
        bump.add(enemies[enemie_i])
        enemies_count = enemies_count + 1
    end

    if now_time - prev_time > 300 and bullets_count < 10 then
        prev_time = now_time
        bullet = love.graphics.newImage("bullet.png")
        local bullet_x = submarine_x + 120
        local bullet_y = submarine_y + 70

        local modif_x = 20
        local modif_y = 0

        bullet_i = bullet_i + 1
        bullets[bullet_i]  = {name='bullet_'..bullet_i,id=bullet_i, img=bullet, l=bullet_x, t=bullet_y, mx=modif_x, my=modif_y, w=10, h=10}
        bump.add(bullets[bullet_i])
        bullets_count = bullets_count + 1
    end

    if love.keyboard.isDown("a") then
        submarine_x = submarine_x - 8
    end
    if love.keyboard.isDown("d") then
        submarine_x = submarine_x + 8
    end
    if love.keyboard.isDown("s") then
        submarine_y = submarine_y + 8
    end
    if love.keyboard.isDown("w") then
        submarine_y = submarine_y - 8
    end
    bump.collide()
end

function love.draw()
    love.graphics.draw(submarine, submarine_x, submarine_y)

    _bc = 0
    for _, bullet in pairs(bullets) do
        _bc = _bc + 1
        bullet['l'] = bullet['l'] + bullet['mx']
        love.graphics.draw(bullet['img'], bullet['l'], bullet['t'])
        if bullet['l'] > 1000 then
            bump.remove(bullet)
            table.remove(bullets, _)
        end
    end
    if _bc > 10 then
        print("Problem with bullets: ".._bc)
    end 

    _ec = 0
    for _, enemie in pairs(enemies) do
        _ec = _ec + 1
        enemie['l'] = enemie['l'] + enemie['mx']
        love.graphics.draw(enemie['img'], enemie['l'], enemie['t'])

        if enemie['l'] > 3000 then
            bump.remove(enemie)
            table.remove(enemies, _)
        end
        if enemie['l'] < -150 then
            bump.remove(enemie)
            table.remove(enemies, _)
        end
    end
    if _ec > 10 then
        print("Problem with enemies: ".._ec)
    end 

end

function love.quit()
  print("Thanks for playing! Come back soon!")
end