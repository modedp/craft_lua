local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local u1 = require(l__ReplicatedStorage__1.Libs.Class);
local uv = require(l__ReplicatedStorage__1.Assets).skins;
return require(l__ReplicatedStorage__1.Libs.Memo)(function(p1)
	local v2 = require(l__ReplicatedStorage__1.Entity.EntityLiving)(p1);
	local v3 = u1(v2);
	local u2 = { "rbxassetid://" .. uv["skin-man-blue"], "rbxassetid://" .. uv["skin-man-green"], "rbxassetid://" .. uv["skin-man-red"], "rbxassetid://" .. uv["skin-man-yellow"], "rbxassetid://" .. uv["skin-woman-blue"], "rbxassetid://" .. uv["skin-woman-green"], "rbxassetid://" .. uv["skin-woman-red"], "rbxassetid://" .. uv["skin-woman-yellow"],};
	function v3.constructor(p2, p3, p4, p5, p6, p7)
		p2.playerName = p7.Name;
		p2.skinUrl = u2[p7.UserId % #u2 + 1];
		if p7.UserId == game.CreatorId then
			p2.skinUrl =  "rbxassetid://" .. uv["skin-owner-black"]
		end;
		p2.initialYOffset = 1.62;
		p2.yOffset = p2.yOffset;
		p2.currentEquippedBlock = 1;
		p2.isSwinging = false;
		p2.swingProgressInt = 0;
	end;
	function v3.getEyeHeight(p8)
		return 0.12;
	end;
	function v3.getSize(p9)
		return 0.6;
	end;
	function v3.getHeight(p10)
		return 1.8;
	end;
	function v3.getReachDistance(p11)
		return 5;
	end;
	function v3.getCurrentEquippedBlock(p12)
		return p12.currentEquippedBlock;
	end;
	function v3.updatePlayerActionState(p13)
		if p13.isSwinging then
			p13.swingProgressInt = p13.swingProgressInt + 1;
			if p13.swingProgressInt == 0 then
				p13.prevSwingProgress = 0;
				p13.swingProgress = 0;
			end;
			if p13.swingProgressInt > 8 then
				p13.swingProgressInt = 0;
				p13.isSwinging = false;
			end;
		else
			p13.swingProgressInt = 0;
		end;
		p13.swingProgress = p13.swingProgressInt / 8;
	end;
	function v3.swingItem(p14)
		p14.swingProgressInt = -1;
		p14.isSwinging = true;
	end;
	function v3.getRemoteUpdatePayload(p15)
		local v4 = v2.getRemoteUpdatePayload(p15);
		v4.currentEquippedBlock = p15.currentEquippedBlock;
		return v4;
	end;
	function v3.processRemoteUpdatePayload(p16, p17)
		v2.processRemoteUpdatePayload(p16, p17);
		p16.currentEquippedBlock = p17.currentEquippedBlock;
	end;
	return v3;
end);
