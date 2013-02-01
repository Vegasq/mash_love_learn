require "socket"
require "math"
enem = require "enem"
drawer = require "drawer"

-- ProFi = require 'ProFi'
-- ProFi:start()

-- Collision detection function.
-- Checks if a and b overlap.
-- w and h mean width and height.
function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end





function ship_crack(player, enem, e_table)
    player.life = player.life - enem.damage
    player.kicked = 5
    table.remove(enemies,e_table)
end



function love.load()
    timeout = 0.3
    _fps = {draw=socket.gettime()*1000, update=socket.gettime()*1000}
    -- delta_time = 0

    _bc = 0
    _ec = 0

    the_end = false
    score = 0
    floor = math.floor
    bg = love.graphics.newImage("resources/images/bg/spacefield_a-000.png")
    bg_counter = 0
    submarine = love.graphics.newImage("resources/images/ships/spaceship_tut/spaceship_tut_modif.png")


    enemie = love.graphics.newImage("enemie.png")

    enem1 = love.graphics.newImage("resources/images/ships/spaceships2/CorvetteC.png")
    enem2 = love.graphics.newImage("resources/images/ships/spaceships2/DestroyerB.png")
    enem3 = love.graphics.newImage("resources/images/ships/spaceships2/Frigate.png")

    bullet = love.graphics.newImage("bullet.png")
    bullet_img = love.graphics.newImage("bullet.png")

    player = {name='player', id=0, img=submarine, l=10, t=10, mx=false, my=false, w=128,h=87, life=100, time=false, kicked=0}

    now_time = 0
    prev_time = 0
    prev_enemie_time = 0
    bullets = {}
    enemies = {}
    for i=1,20 do
        enemies[i] = false
    end
    for i=1,50 do
        bullets[i] = false
    end

    bullets_count = 0
    enemies_count = 0

    bullet_i = 1
    enemie_i = 1
    prev_dt = 0
    loop_counter = {c=0, time=0, ptime=0}
    loop_counter['ptime'] = socket.gettime()*1000

    draw = love.graphics.draw

    local now_time = socket.gettime()*1000
    enemie_orders = {}
    local enemie_order1 = {
        u1={name='1_in_tringle', id='1it', img=enem1, l=1566, t=100, mx=-2, my=0, w=91,h=40, life=5, time=now_time, kicked=0, damage=5},
        u2={name='2_in_tringle', id='2it', img=enem2, l=1466, t=200, mx=-2, my=0, w=130,h=45, life=10, time=now_time, kicked=0, damage=5},
        u3={name='3_in_tringle', id='3it', img=enem3, l=1366, t=300, mx=-2, my=0, w=111,h=45, life=15, time=now_time, kicked=0, damage=5},
        u4={name='4_in_tringle', id='4it', img=enem2, l=1466, t=400, mx=-2, my=0, w=130,h=45, life=10, time=now_time, kicked=0, damage=5},
        u5={name='5_in_tringle', id='5it', img=enem1, l=1566, t=500, mx=-2, my=0, w=91,h=40, life=5, time=now_time, kicked=0, damage=5},
    }
    local enemie_order2 = {
        u1={name='1_in_line', id='1il', img=enem3, l=1566, t=100, mx=-2, my=0, w=111,h=45, life=3, time=now_time, kicked=0, damage=5},
        u2={name='2_in_line', id='2il', img=enem2, l=1766, t=100, mx=-2, my=0, w=130,h=45, life=3, time=now_time, kicked=0, damage=5},
        u3={name='3_in_line', id='3il', img=enem2, l=1966, t=100, mx=-2, my=0, w=130,h=45, life=3, time=now_time, kicked=0, damage=5},
        -- u4={name='4_in_line', id='4il', img=enem1, l=1866, t=100, mx=-2, my=0, w=128,h=128, life=5, time=now_time},
        -- u5={name='5_in_line', id='5il', img=enem1, l=1966, t=100, mx=-2, my=0, w=128,h=128, life=5, time=now_time},
    }
    table.insert(enemie_orders, enemie_order1)
    table.insert(enemie_orders, enemie_order2)

    font = love.graphics.newFont( 30 )
    

end

function table.copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end


function enemies_logic(dt)
    now_time = socket.gettime()*1000
    if now_time - prev_enemie_time > 1300 and enemies_count < 10 then
        local t1 = socket.gettime()*1000
        prev_enemie_time = now_time

        local r = math.random(1,2)
        local d = math.random(-1,1)
        if r == 1 then
            for _, e in pairs(enemie_orders[1]) do
                enemie_i = enemie_i + 1
                local ee = table.copy(e)
                ee.my = d
                table.insert(enemies, ee)
                enemies_count = enemies_count + 1
            end
        else
            for _, e in pairs(enemie_orders[2]) do
                enemie_i = enemie_i + 1
                local ee = table.copy(e)
                ee.my = d

                table.insert(enemies, ee)
                enemies_count = enemies_count + 1
            end
        end
        local t2 = socket.gettime()*1000
        local t3 = t2 - t1
        if t3 > timeout then
            print('enemies_logic', t3)
        end
        return true
    end
end

function bullets_logic()

    now_time = socket.gettime()*1000
    if now_time - prev_time > 200 and _bc < 50 then
        local t1 = socket.gettime()*1000
    
        prev_time = now_time
        local bullet_x = player.l + player.w - 10
        local bullet_y = player.t + player.h / 2 - 5

        local modif_x = 15
        local modif_y = 0


        local bull = {}
        for z=1,10 do
            bull[z] = false
        end
        bull.img='bullet1'
        bull.l=bullet_x
        bull.t=bullet_y
        bull.mx=modif_x * 2
        bull.w=10
        bull.h=10
        bull.damage=2
        bull.owner=true

        bullet_i = bullet_i + 1


        table.insert(bullets, bull)
        bullets_count = bullets_count + 1

        for _, enem in pairs(enemies) do
            if enem then
                local rand = math.random(1, 25)
                if rand == 1 and _ec < 10 then
                    local r1 = socket.gettime()*1000
                    local bull = {}

                    for z=1,10 do
                        bull[z] = false
                    end

                    bull.img='bullet1'
                    bull.l=enem.l
                    bull.t=enem.t + 50
                    bull.mx=-4
                    bull.w=10
                    bull.h=10
                    bull.damage=1
                    bull.owner=false
                    local r2 = socket.gettime()*1000
                    local r3 = r2 -r1
                    if r3 > timeout then
                        print('Random', r3)
                    end
                    bullets_count = bullets_count + 1

                    table.insert(bullets, bull)
                end
            end
        end
    
        local t2 = socket.gettime()*1000
        local t3 = t2 - t1
        if t3 > timeout then
            print('bullets_logic', t3)
        end

    end

end

function love.update(dt)
    -- delta_time = dt
    local draw_timer = socket.gettime()*1000
    local delta = draw_timer - _fps.draw

    if check_game_over() then
        return
    end

    
    enemies_logic()
    bullets_logic()
    enem:collisions()
    check_keyboard()

end

function check_game_over()
    if player.life < 1 then
        font = love.graphics.newFont( 70 )
        love.graphics.setFont(font);
        love.graphics.printf("Game Over\n You're score: "..score, 100, 300, 1100, 'center')

        the_end = true
    end
    return the_end
end

function check_keyboard()
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

    if check_game_over() then
        return
    end


    local t1 = socket.gettime()*1000
    drawer:bg()
    local t2 = socket.gettime()*1000
    local t3 = t2 - t1
    if t3 > 5 then
        print('Draw1', t3)
    end


    local t1 = socket.gettime()*1000
    drawer:player()
    local t2 = socket.gettime()*1000
    local t3 = t2 - t1
    if t3 > 5 then
        print('Draw2', t3)
    end

    local t1 = socket.gettime()*1000
    drawer:interface()
    local t2 = socket.gettime()*1000
    local t3 = t2 - t1
    if t3 > 5 then
        print('Draw3', t3)
    end

    local t1 = socket.gettime()*1000
    drawer:bullets()
    local t2 = socket.gettime()*1000
    local t3 = t2 - t1
    if t3 > 5 then
        print('Draw4', t3)
    end

    local t1 = socket.gettime()*1000
    drawer:enemies()
    local t2 = socket.gettime()*1000
    local t3 = t2 - t1
    if t3 > 5 then
        print('Draw5', t3)
    end



end

function love.quit()
--    ProFi:stop()
--    ProFi:writeReport( 'MyProfilingReport.txt' )

  print("Thanks for playing! Come back soon!")
end