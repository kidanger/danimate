local drystal = require 'drystal'

local Hero = require 'hero'

local hero = Hero.new()
local mobs = {}
local font
local spritesheet

drystal.resize(600, 550)

function drystal.init()
	spritesheet = assert(drystal.load_surface 'spritesheet.png')
	spritesheet:set_filter(drystal.filters.nearest)
	font = assert(drystal.load_font('arial.ttf', 14))

	hero:init()
	local function new(x, y)
		local m = Hero.new()
		m.x = x
		m.y = y
		m:init()
		table.insert(mobs, m)
	end
	new(hero.x + 100, y)
	new(100, 20)
end

function drystal.update(dt)
	hero:update(dt)
	for _, m in ipairs(mobs) do
		m:update(dt)
	end
end

function drystal.draw()
	drystal.set_color 'black'
	drystal.draw_background()

	spritesheet:draw_from()
	drystal.set_color 'white'
	hero:draw()
	for _, m in ipairs(mobs) do
		m:draw()
	end

	drystal.camera.reset()
	drystal.set_color 'white'
	local sprite = hero.sprite
	local key = sprite.animation.keyframe
	font:draw(('%s %d/%d (%.2f sec %s%s)'):format(sprite.animation.name,
			sprite.animation.curkey, #sprite.animation, key.duration, key.method,
			sprite.animation.loop and ' loop' or ''), 0, 0)
end

function drystal.key_release(k)
	if k == 'left' then
		hero.left = false
	elseif k == 'right' then
		hero.right = false
	elseif k == 'up' then
		hero.jump = false
	elseif k == 'down' then
		hero.crouch = false
	elseif k == 'left shift' then
		hero.run = false
	end
	if k == '[1]' or k == 'kp1' then
		spritesheet:set_filter(drystal.filters.nearest)
	elseif k == '[2]' or k == 'kp2' then
		spritesheet:set_filter(drystal.filters.linear)
	end
end
function drystal.key_press(k)
	if k == 'left' then
		hero.left = true
	elseif k == 'right' then
		hero.right = true
	elseif k == 'up' then
		hero.jump = true
	elseif k == 'down' then
		hero.crouch = true
	elseif k == 'left shift' then
		hero.run = true
	end
end


