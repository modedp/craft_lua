--[[Parent of this script is WorldRenderer]]
local l__ServerScriptService__1 = game:GetService("ServerScriptService");
local v2 = {};
local v3 = Instance.new("Camera");
v3.FieldOfView = 1;
v3.Focus = CFrame.new();
v3.CFrame = CFrame.new(Vector3.new(1, 0.8165, 1) * 22, v3.Focus.p);
v3.Parent = script;
v2.renderedItems = {};
v2.renderedFirstPersonItems = {};
local u1 = require(game:GetService("ReplicatedStorage").Block);
local u2 = require(game:GetService("Players").LocalPlayer.PlayerScripts.WorldRenderer.BlockRenderer);
function v2.renderItem(p1, p2)
	if v2.renderedItems[p2] then
		return v2.renderedItems[p2]:Clone();
	end;
	local v4 = "flat";
	local v5 = "";
	if u1.blocks[p2] then
		v4 = u1.blocks[p2]:getItemRenderType();
		v5 = u2:getBlockTexture(u1.blocks[p2].blockTexture);
	end;
	local v7 = nil
	if v4 == "block" then
		local v6 = script.BlockView:Clone();
		v6.CurrentCamera = v3;
		u2:renderBlockAsItem(u1.blocks[p2], CFrame.new()).Parent = v6;
		v7 = v6;
	else
		local v8 = script.Flat:Clone();
		v8.Image = v5;
		v7 = v8;
	end;
	v2.renderedItems[p2] = v7;
	return v7:Clone();
end;
function v2.getFirstPersonItemModel(p3, p4)
	if v2.renderedFirstPersonItems[p4] then
		return v2.renderedFirstPersonItems[p4]:Clone();
	end;
	local v9 = "flat";
	local v10 = "";
	if u1.blocks[p4] then
		v9 = u1.blocks[p4]:getItemRenderType();
		v10 = u2:getBlockTexture(u1.blocks[p4].blockTexture);
	end;
	local v11 = nil;
	if v9 == "block" then
		v11 = u2:renderBlockAsItem(u1.blocks[p4], CFrame.new());
	else
		local v12 = CFrame.new() * CFrame.new(0, -0.12, 0) * CFrame.Angles(0, math.rad(50), 0) * CFrame.Angles(0, 0, math.rad(335)) * CFrame.new(-0.5625000000000001, -0.037500000000000006, 0) * CFrame.new(0.30000000000000004, 0.30000000000000004, 0);
		local v13 = script.ItemPlane:Clone();
		v13.Front.CFrame = v12 * (v13.Front.CFrame - v13.Front.CFrame.Position);
		v13.Back.CFrame = v12 * (v13.Back.CFrame - v13.Back.CFrame.Position);
		v13.Front.Mesh.TextureId = v10;
		v13.Back.Mesh.TextureId = v10;
		v11 = v13;
	end;
	v2.renderedFirstPersonItems[p4] = v11;
	return v11:Clone();
end;
return v2;
