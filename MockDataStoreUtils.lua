local v1 = {};
local u1 = require(script.Parent.MockDataStoreConstants);
local function u2(p1, p2)
	if not (p2 < #p1) then
		return p1;
	end;
	return p1:sub(1, p2 - 2) .. "..";
end;
local function u3(p3)
	if type(p3) ~= "table" then
		return p3;
	end;
	local v2 = {};
	for v3, v4 in pairs(p3) do
		v2[v3] = u3(v4);
	end;
	return v2;
end;
local function u4(p4, p5, p6)
	if type(p4) ~= "table" then
		return u4({
			input = p4
		}, {}, {});
	end;
	p5 = p5 or {};
	p6 = p6 or { "root" };
	p5[p4] = true;
	local v5 = nil
	if type((next(p4))) == "number" then
		v5 = "Array";
	else
		v5 = "Dictionary";
	end;
	local v6 = 0;
	local l__next__7 = next;
	local v8 = nil;
	for v9,v10 in next(p4,v8) do
		p6[#p6 + 1] = tostring(v9);
		if type(v9) == "number" then
			if v5 == "Dictionary" then
				return false, p6, "cannot store mixed tables";
			end;
			if v9 % 1 ~= 0 then
				return false, p6, "cannot store tables with non-integer indices";
			end;
			if v9 == math.huge then
				return false, p6, "cannot store tables with (-)infinity indices";
			end;
			if v9 == -math.huge then
				return false, p6, "cannot store tables with (-)infinity indices";
			end;
		else
			if type(v9) ~= "string" then
				return false, p6, "dictionaries cannot have keys of type " .. typeof(v9);
			end;
			if v5 == "Array" then
				return false, p6, "cannot store mixed tables";
			end;
			if not utf8.len(v9) then
				return false, p6, "dictionary has key that is invalid UTF-8";
			end;
		end;
		if v5 == "Array" then
			if v6 ~= v9 - 1 then
				return false, p6, "array has non-sequential indices";
			end;
			v6 = v9;
		end;
		if type(v10) == "userdata" then
			return false, p6, "cannot store value '" .. tostring(v10) .. "' of type " .. typeof(v10);
		end;
		if type(v10) == "function" then
			return false, p6, "cannot store value '" .. tostring(v10) .. "' of type " .. typeof(v10);
		end;
		if type(v10) == "thread" then
			return false, p6, "cannot store value '" .. tostring(v10) .. "' of type " .. typeof(v10);
		end;
		if type(v10) == "string" and not utf8.len(v10) then
			return false, p6, "cannot store strings that are invalid UTF-8";
		end;
		if type(v10) == "table" then
			if p5[v10] then
				return false, p6, "cannot store cyclic tables";
			end;
			local v11, v12, v13 = u4(v10, p5, p6);
			if not v11 then
				return v11, v12, v13;
			end;
		end;
		p6[#p6] = nil;	
	end;
	p5[p4] = nil;
	return true;
end;
local l__HttpService__5 = game:GetService("HttpService");
local function u6(p7)
	return table.concat(p7, ".");
end;
local u7 = Random.new();
local function u8()
	if u1.YIELD_TIME_MAX > 0 then
		wait(u7:NextNumber(u1.YIELD_TIME_MIN, u1.YIELD_TIME_MAX));
	end;
end;
function v1.logMethod(p8, p9, p10, p11, p12)
	if not u1.LOGGING_ENABLED or type(u1.LOGGING_FUNCTION) ~= "function" then
		return;
	end;
	local l____name__14 = p8.__name;
	local l____scope__15 = p8.__scope;
	local v16 = nil
	if not l____name__14 then
		v16 = ("[GlobalDataStore] [%s]"):format(p9);
	elseif not l____scope__15 then
		v16 = ("[%s] [%s] [%s]"):format(p8.__type, u2(l____name__14, 20), p9);
	else
		v16 = ("[%s] [%s/%s] [%s]"):format(p8.__type, u2(l____name__14, 15), u2(l____scope__15, 15), p9);
	end;
	local v17 = nil
	if p11 and p12 then
		v17 = p10 .. " + " .. tostring(p12) .. " => " .. tostring(p11);
	elseif p12 then
		v17 = p10 .. " + " .. tostring(p12);
	elseif p11 then
		if p9 == "RemoveAsync" then
			v17 = p10 .. " =/> " .. tostring(p11);
		else
			v17 = p10 .. " => " .. tostring(p11);
		end;
	else
		v17 = "key";
	end;
	u1.LOGGING_FUNCTION(v16 .. " " .. v17);
end;
v1.deepcopy = u3;
v1.scanValidity = u4;
v1.getStringPath = u6;
function v1.importPairsFromTable(p13, p14, p15, p16, p17, p18, p19)
	for v18, v19 in pairs(p13) do
		if type(v18) ~= "string" then
			p16(("%s: ignored %s > '%s' (key is not a string, but a %s)"):format(p17, p18, tostring(v18), typeof(v18)));
		elseif not utf8.len(v18) then
			p16(("%s: ignored %s > '%s' (key is not valid UTF-8)"):format(p17, p18, tostring(v18)));
		elseif u1.MAX_LENGTH_KEY < #v18 then
			p16(("%s: ignored %s > '%s' (key exceeds %d character limit)"):format(p17, p18, v18, u1.MAX_LENGTH_KEY));
		elseif type(v19) == "string" and u1.MAX_LENGTH_DATA < #v19 then
			p16(("%s: ignored %s > '%s' (length of value exceeds %d character limit)"):format(p17, p18, v18, u1.MAX_LENGTH_DATA));
		elseif type(v19) == "table" and u1.MAX_LENGTH_DATA < #l__HttpService__5:JSONEncode(v19) then
			p16(("%s: ignored %s > '%s' (length of encoded value exceeds %d character limit)"):format(p17, p18, v18, u1.MAX_LENGTH_DATA));
		elseif type(v19) == "function" or type(v19) == "userdata" or type(v19) == "thread" then
			p16(("%s: ignored %s > '%s' (cannot store value '%s' of type %s)").format("%s: ignored %s > '%s' (cannot store value '%s' of type %s)", p17, p18, v18, tostring(v19), type(v19)));
		elseif p19 and type(v19) ~= "number" then
			p16(("%s: ignored %s > '%s' (cannot store value '%s' of type %s in OrderedDataStore)").format("%s: ignored %s > '%s' (cannot store value '%s' of type %s in OrderedDataStore)", p17, p18, v18, tostring(v19), type(v19)));
		elseif p19 and v19 % 1 ~= 0 then
			p16(("%s: ignored %s > '%s' (cannot store non-integer value '%s' in OrderedDataStore)").format("%s: ignored %s > '%s' (cannot store non-integer value '%s' in OrderedDataStore)", p17, p18, v18, tostring(v19)));
		elseif type(v19) == "string" and not utf8.len(v19) then
			p16(("%s: ignored %s > '%s' (string value is not valid UTF-8)").format("%s: ignored %s > '%s' (string value is not valid UTF-8)", p17, p18, v18, tostring(v19), type(v19)));
		else
			local v20 = true;
			local v21 = nil;
			local v22 = nil;
			if type(v19) == "table" then
				local v23, v24, v25 = u4(v19);
				v20 = v23;
				v21 = v24;
				v22 = v25;
			end;
			if p19 then
				v19 = math.floor(v19 + 0.5);
			end;
			if v20 then
				p14[v18] = v19;
				if p15 and p14[v18] ~= v19 then
					if p19 and p15 then
						if p15.__ref[v18] then
							p15.__ref[v18].Value = v19;
							p15.__changed = true;
						else
							local v26 = {};
							v26.Key = v18;
							v26.Value = p15.__data[v18];
							p15.__ref[v18] = v26;
							table.insert(p15.__sorted, p15.__ref[v18]);
							p15.__changed = true;
						end;
					end;
					local l____event__27 = p15.__event;
					l____event__27.Fire(l____event__27, v18, v19);
				end;
			else
				p16(("%s: ignored %s > '%s' (table has invalid entry at <%s>: %s)").format("%s: ignored %s > '%s' (table has invalid entry at <%s>: %s)", p17, p18, v18, u6(v21), v22));
			end;
		end;
	end;
end;
function v1.prepareDataStoresForExport(p20)
	local v28 = {};
	for v32, v33 in pairs(p20) do
		local v34 = {};
		for v38, v39 in pairs(v33) do
			local v40 = {};
			for v41, v42 in pairs(v39) do
				v40[v41] = v42;
			end;
			if next(v40) ~= nil then
				v34[v38] = v40;
			end;		
		end;
		if next(v34) ~= nil then
			v28[v32] = v34;
		end;	
	end;
	if next(v28) == nil then
		return;
	end;
	return v28;
end;
function v1.preprocessKey(p21)
	if type(p21) ~= "number" then
		return p21;
	end;
	if p21 ~= p21 then
		return "NAN";
	end;
	if math.huge <= p21 then
		return "INF";
	end;
	if p21 <= -math.huge then
		return "-INF";
	end;
	return tostring(p21);
end;
v1.simulateYield = u8;
function v1.simulateErrorCheck(p22)
	if u1.SIMULATE_ERROR_RATE > 0 and u7:NextNumber() <= u1.SIMULATE_ERROR_RATE then
		u8();
		error(p22 .. " rejected with error (simulated error)", 3);
	end;
end;
return v1;
