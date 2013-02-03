gameplay = {}

function gameplay:enemies_logic(dt)
    for k,v in pairs(gAnimations) do
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
                local ee = enem:create_enemie(e.img,e.l,e.t,e.w,e.h,e.mx,e.my,e.life,e.damage)
                ee.my = d
                table.insert(enemies, ee)
                enemies_count = enemies_count + 1
            end
        else
            for _, e in pairs(enemie_orders[2]) do
                local ee = enem:create_enemie(e.img,e.l,e.t,e.w,e.h,e.mx,e.my,e.life,e.damage)
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

function gameplay:bullets_logic()
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

function gameplay:check_game_over()
    if player.life < 1 then
        font = love.graphics.newFont( 70 )
        love.graphics.setFont(font);
        love.graphics.printf("Game Over\n You're score: "..score, 100, 300, 1100, 'center')

        the_end = true
    end
    return the_end
end

function gameplay:check_keyboard()
    local x, y = love.mouse.getPosition()
    player.l = x
    player.t = y

    -- if love.keyboard.isDown("a") and player.l > 0 then
    --     player.l = player.l - 5
    -- end
    -- if love.keyboard.isDown("d") and player.l < 1266 then
    --     player.l = player.l + 5
    -- end
    -- if love.keyboard.isDown("s") and player.t < 668 then
    --     player.t = player.t + 5
    -- end
    -- if love.keyboard.isDown("w") and player.t > 0 then
    --     player.t = player.t - 5
    -- end
end

function gameplay:drow()
    drawer:bg()
    drawer:player()
    drawer:interface()
    drawer:enemies()
    drawer:bullets()
end



function gameplay:ship_crack(player, enem, e_table)
    player.life = player.life - enem.damage
    player.kicked = 155
    print('ShipCrack')
    table.remove(enemies,e_table)
end

function gameplay:update()
    -- delta_time = dt
    local draw_timer = socket.gettime()*1000
    local delta = draw_timer - _fps.draw
    local frame_counter = delta / 10 -- 1000ms / 40 = 25 frames
    if frame_counter >= 1 then
        while frame_counter>0 do
            gameplay:enemies_logic()
            gameplay:bullets_logic()
            enem:collisions()
            gameplay:check_keyboard()
            frame_counter = frame_counter-1

            -- FixME
            bg_counter = bg_counter - 0.3
            if bg_counter < -2450 then
                bg_counter = 0
            end

        end
        _fps.draw = draw_timer
    end

    if gameplay:check_game_over() then
        return
    end
end

return gameplay