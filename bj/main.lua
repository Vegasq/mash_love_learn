require "socket"
require "math"

-- ProFi = require 'ProFi'
-- ProFi:start()

-- Collision detection function.
-- Checks if a and b overlap.
-- w and h mean width and height.
function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end



function collisions()
    for _, b in pairs(bullets) do
        if b.my then
            for __, e in pairs(enemies) do
                if CheckCollision(b.l, b.t, 10, 10, e.l, e.t, 120, 120) then
                    calculate_damage(e, __, b, _)
                end
            end
        else
            if CheckCollision(b.l, b.t, 10, 10, player.l, player.t, player.w, player.h) then
                calculate_damage(player, false, b, _)
            end
        end
    end
end

function calculate_damage(unit, u_table, bullet, b_table)
    unit.life = unit.life - bullet.damage
    if unit.life < 1 then
        if u_table then
            table.remove(enemies,u_table)
        end
        enemies_count = enemies_count - 1
        score = score + 1
    end
    table.remove(bullets,b_table)
    bullets_count = bullets_count - 1
end

function love.load()
    the_end = false
    score = 0
    floor = math.floor
    bg = love.graphics.newImage("bg1.jpg")
    bg_counter = 0
    submarine = love.graphics.newImage("submarine.png")


    enemie = love.graphics.newImage("enemie.png")
    bullet = love.graphics.newImage("bullet.png")

    player = {name='player', id=0, img=submarine, l=10, t=10, mx=false, my=false, w=128,h=128, life=100, time=false}

    now_time = 0
    prev_time = 0
    prev_enemie_time = 0
    bullets = {}
    enemies = {}

    bullets_count = 0
    enemies_count = 0

    bullet_i = 1
    enemie_i = 1
    prev_dt = 0
    loop_counter = {c=0, time=0, ptime=0}
    loop_counter['ptime'] = socket.gettime()*1000

    draw = love.graphics.draw
end

function enemies_logic()
    now_time = socket.gettime()*1000
    if now_time - prev_enemie_time > 300 and enemies_count < 10 then
        prev_enemie_time = now_time
        
        local enemie_x = 1366
        local enemie_y = math.random(50, 700)

        local modif_x = -1
        local modif_y = 0

        enemie_i = enemie_i + 1
        local enem = {name='enemie_'..enemie_i, id=enemie_i, img=enemie, l=enemie_x, t=enemie_y, mx=modif_x, my=modif_y, w=128,h=128, life=5, time=now_time}
        table.insert(enemies, enem)
        enemies_count = enemies_count + 1
    end
end

function bullets_logic()
    now_time = socket.gettime()*1000
    if now_time - prev_time > 100 then
        prev_time = now_time
        local bullet_x = player.l + 120
        local bullet_y = player.t + 70

        local modif_x = 15
        local modif_y = 0

        bullet_i = bullet_i + 1
        bull  = {name='bullet_'..bullet_i,id=bullet_i, img=bullet, l=bullet_x, t=bullet_y, mx=modif_x, my=modif_y, w=10, h=10, damage=1, my=true}
        table.insert(bullets, bull)
        bullets_count = bullets_count + 1

        for _, enemie in pairs(enemies) do
            local rand = math.random(1, 10)
            if rand == 1 then
                bull  = {name='bullet_'..enemie.name, id='id'..enemie.name, img=bullet, l=enemie.l, t=enemie.t, mx=-4, my=0, w=10, h=10, damage=1, my=false}
                table.insert(bullets, bull)
                bullets_count = bullets_count + 1
            end
        end

        -- bullet_i = bullet_i + 1
        -- bull  = {name='bullet_'..bullet_i,id=bullet_i, img=bullet, l=bullet_x, t=bullet_y + 10, mx=modif_x, my=modif_y, w=10, h=10, damage=1}
        -- table.insert(bullets, bull)
        -- bullets_count = bullets_count + 1


    end
end

function love.update(dt)
    if player.life < 1 then
        the_end = true
    end
    if the_end then
        return
    end

    loop_counter['c'] = loop_counter['c'] + 1
    loop_counter['time'] = socket.gettime()*1000
    local t_diff = loop_counter['time'] - loop_counter['ptime']
    frames_to_show = floor(t_diff / 10)
    for i=1,frames_to_show do
        enemies_logic()
        bullets_logic()
    end
    loop_counter['ptime'] = loop_counter['time'] 
    local prcnt = loop_counter['c'] % 10
    if prcnt == 0 or prcnt == 5 then
        collisions()
    end


    -- if dt < 0.01 then
    --     return
    -- end


    if love.keyboard.isDown("a") and player.l > 0 then
        player.l = player.l - 8
    end
    if love.keyboard.isDown("d") and player.l < 1266 then
        player.l = player.l + 8
    end
    if love.keyboard.isDown("s") and player.t < 668 then
        player.t = player.t + 8
    end
    if love.keyboard.isDown("w") and player.t > 0 then
        player.t = player.t - 8
    end
end

function love.draw()
    if the_end then
        font = love.graphics.newFont( 70 )
        love.graphics.setFont(font);

        love.graphics.printf("Game Over", 100, 300, 1100, 'center')

        return
    end


    bg_counter = bg_counter - 1
    if bg_counter < -3900 then
        bg_counter = 0
    end

    draw(bg, bg_counter, 0)
    draw(bg, bg_counter + 4000, 0)

    draw(player.img, player.l, player.t)

    love.graphics.setColor(255, 0, 0)
    love.graphics.setLine(5, "smooth")
    love.graphics.line( 10, 750, player.life * 2 + 10, 750 )
    love.graphics.setColor(255, 255, 255, 255)

    font = love.graphics.newFont( 30 )
    love.graphics.setFont(font);

    love.graphics.print("Score: ", 0, 0);
    love.graphics.print(score, 100, 0);

    love.graphics.print("Life: ", 0, 50);
    love.graphics.print(player.life, 100, 50);


    _bc = 0
    for _, bullet in pairs(bullets) do
        _bc = _bc + 1
        bullet['l'] = bullet['l'] + bullet['mx']
        if bullet['l'] < 1366 or bullet['l'] > 0 or bullet['t'] > 0 or bullet['t'] < 768 then
            draw(bullet['img'], bullet['l'], bullet['t'])
        end
        if bullet['l'] > 3000 or bullet['l'] < 1 then
            table.remove(bullets, _)
        end
    end
    bullets_count = _bc
    -- if _bc > 10 then
    --     print("Problem with bullets: ".._bc)
    -- end 

    _ec = 0
    for _, enemie in pairs(enemies) do
        _ec = _ec + 1
        enemie['l'] = enemie['l'] + enemie['mx']
        draw(enemie['img'], enemie['l'], enemie['t'])

        if enemie['l'] > 3000 then
            table.remove(enemies, _)
        end
        if enemie['l'] < -150 then
            table.remove(enemies, _)
        end
    end
    enemies_count = _ec
    -- if _ec > 10 then
    --     print("Problem with enemies: ".._ec)
    -- end 

    love.graphics.print("Bullets: ", 0, 150);
    love.graphics.print(_bc, 140, 150);

    love.graphics.print("Enemies: ", 0, 100);
    love.graphics.print(_ec, 140, 100);
end

function love.quit()
--    ProFi:stop()
--    ProFi:writeReport( 'MyProfilingReport.txt' )

  print("Thanks for playing! Come back soon!")
end