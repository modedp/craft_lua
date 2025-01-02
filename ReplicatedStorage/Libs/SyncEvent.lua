local v1 = {};
v1.__index = v1;
v1.__type = "SyncEvent";
function v1.new()
	local v2 = setmetatable({}, v1);
	v2.connections = {};
	return v2;
end;
local u1 = require(script.Parent.SyncEventConnection);
function v1.connect(p1, p2)
	assert(type(p2) == "function", "Connect error; callbacks must be functions");
	local l__connections__3 = p1.connections;
	l__connections__3[#l__connections__3 + 1] = p2;
	return u1.new(p1, p2);
end;
function v1.fire(p3, ...)
	local l__connections__4 = p3.connections;
	for v5 = 1, #l__connections__4 do
		l__connections__4[v5](...);
	end;
end;
return v1;
