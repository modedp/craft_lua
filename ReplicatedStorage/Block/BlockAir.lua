local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local v2 = require(l__ReplicatedStorage__1.Libs.AABB);
local u1 = require(l__ReplicatedStorage__1.Libs.Class);
return require(l__ReplicatedStorage__1.Libs.Memo)(function(p1)
	local v3 = u1(p1);
	function v3.constructor(p2)
		p2.boundingBox = nil;
	end;
	function v3.isOpaqueCube(p3)
		return false;
	end;
	function v3.isReplaceable(p4)
		return true;
	end;
	function v3.isFluidReplaceable(p5)
		return true;
	end;
	function v3.isTargetable(p6)
		return false;
	end;
	function v3.isTransparent(p7)
		return true;
	end;
	function v3.isSunlightBlocking(p8)
		return false;
	end;
	function v3.isCollidable(p9)
		return false;
	end;
	return v3;
end);
