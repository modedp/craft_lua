--[[Parent of this script is StarterPlayerScripts]]
local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__TextService__2 = game:GetService("TextService");
local l__RunService__3 = game:GetService("RunService");
local v4 = require(l__ReplicatedStorage__1.Libs.SyncEvent);
local v5 = require(l__ReplicatedStorage__1.Libs.Memo);
local v6 = {
	charsets = require(script.Charsets), 
	charassets = require(l__ReplicatedStorage__1.Assets).fonts,
	spritesheetSizes = { 8, 16, 32, 64, 96 }
};
table.sort(v6.spritesheetSizes);
v6.spaceWidth = 5;
v6.tabWidth = 4 * v6.spaceWidth;
v6.lineHeight = 9;
v6.fallbackFont = Enum.Font.Arial;
v6.fallbackFontScale = 0.875;
v6.alignmentEnumMap = {
	[Enum.TextXAlignment.Left] = 0, 
	[Enum.TextXAlignment.Center] = 0.5, 
	[Enum.TextXAlignment.Right] = 1, 
	[Enum.TextYAlignment.Top] = 0, 
	[Enum.TextYAlignment.Center] = 0.5, 
	[Enum.TextYAlignment.Bottom] = 1
};
v6.sequenceChar = "\194\167";
v6.sequences = {
	black = v6.sequenceChar .. "0", 
	darkBlue = v6.sequenceChar .. "1", 
	darkGreen = v6.sequenceChar .. "2", 
	darkAqua = v6.sequenceChar .. "3", 
	darkRed = v6.sequenceChar .. "4", 
	darkPurple = v6.sequenceChar .. "5", 
	gold = v6.sequenceChar .. "6", 
	grey = v6.sequenceChar .. "7", 
	darkGrey = v6.sequenceChar .. "8", 
	blue = v6.sequenceChar .. "9", 
	green = v6.sequenceChar .. "a", 
	aqua = v6.sequenceChar .. "b", 
	red = v6.sequenceChar .. "c", 
	lightPurple = v6.sequenceChar .. "d", 
	yellow = v6.sequenceChar .. "e", 
	white = v6.sequenceChar .. "f", 
	reset = v6.sequenceChar .. "r"
};
v6.noOverrideColourSet = Color3.fromRGB(-1, -1, -1);
v6.initialOverrideColourSet = Color3.fromRGB(-2, -2, -2);
v6.colours = {
	["0"] = Color3.fromRGB(0, 0, 0), 
	["1"] = Color3.fromRGB(0, 0, 170), 
	["2"] = Color3.fromRGB(0, 170, 0), 
	["3"] = Color3.fromRGB(0, 170, 170), 
	["4"] = Color3.fromRGB(0, 0, 170), 
	["5"] = Color3.fromRGB(170, 0, 170), 
	["6"] = Color3.fromRGB(255, 170, 0), 
	["7"] = Color3.fromRGB(170, 170, 170), 
	["8"] = Color3.fromRGB(85, 85, 85), 
	["9"] = Color3.fromRGB(85, 85, 255), 
	a = Color3.fromRGB(85, 255, 85), 
	b = Color3.fromRGB(85, 255, 255), 
	c = Color3.fromRGB(255, 85, 85), 
	d = Color3.fromRGB(255, 85, 255), 
	e = Color3.fromRGB(255, 255, 85), 
	f = Color3.fromRGB(255, 255, 255)
};
function v6.getGlyphInfo(p1, p2)
	for v7, v8 in pairs(p1.charsets) do
		for v9, v10 in ipairs(v8.characters) do
			for v11, v12 in pairs(v10) do
				if p2 == v12 then
					return v8, v11, v9;
				end;
			end;
		end;
	end;
end;
function v6.getSpritesheetSize(p3, p4)
	for v13, v14 in ipairs(p3.spritesheetSizes) do
		if p4 <= v14 then
			return v14;
		end;
	end;
	return p3.spritesheetSizes[#p3.spritesheetSizes];
end;
function v6.createChunkTemplate(p5, p6)
	local v15 = {};
	local v16 = Instance.new("Frame");
	v16.BackgroundTransparency = 1;
	v16.Size = UDim2.new(1, 0, 1, 0);
	v15.renderedChunk = v16;
	local v17 = {};
	v15.characterData = v17;
	local v18 = 0;
	local v19 = 0;
	local v20 = false;
	local v21 = v6.noOverrideColourSet;
	for v22, v23 in utf8.graphemes(p6) do
		local v24 = p6:sub(v22, v23);
		local v25, v26, v27 = p5:getGlyphInfo(v24);
		v19 = v19 + 1;
		if v20 then
			v20 = false;
			local v28 = p5.colours[v24];
			if v28 then
				v21 = v28;
			elseif v24 == "r" then
				v21 = nil;
			end;
			v17[v19] = {
				graphemeStart = v22, 
				graphemeEnd = v23, 
				currentX = v18, 
				isSpecial = true
			};
		elseif v24 == v6.sequenceChar then
			v20 = true;
			v17[v19] = {
				graphemeStart = v22, 
				graphemeEnd = v23, 
				currentX = v18, 
				isSpecial = true
			};
		elseif v25 then
			if v18 > 0 then
				v18 = v18 + 1;
			end;
			local v29 = v25.widths[v27][v26];
			local v30 = Instance.new("ImageLabel");
			v30.Name = ("Sprite%d"):format(v19);
			v30.BackgroundTransparency = 1;
			v30.Size = UDim2.new(v29 / 8, 0, 1, 0);
			v30.Position = UDim2.new(v18 / 8, 0, 0, 0);
			if v21 and v21 ~= v6.noOverrideColourSet then
				v30.ImageColor3 = v21;
			end;
			v30.Parent = v16;
			local v31 = Instance.new("ImageLabel");
			v31.Name = ("SpriteShadow%d"):format(v19);
			v31.BackgroundTransparency = 1;
			v31.Size = UDim2.new(v29 / 8, 0, 1, 0);
			v31.Position = UDim2.new((v18 + 1) / 8, 0, 0.125, 0);
			v31.ZIndex = -1;
			if v21 and v21 ~= v6.noOverrideColourSet then
				v31.ImageColor3 = v21:Lerp(Color3.new(), 0.75);
			end;
			v31.Parent = v16;
			v17[v19] = {
				charset = v25, 
				glyphX = v26, 
				glyphY = v27, 
				graphemeStart = v22, 
				graphemeEnd = v23, 
				width = v29, 
				spriteName = v30.Name, 
				spriteShadowName = v31.Name, 
				overrideColour = v21, 
				currentX = v18, 
				isUnicode = false, 
				isSpecial = false
			};
			v18 = v18 + v29;
		else
			if v18 > 0 then
				v18 = v18 + 1;
			end;
			local v32 = math.ceil(l__TextService__2:GetTextSize(v24, 64, v6.fallbackFont, Vector2.new(math.huge, math.huge)).X / 64 * 8) + 1;
			local v33 = Instance.new("TextLabel");
			v33.Name = ("Sprite%d"):format(v19);
			v33.BackgroundTransparency = 1;
			v33.Size = UDim2.new(v32 / 8, 0, 1, 0);
			v33.Position = UDim2.new(v18 / 8, 0, 0, 0);
			if v21 and v21 ~= v6.noOverrideColourSet then
				v33.TextColor3 = v21;
			else
				v33.TextColor3 = Color3.new(1, 1, 1);
			end;
			local v35 = Instance.new("TextLabel");
			v35.Name = ("SpriteShadow%d"):format(v19);
			v35.BackgroundTransparency = 1;
			v35.Size = UDim2.new(v32 / 8, 0, 1, 0);
			v35.Position = UDim2.new((v18 + 1) / 8, 0, 0.125, 0);
			v35.ZIndex = -1;
			if v21 and v21 ~= v6.noOverrideColourSet then
				v35.TextColor3 = v21:Lerp(Color3.new(), 0.75);
			else
				v35.TextColor3 = Color3.new(0.25, 0.25, 0.25);
			end;
			v33.Text = v24;
			v33.Parent = v16;
			v35.Text = v24;
			v35.Parent = v16;
			v17[v19] = {
				charset = v25, 
				glyphX = v26, 
				glyphY = v27, 
				graphemeStart = v22, 
				graphemeEnd = v23, 
				width = v32, 
				spriteName = v33.Name, 
				spriteShadowName = v35.Name, 
				overrideColour = v21, 
				currentX = v18, 
				isUnicode = true, 
				isSpecial = false
			};
			v18 = v18 + v32;
		end;
	end;
	v15.finalOverrideColour = v21;
	v15.textWidth = v18;
	return v15;
end;
function v6.getTextChunk(p7, p8)
	local v36 = {};
	local v37 = nil or p7:createChunkTemplate(p8);
	local v38 = v37.renderedChunk:Clone();
	v36.text = p8;
	v36.renderedChunk = v38;
	v36.characterData = v37.characterData;
	v36.textWidth = v37.textWidth;
	v36.finalOverrideColour = v37.finalOverrideColour;
	local u1 = nil;
	function v36.setSize(p9, p10)
		local v39 = v6:getSpritesheetSize(p10);
		u1 = v39;
		for v40, v41 in pairs(v37.characterData) do
			if not v41.isSpecial then
				local v42 = nil;
				local v43 = nil;
				v42 = v38[v41.spriteName];
				v43 = v38[v41.spriteShadowName];
				if v41.isUnicode then
					v42.TextSize = p10 * v6.fallbackFontScale;
					v43.TextSize = v42.TextSize;
				else
					v42.Image = "rbxassetid://" .. v41.charset.texture[(v39)];
					v42.ImageRectSize = Vector2.new(v39 * (v41.width / 8), v39);
					v42.ImageRectOffset = Vector2.new(v39 * (v41.glyphX - 1), v39 * (v41.glyphY - 1));
					v43.Image = v42.Image;
					v43.ImageRectSize = v42.ImageRectSize;
					v43.ImageRectOffset = v42.ImageRectOffset;
				end;
			end;
		end;
	end;
	local u2 = nil;
	function v36.setInitialOverrideColour(p11, p12)
		if p12 == u2 then
			return;
		end;
		u2 = p12;
		local v44 = math.huge;
		for v45, v46 in pairs(v37.characterData) do
			if v46.overrideColour ~= v6.noOverrideColourSet and v46.overrideColour ~= v6.initialOverrideColourSet and v45 < v44 then
				v44 = v45;
			end;
		end;
		for v47, v48 in pairs(v37.characterData) do
			if not v48.isSpecial and v47 < v44 then
				local v49 = nil;
				local v50 = nil;
				v49 = v38[v48.spriteName];
				v50 = v38[v48.spriteShadowName];
				if v48.isUnicode then
					v49.TextColor3 = p12;
					v50.TextColor3 = p12:Lerp(Color3.new(), 0.75);
				else
					v49.ImageColor3 = p12;
					v50.ImageColor3 = p12:Lerp(Color3.new(), 0.75);
				end;
				v48.overrideColour = v6.initialOverrideColourSet;
			end;
		end;
	end;
	local u3 = nil;
	function v36.setColour(p13, p14)
		if p14 == u3 then
			return;
		end;
		u3 = p14;
		for v51, v52 in pairs(v37.characterData) do
			if not v52.isSpecial and (not v52.overrideColour or v52.overrideColour == v6.noOverrideColourSet) then
				local v53 = nil;
				local v54 = nil;
				v53 = v38[v52.spriteName];
				v54 = v38[v52.spriteShadowName];
				if v52.isUnicode then
					v53.TextColor3 = p14;
					v54.TextColor3 = p14:Lerp(Color3.new(), 0.75);
				else
					v53.ImageColor3 = p14;
					v54.ImageColor3 = p14:Lerp(Color3.new(), 0.75);
				end;
			end;
		end;
	end;
	local u4 = nil;
	function v36.setTransparency(p15, p16)
		if p16 == u4 then
			return;
		end;
		u4 = p16;
		for v55, v56 in pairs(v37.characterData) do
			if not v56.isSpecial then
				local v57 = nil;
				local v58 = nil;
				v57 = v38[v56.spriteName];
				v58 = v38[v56.spriteShadowName];
				if v56.isUnicode then
					v57.TextTransparency = p16;
					v58.TextTransparency = p16;
				else
					v57.ImageTransparency = p16;
					v58.ImageTransparency = p16;
				end;
			end;
		end;
	end;
	local u5 = nil;
	function v36.setHasShadow(p17, p18)
		if p18 == u5 then
			return;
		end;
		u5 = p18;
		for v59, v60 in pairs(v37.characterData) do
			if not v60.isSpecial then
				v38[v60.spriteShadowName].Visible = p18;
			end;
		end;
	end;
	function v36.destroy(p19)
		p19.renderedChunk:Destroy();
	end;
	return v36;
end;
function v6.createTextObject(p20)
	local v61 = {
		onRebuild = v4.new(), 
		onReflow = v4.new()
	};
	local v62 = Instance.new("Frame");
	v62.BackgroundTransparency = 1;
	v62.Size = UDim2.new(1, 0, 1, 0);
	v61.rootFrame = v62;
	local u6 = {};
	local u7 = Color3.new(1, 1, 1);
	local u8 = 8;
	local u9 = 0;
	local u10 = false;
	function v61.buildChunks(p21, p22)
		v61.currentText = p22;
		for v63, v64 in pairs(u6) do
			v64:destroy();
		end;
		u6 = {};
		local u11 = "";
		local u12 = 1;
		local u13 = 1;
		local function v65(p23)
			local v66 = v6:getTextChunk(u11);
			u11 = "";
			v66.startLocation = u12;
			v66.endLocation = u13;
			v66:setColour(u7);
			v66:setSize(u8);
			v66:setTransparency(u9);
			v66:setHasShadow(u10);
			if p23 then
				v66.trailingChar = p23.character;
				v66.trailingCharData = p23;
			end;
			if #u6 > 0 then
				local v67 = u6[#u6].finalOverrideColour;
				if v67 == v6.noOverrideColourSet then
					v67 = nil;
				end;
				if v66.finalOverrideColour == v6.noOverrideColourSet then
					v66.finalOverrideColour = v67;
				end;
				v66:setInitialOverrideColour(v67);
			end;
			u6[#u6 + 1] = v66;
		end;
		for v68, v69 in utf8.graphemes(p22) do
			local v70 = p22:sub(v68, v69);
			if v70 == " " or v70 == "\t" or v70 == "\n" then
				v65({
					character = v70, 
					startLocation = v68, 
					endLocation = v69
				});
				u12 = v69 + 1;
			else
				u11 = u11 .. v70;
				u13 = v69;
			end;
		end;
		v65();
		p21.onRebuild:fire();
	end;
	local u14 = {};
	function v61.reflowChunks(p24, p25, p26, p27)
		for v71, v72 in pairs(u6) do
			v72.renderedChunk.Parent = nil;
		end;
		for v73, v74 in pairs(u14) do
			v74:Destroy();
		end;
		u14 = {};
		if p25 == nil then
			p25 = Vector2.new(math.huge, math.huge);
		end;
		if p26 == nil then
			p26 = 0;
		end;
		if p27 == nil then
			p27 = 0;
		end;
		local u15 = {};
		local u16 = 0;
		local u17 = 0;
		local u18 = 8 - v6.lineHeight;
		local u19 = 0;
		local function v75()
			if #u15 == 0 then
				return;
			end;
			u16 = math.max(u16, u17);
			u18 = u18 + v6.lineHeight;
			local v76 = Instance.new("Frame");
			v76.BackgroundTransparency = 1;
			v76.Size = UDim2.new(1, 0, 1, 0);
			v76.Position = UDim2.new((1 - u17 / 8) * p26, 0, u19 / 8, 0);
			for v77, v78 in pairs(u15) do
				v78.renderedChunk.Parent = v76;
				v78.currentX = v78.currentLineX + (1 - u17 / 8) * p26 * 8;
			end;
			u15 = {};
			v76.Parent = v62;
			u14[#u14 + 1] = v76;
		end;
		local v79 = 0;
		for v83, v84 in ipairs(u6) do
			if p25.X < u17 + v79 + v84.textWidth then
				v75();
				u17 = 0;
				u19 = u19 + v6.lineHeight;
			else
				u17 = u17 + v79;
			end;
			v79 = 0;
			v84.currentLineX = u17;
			v84.currentLineY = u19;
			v84.renderedChunk.Position = UDim2.new(u17 / 8, 0, 0, 0);
			u15[#u15 + 1] = v84;
			u17 = u17 + v84.textWidth;
			if v84.trailingChar == " " then
				v79 = v6.spaceWidth;
			elseif v84.trailingChar == "\t" then
				v79 = v6.tabWidth;
			elseif v84.trailingChar == "\n" then
				v75();
				u17 = 0;
				u19 = u19 + v6.lineHeight;
			end;		
		end;
		v75();
		p24.textWidth = u16;
		p24.textHeight = u18;
		for v85, v86 in pairs(u14) do
			v86.Position = v86.Position + UDim2.new(0, 0, (1 - u18 / 8) * p27, 0);
		end;
		for v87, v88 in pairs(u6) do
			v88.currentY = v88.currentLineY + (1 - u18 / 8) * p27 * 8;
		end;
		p24.onReflow:fire();
	end;
	function v61.getCharPosition(p28, p29)
		if #p28.currentText < 1 then
			return Vector2.new(0, 0);
		end;
		local v89 = nil;
		local v90 = false;
		for v91, v92 in ipairs(u6) do
			if v92.startLocation <= p29 then
				if p29 <= v92.endLocation then
					v89 = v92;
					break;
				end;
				if v92.trailingCharData and p29 <= v92.trailingCharData.endLocation then
					v89 = v92;
					v90 = true;
					break;
				end;
			end;
		end;
		if not v89 then
			if p29 <= 0 then
				return Vector2.new(0, 0);
			else
				local v93 = u6[#u6];
				return Vector2.new(v93.currentX + v93.textWidth, v93.currentY);
			end;
		end;
		local v94 = p29 - v89.startLocation + 1;
		if v90 then
			local v95 = v89.characterData[#v89.characterData];
			return Vector2.new(v89.currentX + (v95.currentX + v95.width), v89.currentY);
		end;
		local v96 = nil;
		for v97, v98 in ipairs(v89.characterData) do
			if v98.graphemeStart <= v94 and v94 <= v98.graphemeEnd then
				v96 = v98;
				break;
			end;
		end;
		if not v96 then
			warn("Malformed character data encountered while finding character in chunk - this should never happen!");
			return Vector2.new(0, 0);
		end;
		return Vector2.new(v89.currentX + v96.currentX, v89.currentY);
	end;
	function v61.setColour(p30, p31)
		u7 = p31;
		for v99, v100 in pairs(u6) do
			v100:setColour(p31);
		end;
	end;
	function v61.setSize(p32, p33)
		u8 = p33;
		for v101, v102 in pairs(u6) do
			v102:setSize(p33);
		end;
	end;
	function v61.setHasShadow(p34, p35)
		u10 = p35;
		for v103, v104 in pairs(u6) do
			v104:setHasShadow(p35);
		end;
	end;
	function v61.setTransparency(p36, p37)
		u9 = p37;
		for v105, v106 in pairs(u6) do
			v106:setTransparency(p37);
		end;
	end;
	return v61;
end;
function v6.measureText(p38, p39, p40)
	local v107 = p38:createTextObject();
	v107:buildChunks(p39);
	v107:reflowChunks(p40);
	return Vector2.new(v107.textWidth, v107.textHeight);
end;
v6.measureText = v5(v6.measureText);
function v6.measureCharPosition(p41, p42, p43, p44, p45, p46)
	local v108 = p41:createTextObject();
	v108:buildChunks(p42);
	v108:reflowChunks(p44, p45, p46);
	return v108:getCharPosition(p43);
end;
v6.measureText = v5(v6.measureText);
v6.textLabelObjects = {};
function v6.connectToTextLabel(p47, p48)
	local v109 = p47:createTextObject();
	p47.textLabelObjects[p48] = v109;
	local v110 = false;
	local v111 = 0;
	local v112 = p48.Text;
	local v113 = p48.TextColor3;
	if p48:IsA("TextBox") and #v112 == 0 and not p48:IsFocused() then
		v112 = p48.PlaceholderText;
		v113 = p48.PlaceholderColor3;
	end;
	local v114 = Instance.new("Frame");
	v114.BackgroundTransparency = 1;
	v114.Parent = p48;
	local v115 = nil;
	if p48:IsA("TextBox") then
		v115 = Instance.new("Frame");
		v115.BorderSizePixel = 0;
		v115.ZIndex = 10;
		v115.Name = "VisualCaret";
		v115.Size = UDim2.new(0.125, 0, 1, 0);
		v115.Visible = false;
		v115.Parent = v114;
		local u20 = false;
		p48.Focused:Connect(function()
			if u20 then
				return;
			end;
			u20 = true;
			while wait(0.25) and v115.Parent and p48:IsFocused() do
				v115.Visible = not v115.Visible;			
			end;
			v115.Visible = false;
			u20 = false;
		end);
	end;
	local u21 = v112;
	local u22 = v113;
	local function u23()
		if not p48.TextWrapped then
			return;
		end;
		return p48.AbsoluteSize / (p48.TextSize / 8);
	end;
	local function u24()
		return v6.alignmentEnumMap[p48.TextXAlignment];
	end;
	local function u25()
		return v6.alignmentEnumMap[p48.TextYAlignment];
	end;
	p48:GetPropertyChangedSignal("Text"):Connect(function()
		if p48:IsA("TextBox") then
			if #u21 == 0 and not p48:IsFocused() then
				u21 = p48.PlaceholderText;
				u22 = p48.PlaceholderColor3;
			else
				u21 = p48.Text;
				u22 = p48.TextColor3;
			end;
			v115.BackgroundColor3 = u22;
		else
			u21 = p48.Text;
			u22 = p48.TextColor3;
		end;
		v109:setColour(u22);
		v109:buildChunks(u21);
		v109:reflowChunks(u23(), u24(), u25());
		if p48:IsA("TextBox") then
			local v116 = v109:getCharPosition(p48.CursorPosition);
			v115.Position = UDim2.new(v116.X / 8, 0, v116.Y / 8, 0);
		end;
	end);
	local u26 = false;
	local u27 = p48.TextSize;
	p48:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		if u26 then
			u27 = p48.AbsoluteSize.Y;
			v109:setSize(u27);
			v114.Size = UDim2.new(0, u27, 0, u27);
		end;
		if p48.TextWrapped then
			v109:reflowChunks(u23(), u24(), u25());
			if p48:IsA("TextBox") then
				local v117 = v109:getCharPosition(p48.CursorPosition);
				v115.Position = UDim2.new(v117.X / 8, 0, v117.Y / 8, 0);
			end;
		end;
	end);
	p48:GetPropertyChangedSignal("TextWrapped"):Connect(function()
		v109:reflowChunks(u23(), u24(), u25());
	end);
	p48:GetPropertyChangedSignal("TextSize"):Connect(function()
		if u26 then
			return;
		end;
		u27 = p48.TextSize;
		v109:setSize(u27);
		v114.Size = UDim2.new(0, u27, 0, u27);
		if p48.TextWrapped then
			v109:reflowChunks(u23(), u24(), u25());
			if p48:IsA("TextBox") then
				local v118 = v109:getCharPosition(p48.CursorPosition);
				v115.Position = UDim2.new(v118.X / 8, 0, v118.Y / 8, 0);
			end;
		end;
	end);
	p48:GetPropertyChangedSignal("TextColor3"):Connect(function()
		u22 = p48.TextColor3;
		if p48:IsA("TextBox") then
			if #u21 == 0 and not p48:IsFocused() then
				u22 = p48.PlaceholderColor3;
			end;
			v115.BackgroundColor3 = u22;
		end;
		v109:setColour(u22);
	end);
	p48:GetPropertyChangedSignal("TextXAlignment"):Connect(function()
		v109:reflowChunks(u23(), u24(), u25());
		if p48:IsA("TextBox") then
			local v119 = v109:getCharPosition(p48.CursorPosition);
			v115.Position = UDim2.new(v119.X / 8, 0, v119.Y / 8, 0);
		end;
		v114.Position = UDim2.new(u24(), 0, u25(), 0);
		v114.AnchorPoint = Vector2.new(u24(), u25());
	end);
	p48:GetPropertyChangedSignal("TextYAlignment"):Connect(function()
		v109:reflowChunks(u23(), u24(), u25());
		if p48:IsA("TextBox") then
			local v120 = v109:getCharPosition(p48.CursorPosition);
			v115.Position = UDim2.new(v120.X / 8, 0, v120.Y / 8, 0);
		end;
		v114.Position = UDim2.new(u24(), 0, u25(), 0);
		v114.AnchorPoint = Vector2.new(u24(), u25());
	end);
	if p48:IsA("TextBox") then
		p48:GetPropertyChangedSignal("CursorPosition"):Connect(function()
			local v121 = v109:getCharPosition(p48.CursorPosition);
			v115.Position = UDim2.new(v121.X / 8, 0, v121.Y / 8, 0);
		end);
		p48.Focused:Connect(function()
			u21 = p48.Text;
			u22 = p48.TextColor3;
			v115.BackgroundColor3 = u22;
			v109:setColour(u22);
			v109:buildChunks(u21);
			v109:reflowChunks(u23(), u24(), u25());
			local v122 = v109:getCharPosition(p48.CursorPosition);
			v115.Position = UDim2.new(v122.X / 8, 0, v122.Y / 8, 0);
		end);
		p48.FocusLost:Connect(function()
			l__RunService__3.RenderStepped:Wait();
			if #u21 == 0 then
				u21 = p48.PlaceholderText;
				u22 = p48.PlaceholderColor3;
				v109:setColour(u22);
				v109:buildChunks(u21);
				v109:reflowChunks(u23(), u24(), u25());
			end;
		end);
	end;
	local l__FontOptions__123 = p48:FindFirstChild("FontOptions");
	if l__FontOptions__123 then
		local l__HasShadow__124 = l__FontOptions__123:FindFirstChild("HasShadow");
		if l__HasShadow__124 then
			v110 = l__HasShadow__124.Value;
			local u28 = v110;
			l__HasShadow__124.Changed:Connect(function()
				u28 = l__HasShadow__124.Value;
				v109:setHasShadow(u28);
			end);
		end;
		local l__TextTransparency__125 = l__FontOptions__123:FindFirstChild("TextTransparency");
		if l__TextTransparency__125 then
			v111 = l__TextTransparency__125.Value;
			local u29 = v111;
			l__TextTransparency__125.Changed:Connect(function()
				u29 = l__TextTransparency__125.Value;
				v109:setTransparency(u29);
				if p48:IsA("TextBox") then
					v115.BackgroundTransparency = u29;
				end;
			end);
		end;
		local l__IsScaled__126 = l__FontOptions__123:FindFirstChild("IsScaled");
		if l__IsScaled__126 then
			u26 = l__IsScaled__126.value;
			l__IsScaled__126.Changed:Connect(function()
				if u26 then
					u27 = p48.AbsoluteSize.Y;
				else
					u27 = p48.TextSize;
				end;
				v109:setSize(u27);
				v114.Size = UDim2.new(0, u27, 0, u27);
				if p48.TextWrapped then
					v109:reflowChunks(u23(), u24(), u25());
					if p48:IsA("TextBox") then
						local v127 = v109:getCharPosition(p48.CursorPosition);
						v115.Position = UDim2.new(v127.X / 8, 0, v127.Y / 8, 0);
					end;
				end;
			end);
		end;
	end;
	p48.TextTransparency = 1;
	if u26 then
		u27 = p48.AbsoluteSize.Y;
	end;
	v114.Size = UDim2.new(0, u27, 0, u27);
	v109:buildChunks(u21);
	v109:reflowChunks(u23(), u24(), u25());
	v109:setSize(u27);
	v109:setColour(u22);
	v109:setTransparency(v111);
	v109:setHasShadow(v110);
	v114.Position = UDim2.new(u24(), 0, u25(), 0);
	v114.AnchorPoint = Vector2.new(u24(), u25());
	if p48:IsA("TextBox") then
		v115.BackgroundColor3 = u22;
		v115.BackgroundTransparency = v111;
	end;
	v109.rootFrame.Parent = v114;
	return v109;
end;
function v6.connectAllTextLabelsIn(p49, p50)
	for v128, v129 in pairs(p50:GetDescendants()) do
		if v129.Name == "FontOptions" then
			p49:connectToTextLabel(v129.Parent);
		end;
	end;
	p50.DescendantAdded:Connect(function(p51)
		if p51.Name == "FontOptions" then
			p49:connectToTextLabel(p51.Parent);
		end;
	end);
end;
return v6;
