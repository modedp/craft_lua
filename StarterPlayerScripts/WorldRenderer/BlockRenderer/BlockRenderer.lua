--[[Parent of this script is WorldRenderer]]
local l__ServerScriptService__1 = game:GetService("ServerScriptService");
local v2 = require(game:GetService("ReplicatedStorage").Block);
local l_Blocks_l = require(game:GetService("ReplicatedStorage").Assets).blocks
local u1 = {
	getBlockTexture = function(p1, p2)
		return "rbxassetid://" .. l_Blocks_l[p2];
	end, 
	renderedCubeCache = {}
};
require(game:GetService("Players").LocalPlayer.PlayerScripts.Options).optionChanged:connect(function(p3)
	if p3 == "fancyGraphics" then
		u1.renderedCubeCache = {};
	end;
end);
local function u2(p4, p5, p6, p7, p8, p9)
	p4.Position = p5;
	local v3 = nil
	if p7:isTransparent() then
		v3 = 0.02;
	else
		v3 = 0;
	end;
	p4.Transparency = v3;
	if p6 then
		p4:Destroy();
		return;
	end;
	if p7:isGlowing() then
		local v4 = Color3.new(1.5, 1.5, 1.5);
		p4.Mesh.VertexColor = Vector3.new(1.5, 1.5, 1.5);
	end;
	p4.Mesh.TextureId = u1:getBlockTexture(p7:getTextureForFace(p8));
	if p9 then
		local v5 = p4:Clone();
		v5.Mesh.Scale = Vector3.new(-1, -1, 1);
		v5.Parent = p4.Parent;
	end;
end;
function u1.renderBlock(p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22)
	local v6 = p15:getRenderType();
	if v6 == "cube" and not p15:isGlowing() then
		local v7 = p10.renderedCubeCache[p22];
		local v8 = nil
		if v7 then
			v8 = v7:Clone();
		else
			v8 = script.MeshCube:Clone();
			local v9 = Vector3.new(0, 0, 0);
			u2(v8.Top, v9, p16, p15, Enum.NormalId.Top);
			u2(v8.Bottom, v9, p17, p15, Enum.NormalId.Bottom);
			u2(v8.Front, v9, p20, p15, Enum.NormalId.Front);
			u2(v8.Back, v9, p21, p15, Enum.NormalId.Back);
			u2(v8.Left, v9, p18, p15, Enum.NormalId.Left);
			u2(v8.Right, v9, p19, p15, Enum.NormalId.Right);
			p10.renderedCubeCache[p22] = v8:Clone();
		end;
		local v10 = Vector3.new(p12 * 4, p13 * 4, p14 * 4);
		for v11, v12 in pairs(v8:GetChildren()) do
			v12.Position = v10;
		end;
		return v8;
	end;
	if v6 == "cube" then
		local v13 = script.Cube:Clone();
		v13.CFrame = CFrame.new(p12 * 4, p13 * 4, p14 * 4);
		local v14 = nil
		if p15:isTransparent() then
			v14 = 1;
		else
			v14 = 0;
		end;
		v13.Transparency = v14;
		if not p16 then
			v13.Top.Texture = u1:getBlockTexture(p15:getTextureForFace(Enum.NormalId.Top));
		else
			v13.Top:Destroy();
		end;
		if not p17 then
			v13.Bottom.Texture = u1:getBlockTexture(p15:getTextureForFace(Enum.NormalId.Bottom));
		else
			v13.Bottom:Destroy();
		end;
		if not p20 then
			v13.Front.Texture = u1:getBlockTexture(p15:getTextureForFace(Enum.NormalId.Front));
		else
			v13.Front:Destroy();
		end;
		if not p21 then
			v13.Back.Texture = u1:getBlockTexture(p15:getTextureForFace(Enum.NormalId.Back));
		else
			v13.Back:Destroy();
		end;
		if not p18 then
			v13.Left.Texture = u1:getBlockTexture(p15:getTextureForFace(Enum.NormalId.Left));
		else
			v13.Left:Destroy();
		end;
		if not p19 then
			v13.Right.Texture = u1:getBlockTexture(p15:getTextureForFace(Enum.NormalId.Right));
		else
			v13.Right:Destroy();
		end;
		if p15:isGlowing() then
			local v15 = Color3.new(2, 2, 2);
			if not p16 then
				v13.Top.Color3 = v15;
			end;
			if not p17 then
				v13.Bottom.Color3 = v15;
			end;
			if not p20 then
				v13.Front.Color3 = v15;
			end;
			if not p21 then
				v13.Back.Color3 = v15;
			end;
			if not p18 then
				v13.Left.Color3 = v15;
			end;
			if not p19 then
				v13.Right.Color3 = v15;
			end;
		end;
		return v13;
	end;
	if v6 == "fluid" then
		local v16 = script.MeshCube:Clone();
		local v17 = Vector3.new(p12 * 4 + 0.01, (p13 - 0.1) * 4, p14 * 4 + 0.01);
		u2(v16.Top, v17, p16, p15, Enum.NormalId.Top, not p15:getLiquidCullBackface(Enum.NormalId.Top, p11:getBlock(p12, p13 + 1, p14)));
		u2(v16.Bottom, v17, p17, p15, Enum.NormalId.Bottom, not p15:getLiquidCullBackface(Enum.NormalId.Bottom, p11:getBlock(p12, p13 - 1, p14)));
		u2(v16.Front, v17, p20, p15, Enum.NormalId.Front, true);
		u2(v16.Back, v17, p21, p15, Enum.NormalId.Back, true);
		u2(v16.Left, v17, p18, p15, Enum.NormalId.Left, true);
		u2(v16.Right, v17, p19, p15, Enum.NormalId.Right, true);
		return v16;
	end;
	if v6 == "fluid" then
		local v18 = script.Cube:Clone();
		v18.CFrame = CFrame.new(p12 * 4 + 0.01, (p13 - 0.1) * 4, p14 * 4 + 0.01);
		local v19 = nil
		if p15:isTransparent() then
			v19 = 1;
		else
			v19 = 0;
		end;
		v18.Transparency = v19;
		if not p16 then
			v18.Top.Texture = u1:getBlockTexture(p15:getTextureForFace(Enum.NormalId.Top));
		else
			v18.Top:Destroy();
		end;
		if not p17 then
			v18.Bottom.Texture = u1:getBlockTexture(p15:getTextureForFace(Enum.NormalId.Bottom));
		else
			v18.Bottom:Destroy();
		end;
		if not p20 then
			v18.Front.Texture = u1:getBlockTexture(p15:getTextureForFace(Enum.NormalId.Front));
		else
			v18.Front:Destroy();
		end;
		if not p21 then
			v18.Back.Texture = u1:getBlockTexture(p15:getTextureForFace(Enum.NormalId.Back));
		else
			v18.Back:Destroy();
		end;
		if not p18 then
			v18.Left.Texture = u1:getBlockTexture(p15:getTextureForFace(Enum.NormalId.Left));
		else
			v18.Left:Destroy();
		end;
		if not p19 then
			v18.Right.Texture = u1:getBlockTexture(p15:getTextureForFace(Enum.NormalId.Right));
		else
			v18.Right:Destroy();
		end;
		if p15:isGlowing() then
			local v20 = Color3.new(1.5, 1.5, 1.5);
			if not p16 then
				v18.Top.Color3 = v20;
			end;
			if not p17 then
				v18.Bottom.Color3 = v20;
			end;
			if not p20 then
				v18.Front.Color3 = v20;
			end;
			if not p21 then
				v18.Back.Color3 = v20;
			end;
			if not p18 then
				v18.Left.Color3 = v20;
			end;
			if not p19 then
				v18.Right.Color3 = v20;
			end;
		end;
		return v18;
	end;
	if v6 ~= "slab" then
		if v6 == "plant" then
			local v21 = script.Cross:Clone();
			v21.Position = Vector3.new(p12 * 4, p13 * 4, p14 * 4);
			v21.TextureID = u1:getBlockTexture(p15.blockTexture);
			return v21;
		else
			return;
		end;
	end;
	local v22 = script.Slab:Clone();
	local v23 = nil
	if p15:isTransparent() then
		v23 = 1;
	else
		v23 = 0;
	end;
	v22.Transparency = v23;
	if p15.isDoubleSlab then
		v22.Position = Vector3.new(p12 * 4, p13 * 4, p14 * 4);
	else
		v22.Position = Vector3.new(p12 * 4, p13 * 4 - 1, p14 * 4);
		v22.Size = Vector3.new(4, 2, 4);
		v22.Front.OffsetStudsV = 2;
		v22.Back.OffsetStudsV = 2;
		v22.Left.OffsetStudsV = 2;
		v22.Right.OffsetStudsV = 2;
	end;
	if not p16 then
		v22.Top.Texture = u1:getBlockTexture(p15:getTextureForFace(Enum.NormalId.Top));
	else
		v22.Top:Destroy();
	end;
	if not p17 then
		v22.Bottom.Texture = u1:getBlockTexture(p15:getTextureForFace(Enum.NormalId.Bottom));
	else
		v22.Bottom:Destroy();
	end;
	if not p20 then
		v22.Front.Texture = u1:getBlockTexture(p15:getTextureForFace(Enum.NormalId.Front));
	else
		v22.Front:Destroy();
	end;
	if not p21 then
		v22.Back.Texture = u1:getBlockTexture(p15:getTextureForFace(Enum.NormalId.Back));
	else
		v22.Back:Destroy();
	end;
	if not p18 then
		v22.Left.Texture = u1:getBlockTexture(p15:getTextureForFace(Enum.NormalId.Left));
	else
		v22.Left:Destroy();
	end;
	if p19 then
		v22.Right:Destroy();
		return v22;
	end;
	v22.Right.Texture = u1:getBlockTexture(p15:getTextureForFace(Enum.NormalId.Right));
	return v22;
end;
function u1.renderBlockAsItem(p23, p24, p25)
	if p24:getRenderType() == "slab" and not p24.isDoubleSlab then
		local v24 = script.ItemSlab:Clone();
		local v25 = nil
		if p24:isTransparent() then
			v25 = 1;
		else
			v25 = 0;
		end;
		v24.Transparency = v25;
		v24.CFrame = p25 * CFrame.new(0, -0.1, 0);
		v24.Top.Texture = u1:getBlockTexture(p24:getTextureForFace(Enum.NormalId.Top));
		v24.Bottom.Texture = u1:getBlockTexture(p24:getTextureForFace(Enum.NormalId.Bottom));
		v24.Front.Texture = u1:getBlockTexture(p24:getTextureForFace(Enum.NormalId.Front));
		v24.Back.Texture = u1:getBlockTexture(p24:getTextureForFace(Enum.NormalId.Back));
		v24.Left.Texture = u1:getBlockTexture(p24:getTextureForFace(Enum.NormalId.Left));
		v24.Right.Texture = u1:getBlockTexture(p24:getTextureForFace(Enum.NormalId.Right));
		return v24;
	end;
	local v26 = script.ItemCube:Clone();
	v26.CFrame = p25;
	local v27 = nil;
	if p24:isTransparent() then
		v27 = 1;
	else
		v27 = 0;
	end;
	v26.Transparency = v27;
	v26.Top.Texture = u1:getBlockTexture(p24:getTextureForFace(Enum.NormalId.Top));
	v26.Bottom.Texture = u1:getBlockTexture(p24:getTextureForFace(Enum.NormalId.Bottom));
	v26.Front.Texture = u1:getBlockTexture(p24:getTextureForFace(Enum.NormalId.Front));
	v26.Back.Texture = u1:getBlockTexture(p24:getTextureForFace(Enum.NormalId.Back));
	v26.Left.Texture = u1:getBlockTexture(p24:getTextureForFace(Enum.NormalId.Left));
	v26.Right.Texture = u1:getBlockTexture(p24:getTextureForFace(Enum.NormalId.Right));
	if p24:isGlowing() then
		local v28 = Color3.new(1, 1, 1);
		v26.Top.Color3 = v28;
		v26.Bottom.Color3 = v28;
		v26.Front.Color3 = v28;
		v26.Back.Color3 = v28;
		v26.Left.Color3 = v28;
		v26.Right.Color3 = v28;
	end;
	return v26;
end;
return u1;
