-- Decompiled with the Synapse X Luau decompiler.

local u1 = {
	Font = {
		img = "rbxassetid://3108589584", 
		scale = 2
	}, 
	ScaleFont = {
		img = "rbxassetid://4130871993", 
		scale = 8
	}, 
	FontBreakout = {
		{"\000","☺","☻","♥","♦","♣","♠","•","◘","○","◙","♂","♀","♪","♫","☼"}, 
		{"►","◄","↕","‼","¶","§","▬","↨","↑","↓","→","←","∟","↔","▲","▼"}, 
		{" ","!",[[\]],"#","$","%","&","'","(",")","*","+",",","-",".","/"}, 
		{"0","1","2","3","4","5","6","7","8","9",":","","<","=",">","?"}, 
		{"@","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O"}, 
		{"P","Q","R","S","T","U","V","W","X","Y","Z","[",[[\]],"]","^","_"}, 
		{"`","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o"}, 
		{"p","q","r","s","t","u","v","w","x","y","z","{","|","}","~"},
	}, 
	FontWidth = {
		{64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64}, 
		{64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64}, 
		{16, 8 , 32, 40, 40, 48, 48, 16, 32, 32, 56, 40, 8 , 40, 8 , 40}, 
		{40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 8 , 8 , 32, 40, 32, 40},
		{48, 40, 40, 40, 40, 40, 40, 40, 40, 24, 40, 40, 40, 40, 40, 40}, 
		{40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 24, 40, 24, 40, 40},
		{16, 40, 40, 40, 40, 40, 32, 40, 40, 8 , 40, 32, 16, 40, 40, 40}, 
		{40, 40, 40, 40, 24, 40, 40, 40, 40, 40, 40, 32, 8 , 32, 48} 
	}, 
}
local ColorCode = {
	["0"] = { Color3.new(0, 0, 0), Color3.new(0, 0, 0) }, 
	["1"] = { Color3.fromRGB(0, 0, 170), Color3.fromRGB(0, 0, 42) }, 
	["2"] = { Color3.fromRGB(0, 170, 0), Color3.fromRGB(0, 42, 0) }, 
	["3"] = { Color3.fromRGB(0, 170, 170), Color3.fromRGB(0, 42, 42) }, 
	["4"] = { Color3.fromRGB(170, 0, 0), Color3.fromRGB(42, 0, 0) }, 
	["5"] = { Color3.fromRGB(170, 0, 170), Color3.fromRGB(42, 0, 42) }, 
	["6"] = { Color3.fromRGB(170, 170, 0), Color3.fromRGB(42, 42, 0) }, 
	["7"] = { Color3.fromRGB(170, 170, 170), Color3.fromRGB(42, 42, 42) }, 
	["8"] = { Color3.fromRGB(85, 85, 85), Color3.fromRGB(21, 21, 21) }, 
	["9"] = { Color3.fromRGB(85, 85, 255), Color3.fromRGB(21, 21, 63) }, 
	a = { Color3.fromRGB(85, 255, 85), Color3.fromRGB(21, 63, 21) }, 
	b = { Color3.fromRGB(85, 255, 255), Color3.fromRGB(21, 63, 63) }, 
	c = { Color3.fromRGB(255, 85, 85), Color3.fromRGB(63, 21, 21) }, 
	d = { Color3.fromRGB(255, 85, 255), Color3.fromRGB(63, 16, 63) }, 
	e = { Color3.fromRGB(255, 255, 85), Color3.fromRGB(63, 63, 21) }, 
	f = { Color3.fromRGB(255, 255, 255), Color3.fromRGB(63, 63, 63) }, 
}
local u3 = {}
local u4 = false
u1.CreateTextLetter = function(TextString,Color,Shadow,FontType)
	local l_FontType_l = FontType or u1.Font
	local l_Num1_l = 1
	local l_Num2_l = 1
	local l_FrontColor_l = Color[1]
	local VectorScale = l_FontType_l.scale * 8
	for v1 = 1, #u1.FontBreakout do
		for v2 = 1, #u1.FontBreakout[v1] do
			if u1.FontBreakout[v1][v2] == TextString then
				l_Num1_l = v2
				l_Num2_l = v1
				break
			end
		end
	end
	local MainText = Instance.new("ImageLabel")
	MainText.Size = UDim2.new(0, 16, 0, 16)
	MainText.Image = l_FontType_l.img
	MainText.ImageRectSize = Vector2.new(VectorScale, VectorScale)
	local v3,v4 = (l_Num1_l - 1) * VectorScale, (l_Num2_l - 1) * VectorScale
	MainText.ImageRectOffset = Vector2.new(v3, v4)
	MainText.ScaleType = "Fit"
	local v5 = tostring(16 / (64 / u1.FontWidth[l_Num2_l][l_Num1_l]))
	MainText.Name = v5
	MainText.BackgroundTransparency = 1
	MainText.ImageColor3 = l_FrontColor_l
	if Shadow then
		local l_BackColor_l = Color[2]
		local ShadowText = MainText:Clone()
		ShadowText.Parent = MainText
		ShadowText.Position = UDim2.new(0, -2, 0, -2)
		ShadowText.ImageColor3 = l_BackColor_l
		MainText.ZIndex = MainText.ZIndex + 1
	end
	return MainText
end
function u1.CreateTextLabel(TextString, Color, IfShadow, IfFont, EndingLine)
	local v1 = u1
	local v2 = v1.ScaleFont
	local v3 = Vector2.new(#TextString*12,#TextString)
	local l_DefaultColor_l = ColorCode[Color] or ColorCode.f
	if IfFont then
		v1 = u1
		v2 = v1.Font
	end
	local u11 = false
	local u12 = ColorCode.f
	local l_HolderTextFrame_l = Instance.new("Frame")
	local l_RTS1_l = 0
	local l_RTS2_l = 0
	local function CreateLetter(p22, p23)
		if not p23 and p22 == "&" then
			u11 = true
			return
		end
		if not p23 and u11 then
			u12 = ColorCode[string.lower(p22)]
			u11 = false
			if not u12 then
				u12 = ColorCode.f
				CreateLetter("&", true)
				CreateLetter(p22)
				return
			end
		else
			local v30 = u1.CreateTextLetter(p22, l_DefaultColor_l, IfShadow)
			v30.Parent = l_HolderTextFrame_l
			if not p23 and v3 and v3.X < l_RTS1_l + tonumber(v30.Name) then
				l_RTS1_l = 0
				l_RTS2_l = l_RTS2_l + 16 + 2
			end
			v30.Position = UDim2.new(0, l_RTS1_l + 2, 0, l_RTS2_l + 2)
			l_RTS1_l = l_RTS1_l + tonumber(v30.Name) + 2
		end
	end
	for v32, v33 in utf8.codes(TextString) do
		CreateLetter((utf8.char(v33)))
	end
	if u11 then
		CreateLetter("&", true)
	end
	if EndingLine then
		local v34 = u1.CreateLetter2("_", u12, v2)
		v34.Parent = l_HolderTextFrame_l
		v34.Position = UDim2.new(0, l_RTS1_l + 2, 0, l_RTS2_l + 2)
		l_RTS1_l = l_RTS1_l + tonumber(v34.Name) + 2
		u3[v34] = true
		u4 = false
	end
	l_HolderTextFrame_l.Size = UDim2.new(0, l_RTS1_l, 0, l_RTS2_l + 16)
	l_HolderTextFrame_l.BackgroundTransparency = 1
	return l_HolderTextFrame_l
end
spawn(function()
	local function Tick()
		u4 = not u4
		for v42, v43 in pairs(u3) do
			if v42 and v42.Parent then
				v42.Visible = u4
			end
		end
	end
	while wait(0.5) do
		Tick()	
	end
end)
return u1
