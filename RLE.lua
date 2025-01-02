--[[RLE (run-length encoding) Compression]]
local v1 = {};
local function u1(p1, p2)
	p1 = math.floor(p1);
	if not p2 or p2 == 10 then
		return tostring(p1);
	end;
	local v2 = {};
	local v3 = "";
	if p1 < 0 then
		v3 = "-";
		p1 = -p1;
	end;
	while true do
		local v4 = p1 % p2 + 1;
		p1 = math.floor(p1 / p2);
		table.insert(v2, 1, ("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"):sub(v4, v4));
		if p1 == 0 then
			break;
		end;	
	end;
	return v3 .. table.concat(v2, "");
end;
function v1.compress(p3, p4)
	local v5 = nil;
	local v6 = nil;
	v5 = nil;
	local v10 = nil
	local v7 = {};
	for v8 = 1, #p4 do
		local v9 = nil;
		v9 = p4:sub(v8, v8);
		
		if v6 == nil then
			v6 = v9;
			v10 = 1;
		elseif v6 == v9 then
			v10 = v5 + 1;
		else
			table.insert(v7, u1(v5, 36) .. ":" .. v6);
			v6 = v9;
			v10 = 1;
		end;
	end;
	table.insert(v7, v10 .. ":" .. v6);
	return table.concat(v7, "");
end;
function v1.decompress(p5, p6)
	local v11 = 1;
	local v12 = "";
	local v13 = {};
	while v11 < #p6 do
		local v14 = p6:sub(v11, v11);
		if v14 == ":" then
			local v15 = tonumber(v12, 36);
			v12 = "";
			v11 = v11 + 1;
			table.insert(v13, p6:sub(v11, v11):rep(v15));
		else
			v12 = v12 .. v14;
		end;
		v11 = v11 + 1;	
	end;
	return table.concat(v13, "");
end;
function v1.compare(p7, p8, p9)
	print(math.floor(#p9 / #p8 * 100), "% compression");
end;
return v1;
