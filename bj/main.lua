require "socket"
require "math"
enem = require "enem"
drawer = require "drawer"
anim = require "anim"

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
    player.kicked = 155
    print('ShipCrack')
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

    bonus1 = love.graphics.newImage("resources/images/medic_anim1.png")
    boom1 = love.graphics.newImage("resources/20030506.png")
    boom2 = love.graphics.newImage("resources/boom2.png")

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
    bonuses = {}
    gAnimations = {}
    -- for i=1,20 do
    --     enemies[i] = false
    -- end
    -- for i=1,50 do
    --     bullets[i] = false
    -- end

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
    local enem_speed = -0.4
    local enemie_order1 = {
        u1={name='1_in_tringle', id='1it', img=enem1, l=1566, t=100, mx=enem_speed, my=0, w=91,h=40, life=5, time=now_time, kicked=0, damage=5},
        u2={name='2_in_tringle', id='2it', img=enem2, l=1466, t=200, mx=enem_speed, my=0, w=130,h=45, life=10, time=now_time, kicked=0, damage=5},
        u3={name='3_in_tringle', id='3it', img=enem3, l=1366, t=300, mx=enem_speed, my=0, w=111,h=45, life=15, time=now_time, kicked=0, damage=5},
        u4={name='4_in_tringle', id='4it', img=enem2, l=1466, t=400, mx=enem_speed, my=0, w=130,h=45, life=10, time=now_time, kicked=0, damage=5},
        u5={name='5_in_tringle', id='5it', img=enem1, l=1566, t=500, mx=enem_speed, my=0, w=91,h=40, life=5, time=now_time, kicked=0, damage=5},
    }
    local enemie_order2 = {
        u1={name='1_in_line', id='1il', img=enem3, l=1566, t=100, mx=enem_speed, my=0, w=111,h=45, life=3, time=now_time, kicked=0, damage=5},
        u2={name='2_in_line', id='2il', img=enem2, l=1766, t=100, mx=enem_speed, my=0, w=130,h=45, life=3, time=now_time, kicked=0, damage=5},
        u3={name='3_in_line', id='3il', img=enem2, l=1966, t=100, mx=enem_speed, my=0, w=130,h=45, life=3, time=now_time, kicked=0, damage=5},
        -- u4={name='4_in_line', id='4il', img=enem1, l=1866, t=100, mx=-2, my=0, w=128,h=128, life=5, time=now_time},
        -- u5={name='5_in_line', id='5il', img=enem1, l=1966, t=100, mx=-2, my=0, w=128,h=128, life=5, time=now_time},
    }
    table.insert(enemie_orders, enemie_order1)
    table.insert(enemie_orders, enemie_order2)

    font = love.graphics.newFont( 30 )

    create_enemie_counter = 0
end

function create_enemie(img_name,x,y,w,h,mx,my,life,damage)
    create_enemie_counter = create_enemie_counter + 1
    local now_time = socket.gettime()*1000
    local name = 'enemie'..create_enemie_counter
    print("Cretae "..name)
    local u = {name=name, img=img_name, l=x, t=y, mx=mx, my=my, w=w,h=h, life=life, time=now_time, kicked=0, damage=damage}
    return u
end

function table.copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.copy(orig_key)] = table.copy(orig_value)
        end
        setmetatable(copy, table.copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


-- function table.copy(t)
--   local t2 = {}
--   for k,v in pairs(t) do
--     t2[k] = v
--   end
--   t2['random'] = math.random(2001, 3000)
--   return t2
-- end


function enemies_logic(dt)
    for k,v in pairs(gAnimations) do
        print(v)
        anim:draw(v)
    end

    now_time = socket.gettime()*1000
    for i,enemie_in_logic in ipairs(enemies) do
        if enemie_in_logic then
            -- Update position
            enemie_in_logic['l'] = enemie_in_logic['l'] + enemie_in_logic['mx']
            enemie_in_logic['t'] = enemie_in_logic['t'] + enemie_in_logic['my']

            -- Remove items outside the screen
            if enemie_in_logic['l'] > 3000 then
                print('EnemRemover1')
                table.remove(enemies, i)
            end
            if enemie_in_logic['l'] < -150 then
                print('EnemRemover2 ', enemie_in_logic.name)
                -- enemie_in_logic.life = 0
                table.remove(enemies, i)
            end

            -- Chfnht vertical direction
            if enemie_in_logic['t'] < 100 then
                enemie_in_logic['my'] = enemie_in_logic['my'] * -1 -- - delta_time
                enemie_in_logic['t'] = 100
            end
            if enemie_in_logic['t'] > 700 then
                enemie_in_logic['my'] = enemie_in_logic['my'] * -1 -- - delta_time
                enemie_in_logic['t'] = 700
            end
        end
    end

    if now_time - prev_enemie_time > 3300 and enemies_count < 10 then
        local t1 = socket.gettime()*1000
        prev_enemie_time = now_time

        local r = math.random(1,2)
        local d = math.random(-1,1)
        if r == 1 then
            for _, e in pairs(enemie_orders[1]) do
                local ee = create_enemie(e.img,e.l,e.t,e.w,e.h,e.mx,e.my,e.life,e.damage)
                ee.my = d
                table.insert(enemies, ee)
                enemies_count = enemies_count + 1
            end
        else
            for _, e in pairs(enemie_orders[2]) do
                local ee = create_enemie(e.img,e.l,e.t,e.w,e.h,e.mx,e.my,e.life,e.damage)
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
    for i,bullet_in_logic in ipairs(bullets) do
        if bullet_in_logic then
            bullet_in_logic['l'] = bullet_in_logic['l'] + bullet_in_logic['mx']
            if bullet_in_logic['l'] > 3000 or bullet_in_logic['l'] < -1000 then
                if bullet_in_logic['l'] < -1000 then
                    print('BulletRemover3', bullet_in_logic['l'])
                end
                table.remove(bullets, i)
            end
        end
    end

    -- Enemies bullets
    for _, enem in pairs(enemies) do
        if enem then
            local rand = math.random(1, 500)
            if rand == 1 then
                local bull = {}

                for z=1,10 do
                    bull[z] = false
                end

                bull.img='bullet1'
                bull.l=enem.l
                bull.t=enem.t + 50
                bull.mx=-3
                bull.w=10
                bull.h=10
                bull.damage=1
                bull.owner=false

                bullets_count = bullets_count + 1
                table.insert(bullets, bull)
            end
        end
    end

    -- Player bullets
    now_time = socket.gettime()*1000
    if now_time - prev_time > 100 then
        prev_time = now_time
        local bullet_x = player.l + player.w - 10
        local bullet_y = player.t + player.h / 2 - 5

        local modif_x = 5
        local modif_y = 0


        local bull = {}
        for z=1,10 do
            bull[z] = false
        end
        bull.img='bullet1'
        bull.l=bullet_x
        bull.t=bullet_y
        bull.mx=modif_x
        bull.w=10
        bull.h=10
        bull.damage=2
        bull.owner=true

        bullet_i = bullet_i + 1


        table.insert(bullets, bull)
        bullets_count = bullets_count + 1
    end
end

function love.update(dt)
    -- delta_time = dt
    local draw_timer = socket.gettime()*1000
    local delta = draw_timer - _fps.draw
    local frame_counter = delta / 10 -- 1000ms / 40 = 25 frames
    if frame_counter >= 1 then
        while frame_counter>0 do
            enemies_logic()
            bullets_logic()
            enem:collisions()
            check_keyboard()
            frame_counter = frame_counter-1

            -- FixME
            bg_counter = bg_counter - 0.3
            if bg_counter < -2450 then
                bg_counter = 0
            end

        end
        _fps.draw = draw_timer
    end

    if check_game_over() then
        return
    end
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
        player.l = player.l - 5
    end
    if love.keyboard.isDown("d") and player.l < 1266 then
        player.l = player.l + 5
    end
    if love.keyboard.isDown("s") and player.t < 668 then
        player.t = player.t + 5
    end
    if love.keyboard.isDown("w") and player.t > 0 then
        player.t = player.t - 5
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
    drawer:enemies()
    local t2 = socket.gettime()*1000
    local t3 = t2 - t1
    if t3 > 5 then
        print('Draw5', t3)
    end

    local t1 = socket.gettime()*1000
    drawer:bullets()
    local t2 = socket.gettime()*1000
    local t3 = t2 - t1
    if t3 > 5 then
        print('Draw4', t3)
    end


end

function love.quit()
--    ProFi:stop()
--    ProFi:writeReport( 'MyProfilingReport.txt' )

  print("Thanks for playing! Come back soon!")
end