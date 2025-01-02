local v1 = {};
v1.__index = v1;
v1.pooledAABBs = {};
function v1.new(p1, p2, p3, p4, p5, p6)
	if p4 < p1 then
		p1 = p4;
		p4 = p1;
	end;
	if p5 < p2 then
		p2 = p5;
		p5 = p2;
	end;
	if p6 < p3 then
		p3 = p6;
		p6 = p3;
	end;
	local v2 = setmetatable({}, v1);
	v2.minX = p1;
	v2.minY = p2;
	v2.minZ = p3;
	v2.maxX = p4;
	v2.maxY = p5;
	v2.maxZ = p6;
	v2.pooled = false;
	return v2;
end;
local function u1(p7, p8, p9, p10, p11, p12)
	return ("%.4f/%.4f/%.4f/%.4f/%.4f/%.4f"):format(p7, p8, p9, p10, p11, p12);
end;
function v1.fromPool(p13, p14, p15, p16, p17, p18)
	local v3 = u1(p13, p14, p15, p16, p17, p18);
	local v4 = v1.pooledAABBs[v3];
	if v4 then
		return v4;
	end;
	local v5 = v1.new(p13, p14, p15, p16, p17, p18);
	v5.pooled = true;
	v1.pooledAABBs[v3] = v5;
	return v5;
end;
function v1.IsEmpty(p19)
	local v6 = true;
	if p19.minX ~= p19.maxX then
		v6 = true;
		if p19.minY ~= p19.maxY then
			v6 = p19.minZ == p19.maxZ;
		end;
	end;
	return v6;
end;
function v1.Translate(p20, p21, p22, p23)
	if p20.pooled then
		return v1.fromPool(p20.minX + p21, p20.minY + p22, p20.minZ + p23, p20.maxX + p21, p20.maxY + p22, p20.maxZ + p23);
	end;
	return v1.new(p20.minX + p21, p20.minY + p22, p20.minZ + p23, p20.maxX + p21, p20.maxY + p22, p20.maxZ + p23);
end;
function v1.Offset(p24, p25, p26, p27)
	if p24.pooled then
		warn("AABB.Offset: trying to mutate a pooled bounding box - ignoring!");
		return;
	end;
	p24.minX = p24.minX + p25;
	p24.maxX = p24.maxX + p25;
	p24.minY = p24.minY + p26;
	p24.maxY = p24.maxY + p26;
	p24.minZ = p24.minZ + p27;
	p24.maxZ = p24.maxZ + p27;
	return p24;
end;
function v1.DirectionalExpand(p28, p29)
	local v7 = p28.minX;
	local v8 = p28.maxX;
	local v9 = p28.minY;
	local v10 = p28.maxY;
	local v11 = p28.minZ;
	local v12 = p28.maxZ;
	if p29.X < 0 then
		v7 = v7 + p29.X;
	elseif p29.X > 0 then
		v8 = v8 + p29.X;
	end;
	if p29.Y < 0 then
		v9 = v9 + p29.Y;
	elseif p29.Y > 0 then
		v10 = v10 + p29.Y;
	end;
	if p29.Z < 0 then
		v11 = v11 + p29.Z;
	elseif p29.Z > 0 then
		v12 = v12 + p29.Z;
	end;
	if p28.pooled then
		return v1.fromPool(v7, v9, v11, v8, v10, v12);
	end;
	return v1.new(v7, v9, v11, v8, v10, v12);
end;
function v1.Scale(p30, p31, p32, p33)
	if p30.pooled then
		return v1.fromPool(p30.minX * p31, p30.minY * p32, p30.minZ * p33, p30.maxX * p31, p30.maxY * p32, p30.maxZ * p33);
	end;
	return v1.new(p30.minX * p31, p30.minY * p32, p30.minZ * p33, p30.maxX * p31, p30.maxY * p32, p30.maxZ * p33);
end;
function v1.UniformScale(p34, p35)
	return p34:Scale(p35, p35, p35);
end;
function v1.Intersection(p36, p37)
	if p36.pooled then
		return v1.fromPool(math.max(p36.minX, p37.minX), math.max(p36.minY, p37.minY), math.max(p36.minZ, p37.minZ), math.min(p36.maxX, p37.maxX), math.min(p36.maxY, p37.maxY), math.min(p36.maxZ, p37.maxZ));
	end;
	return v1.new(math.max(p36.minX, p37.minX), math.max(p36.minY, p37.minY), math.max(p36.minZ, p37.minZ), math.min(p36.maxX, p37.maxX), math.min(p36.maxY, p37.maxY), math.min(p36.maxZ, p37.maxZ));
end;
function v1.Extents(p38, p39)
	if p38.pooled then
		return v1.fromPool(math.min(p38.minX, p39.minX), math.min(p38.minY, p39.minY), math.min(p38.minZ, p39.minZ), math.max(p38.maxX, p39.maxX), math.max(p38.maxY, p39.maxY), math.max(p38.maxZ, p39.maxZ));
	end;
	return v1.new(math.min(p38.minX, p39.minX), math.min(p38.minY, p39.minY), math.min(p38.minZ, p39.minZ), math.max(p38.maxX, p39.maxX), math.max(p38.maxY, p39.maxY), math.max(p38.maxZ, p39.maxZ));
end;
function v1.IntersectsPoint(p40, p41)
	local v13 = false;
	if p40.minX < p41.x then
		v13 = false;
		if p41.x < p40.maxX then
			v13 = false;
			if p40.minY < p41.y then
				v13 = false;
				if p41.y < p40.maxY then
					v13 = false;
					if p40.minZ < p41.z then
						v13 = p41.z < p40.maxZ;
					end;
				end;
			end;
		end;
	end;
	return v13;
end;
function v1.IntersectsRay(p42, p43, p44)
	if p42:IntersectsPoint(p43) then
		return true, p43;
	end;
	p44 = p44.Unit;
	local v14 = 1 / p44;
	local v15 = (p42.minX - p43.x) * v14.x;
	local v16 = (p42.maxX - p43.x) * v14.x;
	local v17 = (p42.minY - p43.y) * v14.y;
	local v18 = (p42.maxY - p43.y) * v14.y;
	local v19 = (p42.minZ - p43.z) * v14.z;
	local v20 = (p42.maxZ - p43.z) * v14.z;
	local v21 = math.max(math.min(v15, v16), math.min(v17, v18), math.min(v19, v20));
	local v22 = math.min(math.max(v15, v16), math.max(v17, v18), math.max(v19, v20));
	if v22 < 0 then
		return false;
	end;
	if v22 < v21 then
		return false;
	end;
	local v23 = Vector3.new(-math.sign(p44.x), 0, 0);
	local v24 = Vector3.new(0, -math.sign(p44.y), 0);
	local v25 = Vector3.new(0, 0, -math.sign(p44.z));
	local v26 = nil
	if v21 == v15 or v21 == v16 then
		v26 = v23;
	elseif v21 == v17 or v21 == v18 then
		v26 = v24;
	else
		v26 = v25;
	end;
	return true, p43 + p44 * v21, v26;
end;
function v1.Intersects(p45, p46)
	if not (p46.maxX <= p45.minX) and not (p45.maxX <= p46.minX) and not (p46.maxY <= p45.minY) and not (p45.maxY <= p46.minY) then
		local v27 = false;
		if p45.minZ < p46.maxZ then
			v27 = p46.minZ < p45.maxZ;
		end;
		return v27;
	end;
	return false;
end;
function v1.Clone(p47)
	return v1.new(p47.minX, p47.minY, p47.minZ, p47.maxX, p47.maxY, p47.maxZ);
end;
function v1.CalculateXOffset(p48, p49, p50)
	if p49.maxY <= p48.minY or p48.maxY <= p49.minY then
		return p50;
	end;
	if p49.maxZ <= p48.minZ or p48.maxZ <= p49.minZ then
		return p50;
	end;
	if p50 > 0 and p49.maxX <= p48.minX then
		local v28 = p48.minX - p49.maxX;
		if v28 < p50 then
			p50 = v28 - 0.0001;
		end;
	end;
	if p50 < 0 and p48.maxX <= p49.minX then
		local v29 = p48.maxX - p49.minX;
		if p50 < v29 then
			p50 = v29 + 0.0001;
		end;
	end;
	return p50;
end;
function v1.CalculateYOffset(p51, p52, p53)
	if p52.maxX <= p51.minX or p51.maxX <= p52.minX then
		return p53;
	end;
	if p52.maxZ <= p51.minZ or p51.maxZ <= p52.minZ then
		return p53;
	end;
	if p53 > 0 and p52.maxY <= p51.minY then
		local v30 = p51.minY - p52.maxY;
		if v30 < p53 then
			p53 = v30 - 0.0001;
		end;
	end;
	if p53 < 0 and p51.maxY <= p52.minY then
		local v31 = p51.maxY - p52.minY;
		if p53 < v31 then
			p53 = v31 + 0.0001;
		end;
	end;
	return p53;
end;
function v1.CalculateZOffset(p54, p55, p56)
	if p55.maxY <= p54.minY or p54.maxY <= p55.minY then
		return p56;
	end;
	if p55.maxX <= p54.minX or p54.maxX <= p55.minX then
		return p56;
	end;
	if p56 > 0 and p55.maxZ <= p54.minZ then
		local v32 = p54.minZ - p55.maxZ;
		if v32 < p56 then
			p56 = v32 - 0.0001;
		end;
	end;
	if p56 < 0 and p54.maxZ <= p55.minZ then
		local v33 = p54.maxZ - p55.minZ;
		if p56 < v33 then
			p56 = v33 + 0.0001;
		end;
	end;
	return p56;
end;
return v1;
