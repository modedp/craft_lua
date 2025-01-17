local v1 = {};
v1.__index = v1;
function v1.GetCurrentPage(p1)
	local v2 = {};
	for v3 = math.max(1, (p1.__currentPage - 1) * p1.__pageSize + 1), math.min(p1.__currentPage * p1.__pageSize, #p1.__results) do
		table.insert(v2, p1.__results[v3]);
	end;
	return v2;
end;
local u1 = require(script.Parent.MockDataStoreUtils);
local u2 = require(script.Parent.MockDataStoreManager);
function v1.AdvanceToNextPageAsync(p2)
	if p2.IsFinished then
		error("AdvanceToNextPageAsync rejected with error (no pages to advance to)", 2);
	end;
	u1.simulateErrorCheck("AdvanceToNextPageAsync");
	if not u2.YieldForBudget(function()
		warn("AdvanceToNextPageAsync request was throttled due to lack of budget. Try sending fewer requests.");
	end, { Enum.DataStoreRequestType.GetAsync }) then
		error("AdvanceToNextPageAsync rejected with error (request was throttled, but throttled queue was full)", 2);
	end;
	u1.simulateYield();
	if p2.__currentPage * p2.__pageSize < #p2.__results then
		p2.__currentPage = p2.__currentPage + 1;
	end;
	p2.IsFinished = #p2.__results <= p2.__currentPage * p2.__pageSize;
	u1.logMethod(p2.__datastore, "AdvanceToNextPageAsync");
end;
return v1;
