local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local v2 = {};
local u1 = require(l__ReplicatedStorage__1.Libs.TWait);
local u2 = require(l__ReplicatedStorage__1.Libs.RLE);
function v2.encodeBlockData(p1, p2)
	local v3 = {};
	for v4 = 1, p2.height do
		for v5 = 1, p2.size do
			for v6 = 1, p2.size do
				v3[#v3 + 1] = p2.blocks[v5][v6][v4];
			end;
			u1();
		end;
	end;
	local v7 = table.concat(v3, ",") .. ",";
	local v8 = u2:compress(v7);
	if #v8 < #v7 then
		return "1" .. v8;
	end;
	return "0" .. v7;
end;
function v2.decodeBlockData(p3, p4, p5)
	p4 = p4:sub(2);
	if p4:sub(1, 1) == "1" then
		p4 = u2:decompress(p4);
	end;
	local u3 = 1;
	local function v9()
		if #p4 < u3 then
			error("Unexpected eof when decoding block data");
		end;
		local v10 = "";
		while p4:sub(u3, u3) ~= "," do
			v10 = v10 .. p4:sub(u3, u3);
			u3 = u3 + 1;
			if #p4 < u3 then
				error("Unexpected eof when reading number in block data");
			end;		
		end;
		u3 = u3 + 1;
		return tonumber(v10);
	end;
	for v11 = 1, p5.height do
		for v12 = 1, p5.size do
			for v13 = 1, p5.size do
				p5.blocks[v12][v13][v11] = v9();
			end;
			u1();
		end;
	end;
end;
return v2;
