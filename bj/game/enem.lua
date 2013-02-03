local enem = {}

function enem:create_enemie(img_name,x,y,w,h,mx,my,life,damage)
    create_enemie_counter = create_enemie_counter + 1
    local now_time = socket.gettime()*1000
    local name = 'enemie'..create_enemie_counter
    print("Cretae "..name)
    local u = {name=name, img=img_name, l=x, t=y, mx=mx, my=my, w=w,h=h, life=life, time=now_time, kicked=0, damage=damage}
    return u
end

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
                        if e.l < 1366 and e.l > 0 and utils:CheckCollision(b.l, b.t, 10, 10, e.l, e.t, 120, 120) then
                            enem:calculate_damage(e, __, b, _)
                        end
                    end
                end
            else
                if utils:CheckCollision(b.l, b.t, 10, 10, player.l, player.t, player.w, player.h) then
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
        if utils:CheckCollision(v.l, v.t, v.w, v.h, player.l, player.t, player.w, player.h) then
            player.life = player.life + v.value
            anim:remove(v.name)
            table.remove(bonuses,k)
        end
    end

    for _, enem in pairs(enemies) do
        if enem then
            if utils:CheckCollision(enem.l, enem.t, enem.w, enem.h, player.l, player.t, player.w, player.h) then
                local random_name = "ShipCrack"..math.random(1000,9000)
                anim:create_anim(random_name, boom1, 54, 54, 'once', enem.l, enem.t)
                table.insert(gAnimations, random_name)

                gameplay:ship_crack(player, enem, _)
            end
        end
    end

    local t2 = socket.gettime()*1000
    local t3 = t2 - t1
    if t3 > timeout then
        print('collisions', t3)
    end

end

function enem:init()
    local now_time = socket.gettime()*1000
    enemie_orders = {}
    create_enemie_counter = 0
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

end

return enem