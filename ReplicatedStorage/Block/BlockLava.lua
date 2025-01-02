local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local u1 = require(l__ReplicatedStorage__1.Libs.Class);
return require(l__ReplicatedStorage__1.Libs.Memo)(function(p1)
	local v2 = u1((require(l__ReplicatedStorage__1.Block.BlockFluid)(p1)));
	function v2.getTickInterval(p2)
		if p2.isFlowing then
			return 30;
		end;
		return 0;
	end;
	function v2.isGlowing(p3)
		return true;
	end;
	return v2;
end);
