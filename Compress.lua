local v1 = {
	rle = {}
};
local u1 = require(script.Parent.TWait);
v1.rle.encode = function(p1)
	local v2 = nil;
	local v3 = "";
	local v4 = nil;
	local v7 = nil;
	v2 = nil;
	for v5 = 1, #p1 do
		local v6 = p1:sub(v5, v5);
		if v4 == nil then
			v4 = v6;
			v7 = 1;
		elseif v6 == v4 then
			v7 = v2 + 1;
		else
			local v8 = "";
			while v2 > 126 do
				v2 = v2 - 126;
				v8 = v8 .. "\127";			
			end;
			v3 = v3 .. (v8 .. string.char(v2)) .. v4;
			v4 = v6;
			v7 = 1;
		end;
		if v5 % 100 == 1 then
			u1();
		end;
	end;
	if v4 then
		local v9 = "";
		while v7 > 126 do
			v7 = v7 - 126;
			v9 = v9 .. "\127";		
		end;
		v3 = v3 .. (v9 .. string.char(v7)) .. v4;
	end;
	return v3;
end;
v1.rle.decode = function(p2)
	local v10 = "";
	local v11 = "ready";
	local v12 = nil;
	local v13 = nil;
	for v14 = 1, #p2 do
		local v15 = nil;
		v15 = p2:sub(v14, v14);
		if v11 == "ready" then
			if v15 == "\127" then
				v11 = "length";
				v13 = 1;
			else
				v12 = string.byte(v15);
				v11 = "char";
			end;
		elseif v11 == "length" then
			if v15 == "\127" then
				v13 = v13 + 1;
			else
				v12 = string.byte(v15) + v13 * 126;
				v11 = "char";
			end;
		elseif v11 == "char" then
			v10 = v10 .. string.rep(v15, v12);
			v11 = "ready";
		end;
		if v14 % 100 == 1 then
			u1();
		end;
	end;
	return v10;
end;
v1.byte3d = {};
v1.byte3d.encode = function(p3, p4, p5, p6)
	local v16 = nil;
	v16 = "";
	for v17 = 1, p4 do
		for v18 = 1, p5 do
			for v19 = 1, p6 do
				local v20 = p3[v17][v18][v19]; --[[World Compression?]]
				if v20 < 0 or v20 > 127 then
					error("Value out of bounds");
				end;
				v16 = v16 .. string.char(v20);
			end;
			u1();
		end;
		print(v17, p4);
	end;
	return v16;
end;
v1.byte3d.decode = function(p7, p8, p9, p10)
	local v22 = {};
	for v23 = 1, p8 do
		local v24 = {};
		for v25 = 1, p9 do
			local v26 = {};
			for v27 = 1, p10 do
				v26[v27] = string.byte((p7:sub(v27 + v25 * p10 + v23 * p9 * p10)));
			end;
			v24[v25] = v26;
			u1();
		end;
		v22[v23] = v24;
		print(v23, p8);
	end;
	return p7;
end;
return v1;
