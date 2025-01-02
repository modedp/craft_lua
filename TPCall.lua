local u1 = {};
local u2 = {};
local u3 = 0;
local u4 = game:GetService("HttpService"):GenerateGUID():gsub("%W", "");
local l__runner__5 = script.Parent.runner;
local u6 = {};
for v1 = 1, 10 do
	u3 = u3 + 1;
	local v2 = "tpcall:" .. u4 .. ":" .. u3;
	local v3 = l__runner__5:Clone();
	v3.Name = v2;
	local v4 = require(v3);
	v4.id = v2;
	u6[v2] = v4;
	u2[v4] = true;
end;
local u7 = nil;
local u8 = nil;
local u9 = nil;
game:GetService("ScriptContext").Error:Connect(function(p1, p2, p3)
	local v5 = p2:match("(tpcall:" .. u4 .. ":%d+)");
	if v5 then
		local v6, v7 = p2:match("^(.-), line (%d+) %- [^\n]*\n");
		if v6 then
			if p1:sub(1, #v6) == v6 then
				u7 = p1:sub(#v6 + #v7 + 4);
			else
				u7 = p1;
			end;
		else
			u7 = p1:match("^" .. v5 .. ":%d+: (.*)$") and p1;
		end;
		u8 = v5;
		u9 = p2:match("^(.*)\n[^\n]+\n[^\n]+\n$") and "";
		u6[v5].event:Fire();
	end;
end);
local function u10(p4)
	if u1[p4] then
		return u1[p4];
	end;
	local v8 = next(u2);
	if v8 then
		return v8;
	end;
	u3 = u3 + 1;
	local v9 = "tpcall:" .. u4 .. ":" .. u3;
	local v10 = l__runner__5:Clone();
	v10.Name = v9;
	local v11 = require(v10);
	v11.id = v9;
	u6[v9] = v11;
	return v11;
end;
return function(p5, ...)
	local v12 = u10(coroutine.running());
	local l__coroutine__13 = v12.coroutine;
	local v14 = Instance.new("BindableEvent");
	v12.event = v14;
	local u11 = nil;
	local u12 = nil;
	local u13 = nil;
	local u14 = { ... };
	u11 = v14.Event:Connect(function()
		u11:disconnect();
		u12 = coroutine.running();
		v12.coroutine = u12;
		u1[u12] = v12;
		u13 = { v12(p5, unpack(u14)) };
		v14:Fire();
	end);
	u2[v12] = nil;
	v14:Fire();
	local l__id__15 = v12.id;
	if not u13 and u8 ~= l__id__15 then
		v14.Event:Wait();
	end;
	u1[u12] = nil;
	v12.coroutine = l__coroutine__13;
	v12.event = v12.event;
	if not l__coroutine__13 then
		u2[v12] = true;
	end;
	if u8 == l__id__15 then
		u8 = nil;
		return false, u7, u9;
	end;
	return true, unpack(u13);
end;
