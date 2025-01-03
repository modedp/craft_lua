local function u1(p1)
	if type(p1) ~= "table" then
		return p1;
	end;
	local v1 = {};
	for v2, v3 in pairs(p1) do
		v1[u1(v2)] = u1(v3);
	end;
	return v1;
end;
return u1;
