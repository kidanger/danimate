local drystal = require 'drystal'

local Part = {
	name=nil,
	sprite=nil,
	futuresprite=nil,
	x=0,
	y=0,
	angle=0,
	timer=nil,

	radius=1.5,
	dist=10,

	name=nil,
	swapwith=nil,
}
Part.__index = Part

function Part.new(sprite)
	local p = setmetatable({}, Part)
	p.sprite = sprite
	p.w = sprite.w
	p.h = sprite.h
	p.x = 0
	p.y = 0
	p.angle = 0
	p.dist = math.min(p.w, p.h) / 2
	return p
end

function Part:draw(dx, dy)
	local x, y = dx + self.x, dy + self.y
	local angle = self.angle
	local w = self.w
	local h = self.h

	x = x - w/2
	y = y - h/2
	local transform = {
		angle=angle - math.pi / 2,
		wfactor=1,
		hfactor=1,
	}
	drystal.draw_sprite(self.sprite, x, y, transform)
end

function Part:draw_flipped(dx, dy, maxx)
	local x, y = dx + maxx - self.x, dy + self.y
	local angle = math.pi - self.angle
	local w = self.w
	local h = self.h

	x = x - w/2
	y = y - h/2
	local transform = {
		angle=angle - math.pi / 2,
		wfactor=-1,
		hfactor=1,
	}
	drystal.draw_sprite(self.sprite, x, y, transform)
end

return Part

