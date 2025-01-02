return function(p1, p2)
	local v1 = {};
	for v2 = 1, math.ceil(#p1 / p2) do
		v1[v2] = p1:sub((v2 - 1) * p2 + 1, v2 * p2);
	end;
	return v1;
end;
