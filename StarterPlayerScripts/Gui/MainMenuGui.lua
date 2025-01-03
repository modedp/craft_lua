local l__LocalPlayer__1 = game:GetService("Players").LocalPlayer;
local l__PlayerGui__2 = l__LocalPlayer__1.PlayerGui;
local u1 = require(game:GetService("ReplicatedStorage").Block);
local l__TweenService__2 = game:GetService("TweenService");
local u2 = require(game:GetService("ReplicatedStorage").Assets).blocks
local u3 = require(l__LocalPlayer__1.PlayerScripts.WorldLoader);
return function(p1)
	local v3 = {};
	local v4 = Instance.new("Camera");
	v4.FieldOfView = 1;
	v4.Focus = CFrame.new(0, 8, 0);
	v4.CFrame = CFrame.new(Vector3.new(1, 0.8165, 1) * 3000 / v4.FieldOfView, v4.Focus.p);
	v4.Parent = script;
	p1:registerView("MainMenu", {
		showMouse = true
	});
	local l__gui__5 = p1.views.MainMenu.gui;
	l__gui__5.Scene.CurrentCamera = v4;
	l__gui__5.SceneBack.CurrentCamera = v4;
	local u4 = { u1.bookshelf, u1.bricks, u1.goldBlock, u1.ironBlock, u1.diamondBlock, u1.mossStone, u1.planks, u1.doubleSlab, u1.sponge, u1.tnt, u1.aquaWool, u1.orangeWool, u1.limeWool, u1.magentaWool, u1.obsidian, u1.log, u1.sand, u1.gravel, u1.stone, u1.dirt, u1.cobblestone, u1.bedrock };
	local u5 = {};
	local function v6(p2)
		local v7 = table.remove(u4, math.random(#u4));
		for v8, v9 in pairs(l__gui__5.Scene.Logo:GetChildren()) do
			if v9.Name == p2 then
				for v10, v11 in pairs(v9:GetChildren()) do
					v11.Texture = "rbxassetid://" .. u2[v7:getTextureForFace(v11.Face)];
				end;
				local l__CFrame__12 = v9.CFrame;
				v9.CFrame = l__CFrame__12 + Vector3.new(0, 100, 0);
				u5[#u5 + 1] = {
					instance = v9, 
					initialCFrame = v9.CFrame, 
					tween = l__TweenService__2:Create(v9, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0, false, (math.random() + l__CFrame__12.y / 4) * 0.1), {
						CFrame = l__CFrame__12
					})
				};
			end;
		end;
	end;
	v6("Block1");
	v6("Block2");
	v6("Block3");
	v6("Block4");
	local u6 = false;
	function v3.start(p3)
		u6 = true;
		p3:tweenBlocks();
	end;
	function v3.tweenBlocks(p4)
		for v13, v14 in pairs(u5) do
			v14.tween:Cancel();
			v14.instance.CFrame = v14.initialCFrame;
			v14.tween:Play();
		end;
	end;
	l__gui__5.Menu.Play.Activated:Connect(function()
		p1:navigateTo("InGame");
		if p1.currentView == "InGame" then
			p1:showServerRules();
		end;
	end);
	l__gui__5.Menu.MyWorlds.Activated:Connect(function()
		p1:navigateTo("MyWorlds");
	end);
	l__gui__5.Menu.Credits.Activated:Connect(function()
		p1:navigateTo("Credits");
	end);
	l__gui__5.Menu.Options.Activated:Connect(function()
		p1:navigateTo("Options");
	end);
	l__gui__5.Menu.Donate.Activated:Connect(function()
		p1:navigateTo("Donate");
	end);
	p1.views.MainMenu.onShown:connect(function()
		u3.inGame = false;
		if u6 then
			v3:tweenBlocks();
		end;
	end);
	return v3;
end;
