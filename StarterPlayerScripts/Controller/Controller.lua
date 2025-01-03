local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__PlayerScripts__2 = game:GetService("Players").LocalPlayer.PlayerScripts;
local v3 = require(l__ReplicatedStorage__1.Libs.SyncEvent);
local v4 = {};
v4.keyMouseController = require(script.KeyMouseController)(v4);
v4.touchController = require(script.TouchController)(v4);
v4.controllers = { v4.keyMouseController, v4.touchController };
v4.controllersEnabled = false;
local l__UserInputService__1 = game:GetService("UserInputService");
function v4.init(p1)
	p1.keyMouseController:init();
	p1.touchController:init();
	l__UserInputService__1.LastInputTypeChanged:Connect(function(p2)
		if not p1.controllersEnabled then
			return;
		end;
		p1:switchToInputType(p2);
	end);
end;
function v4.switchToController(p3, p4)
	if p4 == p3.currentController then
		return;
	end;
	if p3.currentController then
		p3.currentController.enabled = false;
		p3.currentController:onDisable();
	end;
	p3.currentController = p4;
	if p4 then
		p4.enabled = true;
		p4:onEnable();
	end;
end;
function v4.switchToInputType(p5, p6)
	for v5, v6 in pairs(p5.controllers) do
		if v6:canHandleInputType(p6) then
			p5:switchToController(v6);
			return;
		end;
	end;
end;
function v4.setControllersEnabled(p7, p8)
	if p8 == p7.controllersEnabled then
		return;
	end;
	p7.controllersEnabled = p8;
	if not p8 then
		p7:switchToController(nil);
		return;
	end;
	p7:switchToInputType(l__UserInputService__1:GetLastInputType());
end;
local u2 = require(l__PlayerScripts__2.WorldLoader);
local u3 = require(l__PlayerScripts__2.Camera);
local u4 = 0;
function v4.updatePlayerMovement(p9, p10, p11, p12, p13, p14, p15)
	if not u2:isInGame() then
		return;
	end;
	if not u3.lockToEntity then
		local v7 = 15 * (tick() - u4);
		local v8 = nil
		if p12 then
			v8 = 1;
		else
			v8 = 0;
		end;
		local v9 = nil;
		if p13 then
			v9 = 1;
		else
			v9 = 0;
		end;
		local v10 = v8 - v9;
		local v11 = nil
		if p10 then
			v11 = 1;
		else
			v11 = 0;
		end;
		local v12 = nil
		if p11 then
			v12 = 1;
		else
			v12 = 0;
		end;
		local v13 = v11 - v12;
		local v14 = nil
		if p14 then
			v14 = 1;
		else
			v14 = 0;
		end;
		local v15 = nil
		if p15 then
			v15 = 1;
		else
			v15 = 0;
		end;
		local v16 = math.sin(math.rad(u3.yaw));
		local v17 = math.cos(math.rad(u3.yaw));
		u3.x = u3.x + (v10 * v17 - v13 * v16) * v7;
		u3.z = u3.z + (v13 * v17 + v10 * v16) * v7;
		u3.y = u3.y + (v14 - v15) * v7;
	else
		local v18 = nil
		if p12 then
			v18 = 1;
		else
			v18 = 0;
		end;
		local v19 = nil
		if p13 then
			v19 = 1;
		else
			v19 = 0;
		end;
		local v20 = v18 - v19;
		local v21 = nil
		if p10 then
			v21 = 1;
		else
			v21 = 0;
		end;
		local v22 = nil
		if p11 then
			v22 = 1;
		else
			v22 = 0;
		end;
		local v23 = v21 - v22;
		if p15 then
			v20 = v20 * 0.3;
			v23 = v23 * 0.3;
		end;
		local l__localPlayerEntity__24 = u2.currentWorld.localPlayerEntity;
		l__localPlayerEntity__24.moveStrafing = v20;
		l__localPlayerEntity__24.moveForward = v23;
		l__localPlayerEntity__24.isJumping = p14;
		l__localPlayerEntity__24.isSneaking = p15;
	end;
	u4 = tick();
end;
function v4.updatePlayerRotation(p16, p17, p18)
	if not u2:isInGame() then
		return;
	end;
	u3:addRotation(p17, p18);
end;
function v4.doPlayerAttack(p19)
	if not u2:isInGame() then
		return;
	end;
	spawn(function()
		p19:breakBlock();
	end);
end;
function v4.doPlayerUse(p20)
	if not u2:isInGame() then
		return;
	end;
	spawn(function()
		p20:placeBlock();
	end);
end;
local u5 = require(l__ReplicatedStorage__1.Block);
function v4.placeBlock(p21)
	if not u2:isInGame() then
		return;
	end;
	local v25, v26, v27 = u3:getLookingAtInfo();
	if not v25 then
		return;
	end;
	local v28 = u2.currentWorld.localPlayerEntity:getCurrentEquippedBlock();
	if v28 == u5.air.blockID then
		return;
	end;
	local v29 = v25;
	if v27 and not u5.blocks[v26]:isReplaceable() and (v26 ~= u5.slab.blockID or v28 ~= u5.slab.blockID or v27 ~= Vector3.new(0, 1, 0)) then
		v29 = v29 + v27;
	end;
	local l__x__30 = v29.x;
	local l__y__31 = v29.y;
	local l__z__32 = v29.z;
	if u2.currentWorld:canPlaceBlockAt(l__x__30, l__y__31, l__z__32, v28) then
		u2.currentWorld.localPlayerEntity:swingItem();
		local v33 = false;
		if u2.currentWorld:getBlock(l__x__30, l__y__31, l__z__32) == u5.slab.blockID then
			v33 = v28 == u5.slab.blockID;
		end;
		u2.currentWorld:setBlock(l__x__30, l__y__31, l__z__32, v33 and u5.doubleSlab.blockID or v28);
		local l__breakSound__34 = u5.blocks[v28].breakSound;
		if not l__ReplicatedStorage__1.Remote.World.PlaceBlock:InvokeServer(l__x__30, l__y__31, l__z__32, v28) and u2.currentWorld:getBlock(l__x__30, l__y__31, l__z__32) == v28 then
			u2.currentWorld:setBlock(l__x__30, l__y__31, l__z__32, (l__ReplicatedStorage__1.Remote.World.GetBlock:InvokeServer(l__x__30, l__y__31, l__z__32)));
		end;
	end;
end;
local u6 = require(l__ReplicatedStorage__1.Entity);
function v4.breakBlock(p22)
	if not u2:isInGame() then
		return;
	end;
	u2.currentWorld.localPlayerEntity:swingItem();
	local v35, v36, v37 = u3:getLookingAtInfo();
	if not v35 or not u5.blocks[v36]:isBreakable() then
		return;
	end;
	local l__x__38 = v35.x;
	local l__y__39 = v35.y;
	local l__z__40 = v35.z;
	u6.particleDig.createBlockBreakParticles(u2.currentWorld, l__x__38, l__y__39, l__z__40);
	local l__breakSound__41 = u5.blocks[u2.currentWorld:getBlock(l__x__38, l__y__39, l__z__40)].breakSound;
	u2.currentWorld:setBlock(l__x__38, l__y__39, l__z__40, 0);
	if not l__ReplicatedStorage__1.Remote.World.BreakBlock:InvokeServer(l__x__38, l__y__39, l__z__40) and u2.currentWorld:getBlock(l__x__38, l__y__39, l__z__40) == 0 then
		u2.currentWorld:setBlock(l__x__38, l__y__39, l__z__40, (l__ReplicatedStorage__1.Remote.World.GetBlock:InvokeServer(l__x__38, l__y__39, l__z__40)));
	end;
end;
return v4;
