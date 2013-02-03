define = {}

function define:init()
    timeout = 0.3
    _bc = 0
    _ec = 0

    the_end = false
    score = 0
    floor = math.floor
    bg_counter = 0

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
    player = {name='player', id=0, img=submarine, l=10, t=10, mx=false, my=false, w=128,h=87, life=100, time=false, kicked=0}
    draw = love.graphics.draw
    font = love.graphics.newFont( 30 )
    font50 = love.graphics.newFont( 50 )
    self.game_status = 'menu'
end

function define:get_game_status()
	return self.game_status
end

function define:set_game_status(val)
	self.game_status = val
end


return define