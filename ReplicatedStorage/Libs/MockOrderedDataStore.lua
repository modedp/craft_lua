local v1 = {};
v1.__index = v1;
local u1 = require(script.Parent.MockDataStoreUtils);
local u2 = require(script.Parent.MockDataStoreConstants);
local u3 = require(script.Parent.MockDataStoreManager);
local u4 = Random.new();
function v1.OnUpdate(p1, p2, p3)
	p2 = u1.preprocessKey(p2);
	if type(p2) ~= "string" then
		error(("bad argument #1 to 'OnUpdate' (string expected, got %s)"):format(typeof(p2)), 2);
	elseif type(p3) ~= "function" then
		error(("bad argument #2 to 'OnUpdate' (function expected, got %s)"):format(typeof(p3)), 2);
	elseif #p2 == 0 then
		error("bad argument #1 to 'OnUpdate' (key name can't be empty)", 2);
	elseif u2.MAX_LENGTH_KEY < #p2 then
		error(("bad argument #1 to 'OnUpdate' (key name exceeds %d character limit)"):format(u2.MAX_LENGTH_KEY), 2);
	end;
	u1.simulateErrorCheck("OnUpdate");
	if not u3.YieldForBudget(function()
		warn(("OnUpdate request was throttled due to lack of budget. Try sending fewer requests. Key = %s"):format(p2));
	end, { Enum.DataStoreRequestType.OnUpdate }) then
		error("OnUpdate rejected with error (request was throttled, but throttled queue was full)", 2);
	end;
	u1.logMethod(p1, "OnUpdate", p2);
	return p1.__event.Event:Connect(function(p4, p5)
		if p4 == p2 then
			if u2.YIELD_TIME_UPDATE_MAX > 0 then
				wait(u4:NextNumber(u2.YIELD_TIME_UPDATE_MIN, u2.YIELD_TIME_UPDATE_MAX));
			end;
			p3(p5);
		end;
	end);
end;
function v1.GetAsync(p6, p7)
	p7 = u1.preprocessKey(p7);
	if type(p7) ~= "string" then
		error(("bad argument #1 to 'GetAsync' (string expected, got %s)"):format(typeof(p7)), 2);
	elseif #p7 == 0 then
		error("bad argument #1 to 'GetAsync' (key name can't be empty)", 2);
	elseif u2.MAX_LENGTH_KEY < #p7 then
		error(("bad argument #1 to 'GetAsync' (key name exceeds %d character limit)"):format(u2.MAX_LENGTH_KEY), 2);
	end;
	if p6.__getCache[p7] and tick() - p6.__getCache[p7] < u2.GET_COOLDOWN then
		p6.__getCache[p7] = tick();
		return p6.__data[p7];
	end;
	u1.simulateErrorCheck("GetAsync");
	if not u3.YieldForBudget(function()
		warn(("GetAsync request was throttled due to lack of budget. Try sending fewer requests. Key = %s"):format(p7));
	end, { Enum.DataStoreRequestType.GetAsync }) then
		error("GetAsync rejected with error (request was throttled, but throttled queue was full)", 2);
	end;
	u1.simulateYield();
	p6.__getCache[p7] = tick();
	u1.logMethod(p6, "GetAsync", p7);
	return p6.__data[p7];
end;
function v1.IncrementAsync(p8, p9, p10)
	p9 = u1.preprocessKey(p9);
	if type(p9) ~= "string" then
		error(("bad argument #1 to 'IncrementAsync' (string expected, got %s)"):format(typeof(p9)), 2);
	elseif p10 ~= nil and type(p10) ~= "number" then
		error(("bad argument #2 to 'IncrementAsync' (number expected, got %s)"):format(typeof(p10)), 2);
	elseif #p9 == 0 then
		error("bad argument #1 to 'IncrementAsync' (key name can't be empty)", 2);
	elseif u2.MAX_LENGTH_KEY < #p9 then
		error(("bad argument #1 to 'IncrementAsync' (key name exceeds %d character limit)"):format(u2.MAX_LENGTH_KEY), 2);
	end;
	u1.simulateErrorCheck("IncrementAsync");
	local v2 = nil
	if p8.__writeLock[p9] or tick() - (p8.__writeCache[p9] and 0) < u2.WRITE_COOLDOWN then
		v2 = u3.YieldForWriteLockAndBudget(function()
			warn(("IncrementAsync request was throttled, a key can only be written to once every %d seconds. Key = %s"):format(u2.WRITE_COOLDOWN, p9));
		end, p9, p8.__writeLock, p8.__writeCache, { Enum.DataStoreRequestType.SetIncrementSortedAsync });
	else
		p8.__writeLock[p9] = true;
		v2 = u3.YieldForBudget(function()
			warn(("IncrementAsync request was throttled due to lack of budget. Try sending fewer requests. Key = %s"):format(p9));
		end, { Enum.DataStoreRequestType.SetIncrementSortedAsync });
		p8.__writeLock[p9] = nil;
	end;
	if not v2 then
		error("IncrementAsync rejected with error (request was throttled, but throttled queue was full)", 2);
	end;
	local v3 = p8.__data[p9];
	if v3 ~= nil and (type(v3) ~= "number" or v3 % 1 ~= 0) then
		u1.simulateYield();
		error("IncrementAsync rejected with error (cannot increment non-integer value)", 2);
	end;
	p8.__writeLock[p9] = true;
	p10 = p10 and math.floor(p10 + 0.5) or 1;
	if v3 == nil then
		p8.__data[p9] = p10;
		p8.__ref[p9] = {
			Key = p9, 
			Value = p8.__data[p9]
		};
		table.insert(p8.__sorted, p8.__ref[p9]);
		p8.__changed = true;
		p8.__event:Fire(p9, p8.__data[p9]);
	elseif p10 ~= 0 then
		p8.__data[p9] = p8.__data[p9] + p10;
		p8.__ref[p9].Value = p8.__data[p9];
		p8.__changed = true;
		p8.__event:Fire(p9, p8.__data[p9]);
	end;
	local v4 = p8.__data[p9];
	u1.simulateYield();
	p8.__writeLock[p9] = nil;
	p8.__writeCache[p9] = tick();
	p8.__getCache[p9] = tick();
	u1.logMethod(p8, "IncrementAsync", p9, v4, p10);
	return v4;
end;
function v1.RemoveAsync(p11, p12)
	p12 = u1.preprocessKey(p12);
	if type(p12) ~= "string" then
		error(("bad argument #1 to 'RemoveAsync' (string expected, got %s)"):format(type(p12)), 2);
	elseif #p12 == 0 then
		error("bad argument #1 to 'RemoveAsync' (key name can't be empty)", 2);
	elseif u2.MAX_LENGTH_KEY < #p12 then
		error(("bad argument #1 to 'RemoveAsync' (key name exceeds %d character limit)"):format(u2.MAX_LENGTH_KEY), 2);
	end;
	u1.simulateErrorCheck("RemoveAsync");
	local v5 = nil
	if p11.__writeLock[p12] or tick() - (p11.__writeCache[p12] and 0) < u2.WRITE_COOLDOWN then
		v5 = u3.YieldForWriteLockAndBudget(function()
			warn(("RemoveAsync request was throttled, a key can only be written to once every %d seconds. Key = %s"):format(u2.WRITE_COOLDOWN, p12));
		end, p12, p11.__writeLock, p11.__writeCache, { Enum.DataStoreRequestType.SetIncrementSortedAsync });
	else
		p11.__writeLock[p12] = true;
		v5 = u3.YieldForBudget(function()
			warn(("RemoveAsync request was throttled due to lack of budget. Try sending fewer requests. Key = %s"):format(p12));
		end, { Enum.DataStoreRequestType.SetIncrementSortedAsync });
		p11.__writeLock[p12] = nil;
	end;
	if not v5 then
		error("RemoveAsync rejected with error (request was throttled, but throttled queue was full)", 2);
	end;
	p11.__writeLock[p12] = true;
	local v6 = p11.__data[p12];
	if v6 ~= nil then
		p11.__data[p12] = nil;
		p11.__ref[p12] = nil;
		for v7, v8 in pairs(p11.__sorted) do
			if v8.Key == p12 then
				table.remove(p11.__sorted, v7);
				break;
			end;
		end;
		p11.__event:Fire(p12, nil);
	end;
	u1.simulateYield();
	p11.__writeLock[p12] = nil;
	p11.__writeCache[p12] = tick();
	u1.logMethod(p11, "RemoveAsync", p12, v6);
	return v6;
end;
function v1.SetAsync(p13, p14, p15)
	p14 = u1.preprocessKey(p14);
	if type(p14) ~= "string" then
		error(("bad argument #1 to 'SetAsync' (string expected, got %s)"):format(typeof(p14)), 2);
	elseif #p14 == 0 then
		error("bad argument #1 to 'SetAsync' (key name can't be empty)", 2);
	elseif u2.MAX_LENGTH_KEY < #p14 then
		error(("bad argument #1 to 'SetAsync' (key name exceeds %d character limit)"):format(u2.MAX_LENGTH_KEY), 2);
	elseif type(p15) ~= "number" then
		error(("bad argument #2 to 'SetAsync' (number expected, got %s)"):format(typeof(p15)), 2);
	elseif p15 % 1 ~= 0 then
		error("bad argument #2 to 'SetAsync' (cannot store non-integer values in OrderedDataStore)", 2);
	end;
	u1.simulateErrorCheck("SetAsync");
	local v9 = nil
	if p13.__writeLock[p14] or tick() - (p13.__writeCache[p14] and 0) < u2.WRITE_COOLDOWN then
		v9 = u3.YieldForWriteLockAndBudget(function()
			warn(("SetAsync request was throttled, a key can only be written to once every %d seconds. Key = %s"):format(u2.WRITE_COOLDOWN, p14));
		end, p14, p13.__writeLock, p13.__writeCache, { Enum.DataStoreRequestType.SetIncrementSortedAsync });
	else
		p13.__writeLock[p14] = true;
		v9 = u3.YieldForBudget(function()
			warn(("SetAsync request was throttled due to lack of budget. Try sending fewer requests. Key = %s"):format(p14));
		end, { Enum.DataStoreRequestType.SetIncrementSortedAsync });
		p13.__writeLock[p14] = nil;
	end;
	if not v9 then
		error("SetAsync rejected with error (request was throttled, but throttled queue was full)", 2);
	end;
	p13.__writeLock[p14] = true;
	local v10 = p13.__data[p14];
	if v10 == nil then
		p13.__data[p14] = p15;
		p13.__ref[p14] = {
			Key = p14, 
			Value = p15
		};
		table.insert(p13.__sorted, p13.__ref[p14]);
		p13.__changed = true;
		p13.__event:Fire(p14, p13.__data[p14]);
	elseif v10 ~= p15 then
		p13.__data[p14] = p15;
		p13.__ref[p14].Value = p15;
		p13.__changed = true;
		p13.__event:Fire(p14, p13.__data[p14]);
	end;
	u1.simulateYield();
	p13.__writeLock[p14] = nil;
	p13.__writeCache[p14] = tick();
	u1.logMethod(p13, "SetAsync", p14, p13.__data[p14]);
	return p15;
end;
function v1.UpdateAsync(p16, p17, p18)
	p17 = u1.preprocessKey(p17);
	if type(p17) ~= "string" then
		error(("bad argument #1 to 'UpdateAsync' (string expected, got %s)"):format(typeof(p17)), 2);
	elseif type(p18) ~= "function" then
		error(("bad argument #2 to 'UpdateAsync' (function expected, got %s)"):format(typeof(p18)), 2);
	elseif #p17 == 0 then
		error("bad argument #1 to 'UpdateAsync' (key name can't be empty)", 2);
	elseif u2.MAX_LENGTH_KEY < #p17 then
		error(("bad argument #1 to 'UpdateAsync' (key name exceeds %d character limit)"):format(u2.MAX_LENGTH_KEY), 2);
	end;
	u1.simulateErrorCheck("UpdateAsync");
	local v11 = nil
	if p16.__writeLock[p17] or tick() - (p16.__writeCache[p17] and 0) < u2.WRITE_COOLDOWN then
		v11 = u3.YieldForWriteLockAndBudget(function()
			warn(("UpdateAsync request was throttled, a key can only be written to once every %d seconds. Key = %s"):format(u2.WRITE_COOLDOWN, p17));
		end, p17, p16.__writeLock, p16.__writeCache, { Enum.DataStoreRequestType.SetIncrementSortedAsync });
	else
		local v12 = nil
		p16.__writeLock[p17] = true;
		if p16.__getCache[p17] and tick() - p16.__getCache[p17] < u2.GET_COOLDOWN then
			v12 = { Enum.DataStoreRequestType.SetIncrementSortedAsync };
		else
			v12 = { Enum.DataStoreRequestType.GetAsync, Enum.DataStoreRequestType.SetIncrementSortedAsync };
		end;
		v11 = u3.YieldForBudget(function()
			warn(("UpdateAsync request was throttled due to lack of budget. Try sending fewer requests. Key = %s"):format(p17));
		end, v12);
		p16.__writeLock[p17] = nil;
	end;
	if not v11 then
		error("UpdateAsync rejected with error (request was throttled, but throttled queue was full)", 2);
	end;
	local v13 = p18(p16.__data[p17]);
	if v13 == nil then
		u1.simulateYield();
		return nil;
	end;
	if type(v13) ~= "number" or v13 % 1 ~= 0 then
		error("UpdateAsync rejected with error (resulting non-integer value can't be stored in OrderedDataStore)", 2);
	end;
	p16.__writeLock[p17] = true;
	local v14 = p16.__data[p17];
	if v14 == nil then
		p16.__data[p17] = v13;
		p16.__ref[p17] = {
			Key = p17, 
			Value = v13
		};
		table.insert(p16.__sorted, p16.__ref[p17]);
		p16.__changed = true;
		p16.__event:Fire(p17, p16.__data[p17]);
	elseif v14 ~= v13 then
		p16.__data[p17] = v13;
		p16.__ref[p17].Value = v13;
		p16.__changed = true;
		p16.__event:Fire(p17, p16.__data[p17]);
	end;
	u1.simulateYield();
	p16.__writeLock[p17] = nil;
	p16.__writeCache[p17] = tick();
	p16.__getCache[p17] = tick();
	u1.logMethod(p16, "UpdateAsync", p17, v13);
	return v13;
end;
local u5 = require(script.Parent.MockDataStorePages);
function v1.GetSortedAsync(p19, p20, p21, p22, p23)
	if type(p20) ~= "boolean" then
		error(("bad argument #1 to 'GetSortedAsync' (boolean expected, got %s)"):format(typeof(p20)), 2);
	elseif type(p21) ~= "number" then
		error(("bad argument #2 to 'GetSortedAsync' (number expected, got %s)"):format(typeof(p21)), 2);
	end;
	p21 = math.floor(p21 + 0.5);
	if p21 <= 0 or u2.MAX_PAGE_SIZE < p21 then
		error(("bad argument #2 to 'GetSortedAsync' (page size must be an integer above 0 and below or equal to %d)"):format(u2.MAX_PAGE_SIZE), 2);
	end;
	if p22 ~= nil then
		if type(p22) ~= "number" then
			error(("bad argument #3 to 'GetSortedAsync' (number expected, got %s)"):format(typeof(p22)), 2);
		elseif p22 % 1 ~= 0 then
			error("bad argument #3 to 'GetSortedAsync' (minimum threshold must be an integer)", 2);
		end;
	else
		p22 = -math.huge;
	end;
	if p23 ~= nil then
		if type(p23) ~= "number" then
			error(("bad argument #4 to 'GetSortedAsync' (number expected, got %s)"):format(typeof(p23)), 2);
		elseif p23 % 1 ~= 0 then
			error("bad argument #4 to 'GetSortedAsync' (maximum threshold must be an integer)", 2);
		end;
	else
		p23 = math.huge;
	end;
	u1.simulateErrorCheck("GetSortedAsync");
	if not u3.YieldForBudget(function()
		warn("GetSortedAsync request was throttled due to lack of budget. Try sending fewer requests.");
	end, { Enum.DataStoreRequestType.GetSortedAsync }) then
		error("GetSortedAsync rejected with error (request was throttled, but throttled queue was full)", 2);
	end;
	if p23 < p22 then
		u1.simulateYield();
		error("GetSortedAsync rejected with error (minimum threshold is higher than maximum threshold)", 2);
	end;
	if p19.__changed then
		table.sort(p19.__sorted, function(p24, p25)
			return p24.Value < p25.Value;
		end);
		p19.__changed = false;
	end;
	local v15 = {};
	if p20 then
		local v16 = 1;
		while p19.__sorted[v16] and p19.__sorted[v16].Value < p22 do
			v16 = v16 + 1;		
		end;
		while p19.__sorted[v16] and p19.__sorted[v16].Value <= p23 do
			table.insert(v15, {
				key = p19.__sorted[v16].Key, 
				value = p19.__sorted[v16].Value
			});
			v16 = v16 + 1;		
		end;
	else
		local v17 = #p19.__sorted;
		while v17 > 0 and p23 < p19.__sorted[v17].Value do
			v17 = v17 - 1;		
		end;
		while v17 > 0 and p22 <= p19.__sorted[v17].Value do
			table.insert(v15, {
				key = p19.__sorted[v17].Key, 
				value = p19.__sorted[v17].Value
			});
			v17 = v17 - 1;		
		end;
	end;
	u1.simulateYield();
	u1.logMethod(p19, "GetSortedAsync");
	return setmetatable({
		__datastore = p19, 
		__currentPage = 1, 
		__pageSize = p21, 
		__results = v15, 
		IsFinished = #v15 <= p21
	}, u5);
end;
local l__HttpService__6 = game:GetService("HttpService");
function v1.ExportToJSON(p26)
	return l__HttpService__6:JSONEncode(p26.__data);
end;
function v1.ImportFromJSON(p27, p28, p29)
	local v18 = nil;
	if type(p28) == "string" then
		local v19, v20 = pcall(function()
			return l__HttpService__6:JSONDecode(p28);
		end);
		if not v19 then
			error("bad argument #1 to 'ImportFromJSON' (string is not valid json)", 2);
		end;
		v18 = v20;
	elseif type(p28) == "table" then
		v18 = p28;
	else
		error(("bad argument #1 to 'ImportFromJSON' (string or table expected, got %s)"):format(typeof(p28)), 2);
	end;
	if p29 ~= nil and type(p29) ~= "boolean" then
		error(("bad argument #2 to 'ImportFromJSON' (boolean expected, got %s)"):format(typeof(p29)), 2);
	end;
	u1.importPairsFromTable(v18, p27.__data, u3.GetDataInterface(p27.__data), p29 == false and function()

	end or warn, "ImportFromJSON", ("OrderedDataStore > %s > %s"):format(p27.__name, p27.__scope), true);
end;
return v1;
