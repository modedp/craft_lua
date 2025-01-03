local v1 = {};
local u1 = require(game:GetService("ReplicatedStorage").Block);
local u2 = require(game:GetService("Players").LocalPlayer.PlayerScripts.WorldRenderer.BlockRenderer);
function v1.createEntityModel(p1, p2, p3)
	local v2 = u1.blocks[p2.blockID];
	local v3 = script.Cube:Clone();
	v3.Name = "FallingBlock";
	for v4, v5 in pairs(v3:GetChildren()) do
		v5.Texture = u2:getBlockTexture(v2:getTextureForFace(v5.Face));
	end;
	v3.Parent = p3;
end;
function v1.updateEntityModel(p4, p5, p6, p7)
	p7.FallingBlock.CFrame = CFrame.new(p6.Position);
end;
function v1.destroyEntityModel(p8, p9, p10)
	p10.FallingBlock:Destroy();
end;
return v1;
