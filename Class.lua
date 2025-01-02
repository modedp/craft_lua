return function(p1)
	local v1 = nil;
	local v2 = {};
	if p1 then
		setmetatable(v2, {
			__index = p1
		});
	end;
	local v3 = {
		__index = v2
	};
	v1 = {};
	function v2.constructor(p2)

	end;
	if p1 then
		function v2.new(...)
			local v4 = setmetatable(p1.new(...), v3);
			v4[v1] = true;
			v4:constructor(...);
			return v4;
		end;
	else
		function v2.new(...)
			local v5 = setmetatable({}, v3);
			v5[v1] = true;
			v5:constructor(...);
			return v5;
		end;
	end;
	function v2.objectIsSelf(p3)
		local v6 = false;
		if type(p3) == "table" then
			v6 = p3[v1];
		end;
		return v6;
	end;
	function v2.isA(p4, p5)
		return p5 and p5.objectIsSelf(p4);
	end;
	return v2;
end;
