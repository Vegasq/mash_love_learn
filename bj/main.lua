require "socket"
require "math"
ProFi = require 'ProFi'
ProFi:start()
-- Collision detection function.
-- Checks if a and b overlap.
-- w and h mean width and height.
function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end

function collisions()
    for _, b in pairs(bullets) do
        for __, e in pairs(enemies) do
            if CheckCollision(b.l, b.t, 10, 10, e.l, e.t, 120, 120) then
                table.remove(bullets,_)
                table.remove(enemies,__)
                enemies_count = enemies_count - 1
                bullets_count = bullets_count - 1
            end
        end
    end
end

function love.load()
    submarine = love.graphics.newImage("submarine.png")
    submarine_x = 10
    submarine_y = 10

    enemie = love.graphics.newImage("enemie.png")
    bullet = love.graphics.newImage("bullet.png")

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
    collisions()
    now_time = socket.gettime()*1000
    if now_time - prev_enemie_time > 300 and enemies_count < 10 then
        prev_enemie_time = now_time

        
        local enemie_x = 1000
        local enemie_y = math.random(50, 550)

        local modif_x = -5
        local modif_y = 0

        enemie_i = enemie_i + 1
        local enem = {name='enemie_'..enemie_i, id=enemie_i, img=enemie, l=enemie_x, t=enemie_y, mx=modif_x, my=modif_y, w=128,h=128}
        table.insert(enemies, enem)
        enemies_count = enemies_count + 1
    end

    if now_time - prev_time > 300 and bullets_count < 10 then
        prev_time = now_time
        local bullet_x = submarine_x + 120
        local bullet_y = submarine_y + 70

        local modif_x = 10
        local modif_y = 0

        bullet_i = bullet_i + 1
        bull  = {name='bullet_'..bullet_i,id=bullet_i, img=bullet, l=bullet_x, t=bullet_y, mx=modif_x, my=modif_y, w=10, h=10}
        table.insert(bullets, bull)
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
end

function love.draw()
    love.graphics.draw(submarine, submarine_x, submarine_y)

    _bc = 0
    for _, bullet in pairs(bullets) do
        _bc = _bc + 1
        bullet['l'] = bullet['l'] + bullet['mx']
        love.graphics.draw(bullet['img'], bullet['l'], bullet['t'])
        if bullet['l'] > 1000 then
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
            table.remove(enemies, _)
        end
        if enemie['l'] < -150 then
            table.remove(enemies, _)
        end
    end
    if _ec > 10 then
        print("Problem with enemies: ".._ec)
    end 

end

function love.quit()
    ProFi:stop()
    ProFi:writeReport( 'F:/MyProfilingReport.txt' )

  print("Thanks for playing! Come back soon!")
end