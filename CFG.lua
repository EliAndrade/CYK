local CFG = {}
function CFG:new()
	local o = {}
	
	o.l_rules = {}
	o.r_rules = {}
	o.__index = self
	
	setmetatable(o, o)
	return o
end

function CFG:newRule(left, right)
	self.l_rules[left] = self.l_rules[left] or {}
	self.r_rules[right] = self.r_rules[right] or {}
	
	table.insert(self.l_rules[left], right)	
	table.insert(self.r_rules[right], left)	
end

function CFG:CYK(word)
	local layers = {}
	
	layers[1] = {}
	
	for token in word:gmatch("%a") do
		if not self.r_rules[token] then
			return false
		end
		
		local set = {}
		for i, rule in ipairs(self.r_rules[token]) do
			table.insert(set, rule)
		end
		
		table.insert(layers[1], set)
		
		io.write(token..'\t')
	end
	
	io.write("\n")
	for i, set in ipairs(layers[1]) do
		for j, rule in ipairs(set) do
			io.write(rule..",")
		end
		io.write('\t')
	end
	
	print()
	
	for level = 2, #layers[1] do
		layers[level] = {}
		for i = 1, #layers[level-1]-1 do
			local possibilities = {}
			
			for l = 1, level-1 do		
				for f, first in ipairs(layers[l][i]) do
					for s, second in ipairs(layers[level-l][i+l]) do
						table.insert(possibilities, first..second)
					end
				end
			end
			
			layers[level][i] = {}
			for a, attempt in ipairs(possibilities) do
				if self.r_rules[attempt] then
					for r, rule in ipairs(self.r_rules[attempt]) do
						local put = true
						
						for t, test in ipairs(layers[level][i]) do
							if test == rule then
								put = false
								break
							end
						end
						
						if put then
							table.insert(layers[level][i], rule)
						end
					end
				end
			end
		end
		
		for i, set in ipairs(layers[level]) do
			for j, rule in ipairs(set) do
				io.write(rule..",")
			end
			io.write('\t')
		end
		
		print()
	end
	
	return #layers[#layers[1]][1] ~= 0
end

return CFG