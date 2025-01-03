return function(p1)
	local v1 = 0;
	for v2, v3 in pairs(p1) do
		v1 = v1 + 1;
	end;
	return v1;
end;
