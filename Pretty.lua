local function u1(p1, p2, p3)
	p2 = p2 and 0;
	if p3 == nil then
		p3 = true;
	end;
	local v1 = p3 and ("    "):rep(p2) or "";
	local v2 = p3 and ("    "):rep(p2 + 1) or "";
	local v3 = nil
	if p3 then
		v3 = "\n";
	else
		v3 = "";
	end;
	if typeof(p1) ~= "table" then
		return tostring(p1);
	end;
	local v4 = "{";
	for v5, v6 in pairs(p1) do
		v4 = v4 .. v3 .. v2 .. u1(v5, nil, false) .. " = " .. u1(v6, p2 + 1);
	end;
	return v4 .. v3 .. v1 .. "}";
end;
return function(p4)
	return u1(p4);
end;
