local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__PlayerScripts__2 = game:GetService("Players").LocalPlayer.PlayerScripts;
local v3 = {
	x = 0, 
	y = 0, 
	z = 0, 
	blockX = 0, 
	blockY = 0, 
	blockZ = 0, 
	pitch = 0, 
	yaw = 0, 
	fieldOfView = 70, 
	lockToEntity = nil, 
	vignetteBrightness = 1, 
	sneakingOffset = 0, 
	firstPersonEquipProgress = 1, 
	firstPersonSwingProgress = 0, 
	firstPersonItemTargetID = nil, 
	firstPersonItemID = nil, 
	firstPersonItemModel = nil, 
	firstPersonItemCamera = Instance.new("Camera")
};
v3.firstPersonItemCamera.CameraType = "Scriptable";
v3.firstPersonItemTransform = nil;
local u1 = require(l__PlayerScripts__2.Gui);
local u2 = require(l__ReplicatedStorage__1.Block);
local l__RunService__3 = game:GetService("RunService");
function v3.init(p1)
	u1.views.InGame.gui.FirstPersonHand.CurrentCamera = p1.firstPersonItemCamera;
	p1:setFirstPersonItem(u2.stone.blockID);
	p1:update(0);
	l__RunService__3:BindToRenderStep("FirstPersonCamera", Enum.RenderPriority.Camera.Value, function(p2)
		p1:update(p2);
	end);
end;
local function u4(p3, p4, p5, p6, p7, p8, p9)
	return (p6 - p3) * p9 + p3, (p7 - p4) * p9 + p4, (p8 - p5) * p9 + p5;
end;
local function u5(p10, p11, p12)
	return (p11 - p10) * p12 + p10;
end;
local u6 = require(l__PlayerScripts__2.WorldLoader);
local u7 = require(l__PlayerScripts__2.WorldRenderer.BlockRenderer);
local l__Hitbox__8 = script.Hitbox;
function v3.update(p13, p14)
	local v4 = nil;
	if p13.lockToEntity then
		local v5 = nil
		if p13.lockToEntity.isRemote then
			v5 = p13.lockToEntity.lastReplicateTime;
		else
			v5 = p13.lockToEntity.world.lastTickTime;
		end;
		local v6 = math.clamp((tick() - v5) / 0.05, 0, 1);
		local v7, v8, v9 = u4(p13.lockToEntity.prevX, p13.lockToEntity.prevY - p13.lockToEntity.prevYSize, p13.lockToEntity.prevZ, p13.lockToEntity.x, p13.lockToEntity.y - p13.lockToEntity.ySize, p13.lockToEntity.z, v6);
		p13.x = v7;
		p13.y = v8 - p13.lockToEntity.yOffset + p13.lockToEntity.initialYOffset - p13.sneakingOffset;
		local v10 = nil
		if p13.lockToEntity.isSneaking then
			v10 = 0.125;
		else
			v10 = 0;
		end;
		p13.sneakingOffset = u5(p13.sneakingOffset, v10, 0.2);
		p13.firstPersonSwingProgress = u5(p13.lockToEntity.prevSwingProgress, math.max(p13.lockToEntity.prevSwingProgress, p13.lockToEntity.swingProgress), v6);
		p13.z = v9;
		p13.lockToEntity.pitch = p13.pitch;
		p13.lockToEntity.yaw = p13.yaw;
	end;
	p13.blockX = math.floor(p13.x);
	p13.blockY = math.floor(p13.y);
	p13.blockZ = math.floor(p13.z);
	local v11 = CFrame.new(p13.x * 4 - 2, p13.y * 4 - 2, p13.z * 4 - 2) * CFrame.fromEulerAnglesYXZ(-math.rad(p13.pitch), math.pi - math.rad(p13.yaw), 0);
	local v12 = p13:getViewBobbingCFrame();
	workspace.CurrentCamera.CFrame = v11 * v12;
	workspace.CurrentCamera.Focus = workspace.CurrentCamera.CFrame;
	workspace.CurrentCamera.FieldOfView = p13.fieldOfView;
	p13.firstPersonItemCamera.CFrame = (v11 - v11.p) * v12:inverse();
	p13.firstPersonItemCamera.Focus = p13.firstPersonItemCamera.CFrame;
	p13.firstPersonItemCamera.FieldOfView = p13.fieldOfView;
	if p13.firstPersonItemID ~= p13.firstPersonTargetItemID then
		p13.firstPersonEquipProgress = p13.firstPersonEquipProgress - p14 * 6;
		if p13.firstPersonEquipProgress < 0 then
			p13.firstPersonEquipProgress = 0;
			p13:setFirstPersonItem(p13.firstPersonTargetItemID);
		end;
	else
		p13.firstPersonEquipProgress = p13.firstPersonEquipProgress + p14 * 6;
		if p13.firstPersonEquipProgress > 1 then
			p13.firstPersonEquipProgress = 1;
		end;
	end;
	if p13.firstPersonItemTransform then
		p13.firstPersonItemTransform:setTransform(p13:getFirstPersonItemCFrame());
	end;
	local v13 = 1;
	v4 = u1.views.InGame.gui.SuffocateOverlay;
	local l__blockX__14 = p13.blockX;
	local l__blockY__15 = p13.blockY;
	local l__blockZ__16 = p13.blockZ;
	local v17 = u2.blocks[u6.currentWorld:getBlock(l__blockX__14, l__blockY__15, l__blockZ__16)];
	if v17:isOpaqueCube() then
		if v3.lockToEntity then
			v4.Visible = true;
			v4.Image = u7:getBlockTexture(v17.blockTexture);
		end;
		v13 = 0;
	else
		v4.Visible = false;
		if not u6.currentWorld:canBlockSeeSky(l__blockX__14, l__blockY__15, l__blockZ__16) then
			v13 = 0.75;
		end;
	end;
	local l__WaterOverlay__18 = u1.views.InGame.gui.WaterOverlay;
	if v17 == u2.water or v17 == u2.waterMoving then
		workspace.CurrentCamera.FieldOfView = p13.fieldOfView * 0.9;
		p13.firstPersonItemCamera.FieldOfView = p13.fieldOfView * 0.9;
		l__WaterOverlay__18.Visible = true;
		l__WaterOverlay__18.Position = UDim2.new(0, -(p13.yaw / 360 * 2048 % 1024), 0, -((p13.pitch + 90) / 360 * 4096 % 1024));
	else
		l__WaterOverlay__18.Visible = false;
	end;
	p13.vignetteBrightness = u5(p13.vignetteBrightness, math.clamp(1 - v13, 0, 1), 0.01);
	u1.views.InGame.gui.Vignette.ImageTransparency = 1 - p13.vignetteBrightness;
	local v19, v20 = p13:getLookingAtInfo();
	if not v19 then
		l__Hitbox__8.Parent = nil;
		return;
	end;
	local v21 = u2.blocks[v20]:getBoundingBox();
	l__Hitbox__8.Size = Vector3.new(v21.maxX - v21.minX, v21.maxY - v21.minY, v21.maxZ - v21.minZ) * 4;
	l__Hitbox__8.CFrame = CFrame.new((v19 + Vector3.new(v21.minX, v21.minY, v21.minZ)) * 4 - Vector3.new(2, 2, 2) + l__Hitbox__8.Size / 2);
	l__Hitbox__8.Parent = workspace.CurrentCamera;
end;
function v3.getLookVector(p15)
	local v22 = math.rad(p15.yaw);
	local v23 = math.rad(p15.pitch);
	local v24 = math.cos(v23);
	return Vector3.new(-math.sin(v22) * v24, -math.sin(v23), math.cos(v22) * v24);
end;
function v3.addRotation(p16, p17, p18)
	p16.pitch = math.clamp(p16.pitch + p17, -90, 90);
	p16.yaw = p16.yaw + p18;
end;
local u9 = require(l__ReplicatedStorage__1.Raycast);
function v3.getLookingAtInfo(p19)
	local v25, v26, v27, v28 = u9:cast(u6.currentWorld, Vector3.new(v3.x, v3.y, v3.z), v3:getLookVector(), (u6.currentWorld.localPlayerEntity:getReachDistance()));
	return v25, v26, v27, v28;
end;
local u10 = require(l__PlayerScripts__2.Options);
function v3.getViewBobbingCFrame(p20)
	if not u10:getOption("viewBobbing") then
		return CFrame.new();
	end;
	local l__lockToEntity__29 = p20.lockToEntity;
	if not l__lockToEntity__29 then
		return CFrame.new();
	end;
	local v30 = math.clamp((tick() - l__lockToEntity__29.world.lastTickTime) / 0.05, 0, 1);
	local v31 = u5(l__lockToEntity__29.prevRenderDistanceWalked, l__lockToEntity__29.renderDistanceWalked, v30);
	local v32 = u5(l__lockToEntity__29.prevRenderMoveBobbing, l__lockToEntity__29.renderMoveBobbing, v30);
	return CFrame.new(math.sin(v31 * math.pi) * v32 * 0.5, -math.abs(math.cos(v31 * math.pi) * v32), 0) * CFrame.Angles(0, 0, math.rad(math.sin(v31 * math.pi) * v32 * 3) * 0.5) * CFrame.Angles(math.rad(math.abs(math.cos(v31 * math.pi - 0.2) * v32) * 5) * 0.5, 0, 0) * CFrame.Angles(math.rad((u5(l__lockToEntity__29.prevRenderFallBobbing, l__lockToEntity__29.renderFallBobbing, v30))) * 0.5, 0, 0);
end;
function v3.switchFirstPersonItem(p21, p22)
	p21.firstPersonTargetItemID = p22;
end;
local u11 = require(l__PlayerScripts__2.WorldRenderer.ItemRenderer);
local u12 = require(l__ReplicatedStorage__1.Libs.ModelTransform);
function v3.setFirstPersonItem(p23, p24)
	if p23.firstPersonItemModel then
		p23.firstPersonItemModel:Destroy();
		p23.firstPersonItemModel = nil;
	end;
	p23.firstPersonItemID = p24;
	p23.firstPersonTargetItemID = p24;
	if p24 > 0 then
		p23.firstPersonItemModel = u11:getFirstPersonItemModel(p24);
		p23.firstPersonItemModel.Parent = u1.views.InGame.gui.FirstPersonHand;
		p23.firstPersonItemTransform = u12.new(p23.firstPersonItemModel);
		p23.firstPersonItemTransform:setTransform(p23:getFirstPersonItemCFrame());
	end;
end;
function v3.getFirstPersonItemCFrame(p25)
	local l__firstPersonSwingProgress__33 = p25.firstPersonSwingProgress;
	local v34 = math.sin(math.sqrt(l__firstPersonSwingProgress__33) * math.pi);
	return (workspace.CurrentCamera.CFrame - workspace.CurrentCamera.CFrame.Position) * (CFrame.new(-math.sin(math.sqrt(l__firstPersonSwingProgress__33) * math.pi) * 0.4, math.sin(math.sqrt(l__firstPersonSwingProgress__33) * math.pi * 2) * 0.2, -math.sin(l__firstPersonSwingProgress__33 * math.pi) * 0.2) * CFrame.new(0.5599999999999999, -0.52 - (1 - p25.firstPersonEquipProgress) * 0.6, -0.7200000000000001) * CFrame.Angles(0, math.rad(45), 0) * CFrame.Angles(0, math.rad(-math.sin(l__firstPersonSwingProgress__33 ^ 2 * math.pi) * 20), 0) * CFrame.Angles(0, 0, math.rad(-v34 * 20)) * CFrame.Angles(math.rad(-v34 * 80), 0, 0));
end;
return v3;
