local enem = {}

function enem:calculate_damage(unit, u_table, bullet, b_table)
    local t1 = socket.gettime()*1000

    unit.life = unit.life - bullet.damage
    unit.kicked = 5
    if unit.life < 1 then
        if u_table then
            table.remove(enemies,u_table)
        end
        enemies_count = enemies_count - 1
        score = score + 1
    end
    table.remove(bullets,b_table)
    bullets_count = bullets_count - 1

    local t2 = socket.gettime()*1000
    local t3 = t2 - t1
    if t3 > timeout then
        print('calculate_damage', t3)
    end

end

function enem:collisions()
    local t1 = socket.gettime()*1000

    for _, b in pairs(bullets) do
        if b then
            if b.owner then
                for __, e in pairs(enemies) do
                    if e then
                        if e.l < 1366 and e.l > 0 and CheckCollision(b.l, b.t, 10, 10, e.l, e.t, 120, 120) then
                            enem:calculate_damage(e, __, b, _)
                        end
                    end
                end
            else
                if CheckCollision(b.l, b.t, 10, 10, player.l, player.t, player.w, player.h) then
                    enem:calculate_damage(player, false, b, _)
                end
            end
            if bullet_status then
                table.remove(bullets,_)
                enemies_count = enemies_count - 1
            end
        end
    end

    for _, enem in pairs(enemies) do
        if enem then
            if CheckCollision(enem.l, enem.t, enem.w, enem.h, player.l, player.t, player.w, player.h) then
                ship_crack(player, enem, _)
            end
        end
    end

    local t2 = socket.gettime()*1000
    local t3 = t2 - t1
    if t3 > timeout then
        print('collisions', t3)
    end

end

return enem