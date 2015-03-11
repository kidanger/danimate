local drystal = require 'drystal'

local Animation = require 'danimate.Animation'
local SpritePart = require 'danimate.SpritePart'

local Sprite = {
	x=0,
	y=0,
	w=0,
	h=0,
	dir=1,
}
Sprite.__index = Sprite

function Sprite.new(x, y, w, h)
	local s = setmetatable({}, Sprite)
	s.x = x
	s.y = y
	s.w = w
	s.h = h
	s.parts = {}
	s.animations = {}
	s.indexes = {}
	return s
end

function Sprite:add_part(name, part, swapwith)
	part.name = name
	part.swapwith = swapwith
	self.parts[#self.parts + 1] = part
	self.parts[name] = part
	return self
end

function Sprite:add_parts(parts)
	for _, part in ipairs(parts) do
		self:add_part(part.name, SpritePart.new(part.sprite), part.swapwith)
	end
end

function Sprite:add_animation(animation)
	table.insert(self.animations, animation)
	self.indexes[animation.name] = #self.animations
	return self
end

function Sprite:add_animations(animations)
	for _, anim in ipairs(animations) do
		local a = Animation.new_from_table(anim)
		self:add_animation(a)
	end
end

function Sprite:set_animation(name, after)
	local index = self.indexes[name]

	if self.animation then
		self.animation:stop()
	else
		for _, p in ipairs(self.parts) do
			local key = self.animations[index][1].key[p.name]
			p.angle = key.angle
			p.x = key.x
			p.y = key.y
		end
	end

	self.animation = self.animations[index]
	self.animation:prepare(self.parts)

	self.animation.before_keyframe = function(key)
		local keyframe = key.key
		for _, p in ipairs(self.parts) do
			local angle_dest = keyframe[p.name].angle
			while p.angle < angle_dest - math.pi do
				p.angle = p.angle + math.pi * 2
			end
			while p.angle > angle_dest + math.pi do
				p.angle = p.angle - math.pi * 2
			end
		end
	end
	self.animation.after = function()
		if after then
			self:set_animation(after)
		end
	end

	self:start_animation()
end

function Sprite:stop_animation()
	self.animation:stop()
end
function Sprite:start_animation()
	self.animation:start()
end

function Sprite:update(dt)
	if self.animation then
		self.animation:update(dt)
	end
end

function Sprite:set_dir(dir)
	if self.dir ~= dir then
		self.dir = dir
		for _, p in ipairs(self.parts) do
			if p.swapwith and self.parts[p.swapwith] then
				p.futuresprite = self.parts[p.swapwith].sprite
			else
				p.futuresprite = p.sprite
			end
		end
		for _, p in ipairs(self.parts) do
			p.sprite = p.futuresprite
			p.futuresprite = nil
		end
	end
end

function Sprite:draw()
	for _, p in ipairs(self.parts) do
		if self.dir > 0 then
			p:draw(self.x, self.y)
		elseif self.dir < 0 then
			p:draw_flipped(self.x, self.y, self.w)
		end
	end
end

function Sprite:draw2()
	if not self.animation then
		return
	end

	local dx, dy = self.x, self.y
	for _, p in ipairs(self.parts) do
		local p1 = {x=p.x, y=p.y}
		local p2 = {
			x=p.x + math.cos(p.angle) * p.dist,
			y=p.y + math.sin(p.angle) * p.dist,
		}
		local k = self.animation.keyframe.key[p.name] or {x=0,y=0,angle=0}
		local p1b = {x=k.x, y=k.y}
		local p2b = {
			x=k.x + math.cos(k.angle) * p.dist,
			y=k.y + math.sin(k.angle) * p.dist,
		}
		local function isinside(point)
			return point_hovered(dx + point.x, dy + point.y, p.radius * 1.5)
		end
		local inside = isinside(p1) or isinside(p2) or isinside(p1b) or isinside(p2b)
		if inside then
			local function printpoint(pp, factor)
				--local mode = point_hovered(self.x + pp.x, self.y + pp.y, p.radius) and 'fill' or 'line'
				--love.graphics.circle(mode, pp.x, pp.y, p.radius * factor)
				if point_hovered(self.x + pp.x, self.y + pp.y, p.radius) then
					drystal.draw_circle(dx + pp.x, dy + pp.y, p.radius * factor)
				end
				drystal.draw_circle(dx + pp.x, dy + pp.y, p.radius * factor)
			end
			drystal.set_color '#3F3'
			drystal.set_color(50, 255, 50)
			printpoint(p1b, 1)
			printpoint(p2b, 1)

			drystal.set_color '#050'
			printpoint(p1, 0.5)
			printpoint(p2, 0.5)
		end
	end
	local mx, my = mousepos()
	if mx >= self.x and mx <= self.x + self.w
	and my >= self.y and my <= self.y + self.h then
		drystal.set_color '#777'
		drystal.draw_square(dx, dy, self.w, self.h)
	end
end

return Sprite

