local tween = require 'tween'

local Keyframe = require 'Keyframe'

local Animation = {
	-- the array part contains the keyframes,
	loop=false,
	curkey=1,
	keyframe=nil,
	timers=nil,
	before_keyframe=nil,
	after=nil,
}
Animation.__index = Animation

function Animation.new()
	local self = setmetatable({}, Animation)
	self.timers = {}
	return self
end

function Animation.new_from_sprite(sprite)
	local self = Animation.new()
	local key = Keyframe.new()
	for _, part in ipairs(sprite.parts) do
		key:set(part.name, part.x, part.y, part.angle)
	end
	self:add(key, .2)
	return self
end

function Animation.new_from_table(keys)
	local self = Animation.new()
	for _, ktable in ipairs(keys) do
		local key = Keyframe.new()
		for partname, data in pairs(ktable) do
			if partname ~= 'duration' and partname ~= 'method' then
				key:set(partname, data.x, data.y, data.angle)
			end
		end
		self:add(key, ktable.duration, ktable.method)
	end
	self.name = keys.name
	self.loop = keys.loop
	return self
end

function Animation:add(keyframe, duration, method)
	table.insert(self, {
		key=keyframe,
		duration=duration,
		method=method or 'linear',
	})
	return self
end

function Animation:prepare(animated_elements)
	self.curkey = 1
	self.keyframe = self[self.curkey]
	self.elements = animated_elements
	self.after = nil
end

function Animation:start()
	self:stop()
	if self.before_keyframe then
		self.before_keyframe(self.keyframe)
	end
	local duration = self.keyframe.duration
	local keyframe = self.keyframe.key
	local method = self.keyframe.method
	for _, p in ipairs(self.elements) do
		if keyframe[p.name] then
			self.timers[#self.timers + 1] = tween.new(duration, p, keyframe[p.name], method)
		end
	end
end

function Animation:stop()
	self.timers = {}
end

function Animation:update(dt, parent)
	local ended = false
	local allzero = true
	for _, t in ipairs(self.timers) do
		if t:update(dt) then
			ended = true
		end
		if t.clock > 0 then
			allzero = false
		end
	end

	if allzero and dt < 0 and (self.curkey > 1 or self.loop) then
		self:previous_keyframe()
		self:previous_keyframe()
		self:start()
		local normal_initials = {}
		for i, t in ipairs(self.timers) do
			t:set(t.duration)
		end
		self:next_keyframe()
		self:start()
		for i, t in ipairs(self.timers) do
			normal_initials[i] = t.initial
		end
		for i, t in ipairs(self.timers) do
			t.initial = normal_initials[i]
			t:set(t.duration)
		end
	elseif ended then
		if self.curkey < #self or self.loop then
			self:next_keyframe()
			self:start()
		elseif self.after then
			self.after()
		end
	end
end

function Animation:next_keyframe()
	self.curkey = self.curkey + 1
	if self.curkey > #self then
		self.curkey = 1
	end
	self.keyframe = self[self.curkey]
end

function Animation:previous_keyframe()
	self.curkey = self.curkey - 1
	if self.curkey < 1 then
		self.curkey = #self
	end
	self.keyframe = self[self.curkey]
end

function Animation:reset_keyframe()
	for elementname, data in pairs(self.keyframe.key) do
		local element = self.elements[elementname]
		for k, v in pairs(data) do
			element[k] = v
		end
	end
	self:stop()
end

local function deepcopy(orig)
	-- from http://lua-users.org/wiki/CopyTable, modified
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in pairs(orig) do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, getmetatable(orig))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

function Animation:copy_keyframe()
	table.insert(self, self.curkey, deepcopy(self.keyframe))
	if self.curkey < #self then
		self:next_keyframe()
	end
end

function Animation:delete_keyframe()
	if #self == 1 then
		print 'can\'t delete the last keyframe'
		return
	end
	table.remove(self, self.curkey)
	if self.curkey > #self then
		self.curkey = self.curkey - 1
	end
	self.keyframe = self[self.curkey]
	self:reset_keyframe()
end

function Animation:copy()
	return deepcopy(self)
end

function Animation:__tostring()
	local buf = '{\n'
	buf = buf .. ('\t\tname=%q,\n'):format(self.name)
	buf = buf .. ('\t\tloop=%s,\n'):format(self.loop and 'true' or 'false')
	for i, k in ipairs(self) do
		buf = buf .. '\t\t{\n'
		buf = buf .. ('\t\t\tduration=%.2f,\n'):format(k.duration)
		buf = buf .. ('\t\t\tmethod=\'%s\',\n'):format(k.method)
		buf = buf .. ('%s'):format(k.key)
		buf = buf .. '\t\t},\n'
	end
	buf = buf .. '\t}'
	return buf
end

return Animation

