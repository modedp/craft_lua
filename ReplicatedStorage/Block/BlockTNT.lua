local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local u1 = require(l__ReplicatedStorage__1.Libs.Class);
return require(l__ReplicatedStorage__1.Libs.Memo)(function(p1)
	local v2 = u1(p1);
	function v2.constructor(p2)
		p2:setBlockTexture("tnt");
	end;
	function v2.getTextureForFace(p3, p4)
		if p4 == Enum.NormalId.Top then
			return "tnt-top";
		end;
		if p4 == Enum.NormalId.Bottom then
			return "tnt-bottom";
		end;
		return p3.blockTexture;
	end;
	return v2;
end);
