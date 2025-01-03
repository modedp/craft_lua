local l__RunService__1 = game:GetService("RunService");
local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
return function(p1)
	local v1 = {};
	p1:registerView("Loading", {
		showMouse = false
	});
	v1.isLoading = true;
	local l__gui__3 = p1.views.Loading.gui;
	function v1.setStep(p2, p3)
		l__gui__3.Step.Text = p3;
	end;
	local u4 = -1;
	function v1.setProgress(p4, p5)
		local l__Progress__2 = l__gui__3.Progress;
		u4 = p5;
		if p5 >= 0 then
			l__Progress__2.Bar.Size = UDim2.new(p5, 0, 1, 0);
			l__Progress__2.Bar.Position = UDim2.new(0, 0, 0, 0);
		end;
	end;
	l__RunService__1.RenderStepped:Connect(function()
		local l__Progress__3 = l__gui__3.Progress;
		if u4 < 0 then
			l__Progress__3.Bar.Position = UDim2.new(tick() % 1.7 - 0.5, 0, 0, 0);
			l__Progress__3.Bar.Size = UDim2.new(0.5, 0, 1, 0);
		end;
	end);
	v1:setStep(l__ReplicatedStorage__2.Remote.Loading.Step.Value);
	l__ReplicatedStorage__2.Remote.Loading.Step.Changed:Connect(function()
		v1:setStep(l__ReplicatedStorage__2.Remote.Loading.Step.Value);
	end);
	v1:setProgress(l__ReplicatedStorage__2.Remote.Loading.Progress.Value);
	l__ReplicatedStorage__2.Remote.Loading.Progress.Changed:Connect(function()
		v1:setProgress(l__ReplicatedStorage__2.Remote.Loading.Progress.Value);
	end);
	return v1;
end;
