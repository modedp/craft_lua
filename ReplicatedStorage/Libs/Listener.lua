local v1 = {};
v1._mt = {
	__index = v1
};
function v1.new()
	local v2 = setmetatable({}, {
		__index = v1
	});
	v2.events = {};
	return v2;
end;
function v1.listen(p1, p2, p3)
	if not p1.events[p2] then
		p1.events[p2] = Instance.new("BindableEvent");
	end;
	p1.events[p2].Event:Connect(p3);
end;
function v1.fire(p4, p5, ...)
	if p4.events[p5] then
		p4.events[p5]:Fire(...);
	end;
end;
return v1;
