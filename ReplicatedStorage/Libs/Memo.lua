local function u1(p1, p2)
	if p1 == p2 then
		return true;
	end;
	if #p1 ~= #p2 then
		return false;
	end;
	for v1, v2 in pairs(p1) do
		if p2[v1] ~= v2 then
			return false;
		end;
	end;
	for v3, v4 in pairs(p2) do
		if p1[v3] ~= v4 then
			return false;
		end;
	end;
	return true;
end;
return function(p3)
	local u2 = {};
	local function u3(p4, p5)
		u2[#u2 + 1] = {
			args = p4, 
			ret = p5
		};
	end;
	local function u4(p6)
		for v5, v6 in pairs(u2) do
			if u1(p6, v6.args) then
				return v6.ret;
			end;
		end;
		local v7 = p3(unpack(p6));
		u3(p6, v7);
		return v7;
	end;
	return function(...)
		return u4({ ... });
	end;
end;
