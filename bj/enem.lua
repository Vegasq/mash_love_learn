local enem = {}

function enem:calculate_damage(unit, u_table, bullet, b_table)
    local t1 = socket.gettime()*1000

    unit.life = unit.life - bullet.damage
    unit.kicked = 50
    if unit.life < 1 then
        if u_table then
            local random_name = "bang"..math.random(1000,9000)
            print('EnemRemover9'..random_name)

            local try = anim:create_anim(random_name, boom2, 100, 100, 'once', unit.l, unit.t)
            if try ~= false then
                table.insert(gAnimations, try)
            end

            local bonus_posibility = math.random(1,2)
            if bonus_posibility == 1 then
                local random_name = "bonusname"..math.random(1000,9000)

                local try = anim:create_anim(random_name, bonus1, 20, 20, 'loop', unit.l, unit.t)
                if try ~= false then
                    table.insert(bonuses, {name=random_name, type='life', value=20, t=unit.t, l=unit.l, mx=unit.mx, my=0, w=20, h=20})
                    table.insert(gAnimations, try)
                end
            end
            table.remove(enemies,u_table)
        end
        enemies_count = enemies_count - 1
        score = score + 1
    end
    print('BulletRemover2')
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
                print('BulletRemover1')
                table.remove(bullets,_)
                enemies_count = enemies_count - 1
            end
        end
    end

    for k,v in pairs(bonuses) do
        if CheckCollision(v.l, v.t, v.w, v.h, player.l, player.t, player.w, player.h) then
            player.life = player.life + v.value
            anim:remove(v.name)
            table.remove(bonuses,k)
        end
    end

    for _, enem in pairs(enemies) do
        if enem then
            if CheckCollision(enem.l, enem.t, enem.w, enem.h, player.l, player.t, player.w, player.h) then
                local random_name = "ShipCrack"..math.random(1000,9000)
                anim:create_anim(random_name, boom1, 54, 54, 'once', enem.l, enem.t)
                table.insert(gAnimations, random_name)

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