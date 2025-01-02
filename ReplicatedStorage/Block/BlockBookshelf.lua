local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local u1 = require(l__ReplicatedStorage__1.Libs.Class);
return require(l__ReplicatedStorage__1.Libs.Memo)(function(p1)
	local v2 = u1(p1);
	function v2.constructor(p2)
		p2:setBlockTexture("bookshelf");
	end;
	function v2.getTextureForFace(p3, p4)
		if p4 ~= Enum.NormalId.Top and p4 ~= Enum.NormalId.Bottom then
			return p3.blockTexture;
		end;
		return p1.planks.blockTexture;
	end;
	return v2;
end);
