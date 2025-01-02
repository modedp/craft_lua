local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local u1 = require(l__ReplicatedStorage__1.Libs.Class);
return require(l__ReplicatedStorage__1.Libs.Memo)(function(p1)
	local v2 = u1(p1);
	function v2.getCullFace(p2, p3, p4)
		return true;
	end;
	function v2.isTargetable(p5)
		return false;
	end;
	function v2.isBreakable(p6)
		return false;
	end;
	return v2;
end);
