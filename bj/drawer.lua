local drawer = {}

function drawer:bg()
    bg_counter = bg_counter - 1
    if bg_counter < -2450 then
        bg_counter = 0
    end

    draw(bg, bg_counter, 0)
    draw(bg, bg_counter + 2500, 0)
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
    _ec = 0
    for _, enemie in pairs(enemies) do
        if enemie then
            _ec = _ec + 1
            enemie['l'] = enemie['l'] + enemie['mx']
            enemie['t'] = enemie['t'] + enemie['my']

            if enemie['t'] < 100 then
                enemie['my'] = enemie['my'] * -1 -- - delta_time
                enemie['t'] = 100
            end
            if enemie['t'] > 700 then
                enemie['my'] = enemie['my'] * -1 -- - delta_time
                enemie['t'] = 700
            end



            if enemie.kicked > 0 then
                love.graphics.setColor(255, 0, 0)
            end
            draw(enemie['img'], enemie['l'], enemie['t'])
            if enemie.kicked > 0 then
                enemie.kicked = enemie.kicked - 1
                love.graphics.setColor(255, 255, 255, 255)
            end

            if enemie['l'] > 3000 then
                table.remove(enemies, _)
            end
            if enemie['l'] < -150 then
                table.remove(enemies, _)
            end
        end
    end
    enemies_count = _ec

end

function drawer:bullets()
    _bc = 0
    for _, _bullet in pairs(bullets) do
        if _bullet then
            _bc = _bc + 1

            -- if _bullet['mx'] > 0 then
            --     _dt = delta_time
            -- else
            --     _dt = delta_time * -1
            -- end

            _bullet['l'] = _bullet['l'] + _bullet['mx'] --+ _dt
            if _bullet['l'] < 1366 or _bullet['l'] > 0 or _bullet['t'] > 0 or _bullet['t'] < 768 then

                if _bullet['img'] == 'bullet1' then
                    draw(bullet_img, _bullet['l'], _bullet['t'])
                else
                    draw(_bullet['img'], _bullet['l'], _bullet['t'])
                end 

            end
            if _bullet['l'] > 3000 or _bullet['l'] < 1 then
                table.remove(bullets, _)
            end
        end
    end
    bullets_count = _bc
end

return drawer