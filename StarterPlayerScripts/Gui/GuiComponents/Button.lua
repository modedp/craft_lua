local l__LocalPlayer__1 = game:GetService("Players").LocalPlayer;
local l__PlayerGui__2 = l__LocalPlayer__1.PlayerGui;
local l__PlayerScripts__3 = l__LocalPlayer__1.PlayerScripts;
local v4 = {};
local u1 = require(l__PlayerScripts__3.AudioEngine);
local u2 = require(l__PlayerScripts__3.AudioEngine.Sounds);
function v4.applyTo(p1, p2)
	p2.MouseEnter:Connect(function()
		if p2.ImageRectOffset.X == 0 then
			p2.ImageRectOffset = Vector2.new(10, 0);
		end;
	end);
	p2.MouseLeave:Connect(function()
		if p2.ImageRectOffset.X == 10 then
			p2.ImageRectOffset = Vector2.new(0, 0);
		end;
	end);
	local function u3()
		if not p2.UIComponent:FindFirstChild("IsSilent") then
			return false;
		end;
		return p2.UIComponent.IsSilent.Value;
	end;
	p2.Activated:Connect(function()
		if p2.ImageRectOffset.X == 20 then
			return;
		end;
		if u3() then
			return;
		end;
		u1:playGlobalSound(u2.misc.click, "Sound");
	end);
end;
return v4;
