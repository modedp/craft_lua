local v1 = {};
local u1 = require(script.Parent.MockDataStoreConstants);
local function v2(p1, p2, p3)
	return function(p4, p5, p6)
		if not game:GetService("RunService"):IsServer() then
			error("DataStore can't be accessed from client", 2);
		end;
		if p3 then
			return p2();
		end;
		if type(p5) ~= "string" then
			error(("bad argument #1 to '%s' (string expected, got %s)"):format(p1, typeof(p5)), 2);
		elseif p6 ~= nil and type(p6) ~= "string" then
			error(("bad argument #2 to '%s' (string expected, got %s)"):format(p1, typeof(p6)), 2);
		elseif #p5 == 0 then
			error(("bad argument #1 to '%s' (name can't be empty string)"):format(p1), 2);
		elseif u1.MAX_LENGTH_NAME < #p5 then
			error(("bad argument #1 to '%s' (name exceeds %d character limit)"):format(p1, u1.MAX_LENGTH_NAME), 2);
		elseif p6 and #p6 == 0 then
			error(("bad argument #2 to '%s' (scope can't be empty string)").format("bad argument #2 to '%s' (scope can't be empty string)", p1), 2);
		elseif p6 and u1.MAX_LENGTH_SCOPE < #p6 then
			error(("bad argument #2 to '%s' (scope exceeds %d character limit)").format("bad argument #2 to '%s' (scope exceeds %d character limit)", p1, u1.MAX_LENGTH_SCOPE), 2);
		end;
		return p2(p5, p6 and "global");
	end;
end;
local u2 = require(script.Parent.MockDataStoreManager);
local u3 = require(script.Parent.MockGlobalDataStore);
v1.GetGlobalDataStore = v2("GetGlobalDataStore", function()
	local v3 = u2.GetGlobalData();
	local v4 = u2.GetDataInterface(v3);
	if v4 then
		return v4;
	end;
	local v5 = setmetatable({
		__type = "GlobalDataStore", 
		__data = v3, 
		__event = Instance.new("BindableEvent"), 
		__writeCache = {}, 
		__writeLock = {}, 
		__getCache = {}
	}, u3);
	u2.SetDataInterface(v3, v5);
	return v5;
end, true);
v1.GetDataStore = v2("GetDataStore", function(p7, p8)
	local v6 = u2.GetData(p7, p8);
	local v7 = u2.GetDataInterface(v6);
	if v7 then
		return v7;
	end;
	local v8 = setmetatable({
		__type = "GlobalDataStore", 
		__name = p7, 
		__scope = p8, 
		__data = v6, 
		__event = Instance.new("BindableEvent"), 
		__writeCache = {}, 
		__writeLock = {}, 
		__getCache = {}
	}, u3);
	u2.SetDataInterface(v6, v8);
	return v8;
end);
local u4 = require(script.Parent.MockOrderedDataStore);
v1.GetOrderedDataStore = v2("GetOrderedDataStore", function(p9, p10)
	local v9 = u2.GetOrderedData(p9, p10);
	local v10 = u2.GetDataInterface(v9);
	if v10 then
		return v10;
	end;
	local v11 = setmetatable({
		__type = "OrderedDataStore", 
		__name = p9, 
		__scope = p10, 
		__data = v9, 
		__sorted = {}, 
		__ref = {}, 
		__changed = false, 
		__event = Instance.new("BindableEvent"), 
		__writeCache = {}, 
		__writeLock = {}, 
		__getCache = {}
	}, u4);
	u2.SetDataInterface(v9, v11);
	return v11;
end);
local v12 = {};
for v13, v14 in ipairs(Enum.DataStoreRequestType:GetEnumItems()) do
	v12[v14] = v14;
	v12[v14.Name] = v14;
	v12[v14.Value] = v14;
end;
function v1.GetRequestBudgetForRequestType(p11, p12)
	if not v12[p12] then
		error(("bad argument #1 to 'GetRequestBudgetForRequestType' (unable to cast '%s' of type %s to DataStoreRequestType)"):format(tostring(p12), typeof(p12)), 2);
	end;
	return u2.GetBudget(v12[p12]);
end;
function v1.ImportFromJSON(p13, ...)
	return u2.ImportFromJSON(...);
end;
function v1.ExportToJSON(p14, ...)
	return u2.ExportToJSON(...);
end;
return v1;
