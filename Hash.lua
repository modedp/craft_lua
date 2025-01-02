local function u1(p1)
	return (p1 + 1099511627776) % 2199023255552 - 1099511627776;
end;
local function u2(p2, p3)
	for v1 = 1, p3 do
		p2 = u1(p2 * p2);
	end;
	return p2;
end;
return function(p4)
	local v2 = nil;
	p4 = tostring(p4);
	v2 = 0;
	for v3 = 1, #p4 do
		v2 = u1(v2 + p4:sub(v3, v3):byte() * u2(31, #p4 - (v3 - 1)));
	end;
	return v2;
end;
