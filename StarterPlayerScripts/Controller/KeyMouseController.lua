local l__UserInputService__1 = game:GetService("UserInputService");
local l__RunService__2 = game:GetService("RunService");
local l__UserGameSettings__3 = UserSettings():GetService("UserGameSettings");
return function(p1)
	local v1 = {
		enabled = false, 
		keyBindings = {
			moveForward = Enum.KeyCode.W, 
			moveBack = Enum.KeyCode.S, 
			moveLeft = Enum.KeyCode.A, 
			moveRight = Enum.KeyCode.D, 
			jump = Enum.KeyCode.Space, 
			sneak = Enum.KeyCode.LeftShift, 
			openChat = Enum.KeyCode.Slash, 
			openInventory = Enum.KeyCode.E, 
			openPauseMenu = Enum.KeyCode.Return
		}, 
		activeButtons = {
			moveForward = false, 
			moveBack = false, 
			moveLeft = false, 
			moveRight = false, 
			jump = false, 
			sneak = false
		}, 
		sensitivityVector = Vector2.new(0.36, 0.27), 
		canHandleInputType = function(p2, p3)
			local v2 = true;
			if p3 ~= Enum.UserInputType.Keyboard then
				v2 = true;
				if p3 ~= Enum.UserInputType.MouseButton1 then
					v2 = true;
					if p3 ~= Enum.UserInputType.MouseButton2 then
						v2 = true;
						if p3 ~= Enum.UserInputType.MouseButton3 then
							v2 = true;
							if p3 ~= Enum.UserInputType.MouseMovement then
								v2 = p3 == Enum.UserInputType.MouseWheel;
							end;
						end;
					end;
				end;
			end;
			return v2;
		end
	};
	function v1.onEnable(p4)
		spawn(function()
			while p4.enabled do
				l__UserInputService__1.MouseBehavior = Enum.MouseBehavior.LockCenter;
				p1:updatePlayerMovement(p4.activeButtons.moveForward, p4.activeButtons.moveBack, p4.activeButtons.moveLeft, p4.activeButtons.moveRight, p4.activeButtons.jump, p4.activeButtons.sneak);
				l__RunService__2.RenderStepped:Wait();			
			end;
		end);
	end;
	function v1.onDisable(p5)

	end;
	function v1.init(p6)
		l__UserInputService__1.InputBegan:Connect(function(p7, p8)
			if p8 then
				return;
			end;
			if p7.UserInputType ~= Enum.UserInputType.Keyboard then
				if p7.UserInputType == Enum.UserInputType.MouseButton1 then
					p1:doPlayerAttack();
					return;
				else
					if p7.UserInputType == Enum.UserInputType.MouseButton2 then
						p1:doPlayerUse();
					end;
					return;
				end;
			end;
			for v3, v4 in pairs(p6.activeButtons) do
				if p7.KeyCode == p6.keyBindings[v3] then
					p6.activeButtons[v3] = true;
					return;
				end;
			end;
		end);
		l__UserInputService__1.InputEnded:Connect(function(p9, p10)
			local v5 = nil;
			local v6 = nil;
			local v7 = nil;
			local v8 = nil;
			local v9 = nil;
			local v10 = nil;
			local v11 = nil;
			local v12 = nil;
			local v13 = nil;
			local v18 = nil
			if p10 then
				return;
			end;
			if p9.UserInputType == Enum.UserInputType.Keyboard then
				for v5,_ in pairs(p6.activeButtons) do
					if p9.KeyCode == p6.keyBindings[v5] then
						v6 = p6;
						v7 = "activeButtons";
						v8 = v6;
						v9 = v7;
						v10 = v8[v9];
						v18 = false;
						v11 = v10;
						v12 = v5;
						v13 = v18;
						v11[v12] = v13;
						return;
					end;				
				end;
				return;
			else
				v6 = p6;
				v7 = "activeButtons";
				v8 = v6;
				v9 = v7;
				v10 = v8[v9];
				v18 = false;
				v11 = v10;
				v12 = v5;
				v13 = v18;
				v11[v12] = v13;
				return;
			end;
		end);
		l__UserInputService__1.InputChanged:Connect(function(p11, p12)
			if not p6.enabled then
				return;
			end;
			if p11.UserInputType == Enum.UserInputType.MouseMovement then
				local v19 = Vector2.new(p11.Delta.X, p11.Delta.Y * l__UserGameSettings__3:GetCameraYInvertValue()) * p6.sensitivityVector;
				p1:updatePlayerRotation(v19.Y, v19.X);
			end;
		end);
	end;
	return v1;
end;
