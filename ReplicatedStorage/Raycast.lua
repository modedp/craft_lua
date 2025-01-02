local v1 = {};
local function u1(p1, p2)
	if p2 < 0 and p1 % 1 == 0 then
		return 0;
	end;
	if p2 > 0 then
		return (math.ceil(p1) - p1) / math.abs(p2);
	end;
	return (p1 - math.floor(p1)) / math.abs(p2);
end;
local function u2(p3, p4, p5)
	if p3 then
		return p4;
	end;
	return p5;
end;
local u3 = require(game:GetService("ReplicatedStorage").Block);
function v1.cast(p6, p7, p8, p9, p10)
	p9 = p9.Unit;
	local v2 = math.floor(p8.x);
	local v3 = math.floor(p8.y);
	local v4 = math.floor(p8.z);
	local l__x__5 = p9.x;
	local l__y__6 = p9.y;
	local l__z__7 = p9.z;
	local v8 = math.sign(l__x__5);
	local v9 = math.sign(l__y__6);
	local v10 = math.sign(l__z__7);
	local v11 = u1(p8.x, l__x__5);
	local v12 = u1(p8.y, l__y__6);
	local v13 = u1(p8.z, l__z__7);
	local v14 = v8 / l__x__5;
	local v15 = v9 / l__y__6;
	local v16 = v10 / l__z__7;
	p10 = p10 / p9.Magnitude;
	local v17 = true;
	if v8 == 0 then
		v17 = true;
		if v9 == 0 then
			v17 = v10 ~= 0;
		end;
	end;
	assert(v17, "Attempt to raycast with zero direction");
	while u2(v8 > 0, v2 <= p7.size + 1, v2 >= 0) and u2(v9 > 0, v3 <= p7.height + 1, v3 >= 0) and u2(v10 > 0, v4 <= p7.size + 1, v4 >= 0) do
		local v18 = p7:getBlock(v2, v3, v4);
		local v19 = u3.blocks[v18];
		local v20 = v19:getBoundingBox();
		if v20 and v19:isTargetable() then
			local v21 = Vector3.new(v2, v3, v4);
			local v22, v23, v24 = v20:IntersectsRay(p8 - v21, p9);
			if v22 then
				return v21, v18, v24, v23 + v21;
			end;
		end;
		local v25 = math.min(v11, v12, v13);
		if v25 == v11 then
			if p10 < v11 then
				return nil, nil, nil, nil;
			end;
			v2 = v2 + v8;
			v11 = v11 + v14;
		elseif v25 == v12 then
			if p10 < v12 then
				return nil, nil, nil, nil;
			end;
			v3 = v3 + v9;
			v12 = v12 + v15;
		else
			if p10 < v13 then
				return nil, nil, nil, nil;
			end;
			v4 = v4 + v10;
			v13 = v13 + v16;
		end;	
	end;
end;
return v1;
