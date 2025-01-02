return setmetatable({}, {
	__call = function(p1, p2, ...)
		return p2(...);
	end
});
