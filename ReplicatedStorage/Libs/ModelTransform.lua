local v1 = {};
v1.__index = v1;
function v1.new(p1)
	local v2 = setmetatable({}, v1);
	v2.model = p1;
	v2.cframe = CFrame.new();
	v2.originCFrames = {};
	if p1:IsA("BasePart") then
		v2.originCFrames[p1] = p1.CFrame;
	end;
	for v3, v4 in pairs(p1:GetDescendants()) do
		if v4:IsA("BasePart") then
			v2.originCFrames[v4] = v4.CFrame;
		end;
	end;
	p1.DescendantAdded:Connect(function(p2)
		if p2:IsA("BasePart") then
			v2.originCFrames[p2] = p2.CFrame;
			p2.CFrame = v2.cframe * p2.CFrame;
		end;
	end);
	p1.DescendantRemoving:Connect(function(p3)
		if p3:IsA("BasePart") then
			v2.originCFrames[p3] = nil;
		end;
	end);
	return v2;
end;
function v1.setTransform(p4, p5)
	p4.cframe = p5;
	if p4.model:IsA("BasePart") then
		p4.model.CFrame = p5 * p4.originCFrames[p4.model];
	end;
	for v5, v6 in pairs(p4.model:GetDescendants()) do
		if p4.originCFrames[v6] then
			v6.CFrame = p5 * p4.originCFrames[v6];
		end;
	end;
end;
return v1;
