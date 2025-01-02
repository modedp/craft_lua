local u1 = tick(); --[[TickWait]]
local l__Heartbeat__2 = game:GetService("RunService").Heartbeat;
return function()
	if tick() - u1 > 0.05 then
		l__Heartbeat__2:Wait();
		u1 = tick();
	end;
end;
