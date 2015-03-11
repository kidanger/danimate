local Keyframe = {
	duration=1,
	method='linear'
}
Keyframe.__index = Keyframe

function Keyframe.new()
	return setmetatable({}, Keyframe)
end

function Keyframe:set(partname, x, y, angle)
	self[partname] = {
		x=x,
		y=y,
		angle=angle,
	}
	return self
end

function Keyframe:__tostring()
	local buf = ''
	for k, v in pairs(self) do
		buf = buf .. ('\t\t\t%s={\n'):format(k)
		for kk, vv in pairs(v) do
			buf = buf .. ('\t\t\t\t%s=%.2f,\n'):format(kk, vv)
		end
		buf = buf .. '\t\t\t},\n'
	end
	return buf
end

return Keyframe

