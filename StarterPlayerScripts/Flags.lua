local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local u2 = {
	shouldJoinInstantly = game:GetService("TeleportService"):GetTeleportSetting("JoinInstantly")
};
local l__LocalPlayer__3 = game:GetService("Players").LocalPlayer;
function u2.initRemoteFlags(p1)
	for v1, v2 in pairs((l__ReplicatedStorage__1.Remote.Flags.GetRemoteFlags:InvokeServer())) do
		u2[v1] = v2;
	end;
	u2.isVipServerOwner = u2.vipServerOwnerId == l__LocalPlayer__3.UserId;
end;
return u2;
