--[[Parent of this script is StarterPlayerScripts]]
local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local v2 = require(l__ReplicatedStorage__1.Libs.Listener);
local v3 = require(l__ReplicatedStorage__1.Libs.Class)();
local function v4(p1, p2, p3, p4, p5, p6, p7)
	local v5 = 0;
	if p2 then
		v5 = 1;
	end;
	if p3 then
		v5 = v5 + 2;
	end;
	if p4 then
		v5 = v5 + 4;
	end;
	if p5 then
		v5 = v5 + 8;
	end;
	if p6 then
		v5 = v5 + 16;
	end;
	if p7 then
		v5 = v5 + 32;
	end;
	return v5 + p1 * 64;
end;
local u1 = require(l__ReplicatedStorage__1.Libs.Arrays);
local u2 = require(game:GetService("Players").LocalPlayer.PlayerScripts.Options);
function v3.constructor(p8, p9, p10)
	p8.world = p9;
	p8.model = Instance.new("Model");
	p8.model.Name = "BloxWorld";
	p8.model.Parent = workspace;
	p8.listener = p10;
	p8.chunkMap = {};
	for v6 = 0, math.ceil(p8.world.size / 16) do
		p8.chunkMap[v6] = {};
		for v7 = 0, math.ceil(p8.world.size / 16) do
			p8.chunkMap[v6][v7] = {};
			for v8 = 0, math.ceil(p8.world.height / 16) do
				local v9 = Instance.new("Model");
				v9.Name = ("Chunk%d_%d_%d"):format(v6, v8, v7);
				v9.Parent = nil;
				p8.chunkMap[v6][v7][v8] = v9;
			end;
		end;
	end;
	p8.entityModelMap = {};
	p8.blockCullCache = u1.new(p9.size, p9.size, p9.height);
	p8.currentlyRendering = nil;
	u2.optionChanged:connect(function(p11)
		if p11 == "renderDistance" then
			p8:recalcVisibleChunks(true);
			return;
		end;
		if p11 == "fancyGraphics" then
			spawn(function()
				p8:doFullRender();
			end);
		end;
	end);
end;
function v3.updateBoundsSize(p12)
	local l__world__10 = p12.world;
	local l__size__11 = l__world__10.size;
	local l__height__12 = l__world__10.height;
	local l__Bounds__13 = workspace.Bounds;
	l__Bounds__13.BedrockBase.Size = Vector3.new(l__size__11 * 4, 116, l__size__11 * 4);
	l__Bounds__13.BedrockBase.CFrame = CFrame.new(l__size__11 * 2 + 2, -56, l__size__11 * 2 + 2);
	local function v14(p13, p14)
		local v15 = l__Bounds__13[p13 .. "NegX"];
		v15.Size = Vector3.new(2048, v15.Size.Y, l__size__11 * 4);
		v15.CFrame = CFrame.new(-1022, v15.CFrame.Y, l__size__11 * 2 + 2);
		local v16 = l__Bounds__13[p13 .. "NegZ"];
		v16.Size = Vector3.new(l__size__11 * 4, v16.Size.Y, 2048);
		v16.CFrame = CFrame.new(l__size__11 * 2 + 2, v16.CFrame.Y, -1022);
		local v17 = l__Bounds__13[p13 .. "PosX"];
		v17.Size = Vector3.new(2048, v17.Size.Y, l__size__11 * 4);
		v17.CFrame = CFrame.new(1026 + l__size__11 * 4, v17.CFrame.Y, l__size__11 * 2 + 2);
		local v18 = l__Bounds__13[p13 .. "PosZ"];
		v18.Size = Vector3.new(l__size__11 * 4, v18.Size.Y, 2048);
		v18.CFrame = CFrame.new(l__size__11 * 2 + 2, v18.CFrame.Y, 1026 + l__size__11 * 4);
		l__Bounds__13[p13 .. "NegXPosZ"].CFrame = CFrame.new(-1022, v15.CFrame.Y, 1026 + l__size__11 * 4);
		l__Bounds__13[p13 .. "PosXNegZ"].CFrame = CFrame.new(1026 + l__size__11 * 4, v15.CFrame.Y, -1022);
		l__Bounds__13[p13 .. "PosXZ"].CFrame = CFrame.new(1026 + l__size__11 * 4, v15.CFrame.Y, 1026 + l__size__11 * 4);
	end;
	v14("Bedrock");
	v14("Invisible");
	v14("Water");
end;
local u3 = require(l__ReplicatedStorage__1.Block);
local u4 = require(script.BlockRenderer);
local u5 = v4(0, true, true, true, true, true, true);
local u6 = require(l__ReplicatedStorage__1.Libs.TWait);
function v3.doFullRender(p15)
	if p15.currentlyRendering == nil then
		p15.currentlyRendering = 1;
	else
		p15.currentlyRendering = p15.currentlyRendering + 1;
	end;
	local l__currentlyRendering__19 = p15.currentlyRendering;
	local l__world__20 = p15.world;
	local l__size__21 = l__world__20.size;
	local l__height__22 = l__world__20.height;
	local l__blocks__23 = l__world__20.blocks;
	local l__listener__24 = p15.listener;
	local l__model__25 = p15.model;
	for v26 = 0, math.ceil(l__size__21 / 16) do
		for v27 = 0, math.ceil(l__size__21 / 16) do
			for v28 = 0, math.ceil(l__height__22 / 16) do
				p15.chunkMap[v26][v27][v28]:ClearAllChildren();
			end;
		end;
	end;
	for v29 = 1, l__size__21 do
		local v30 = p15.chunkMap[math.floor((v29 - 1) / 16)];
		for v31 = 1, l__size__21 do
			local v32 = v30[math.floor((v31 - 1) / 16)];
			for v33 = 1, l__height__22 do
				local v34 = l__blocks__23[v29][v31][v33];
				if v34 ~= u3.air.blockID then
					local v35 = v32[math.floor((v33 - 1) / 16)];
					local v36 = u3.blocks[v34];
					local v37 = false;
					if v33 ~= l__height__22 then
						v37 = v36:getCullFace(Enum.NormalId.Top, l__blocks__23[v29][v31][v33 + 1]);
					end;
					local v38 = true;
					if v33 ~= 1 then
						v38 = v36:getCullFace(Enum.NormalId.Bottom, l__blocks__23[v29][v31][v33 - 1]);
					end;
					local v39 = true;
					if v29 ~= 1 then
						v39 = v36:getCullFace(Enum.NormalId.Left, l__blocks__23[v29 - 1][v31][v33]);
					end;
					local v40 = true;
					if v29 ~= l__size__21 then
						v40 = v36:getCullFace(Enum.NormalId.Right, l__blocks__23[v29 + 1][v31][v33]);
					end;
					local v41 = true;
					if v31 ~= 1 then
						v41 = v36:getCullFace(Enum.NormalId.Front, l__blocks__23[v29][v31 - 1][v33]);
					end;
					local v42 = true;
					if v31 ~= l__size__21 then
						v42 = v36:getCullFace(Enum.NormalId.Back, l__blocks__23[v29][v31 + 1][v33]);
					end;
					local v43 = nil
					local v44 = nil
					local v45 = nil
					local v46 = nil
					local v47 = nil
					local v48 = nil
					if v37 then
						v43 = "c";
					else
						v43 = "v";
					end;
					if v38 then
						v44 = "c";
					else
						v44 = "v";
					end;
					if v39 then
						v45 = "c";
					else
						v45 = "v";
					end;
					if v40 then
						v46 = "c";
					else
						v46 = "v";
					end;
					if v41 then
						v47 = "c";
					else
						v47 = "v";
					end;
					if v42 then
						v48 = "c";
					else
						v48 = "v";
					end;
					local v49 = ("%d:%s%s%s%s%s%s"):format(v34, v43, v44, v45, v46, v47, v48);
					p15.blockCullCache[v29][v31][v33] = v49;
					if not v37 or not v38 or not v39 or not v40 or not v41 or not v42 then
						local v50 = u4:renderBlock(l__world__20, v29, v33, v31, v36, v37, v38, v39, v40, v41, v42, v49);
						v50.Name = ("Block%d_%d_%d"):format(v29, v33, v31);
						v50.Parent = v35;
					end;
				else
					p15.blockCullCache[v29][v31][v33] = u5;
				end;
			end;
			l__listener__24:fire("progress", (v31 / l__size__21 + v29) / l__size__21);
			u6();
			if p15.currentlyRendering ~= l__currentlyRendering__19 then
				return;
			end;
		end;
	end;
	p15.currentlyRendering = nil;
end;
function v3.doBlockRender(p16, p17, p18, p19)
	local l__world__51 = p16.world;
	local l__size__52 = l__world__51.size;
	local l__height__53 = l__world__51.height;
	local l__blocks__54 = l__world__51.blocks;
	if p17 >= 1 and p18 >= 1 and p19 >= 1 and p17 <= l__size__52 and p18 <= l__height__53 and p19 <= l__size__52 then
		local v55 = ("Block%d_%d_%d"):format(p17, p18, p19);
		local v56 = l__blocks__54[p17][p19][p18];
		local v57 = p16.chunkMap[math.floor((p17 - 1) / 16)][math.floor((p19 - 1) / 16)][math.floor((p18 - 1) / 16)];
		if v56 ~= u3.air.blockID then
			local v58 = u3.blocks[v56];
			local v59 = false;
			if p18 ~= l__height__53 then
				v59 = v58:getCullFace(Enum.NormalId.Top, l__blocks__54[p17][p19][p18 + 1]);
			end;
			local v60 = true;
			if p18 ~= 1 then
				v60 = v58:getCullFace(Enum.NormalId.Bottom, l__blocks__54[p17][p19][p18 - 1]);
			end;
			local v61 = true;
			if p17 ~= 1 then
				v61 = v58:getCullFace(Enum.NormalId.Left, l__blocks__54[p17 - 1][p19][p18]);
			end;
			local v62 = true;
			if p17 ~= l__size__52 then
				v62 = v58:getCullFace(Enum.NormalId.Right, l__blocks__54[p17 + 1][p19][p18]);
			end;
			local v63 = true;
			if p19 ~= 1 then
				v63 = v58:getCullFace(Enum.NormalId.Front, l__blocks__54[p17][p19 - 1][p18]);
			end;
			local v64 = true;
			if p19 ~= l__size__52 then
				v64 = v58:getCullFace(Enum.NormalId.Back, l__blocks__54[p17][p19 + 1][p18]);
			end;
			local v65 = v4(v56, v59, v60, v61, v62, v63, v64);
			if p16.blockCullCache[p17][p19][p18] ~= v65 then
				p16.blockCullCache[p17][p19][p18] = v65;
				if v57:FindFirstChild(v55) then
					v57[v55]:Destroy();
				end;
				if not v59 or not v60 or not v61 or not v62 or not v63 or not v64 then
					local v66 = u4:renderBlock(l__world__51, p17, p18, p19, v58, v59, v60, v61, v62, v63, v64, v65);
					v66.Name = v55;
					v66.Parent = v57;
					return;
				else
					return;
				end;
			else
				return;
			end;
		else
			if v57:FindFirstChild(v55) then
				v57[v55]:Destroy();
			end;
			p16.blockCullCache[p17][p19][p18] = u5;
			return;
		end;
	end;
end;
function v3.recalcVisibleChunks(p20, p21)
	local l__model__67 = p20.model;
	local l__chunkMap__68 = p20.chunkMap;
	local l__size__69 = p20.world.size;
	local v70 = u2:getOption("renderDistance");
	local u7 = workspace.CurrentCamera.CFrame.Position / 4 + Vector3.new(0.5, 0.5, 0.5);
	local function v71(p22, p23, p24)
		local v72 = u7 / 16 - Vector3.new(p22, p23, p24);
		return (v72 - Vector3.new(math.clamp(v72.X, 0, 1), math.clamp(v72.Y, 0, 1), math.clamp(v72.Z, 0, 1))).Magnitude <= v70;
	end;
	local v73 = nil
	local v74 = nil
	local v75 = nil
	local v76 = nil
	local v77 = nil
	local v78 = nil
	if p21 then
		v73 = 0;
		v74 = 0;
		v75 = 0;
		v76 = math.ceil(l__size__69 / 16);
		v77 = math.ceil(p20.world.height / 16);
		v78 = math.ceil(l__size__69 / 16);
	else
		v73 = math.floor(u7.X / 16 - v70 - 1);
		v76 = math.ceil(u7.X / 16 + v70 + 1);
		v74 = math.floor(u7.Y / 16 - v70 - 1);
		v77 = math.ceil(u7.Y / 16 + v70 + 1);
		v75 = math.floor(u7.Z / 16 - v70 - 1);
		v78 = math.ceil(u7.Z / 16 + v70 + 1);
	end;
	for v79 = v73, v76 do
		local v80 = p20.chunkMap[v79];
		if v80 then
			for v81 = v75, v78 do
				local v82 = v80[v81];
				if v82 then
					for v83 = v74, v77 do
						local v84 = v82[v83];
						if v84 then
							v84.Parent = v71(v79, v83, v81) and l__model__67 or nil;
						end;
					end;
				end;
			end;
		end;
	end;
end;
local u8 = require(script.EntityRenderer);
function v3.startRenderingEntity(p25, p26)
	local v85 = u8:createEntityModel(p26);
	u8:updateEntityModel(p26, v85);
	p25.entityModelMap[p26] = v85;
end;
function v3.stopRenderingEntity(p27, p28)
	local v86 = p27.entityModelMap[p28];
	if not v86 then
		return;
	end;
	p27.entityModelMap[p28] = nil;
	u8:destroyEntityModel(p28, v86);
end;
function v3.renderTick(p29, p30)
	for v87, v88 in pairs(p29.entityModelMap) do
		u8:updateEntityModel(v87, v88);
	end;
end;
return v3;
