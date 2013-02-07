local drawer = {}

function drawer:init()
    bg = love.graphics.newImage("resources/images/bg/mirra.png")
    bonus1 = love.graphics.newImage("resources/images/medic_anim2.png")
    boom1 = love.graphics.newImage("resources/20030506.png")
    boom2 = love.graphics.newImage("resources/boom2.png")
    submarine = love.graphics.newImage("resources/s1.png")
    enemie = love.graphics.newImage("resources/enemie.png")

    enem1 = love.graphics.newImage("resources/s2.png")
    enem2 = love.graphics.newImage("resources/s3.png")
    enem3 = love.graphics.newImage("resources/images/ships/spaceships2/Frigate.png")
    anim_enem = love.graphics.newImage("resources/images/ships/enemie1.png")
    bullet = love.graphics.newImage("resources/bullet.png")
    bullet_img = love.graphics.newImage("resources/bullet.png")
end

function drawer:bg()
    draw(gBackground.bg, gBackground.bg_counter, 0)
    draw(gBackground.bg, gBackground.bg_counter + gBackground.bg:getWidth(), 0)
end

function drawer:player()
    if player.kicked > 0 then
        love.graphics.setColor(255, 0, 0)
    end
    draw(player.img, player.l, player.t)
    if player.kicked > 0 then
        player.kicked = player.kicked - 1
        love.graphics.setColor(255, 255, 255, 255)
    end
end

function drawer:interface()
    love.graphics.setFont(font);
    love.graphics.setColor(255, 0, 0)
    love.graphics.setLine(5, "smooth")
    love.graphics.line( 10, 750, player.life * 2 + 10, 750 )
    love.graphics.setColor(255, 255, 255, 255)


    love.graphics.print("Score: ", 0, 0);
    love.graphics.print(score, 100, 0);

    love.graphics.print("Life: ", 0, 50);
    love.graphics.print(player.life, 100, 50);

    love.graphics.print("Bullets: ", 0, 150);
    love.graphics.print(_bc, 140, 150);

    love.graphics.print("Enemies: ", 0, 100);
    love.graphics.print(_ec, 140, 100);

end

function drawer:enemies()
    animations_counter = 0
    for i,v in ipairs(gAnimations) do
        if v ~= nil then
            animations_counter = animations_counter + 1
            anim:draw(v)
        end
    end


    _ec = 0
    for _, enemie_in_drawer in pairs(enemies) do
        if type(enemie_in_drawer) == 'table' then
            _ec = _ec + 1

            if enemie_in_drawer.kicked > 0 then
                love.graphics.setColor(255, 0, 0)
            end
            
            if type(enemie_in_drawer['img']) == 'userdata' then
                draw(enemie_in_drawer['img'], enemie_in_drawer['l'], enemie_in_drawer['t'])
            end

            if type(enemie_in_drawer['img']) == 'string' then
                anim:draw(enemie_in_drawer.img, enemie_in_drawer.l, enemie_in_drawer.t)
            end

            if enemie_in_drawer.kicked > 0 then
                enemie_in_drawer.kicked = enemie_in_drawer.kicked - 1
                love.graphics.setColor(255, 255, 255, 255)
            end

        end
    end
    enemies_count = _ec

end

function drawer:bullets()
    _bc = 0
    for _, bullet_in_drawer in pairs(bullets) do
        if bullet_in_drawer then
            _bc = _bc + 1


                if bullet_in_drawer['img'] == 'bullet1' then
                    draw(bullet_img, bullet_in_drawer['l'], bullet_in_drawer['t'])
                else
                    draw(bullet_in_drawer['img'], 
                        bullet_in_drawer['l'], bullet_in_drawer['t'])
                end 

        end
    end
    bullets_count = _bc
end

return drawer