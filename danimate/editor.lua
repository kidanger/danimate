local drystal = require 'drystal'

local filename = arg[1]
if not filename then
	error 'No filename specified in command line. Aborting.'
end

package.path = package.path .. ';danimate/?.lua'
local Sprite = require 'danimate.Sprite'
local Animation = require 'danimate.Animation'

local sprite

local mouse_drag
local zoom = 4
local run = false
local font
local spritesheet

function drystal.init()
	drystal.resize(300, 300)

	spritesheet = assert(drystal.load_surface 'spritesheet.png')
	spritesheet:set_filter(drystal.filters.nearest)
	font = assert(drystal.load_font('arial.ttf', 14))

	local data = dofile(filename)
	sprite = Sprite.new(0, 0, data.sprite.w, data.sprite.h)
	sprite:add_parts(data.parts)
	sprite:add_animations(data.animations)

	sprite.x = 150 - sprite.w / 2
	sprite.y = 150 - sprite.h / 2

	if sprite.animations[1] then
		sprite:set_animation(sprite.animations[1].name)
	end
end

local timecontrol = false
local timecontrolfrom
local paused = false
local mx = 0
local my = 0
function drystal.update(dt)
	if timecontrol then
		local dt = math.log(1 + (mx - timecontrolfrom) / 900.) / 20.
		sprite:update(dt)
		return
	end

	if not paused then
		sprite:update(dt)
	end
	if mouse_drag then
		local mx, my = mousepos()
		if mouse_drag.master then
			mouse_drag.part.x = mx - mouse_drag.sprite.x
			mouse_drag.part.y = my - mouse_drag.sprite.y
		else
			local angle = math.atan2(my - mouse_drag.sprite.y - mouse_drag.part.y,
									 mx - mouse_drag.sprite.x - mouse_drag.part.x)
			mouse_drag.part.angle = angle
		end
		sprite.animation:reset_keyframe()
	end
end

function drystal.draw()
	drystal.set_color 'black'
	drystal.draw_background()
	drystal.camera.zoom = zoom

	spritesheet:draw_from()
	drystal.set_color 'white'
	sprite:draw()
	sprite:draw2()

	drystal.camera.reset()
	local y = 0
	local i = 1
	for _, anim in pairs(sprite.animations) do
		local y = (i - 1) * 14
		if anim == sprite.animation then
			drystal.set_color 'green'
			local key = sprite.animation.keyframe
			font:draw(('%d - %s %d'):format(i, anim.name, #anim), 0, y)

			drystal.set_color 'white'
			font:draw(('Keyframe %d - %.2f sec'):format(anim.curkey, key.duration),
						drystal.screen.w-2, 0, drystal.aligns.right)
			font:draw(key.method, drystal.screen.w-2, 14, drystal.aligns.right)
			if anim.loop then
				font:draw('loop', drystal.screen.w-2, 14*2, drystal.aligns.right)
			end
		else
			drystal.set_color 'white'
			font:draw(('%d - %s %d'):format(i, anim.name, #anim), 0, y)
		end
		i = i + 1
	end

	if timecontrol then
		drystal.set_color 'orange'
		drystal.set_line_width(5)
		drystal.draw_line(mx, my, timecontrolfrom, my)
	end

	drystal.camera.zoom = zoom
end

function drystal.mouse_motion(x, y, dx, dy)
	mx = x
	my = y
end
function drystal.mouse_release(_, _, b)
	mouse_drag = nil
	if b == drystal.buttons.right then
		timecontrol = false
		paused = true
	end
end
function drystal.mouse_press(x, y, b)
	if b == drystal.buttons.wheel_down then
		zoom = zoom * 0.9
	elseif b == drystal.buttons.wheel_up then
		zoom = zoom * 1.1
	elseif b == drystal.buttons.right then
		run = false
		timecontrol = true
		timecontrolfrom = x
		pause = true
	else
		local s = sprite
		for _, p in ipairs(s.parts) do
			local p1 = {x=p.x, y=p.y}
			local p2 = {
				x=p.x + math.cos(p.angle) * p.dist,
				y=p.y + math.sin(p.angle) * p.dist,
			}

			if point_hovered(s.x + p1.x, s.y + p1.y, p.radius) then
				mouse_drag = {master=true, part=p, sprite=s}
			elseif point_hovered(s.x + p2.x, s.y + p2.y, p.radius) then
				mouse_drag = {slave=true, part=p, sprite=s}
			end

			local key = sprite.animation.keyframe.key[p.name] or {x=0,y=0,angle=0}
			local p1b = {x=key.x, y=key.y}
			local p2b = {
				x=key.x + math.cos(key.angle) * p.dist,
				y=key.y + math.sin(key.angle) * p.dist,
			}

			if point_hovered(s.x + p1b.x, s.y + p1b.y, p.radius) then
				mouse_drag = {master=true, part=key, sprite=s}
			elseif point_hovered(s.x + p2b.x, s.y + p2b.y, p.radius) then
				mouse_drag = {slave=true, part=key, sprite=s}
			end
		end
	end
end

local function save()
	sprite:set_dir(1)
	local file = io.open(filename, 'w')
	local function w(line, ...)
		file:write(line:format(...))
		file:write('\n')
	end
	w('local parts={')
	for _, part in ipairs(sprite.parts) do
		w('\t{')
		w('\t\tname=%q,', part.name)
		w('\t\tsprite={x=%d, y=%d, w=%d, h=%d},', part.sprite.x, part.sprite.y, part.sprite.w, part.sprite.h)
		if part.swapwith then
			w('\t\tswapwith=%q,', part.swapwith)
		end
		w('\t},')
	end
	w('}')
	w('local animations = {')
	local n = 0
	for _, anim in pairs(sprite.animations) do
		w('\t%s,', anim)
		n = n + 1
	end
	w('}')
	w('return {')
	w('\tsprite={w=%d, h=%d},', sprite.w, sprite.h)
	w('\tparts=parts,')
	w('\tanimations=animations')
	w('}')
	file:close()
	print(('%d animations saved to %s'):format(n, filename))
end

local function get_name()
	local name
	repeat
		io.write("Animation name: ")
		io.flush()
		name = io.read()
	until #name > 0 and not sprite.indexes[name]
	return name
end
local function get_name_of_animation()
	local name
	repeat
		for _, anim in ipairs(sprite.animations) do
			io.write(anim.name)
			io.write(', ')
		end
		io.write("\nCopy of: ")
		io.flush()
		name = io.read()
	until sprite.indexes[name]
	return name
end

print([[
Commands:
  s     - save
  right - next frame
  left  - previous frame
  down  - next animation
  up    - previous animation
  c     - new keyframe from current one
  b     - new empty animation
  n     - new animation from an existing one
  d     - delete keyframe
  space - toggle run
  -/+   - modify keyframe duration
  m     - change tweening method
  l     - toggle animation loop
  f     - toggle direction
]])
function drystal.key_press(k)
	if k == 's' then
		save()
	elseif k == 'right' then
		sprite.animation:next_keyframe()
		sprite.animation:reset_keyframe()
		run = false
	elseif k == 'left' then
		sprite.animation:previous_keyframe()
		sprite.animation:reset_keyframe()
		run = false
	elseif k == 'up' then
		local index = (sprite.indexes[sprite.animation.name] - 2) % #sprite.animations + 1
		sprite:set_animation(sprite.animations[index].name)
		paused = false
	elseif k == 'down' then
		local index = sprite.indexes[sprite.animation.name] % #sprite.animations + 1
		sprite:set_animation(sprite.animations[index].name)
		paused = false
	elseif k == 'c' then
		sprite.animation:copy_keyframe()
	elseif k == 'b' then
		local name = get_name()
		local a = Animation.new_from_sprite(sprite)
		a.name = name
		sprite:add_animation(a)
		sprite:set_animation(name)
	elseif k == 'n' then
		local name = get_name()
		local a = sprite.animations[sprite.indexes[get_name_of_animation()]]:copy()
		a.name = name
		sprite:add_animation(a)
		sprite:set_animation(name)
	elseif k == 'd' then
		sprite.animation:delete_keyframe()
	elseif k == 'space' then
		paused = false
		run = not run
		if not run then
			sprite:stop_animation()
		else
			sprite:start_animation()
		end
	elseif k == 'm' then
		local methods = {linear=1, inOutCubic=1, outInCubic=1, inBack=1}
		local oldmeth = sprite.animation.keyframe.method
		local nextmeth = table.next(methods, oldmeth)
		sprite.animation.keyframe.method = nextmeth
	elseif k == 'l' then
		sprite.animation.loop = not sprite.animation.loop
	elseif k == 'f' then
		sprite:set_dir(sprite.dir * -1)
	elseif k == '[+]' then
		sprite.animation.keyframe.duration = sprite.animation.keyframe.duration + 0.05
	elseif k == '[-]' then
		sprite.animation.keyframe.duration = sprite.animation.keyframe.duration - 0.01
		if sprite.animation.keyframe.duration <= 0 then
			sprite.animation.keyframe.duration = 0.1
		end
	elseif k == 'escape' then
		drystal.stop()
	else
		--print(k, 'unknown command')
	end
end

function drystal.key_text(k)
	local i = tonumber(k)
	if i and sprite.animations[i] then
		sprite:set_animation(sprite.animations[i].name)
		run = true
	end
end

function point_hovered(x, y, radius)
	local mx, my = mousepos()
	local d = math.sqrt((x - mx) ^ 2 + (y - my) ^ 2)
	return d <= radius
end

function mousepos()
	return drystal.screen2scene(mx, my)
end

