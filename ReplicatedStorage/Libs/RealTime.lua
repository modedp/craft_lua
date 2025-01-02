local l__HttpService__1 = game:GetService("HttpService");
local u2 = {
	Jan = 1, 
	Feb = 2, 
	Mar = 3, 
	Apr = 4, 
	May = 5, 
	Jun = 6, 
	Jul = 7, 
	Aug = 8, 
	Sep = 9, 
	Oct = 10, 
	Nov = 11, 
	Dec = 12
};
local u3 = 0;
local u4 = {};
local function v1()
	local v2, v3 = pcall(l__HttpService__1.RequestAsync, l__HttpService__1, {
		Url = "https://google.com"
	});
	if v2 and v3.Success and v3.Headers.date then
		local v4, v5, v6, v7, v8, v9, v10 = v3.Headers.date:match("%a+, (%d+) (%a+) (%d+) (%d+):(%d+):(%d+) (%a+)");
		if v4 and v5 and v7 and v8 and v9 and v10 then
			local v11, v12 = pcall(os.time, {
				day = v4, 
				month = u2[v5], 
				year = v6, 
				hour = v7, 
				min = v8, 
				sec = v9, 
				tz = v10
			});
			if v11 then
				u3 = v12 - os.time();
				return;
			end;
			if u4.onError then
				spawn(u4.onError);
				return;
			end;
		elseif u4.onError then
			spawn(u4.onError);
			return;
		end;
	elseif u4.onError then
		spawn(u4.onError);
	end;
end;
function u4.now()
	return os.time() + u3;
end;
v1();
delay(30, v1);
return u4;
