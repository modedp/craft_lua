--[[Parent of this script is Gui]]
local v1 = {
	componentTypes = {}, 
	applyComponentTo = function(p1, p2, p3)
		if p1.componentTypes[p3] then
			p1.componentTypes[p3]:applyTo(p2);
		end;
	end, 
	applyAllComponents = function(p4, p5)
		local function v2(p6)
			if p6.Name == "UIComponent" and p6:IsA("Configuration") then
				p4:applyComponentTo(p6.Parent, p6.ComponentType.Value);
			end;
		end;
		for v3, v4 in pairs(p5:GetDescendants()) do
			v2(v4);
		end;
	end
};
for v5, v6 in pairs(script:GetChildren()) do
	if v6:IsA("ModuleScript") then
		v1.componentTypes[v6.Name] = require(v6);
	end;
end;
return v1;
