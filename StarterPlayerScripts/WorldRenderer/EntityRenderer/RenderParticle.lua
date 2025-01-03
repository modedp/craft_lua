return {
	createEntityModel = function(p1, p2, p3)
		local v1 = Instance.new("Part");
		v1.Name = "ParticlePart";
		v1.Size = Vector3.new(0.05, 0.05, 0.05);
		v1.Anchored = true;
		v1.Transparency = 1;
		v1.CanCollide = false;
		v1.Locked = true;
		local v2 = Instance.new("BillboardGui");
		v2.Name = "ParticleGui";
		v2.Active = false;
		v2.LightInfluence = 1;
		v2.Size = UDim2.new(4, 0, 4, 0);
		v2.ZIndexBehavior = "Sibling";
		v2.ClipsDescendants = false;
		v2.ResetOnSpawn = false;
		v2.Adornee = v1;
		p2:createParticleModel(v2);
		v2.Parent = v1;
		v1.Parent = p3;
	end, 
	updateEntityModel = function(p4, p5, p6, p7)
		p7.ParticlePart.CFrame = p6;
		p5:updateParticleModel(p7.ParticlePart.ParticleGui);
	end, 
	destroyEntityModel = function(p8, p9, p10)
		p10.ParticlePart:Destroy();
	end
};
