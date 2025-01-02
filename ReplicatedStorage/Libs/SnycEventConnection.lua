local v1 = {};
v1.__index = v1;
v1.__type = "SyncEventConnection";
function v1.new(p1, p2)
	local v2 = setmetatable({}, v1);
	v2.connected = true;
	v2.event = p1;
	v2.callback = p2;
	return v2;
end;
function v1.disconnect(p3)
	if not p3.connected then
		return;
	end;
	local l__connections__3 = p3.event.connections;
	local l__callback__4 = p3.callback;
	for v5 = 1, #l__connections__3 do
		if l__connections__3[v5] == l__callback__4 then
			table.remove(l__connections__3, v5);
			p3.connected = false;
			return;
		end;
	end;
	error("Disconnect error; somehow your callback doesn't exist. I'm confused.");
end;
return v1;
