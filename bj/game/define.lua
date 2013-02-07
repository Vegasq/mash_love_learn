define = {}

function define:init()
    gAudio = {}
    gAudio['bang1'] = love.audio.newSource(
        'resources/music/machine_gun_223_caliber_single_shot_distant_bushmaster_ar_15.ogg', 'static')
    gAudio['bg1'] = love.audio.newSource(
        'resources/music/improv_for_evil_a_short_dark_drum_heavy_groove.ogg' )
    gAudio['bg1']:setLooping(true)

    gAudio['bg2'] = love.audio.newSource(
        'resources/music/lost_in_space_dance_track_with_electronic_rhythms_and_looped_sax_riff_runing_throughout.ogg' )
    gAudio['bg2']:setLooping(true)




    timeout = 0.3
    _bc = 0
    _ec = 0

    the_end = false
    score = 0
    floor = math.floor

    gCurrent_level = {level=0, description=''}

    now_time = 0
    prev_time = 0
    prev_enemie_time = 0
    bullets = {}
    enemies = {}
    bonuses = {}
    gAnimations = {}

    bullets_count = 0
    enemies_count = 0

    bullet_i = 1
    enemie_i = 1
    prev_dt = 0
    loop_counter = {c=0, time=0, ptime=0}
    loop_counter['ptime'] = socket.gettime()*1000

    _fps = {draw=socket.gettime()*1000, update=socket.gettime()*1000}
    player = {name='player', id=0, img=submarine, l=10, t=10, mx=false, my=false, w=128,h=87, life=5, time=false, kicked=0}
    draw = love.graphics.draw
    font = love.graphics.newFont( 30 )
    font50 = love.graphics.newFont( 50 )
    self.game_status = 'menu'


    levels = {}
    local enem_speed = -0.4


    levels[1] = {}
    levels[1].description = "You should destroy 100 enemies to switch to next level!"
    levels[1].bg = bg
    levels[1].bg_speed = 0.3
    levels[1].enemies = {
        {
            pos=99,
            u1={name='1_in_tringle', id='1it', img=enem1, l=1566, t=100, mx=enem_speed, my=0, w=91,h=40, life=15, time=now_time, kicked=0, damage=5},
            u2={name='2_in_tringle', id='2it', img=enem2, l=1466, t=200, mx=enem_speed, my=0, w=130,h=45, life=20, time=now_time, kicked=0, damage=5},
            u3={name='3_in_tringle', id='3it', img=enem3, l=1366, t=300, mx=enem_speed, my=0, w=111,h=45, life=25, time=now_time, kicked=0, damage=5},
            u4={name='4_in_tringle', id='4it', img=enem2, l=1466, t=400, mx=enem_speed, my=0, w=130,h=45, life=20, time=now_time, kicked=0, damage=5},
            u5={name='5_in_tringle', id='5it', img=enem1, l=1566, t=500, mx=enem_speed, my=0, w=91,h=40, life=15, time=now_time, kicked=0, damage=5},
        },
        {
            pos=99,
            u1={name='1_in_line', id='1il', img=enem3, l=1566, t=100, mx=enem_speed, my=0, w=111,h=45, life=30, time=now_time, kicked=0, damage=5},
            u2={name='2_in_line', id='2il', img=enem2, l=1766, t=100, mx=enem_speed, my=0, w=130,h=45, life=30, time=now_time, kicked=0, damage=5},
            u3={name='3_in_line', id='3il', img=enem2, l=1966, t=100, mx=enem_speed, my=0, w=130,h=45, life=30, time=now_time, kicked=0, damage=5},
        }
    }
    levels[1].victory = {by_points=10, by_helth=200, by_time=180000, by_destroy='boss1', start_time=0}
    levels[1].specOps = {by_points=100, by_helth=200, by_time=180000, who='boss1', start_time=0}




    levels[2] = {}
    levels[2].description = "You should destroy 200 enemies to switch to next level!"
    levels[2].bg = bg
    levels[2].bg_speed = 0.3
    levels[2].enemies = {
        {
            pos=10,
            u1={name='1_in_tringle', id='1it', img=enem1, l=1566, t=100, mx=enem_speed, my=0, w=91,h=40, life=15, time=now_time, kicked=0, damage=5},
            u2={name='2_in_tringle', id='2it', img=enem2, l=1466, t=200, mx=enem_speed, my=0, w=130,h=45, life=20, time=now_time, kicked=0, damage=5},
            u3={name='3_in_tringle', id='3it', img=enem3, l=1566, t=300, mx=enem_speed, my=0, w=111,h=45, life=25, time=now_time, kicked=0, damage=5},
            u4={name='4_in_tringle', id='4it', img=enem2, l=1466, t=400, mx=enem_speed, my=0, w=130,h=45, life=20, time=now_time, kicked=0, damage=5},
            u5={name='5_in_tringle', id='5it', img=enem1, l=1566, t=500, mx=enem_speed, my=0, w=91,h=40, life=15, time=now_time, kicked=0, damage=5},
        },
        {
            pos=30,
            u1={name='1_in_line', id='1il', img=enem3, l=1566, t=100, mx=enem_speed, my=0, w=111,h=45, life=30, time=now_time, kicked=0, damage=5},
            u2={name='2_in_line', id='2il', img=enem2, l=1766, t=200, mx=enem_speed, my=0, w=130,h=45, life=30, time=now_time, kicked=0, damage=5},
            u3={name='3_in_line', id='3il', img=enem2, l=1966, t=300, mx=enem_speed, my=0, w=130,h=45, life=30, time=now_time, kicked=0, damage=5},
        }
    }
    levels[2].victory = {by_points=200, by_helth=200, by_time=180000, by_destroy='boss1', start_time=0}
    levels[2].specOps = {by_points=100, by_helth=200, by_time=180000, who='boss1', start_time=0}

end

function define:get_game_status()
    return self.game_status
end

function define:set_game_status(val)
    if val == 'game' then
        love.audio.stop()
        love.audio.play(gAudio['bg2'])
    else
        love.audio.stop()
        love.audio.play(gAudio['bg1'])
    end

    self.game_status = val
end

function define:set_level(level)
    gBackground={}
    gBackground.bg=levels[level].bg
    gBackground.speed=levels[level].bg_speed
    gBackground.bg_w=levels[level].bg:getWidth()
    gBackground.bg_counter = 0

    gVictory = {}
    gVictory = levels[level].victory
    gVictory.start_time = socket.gettime()*1000

    gCurrent_level = {level=level, description=levels[level].description}

    enemie_orders = levels[level].enemies
end

function define:init_levels()

end

return define