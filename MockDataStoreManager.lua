local v1 = {};
local v2 = require(script.Parent.MockDataStoreConstants);
local l__Players__3 = game:GetService("Players");
local v4 = {
	[Enum.DataStoreRequestType.GetAsync] = {}, 
	[Enum.DataStoreRequestType.GetSortedAsync] = {}, 
	[Enum.DataStoreRequestType.OnUpdate] = {}, 
	[Enum.DataStoreRequestType.SetIncrementAsync] = {}, 
	[Enum.DataStoreRequestType.SetIncrementSortedAsync] = {}
};
local u1 = {
	[Enum.DataStoreRequestType.GetAsync] = v2.BUDGET_GETASYNC, 
	[Enum.DataStoreRequestType.GetSortedAsync] = v2.BUDGET_GETSORTEDASYNC, 
	[Enum.DataStoreRequestType.OnUpdate] = v2.BUDGET_ONUPDATE, 
	[Enum.DataStoreRequestType.SetIncrementAsync] = v2.BUDGET_SETINCREMENTASYNC, 
	[Enum.DataStoreRequestType.SetIncrementSortedAsync] = v2.BUDGET_SETINCREMENTSORTEDASYNC
};
local u2 = {};
local function v5(p1)
	if not v2.BUDGETING_ENABLED then
		return;
	end;
	for v6, v7 in pairs(p1) do
		if u2[v7] then
			u2[v7] = math.max(0, u2[v7] - 1);
		end;
	end;
	u2[Enum.DataStoreRequestType.UpdateAsync] = math.min(u2[Enum.DataStoreRequestType.GetAsync], u2[Enum.DataStoreRequestType.SetIncrementAsync]);
end;
local function v8(p2)
	if not v2.BUDGETING_ENABLED then
		return true;
	end;
	for v9, v10 in pairs(p2) do
		if u2[v10] and u2[v10] < 1 then
			return false;
		end;
	end;
	return true;
end;
if game:GetService("RunService"):IsServer() then
	(function()
		for v11, v12 in pairs(u1) do
			u2[v11] = v12.START;
		end;
		u2[Enum.DataStoreRequestType.UpdateAsync] = math.min(u2[Enum.DataStoreRequestType.GetAsync], u2[Enum.DataStoreRequestType.SetIncrementAsync]);
	end)();
	local function u3(p3, p4, p5, p6)
		if not v2.BUDGETING_ENABLED then
			return;
		end;
		local v13 = p4.RATE + p6 * p4.RATE_PLR;
		u2[p3] = math.min(u2[p3] + p5 * v13, p4.MAX_FACTOR * v13);
	end;
	delay(0, function()
		local v14 = tick();
		while wait(v2.BUDGET_UPDATE_INTERVAL) do
			local v15 = (tick() - v14) / 60;
			local v16 = #l__Players__3:GetPlayers();
			for v17, v18 in pairs(u1) do
				u3(v17, v18, v15, v16);
			end;
			u2[Enum.DataStoreRequestType.UpdateAsync] = math.min(u2[Enum.DataStoreRequestType.GetAsync], u2[Enum.DataStoreRequestType.SetIncrementAsync]);
			for v22, v23 in pairs(v4) do
				for v24 = #v23, 1, -1 do
					local v25 = v23[v24];
					local l__Budget__26 = v25.Budget;
					local l__Key__27 = v25.Key;
					local l__Lock__28 = v25.Lock;
					if l__Lock__28 then
						if not l__Lock__28[l__Key__27] and (not (tick() - (v25.Cache[l__Key__27] and 0) < v2.WRITE_COOLDOWN) and v8(l__Budget__26)) then
							table.remove(v23, v24);
							v5(l__Budget__26);
							coroutine.resume(v25.Thread);
						end;
					elseif v8(l__Budget__26) then
						table.remove(v23, v24);
						v5(l__Budget__26);
						coroutine.resume(v25.Thread);
					end;
				end;			
			end;		
		end;
	end);
	game:BindToClose(function()
		for v29, v30 in pairs(u1) do
			u2[v29] = math.max(u2[v29], v2.BUDGET_ONCLOSE_BASE * (v30.RATE / v2.BUDGET_BASE));
		end;
		u2[Enum.DataStoreRequestType.UpdateAsync] = math.min(u2[Enum.DataStoreRequestType.GetAsync], u2[Enum.DataStoreRequestType.SetIncrementAsync]);
	end);
end;
local u4 = {
	GlobalDataStore = {}, 
	DataStore = {}, 
	OrderedDataStore = {}
};
function v1.GetGlobalData()
	return u4.GlobalDataStore;
end;
function v1.GetData(p7, p8)
	assert(type(p7) == "string");
	assert(type(p8) == "string");
	if not u4.DataStore[p7] then
		u4.DataStore[p7] = {};
	end;
	if not u4.DataStore[p7][p8] then
		u4.DataStore[p7][p8] = {};
	end;
	return u4.DataStore[p7][p8];
end;
function v1.GetOrderedData(p9, p10)
	assert(type(p9) == "string");
	assert(type(p10) == "string");
	if not u4.OrderedDataStore[p9] then
		u4.OrderedDataStore[p9] = {};
	end;
	if not u4.OrderedDataStore[p9][p10] then
		u4.OrderedDataStore[p9][p10] = {};
	end;
	return u4.OrderedDataStore[p9][p10];
end;
local u5 = {};
function v1.GetDataInterface(p11)
	return u5[p11];
end;
function v1.SetDataInterface(p12, p13)
	assert(type(p12) == "table");
	assert(type(p13) == "table");
	u5[p12] = p13;
end;
function v1.GetBudget(p14)
	if not v2.BUDGETING_ENABLED then
		return math.huge;
	end;
	return math.floor(u2[p14] and 0);
end;
function v1.YieldForWriteLockAndBudget(p15, p16, p17, p18, p19)
	assert(type(p15) == "function");
	assert(type(p16) == "string");
	assert(type(p17) == "table");
	assert(type(p18) == "table");
	assert(#p19 > 0);
	local v31 = p19[1];
	if v2.THROTTLE_QUEUE_SIZE <= #v4[v31] then
		return false;
	end;
	p15();
	table.insert(v4[v31], 1, {
		Key = p16, 
		Lock = p17, 
		Cache = p18, 
		Thread = coroutine.running(), 
		Budget = p19
	});
	coroutine.yield();
	return true;
end;
function v1.YieldForBudget(p20, p21)
	assert(type(p20) == "function");
	assert(#p21 > 0);
	local v32 = p21[1];
	if v8(p21) then
		v5(p21);
	else
		if v2.THROTTLE_QUEUE_SIZE <= #v4[v32] then
			return false;
		end;
		p20();
		table.insert(v4[v32], 1, {
			After = 0, 
			Thread = coroutine.running(), 
			Budget = p21
		});
		coroutine.yield();
	end;
	return true;
end;
local u6 = require(script.Parent.MockDataStoreUtils);
local l__HttpService__7 = game:GetService("HttpService");
function v1.ExportToJSON()
	local v33 = {};
	if next(u4.GlobalDataStore) ~= nil then
		v33.GlobalDataStore = u4.GlobalDataStore;
	end;
	v33.DataStore = u6.prepareDataStoresForExport(u4.DataStore);
	v33.OrderedDataStore = u6.prepareDataStoresForExport(u4.OrderedDataStore);
	return l__HttpService__7:JSONEncode(v33);
end;
local function u8(p22, p23, p24, p25, p26, p27)
	for v34, v35 in pairs(p22) do
		if type(v34) ~= "string" then
			p24(("%s: ignored %s > %q (name is not a string, but a %s)"):format(p25, p26, tostring(v34), typeof(v34)));
		elseif type(v35) ~= "table" then
			p24(("%s: ignored %s > %q (scope list is not a table, but a %s)"):format(p25, p26, v34, typeof(v35)));
		elseif #v34 == 0 then
			p24(("%s: ignored %s > %q (name is an empty string)"):format(p25, p26, v34));
		elseif v2.MAX_LENGTH_NAME < #v34 then
			p24(("%s: ignored %s > %q (name exceeds %d character limit)"):format(p25, p26, v34, v2.MAX_LENGTH_NAME));
		else
			for v36, v37 in pairs(v35) do
				if type(v36) ~= "string" then
					p24(("%s: ignored %s > %q > %q (scope is not a string, but a %s)"):format(p25, p26, v34, tostring(v36), typeof(v36)));
				elseif type(v37) ~= "table" then
					p24(("%s: ignored %s > %q > %q (data list is not a table, but a %s)"):format(p25, p26, v34, v36, typeof(v37)));
				elseif #v36 == 0 then
					p24(("%s: ignored %s > %q > %q (scope is an empty string)").format("%s: ignored %s > %q > %q (scope is an empty string)", p25, p26, v34, v36));
				elseif v2.MAX_LENGTH_SCOPE < #v36 then
					p24(("%s: ignored %s > %q > %q (scope exceeds %d character limit)").format("%s: ignored %s > %q > %q (scope exceeds %d character limit)", p25, p26, v34, v36, v2.MAX_LENGTH_SCOPE));
				else
					if not p23[v34] then
						p23[v34] = {};
					end;
					if not p23[v34][v36] then
						p23[v34][v36] = {};
					end;
					u6.importPairsFromTable(v37, p23[v34][v36], u5[p23[v34][v36]], p24, p25, ("%s > %q > %q").format("%s > %q > %q", p26, v34, v36), p27);
				end;
			end;
		end;
	end;
end;
function v1.ImportFromJSON(p28, p29)
	local v38 = nil;
	if type(p28) == "string" then
		local v39, v40 = pcall(function()
			return l__HttpService__7:JSONDecode(p28);
		end);
		if not v39 then
			error("bad argument #1 to 'ImportFromJSON' (string is not valid json)", 2);
		end;
		v38 = v40;
	elseif type(p28) == "table" then
		v38 = u6.deepcopy(p28);
	else
		error(("bad argument #1 to 'ImportFromJSON' (string or table expected, got %s)"):format(typeof(p28)), 2);
	end;
	local v41 = warn;
	if p29 == false then
		v41 = function()

		end;
	end;
	if type(v38.GlobalDataStore) == "table" then
		u6.importPairsFromTable(v38.GlobalDataStore, u4.GlobalDataStore, u5[u4.GlobalDataStore], v41, "ImportFromJSON", "GlobalDataStore", false);
	end;
	if type(v38.DataStore) == "table" then
		u8(v38.DataStore, u4.DataStore, v41, "ImportFromJSON", "DataStore", false);
	end;
	if type(v38.OrderedDataStore) == "table" then
		u8(v38.OrderedDataStore, u4.OrderedDataStore, v41, "ImportFromJSON", "OrderedDataStore", true);
	end;
end;
return v1;
