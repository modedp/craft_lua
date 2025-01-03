local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__StarterGui__2 = game:GetService("StarterGui");
local l__UserInputService__3 = game:GetService("UserInputService");
local l__TeleportService__4 = game:GetService("TeleportService");
local l__LocalPlayer__5 = game:GetService("Players").LocalPlayer;
local l__PlayerGui__6 = l__LocalPlayer__5.PlayerGui;
local l__PlayerScripts__7 = l__LocalPlayer__5.PlayerScripts;
local v8 = require(l__PlayerScripts__7.WorldLoader);
local v9 = require(l__PlayerScripts__7.FontRenderer);
local v10 = require(l__PlayerScripts__7.Flags);
local v11 = require(script.GuiComponents);
local v12 = {};
for v13, v14 in pairs(l__ReplicatedStorage__1.StarterGui:GetChildren()) do
	v14:Clone().Parent = l__PlayerGui__6;
end;
v12.views = {};
local l__GameGui__1 = l__PlayerGui__6.GameGui;
local u2 = require(l__ReplicatedStorage__1.Libs.SyncEvent);
function v12.registerView(p1, p2, p3)
	p1.views[p2] = p3;
	p3.name = p2;
	p3.gui = l__GameGui__1[p2];
	p3.gui.Visible = false;
	p3.onShown = u2.new();
	p3.onHidden = u2.new();
end;
local u3 = not v10.isUserWorld;
function v12.showServerRules(p4)
	if not u3 then
		return;
	end;
	p4.GenericMessageGui:show("Welcome to the public build server!\n\nPlease note that griefing/vandalism of builds is disallowed.\nYou can submit reports to our moderators in our community server,\nlinked on the Roblox game page under Social Links.", "Got it!");
	u3 = false;
end;
v12.currentView = nil;
function v12.setView(p5, p6)
	local l__isLoading__15 = v12.GuiLoading.isLoading;
	if p6 == "InGame" and l__isLoading__15 then
		p6 = "Loading";
	elseif p6 == "Loading" and not l__isLoading__15 then
		p6 = "InGame";
	end;
	for v19, v20 in pairs(p5.views) do
		local v21 = v20.name == p6;
		if v20.name == "InGame" then
			v20.gui.Visible = v8:isInGame() and v21;
			v20.visible = v8:isInGame() and v21;
		else
			v20.gui.Visible = v21;
			v20.visible = v21;
			if p5.currentView == v20.name then
				v20.onHidden:fire();
			end;
		end;
		if v21 then
			l__UserInputService__3.MouseIconEnabled = v20.showMouse;
			if v20.name == "InGame" then
				l__GameGui__1.ViewBackground.Visible = false;
			else
				l__GameGui__1.ViewBackground.Visible = true;
				local v22 = true;
				if v20.backgroundMode ~= "always" then
					v22 = not v8:isInGame();
				end;
				l__GameGui__1.ViewBackground.PlainBackground.Visible = v22;
			end;
			v20.onShown:fire();
		end;	
	end;
	p5.currentView = p6;
end;
v12.history = {};
function v12.navigateTo(p7, p8)
	v12.history[#v12.history + 1] = v12.currentView;
	v12:setView(p8);
end;
function v12.navigateBack(p9)
	v12:setView((table.remove(v12.history, #v12.history)));
end;
v12.NullGui = require(script.NullGui)(v12);
v12.YesNoGui = require(script.YesNoGui)(v12);
v12.GenericMessageGui = require(script.GenericMessageGui)(v12);
v12.GuiLoading = require(script.LoadingGui)(v12);
v12.DonateGui = require(script.DonateGui)(v12);
v12.InGameGui = require(script.InGameGui)(v12);
v12.MainMenuGui = require(script.MainMenuGui)(v12);
v12.PauseMenuGui = require(script.PauseMenuGui)(v12);
v12.CreditsGui = require(script.CreditsGui)(v12);
v12.MyWorldsGui = require(script.MyWorldsGui)(v12);
v12.WorldInvitesGui = require(script.WorldInvitesGui)(v12);
v12.NewWorldGui = require(script.NewWorldGui)(v12);
v12.OptionsGui = require(script.OptionsGui)(v12);
v12.InviteToWorldGui = require(script.InviteToWorldGui)(v12);
v9:connectAllTextLabelsIn(l__GameGui__1);
v11:applyAllComponents(l__GameGui__1);
l__ReplicatedStorage__1.Remote.Loading.ShowJoinGui.OnClientEvent:Connect(function(p10)
	l__TeleportService__4:SetTeleportSetting("JoinInstantly", p10);
	l__PlayerGui__6.JoinGui.Enabled = true;
end);
spawn(function()
	local v23 = nil
	if v10.shouldJoinInstantly then
		v23 = "InGame";
	else
		v23 = "MainMenu";
	end;
	v12:navigateTo(v23);
	l__TeleportService__4:SetTeleportSetting("JoinInstantly", false);
	if l__PlayerGui__6:FindFirstChild("StartupGui") then
		while l__PlayerGui__6.ChildRemoved:Wait().Name ~= "StartupGui" do
		
		end;
	end;
	v12.MainMenuGui:start();
	l__StarterGui__2:SetCore("TopbarEnabled", false);
end);
return v12;
