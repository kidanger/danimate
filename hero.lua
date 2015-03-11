package.path = package.path .. ';danimate/?.lua'

local Sprite = require 'danimate.Sprite'
local SpritePart = require 'danimate.SpritePart'
local Animation = require 'danimate.Animation'

local Hero = {
	x=300,
	y=500,
	dx=0,
	dy=0,
	run=false,
	left=false,
	right=false,
	jump=false,
	doublejumped=false,
	crouch=false,
	dead_timer=0,
}
Hero.__index = Hero

function Hero.new()
	return setmetatable({}, Hero)
end

function Hero:init()
	local data = dofile('animations.lua')
	self.sprite = Sprite.new(0, 0, data.sprite.w, data.sprite.h)
	self.sprite:add_parts(data.parts)
	self.sprite:add_animations(data.animations)

	self.sprite:set_animation 'still'
end

function Hero:update(dt)
	local accel = 7000
	local maxspeed = (self.run and self.y == 500) and 220 or 120
	local gravity = 1000
	local jumpspeed = 25000

	if self.y == 500 then
		self.dx = self.dx * 0.85
	end
	if self.dead_timer == 0 then
		if self.crouch then
			accel = accel / 15
		end
		if self.left then
			self.dx = self.dx - accel * dt
		end
		if self.right then
			self.dx = self.dx + accel * dt
		end
		self.dx = math.max(math.min(self.dx, maxspeed), -maxspeed)

		if self.jump and self.y == 500 then
			self.dy = self.dy - jumpspeed * dt
			self:set_anim('jump', 'falling')
			self.jump = false
		elseif self.jump and not self.doublejumped then
			self.dy = - jumpspeed * dt
			self.doublejumped = true
			self:set_anim('doublejump', 'falling')
		end
		if self.y ~= 500 and self.sprite.animation.name ~= 'jump' and self.sprite.animation.name ~= 'doublejump' then
			self:set_anim 'falling'
		end

		self.dy = self.dy + gravity * dt

		self.x = self.x + self.dx * dt
		self.y = self.y + self.dy * dt

		if self.y >= 500 then
			self.y = 500
			self.doublejumped = false
			self.dy = 0
			--if math.random() < 0.001 then
				--self:set_anim 'dead'
				--self.dead_timer = 2
			--end
		end

		local still_threshold = maxspeed * 0.05
		if self.y == 500 and self.dead_timer == 0 then
			if self.crouch then
				if math.abs(self.dx) > 10. then
					self:set_anim 'crawl'
				else
					self:set_anim 'crouch'
				end
			elseif math.abs(self.dx) > still_threshold then
				self:set_anim(self.run and 'run' or 'walk')
			elseif math.abs(self.dx) < still_threshold then
				self:set_anim 'still'
			end
		end
	else
		self.dead_timer = self.dead_timer - dt
		if self.dead_timer < 0 then
			self.dead_timer = 0
		end
	end

	self.sprite.x = self.x
	self.sprite.y = self.y
	if self.dx < 0 then
		self.sprite:set_dir(-1)
	elseif self.dx > 0 then
		self.sprite:set_dir(1)
	end
	self.sprite:update(dt)
end

function Hero:set_anim(name, after)
	if self.sprite.animation.name ~= name then
		self.sprite:set_animation(name, after)
	end
end

function Hero:draw()
	self.sprite:draw()
end

return Hero

