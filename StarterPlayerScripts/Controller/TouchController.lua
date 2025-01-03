local l__RunService__1 = game:GetService("RunService");
local u2 = require(game:GetService("Players").LocalPlayer.PlayerScripts.Gui);
local l__UserInputService__3 = game:GetService("UserInputService");
local l__TweenService__4 = game:GetService("TweenService");
local l__UserGameSettings__5 = UserSettings():GetService("UserGameSettings");
return function(p1)
	local v1 = {
		enabled = false, 
		sensitivityVector = Vector2.new(0.81, 0.6075), 
		deadzoneSize = 10, 
		activeButtons = {
			moveForward = false, 
			moveBack = false, 
			moveLeft = false, 
			moveRight = false, 
			jump = false, 
			sneak = false
		}, 
		canHandleInputType = function(p2, p3)
			return p3 == Enum.UserInputType.Touch;
		end
	};
	function v1.onEnable(p4)
		p4.touchGui.Visible = true;
		spawn(function()
			while p4.enabled do
				p1:updatePlayerMovement(p4.activeButtons.moveForward, p4.activeButtons.moveBack, p4.activeButtons.moveLeft, p4.activeButtons.moveRight, p4.activeButtons.jump, p4.activeButtons.sneak);
				l__RunService__1.RenderStepped:Wait();			
			end;
		end);
	end;
	function v1.onDisable(p5)
		p5.touchGui.Visible = false;
	end;
	function v1.init(p6)
		p6.touchGui = u2.views.InGame.gui.TouchGui;
		local function v2(p7, p8)
			p7.InputBegan:Connect(function(p9)
				if p9.UserInputType == Enum.UserInputType.Touch then
					p6.activeButtons[p8] = true;
				end;
			end);
			p7.InputEnded:Connect(function(p10)
				if p10.UserInputType == Enum.UserInputType.Touch then
					p6.activeButtons[p8] = false;
				end;
			end);
		end;
		v2(p6.touchGui.Controls.MoveForward, "moveForward");
		v2(p6.touchGui.Controls.MoveBack, "moveBack");
		v2(p6.touchGui.Controls.MoveLeft, "moveLeft");
		v2(p6.touchGui.Controls.MoveRight, "moveRight");
		v2(p6.touchGui.Controls.Jump, "jump");
		v2(p6.touchGui.Controls.Sneak, "sneak");
		local u6 = false;
		l__UserInputService__3.TouchStarted:Connect(function(p11, p12)
			if p12 then
				return;
			end;
			local v3 = Vector2.new(p11.Position.X, p11.Position.Y);
			local v4 = tick();
			local v5 = script.TouchDragTarget:Clone();
			v5.Position = UDim2.new(0, v3.X, 0, v3.Y + 36);
			v5.Parent = p6.touchGui.Targets;
			l__TweenService__4:Create(v5, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
				ImageTransparency = 0
			}):Play();
			l__TweenService__4:Create(v5.TargetFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
				ImageTransparency = 0
			}):Play();
			local u7 = true;
			local u8 = false;
			local u9 = false;
			spawn(function()
				local v6 = 0;
				while u7 and not u8 and not u9 do
					v6 = v6 + l__RunService__1.RenderStepped:Wait();
					if v6 > 0.5 then
						break;
					end;
					v5.TargetFill.UIScale.Scale = v6 / 0.5;				
				end;
				if not u7 or not (not u8) or u9 then
					return;
				end;
				v5.TargetFill.UIScale.Scale = 1;
				l__TweenService__4:Create(v5.TargetFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
					ImageTransparency = 1
				}):Play();
				if u7 and not u8 and not u9 then
					u9 = true;
					p1:doPlayerAttack();
				end;
			end);
			local u10 = l__UserInputService__3.TouchMoved:Connect(function(p13)
				if p11 ~= p13 then
					return;
				end;
				local v7 = Vector2.new(p11.Position.X, p11.Position.Y);
				if not u8 and not u6 and p6.deadzoneSize < (v7 - v3).Magnitude then
					u8 = true;
					u6 = true;
					l__TweenService__4:Create(v5.TargetFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
						ImageTransparency = 1
					}):Play();
				end;
				if u8 then
					local v8 = Vector2.new(p11.Delta.X, p11.Delta.Y * l__UserGameSettings__5:GetCameraYInvertValue()) * p6.sensitivityVector;
					p1:updatePlayerRotation(v8.Y, v8.X);
				end;
				v5.Position = UDim2.new(0, v7.X, 0, v7.Y + 36);
			end);
			local u11 = nil;
			u11 = l__UserInputService__3.TouchEnded:Connect(function(p14)
				if p11 ~= p14 then
					return;
				end;
				u7 = false;
				if not u8 and not u9 then
					p1:doPlayerUse();
				end;
				if u8 then
					u6 = false;
				end;
				l__TweenService__4:Create(v5, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
					ImageTransparency = 1
				}):Play();
				l__TweenService__4:Create(v5.TargetFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
					ImageTransparency = 1
				}):Play();
				delay(0.1, function()
					v5:Destroy();
				end);
				u10:Disconnect();
				u11:Disconnect();
			end);
		end);
	end;
	return v1;
end;
