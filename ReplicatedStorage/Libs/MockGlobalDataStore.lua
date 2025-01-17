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
		return u1.deepcopy(p6.__data[p7]);
	end;
	u1.simulateErrorCheck("GetAsync");
	if not u3.YieldForBudget(function()
		warn(("GetAsync request was throttled due to lack of budget. Try sending fewer requests. Key = %s"):format(p7));
	end, { Enum.DataStoreRequestType.GetAsync }) then
		error("GetAsync rejected with error (request was throttled, but throttled queue was full)", 2);
	end;
	p6.__getCache[p7] = tick();
	local v2 = u1.deepcopy(p6.__data[p7]);
	u1.simulateYield();
	u1.logMethod(p6, "GetAsync", p7);
	return v2;
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
	local v3 = nil
	if p8.__writeLock[p9] or tick() - (p8.__writeCache[p9] and 0) < u2.WRITE_COOLDOWN then
		v3 = u3.YieldForWriteLockAndBudget(function()
			warn(("IncrementAsync request was throttled, a key can only be written to once every %d seconds. Key = %s"):format(u2.WRITE_COOLDOWN, p9));
		end, p9, p8.__writeLock, p8.__writeCache, { Enum.DataStoreRequestType.SetIncrementAsync });
	else
		p8.__writeLock[p9] = true;
		v3 = u3.YieldForBudget(function()
			warn(("IncrementAsync request was throttled due to lack of budget. Try sending fewer requests. Key = %s"):format(p9));
		end, { Enum.DataStoreRequestType.SetIncrementAsync });
		p8.__writeLock[p9] = nil;
	end;
	if not v3 then
		error("IncrementAsync rejected with error (request was throttled, but throttled queue was full)", 2);
	end;
	local v4 = p8.__data[p9];
	if v4 ~= nil and (type(v4) ~= "number" or v4 % 1 ~= 0) then
		u1.simulateYield();
		error("IncrementAsync rejected with error (cannot increment non-integer value)", 2);
	end;
	p8.__writeLock[p9] = true;
	p10 = p10 and math.floor(p10 + 0.5) or 1;
	p8.__data[p9] = (v4 and 0) + p10;
	if v4 == nil or p10 ~= 0 then
		p8.__event:Fire(p9, p8.__data[p9]);
	end;
	local v5 = p8.__data[p9];
	u1.simulateYield();
	p8.__writeLock[p9] = nil;
	p8.__writeCache[p9] = tick();
	p8.__getCache[p9] = tick();
	u1.logMethod(p8, "IncrementAsync", p9, v5, p10);
	return v5;
end;
function v1.RemoveAsync(p11, p12)
	p12 = u1.preprocessKey(p12);
	if type(p12) ~= "string" then
		error(("bad argument #1 to 'RemoveAsync' (string expected, got %s)"):format(typeof(p12)), 2);
	elseif #p12 == 0 then
		error("bad argument #1 to 'RemoveAsync' (key name can't be empty)", 2);
	elseif u2.MAX_LENGTH_KEY < #p12 then
		error(("bad argument #1 to 'RemoveAsync' (key name exceeds %d character limit)"):format(u2.MAX_LENGTH_KEY), 2);
	end;
	u1.simulateErrorCheck("RemoveAsync");
	local v6 = nil
	if p11.__writeLock[p12] or tick() - (p11.__writeCache[p12] and 0) < u2.WRITE_COOLDOWN then
		v6 = u3.YieldForWriteLockAndBudget(function()
			warn(("RemoveAsync request was throttled, a key can only be written to once every %d seconds. Key = %s"):format(u2.WRITE_COOLDOWN, p12));
		end, p12, p11.__writeLock, p11.__writeCache, { Enum.DataStoreRequestType.SetIncrementAsync });
	else
		p11.__writeLock[p12] = true;
		v6 = u3.YieldForBudget(function()
			warn(("RemoveAsync request was throttled due to lack of budget. Try sending fewer requests. Key = %s"):format(p12));
		end, { Enum.DataStoreRequestType.SetIncrementAsync });
		p11.__writeLock[p12] = nil;
	end;
	if not v6 then
		error("RemoveAsync rejected with error (request was throttled, but throttled queue was full)", 2);
	end;
	p11.__writeLock[p12] = true;
	local v7 = u1.deepcopy(p11.__data[p12]);
	p11.__data[p12] = nil;
	if v7 ~= nil then
		p11.__event:Fire(p12, nil);
	end;
	u1.simulateYield();
	p11.__writeLock[p12] = nil;
	p11.__writeCache[p12] = tick();
	u1.logMethod(p11, "RemoveAsync", p12, v7);
	return v7;
end;
local l__HttpService__5 = game:GetService("HttpService");
function v1.SetAsync(p13, p14, p15)
	p14 = u1.preprocessKey(p14);
	if type(p14) ~= "string" then
		error(("bad argument #1 to 'SetAsync' (string expected, got %s)"):format(typeof(p14)), 2);
	elseif #p14 == 0 then
		error("bad argument #1 to 'SetAsync' (key name can't be empty)", 2);
	elseif u2.MAX_LENGTH_KEY < #p14 then
		error(("bad argument #1 to 'SetAsync' (key name exceeds %d character limit)"):format(u2.MAX_LENGTH_KEY), 2);
	elseif p15 == nil or type(p15) == "function" or type(p15) == "userdata" or type(p15) == "thread" then
		error(("bad argument #2 to 'SetAsync' (cannot store value '%s' of type %s)"):format(tostring(p15), typeof(p15)), 2);
	end;
	if type(p15) == "table" then
		local v8, v9, v10 = u1.scanValidity(p15);
		if not v8 then
			error(("bad argument #2 to 'SetAsync' (table has invalid entry at <%s>: %s)"):format(u1.getStringPath(v9), v10), 2);
		end;
		local v11, v12 = pcall(function()
			return l__HttpService__5:JSONEncode(p15);
		end);
		if not v11 then
			error("bad argument #2 to 'SetAsync' (table could not be encoded to json)", 2);
		elseif u2.MAX_LENGTH_DATA < #v12 then
			error(("bad argument #2 to 'SetAsync' (encoded data length exceeds %d character limit)"):format(u2.MAX_LENGTH_DATA), 2);
		end;
	elseif type(p15) == "string" then
		if u2.MAX_LENGTH_DATA < #p15 then
			error(("bad argument #2 to 'SetAsync' (data length exceeds %d character limit)"):format(u2.MAX_LENGTH_DATA), 2);
		elseif not utf8.len(p15) then
			error("bad argument #2 to 'SetAsync' (string value is not valid UTF-8)", 2);
		end;
	end;
	u1.simulateErrorCheck("SetAsync");
	local v13 = nil
	if p13.__writeLock[p14] or tick() - (p13.__writeCache[p14] and 0) < u2.WRITE_COOLDOWN then
		v13 = u3.YieldForWriteLockAndBudget(function()
			warn(("SetAsync request was throttled, a key can only be written to once every %d seconds. Key = %s"):format(u2.WRITE_COOLDOWN, p14));
		end, p14, p13.__writeLock, p13.__writeCache, { Enum.DataStoreRequestType.SetIncrementAsync });
	else
		p13.__writeLock[p14] = true;
		v13 = u3.YieldForBudget(function()
			warn(("SetAsync request was throttled due to lack of budget. Try sending fewer requests. Key = %s"):format(p14));
		end, { Enum.DataStoreRequestType.SetIncrementAsync });
		p13.__writeLock[p14] = nil;
	end;
	if not v13 then
		error("SetAsync rejected with error (request was throttled, but throttled queue was full)", 2);
	end;
	p13.__writeLock[p14] = true;
	if type(p15) == "table" or p15 ~= p13.__data[p14] then
		p13.__data[p14] = u1.deepcopy(p15);
		p13.__event:Fire(p14, p13.__data[p14]);
	end;
	u1.simulateYield();
	p13.__writeLock[p14] = nil;
	p13.__writeCache[p14] = tick();
	u1.logMethod(p13, "SetAsync", p14, p13.__data[p14]);
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
	local v14 = nil
	if p16.__writeLock[p17] or tick() - (p16.__writeCache[p17] and 0) < u2.WRITE_COOLDOWN then
		v14 = u3.YieldForWriteLockAndBudget(function()
			warn(("UpdateAsync request was throttled, a key can only be written to once every %d seconds. Key = %s"):format(u2.WRITE_COOLDOWN, p17));
		end, p17, p16.__writeLock, p16.__writeCache, { Enum.DataStoreRequestType.SetIncrementAsync });
	else
		p16.__writeLock[p17] = true;
		local v15 = nil
		if p16.__getCache[p17] and tick() - p16.__getCache[p17] < u2.GET_COOLDOWN then
			v15 = { Enum.DataStoreRequestType.SetIncrementAsync };
		else
			v15 = { Enum.DataStoreRequestType.GetAsync, Enum.DataStoreRequestType.SetIncrementAsync };
		end;
		v14 = u3.YieldForBudget(function()
			warn(("UpdateAsync request was throttled due to lack of budget. Try sending fewer requests. Key = %s"):format(p17));
		end, v15);
		p16.__writeLock[p17] = nil;
	end;
	if not v14 then
		error("UpdateAsync rejected with error (request was throttled, but throttled queue was full)", 2);
	end;
	local v16 = p18(u1.deepcopy(p16.__data[p17]));
	if v16 == nil then
		u1.simulateYield();
		return nil;
	end;
	if type(v16) == "function" or type(v16) == "userdata" or type(v16) == "thread" then
		error(("UpdateAsync rejected with error (resulting value '%s' is of type %s that cannot be stored)"):format(tostring(v16), typeof(v16)), 2);
	end;
	if type(v16) == "table" then
		local v17, v18, v19 = u1.scanValidity(v16);
		if not v17 then
			error(("UpdateAsync rejected with error (resulting table has invalid entry at <%s>: %s)"):format(u1.getStringPath(v18), v19), 2);
		end;
		local v20, v21 = pcall(function()
			return l__HttpService__5:JSONEncode(v16);
		end);
		if not v20 then
			error("UpdateAsync rejected with error (resulting table could not be encoded to json)", 2);
		elseif u2.MAX_LENGTH_DATA < #v21 then
			error(("UpdateAsync rejected with error (resulting encoded data length exceeds %d character limit)"):format(u2.MAX_LENGTH_DATA), 2);
		end;
	elseif type(v16) == "string" then
		if u2.MAX_LENGTH_DATA < #v16 then
			error(("UpdateAsync rejected with error (resulting data length exceeds %d character limit)"):format(u2.MAX_LENGTH_DATA), 2);
		elseif not utf8.len(v16) then
			error("UpdateAsync rejected with error (string value is not valid UTF-8)", 2);
		end;
	end;
	p16.__writeLock[p17] = true;
	if type(v16) == "table" or v16 ~= p16.__data[p17] then
		p16.__data[p17] = u1.deepcopy(v16);
		p16.__event:Fire(p17, p16.__data[p17]);
	end;
	local v22 = u1.deepcopy(v16);
	p16.__writeLock[p17] = nil;
	p16.__writeCache[p17] = tick();
	p16.__getCache[p17] = tick();
	u1.logMethod(p16, "UpdateAsync", p17, v22);
	return v22;
end;
function v1.ExportToJSON(p19)
	return l__HttpService__5:JSONEncode(p19.__data);
end;
function v1.ImportFromJSON(p20, p21, p22)
	local v23 = nil;
	if type(p21) == "string" then
		local v24, v25 = pcall(function()
			return l__HttpService__5:JSONDecode(p21);
		end);
		if not v24 then
			error("bad argument #1 to 'ImportFromJSON' (string is not valid json)", 2);
		end;
		v23 = v25;
	elseif type(p21) == "table" then
		v23 = u1.deepcopy(p21);
	else
		error(("bad argument #1 to 'ImportFromJSON' (string or table expected, got %s)"):format(typeof(p21)), 2);
	end;
	if p22 ~= nil and type(p22) ~= "boolean" then
		error(("bad argument #2 to 'ImportFromJSON' (boolean expected, got %s)"):format(typeof(p22)), 2);
	end;
	local v26 = nil
	if type(p20.__name) == "string" then
		v26 = type(p20.__scope) == "string" and ("DataStore > %s > %s"):format(p20.__name, p20.__scope) or "GlobalDataStore";
	else
		v26 = "GlobalDataStore";
	end;
	u1.importPairsFromTable(v23, p20.__data, u3.GetDataInterface(p20.__data), p22 == false and function()

	end or warn, "ImportFromJSON", v26, false);
end;
return v1;
