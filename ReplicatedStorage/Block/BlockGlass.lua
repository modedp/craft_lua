local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local v2 = require(l__ReplicatedStorage__1.Entity);
local u1 = require(l__ReplicatedStorage__1.Libs.Class);
return require(l__ReplicatedStorage__1.Libs.Memo)(function(p1)
	local v3 = u1(p1);
	function v3.isOpaqueCube(p2)
		return false;
	end;
	function v3.isTransparent(p3)
		return true;
	end;
	function v3.isSunlightBlocking(p4)
		return false;
	end;
	return v3;
end);
