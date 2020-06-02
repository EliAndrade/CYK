local CFG = require "CFG"
local l = CFG:new()
local textfile = io.open("CFG.txt", "r")

for line in textfile:lines() do
	local from, to = line:match("(%w+) => (.+)")
	for t in to:gmatch("%w+") do
		l:newRule(from, t)
	end
end

l:parse("aaabbb")

