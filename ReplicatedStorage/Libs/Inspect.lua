return {
	GetFromPath = function(p1, p2, p3, p4)
		local v1 = p2;
		for v2, v3 in ipairs(p3) do
			if type(v1) ~= "table" then
				return p4;
			end;
			v1 = v1[v3];
		end;
		if v1 == nil then
			return p4;
		end;
		return v1;
	end, 
	SetAtPath = function(p5, p6, p7, p8)
		local v4 = p6;
		for v5, v6 in ipairs(p7) do
			if v5 < #p7 then
				if v4[v6] == nil then
					v4[v6] = {};
				end;
				v4 = v4[v6];
			else
				v4[v6] = p8;
			end;
		end;
	end
};
