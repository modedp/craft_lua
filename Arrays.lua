local u1 = {}
function u1.new(p1, p2, ...)
	if p2 == nil then
		local v1 = {};
		for v2 = 1, p1 do
			v1[v2] = 0;
		end;
		return v1;
	end;
	local v3 = {};
	for v4 = 1, p1 do
		v3[v4] = u1.new(p2, ...);
	end;
	return v3;
end
function u1.contains(p3, p4)
	for v5, v6 in pairs(p3) do
		if v6 == p4 then
			return true;
		end;
	end;
	return false;
end

return u1;
