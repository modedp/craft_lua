local v1 = {};
local function u1(p1, p2, p3)
	return (p2 - p1) * p3 + p1;
end;
local u2 = require(game:GetService("Players").LocalPlayer.PlayerScripts.FontRenderer);
local function u3(p4, p5, p6, p7)
	local v2 = p4.ticksExisted + p7;
	local v3 = u1(p4.prevSwingProgress, math.max(p4.prevSwingProgress, p4.swingProgress), p7);
	local v4 = 1.62;
	if p4.isSneaking then
		v4 = v4 - 0.1875;
	end;
	local v5 = Vector3.new(0, -1.5, 0);
	local v6 = Vector3.new(-0.25, -1, 0);
	local v7 = Vector3.new(0.25, -1, 0);
	local v8 = Vector3.new(0, -1.5, 0);
	local v9 = Vector3.new(0, -1.5, 0);
	local v10 = Vector3.new(0, 1, 0);
	local v11 = Vector3.new(0, 0, 0);
	local v12 = Vector3.new(0, 0, 0);
	local v13 = Vector3.new(0, 0, 0);
	local v14 = Vector3.new(0, 0, 0);
	local v15 = Vector3.new(0, 0, 0);
	local v16 = Vector3.new(0, 0, 0);
	local v17 = Vector3.new(0, 0, 0);
	local v18 = Vector3.new(-1.25, -0.5, 0);
	local v19 = Vector3.new(1.25, -0.5, 0);
	local v20 = Vector3.new(-0.5, -3, 0);
	local v21 = Vector3.new(0.5, -3, 0);
	local v22 = Vector3.new(0, 0, 0);
	local v23 = Vector3.new(-math.rad((u1(p4.prevPitch, p4.pitch, p7))), -math.rad(u1(p4.prevYaw, p4.yaw, p7) - u1(p4.prevRenderYawOffset, p4.renderYawOffset, p7)), 0);
	local v24 = math.cos((p4.renderWalkTime - p4.renderWalkDepth * (1 - p7)) * 0.6662) * u1(p4.renderLastWalkDepth, p4.renderWalkDepth, p7);
	local v25 = Vector3.new(v24, 0, 0);
	local v26 = Vector3.new(v24 * 1.4, 0, 0);
	local v27 = Vector3.new(-v24 * 1.4, 0, 0);
	local v28 = Vector3.new(-v24, 0, 0) * Vector3.new(1, 0, 1);
	local v29 = v25 * Vector3.new(1, 0, 1);
	if v3 > 0 then
		v11 = Vector3.new(v11.X, math.sin(math.sqrt(v3) * 2 * math.pi) * 0.2, v11.Z);
		v19 = Vector3.new(math.cos(v11.Y) * 1.25, v19.Y, -math.sin(v11.Y) * 1.25);
		v18 = Vector3.new(-math.cos(v11.Y) * 1.25, v18.Y, math.sin(v11.Y) * 1.25);
		local v30 = v28 + Vector3.new(0, v11.Y, 0);
		v29 = v29 + Vector3.new(-v11.Y, v11.Y, 0);
		v28 = Vector3.new(v30.X + (math.sin((1 - (1 - v3) ^ 3) * math.pi) * 1.2 + math.sin(v3 * math.pi) * -(-v23.X - 0.7) * 0.75), v30.Y + v11.Y * 2, math.sin(v3 * math.pi) * 0.4);
	end;
	local v31 = nil
	local v32 = nil
	local v33 = nil
	local v34 = nil	
	if p4.isSneaking then
		v31 = Vector3.new(-0.5, v11.Y, v11.Z);
		v28 = v28 + Vector3.new(-0.4, 0, 0);
		v29 = v29 + Vector3.new(-0.4, 0, 0);
		v32 = Vector3.new(v21.X, -2.25, 1.25);
		v33 = Vector3.new(v20.X, -2.25, 1.25);
		v34 = Vector3.new(v22.X, -0.25, v22.Z);
	else
		v31 = Vector3.new(0, v11.Y, v11.Z);
		v32 = Vector3.new(v21.X, -3, 0);
		v33 = Vector3.new(v20.X, -3, 0);
		v34 = Vector3.new(v22.X, 0, v22.Z);
	end;
	local v35 = Vector3.new(math.cos(v2 * 0.067) * 0.05, 0, math.cos(v2 * 0.09) * 0.05 + 0.05);
	local v36 = v29 - v35;
	local v37 = v28 + v35;
	local v38 = CFrame.fromEulerAnglesYXZ(v31.X, v31.Y, v31.Z);
	local v39 = CFrame.fromEulerAnglesYXZ(v36.X, v36.Y, v36.Z);
	local v40 = CFrame.fromEulerAnglesYXZ(v37.X, v37.Y, v37.Z);
	local v41 = CFrame.fromEulerAnglesYXZ(v27.X, v27.Y, v27.Z);
	local v42 = CFrame.fromEulerAnglesYXZ(v26.X, v26.Y, v26.Z);
	local v43 = CFrame.fromEulerAnglesYXZ(v23.X, v23.Y, v23.Z);
	p6 = p6 * CFrame.new(0, v4 * 4 - 1, 0);
	p5.Torso.CFrame = p6 * (CFrame.new(v17 * 0.9) * v38 * CFrame.new(v5 * 0.9));
	p5.LeftArm.CFrame = p6 * (CFrame.new(v18 * 0.9) * v39 * CFrame.new(v6 * 0.9));
	p5.RightArm.CFrame = p6 * (CFrame.new(v19 * 0.9) * v40 * CFrame.new(v7 * 0.9));
	p5.LeftLeg.CFrame = p6 * (CFrame.new(v33 * 0.9) * v41 * CFrame.new(v8 * 0.9));
	p5.RightLeg.CFrame = p6 * (CFrame.new(v32 * 0.9) * v42 * CFrame.new(v9 * 0.9));
	p5.Head.CFrame = p6 * (CFrame.new(v34 * 0.9) * v43 * CFrame.new(v10 * 0.9));
end;
function v1.createEntityModel(p8, p9, p10)
	local v44 = script.PlayerModel:Clone();
	for v45, v46 in pairs(v44:GetChildren()) do
		if v46:IsA("BasePart") then
			for v47, v48 in pairs(v46:GetChildren()) do
				if v48:IsA("Texture") then
					v48.Texture = p9.skinUrl;
				end;
			end;
		end;
	end;
	v44.Parent = p10;
	local v49 = script.NamePlate:Clone();
	v49.BottomPanel.TextLabel.Text = p9.playerName;
	v49.TopPanel.TextLabel.Text = p9.playerName;
	u2:connectAllTextLabelsIn(v49);
	local v50 = u2:measureText(p9.playerName);
	v49.BottomPanel.Size = UDim2.new((v50.X / v50.Y + 1) * 0.875, 0, 0.875, 0);
	v49.TopPanel.Size = UDim2.new((v50.X / v50.Y + 1) * 0.875, 0, 0.875, 0);
	v49.Parent = v44;
	u3(p9, p10.PlayerModel, CFrame.new(), 0);
end;
function v1.updateEntityModel(p11, p12, p13, p14, p15)
	local l__PlayerModel__51 = p14.PlayerModel;
	u3(p12, p14.PlayerModel, p13, p15);
	if not p12.world or not p12.world.localPlayerEntity or not (p12.world.localPlayerEntity:getDistanceTo(p12.x, p12.y, p12.z) < 48) then
		l__PlayerModel__51.NamePlate.BottomPanel.Enabled = false;
		l__PlayerModel__51.NamePlate.TopPanel.Enabled = false;
		return;
	end;
	local v52 = nil
	if p12.isSneaking then
		v52 = 1.65;
	else
		v52 = 1.8;
	end;
	l__PlayerModel__51.NamePlate.CFrame = p13 + Vector3.new(0, v52 * 4, 0);
	l__PlayerModel__51.NamePlate.BottomPanel.Enabled = true;
	l__PlayerModel__51.NamePlate.TopPanel.Enabled = true;
end;
function v1.destroyEntityModel(p16, p17, p18)
	p18.PlayerModel:Destroy();
end;
return v1;
