--[[
	AABB.lua
	Represents an Axis-Aligned Bounding Box (AABB) in 3D space.
	Provides methods for creation, manipulation, and intersection testing.
	Includes an object pooling mechanism for potentially reusing common AABB instances.
]]

local AABB = {}
AABB.__index = AABB

-- Store pooled AABB instances to reduce garbage collection pressure for common boxes.
AABB.pooledAABBs = {}

-- Private helper function to generate a unique string key for pooling based on coordinates.
local function getPoolKey(minX, minY, minZ, maxX, maxY, maxZ)
	-- Use a consistent format for the key. Precision might matter depending on use case.
	return ("%.4f,%.4f,%.4f|%.4f,%.4f,%.4f"):format(minX, minY, minZ, maxX, maxY, maxZ)
end

--[[
	Constructs a new AABB instance.
	Ensures that min coordinates are less than or equal to max coordinates.

	@param minX (number): Minimum X coordinate.
	@param minY (number): Minimum Y coordinate.
	@param minZ (number): Minimum Z coordinate.
	@param maxX (number): Maximum X coordinate.
	@param maxY (number): Maximum Y coordinate.
	@param maxZ (number): Maximum Z coordinate.
	@return (AABB): The newly created AABB object.
]]
function AABB.new(minX, minY, minZ, maxX, maxY, maxZ)
	-- Ensure min <= max for each axis
	if maxX < minX then minX, maxX = maxX, minX end
	if maxY < minY then minY, maxY = maxY, minY end
	if maxZ < minZ then minZ, maxZ = maxZ, minZ end

	local self = setmetatable({}, AABB)
	self.minX = minX
	self.minY = minY
	self.minZ = minZ
	self.maxX = maxX
	self.maxY = maxY
	self.maxZ = maxZ
	self.pooled = false -- Indicates if this instance came from the pool (and shouldn't be mutated)
	return self
end

--[[
	Retrieves an AABB from the pool or creates a new pooled instance if one doesn't exist.
	Pooled AABBs should generally be treated as immutable.

	@param minX (number): Minimum X coordinate.
	@param minY (number): Minimum Y coordinate.
	@param minZ (number): Minimum Z coordinate.
	@param maxX (number): Maximum X coordinate.
	@param maxY (number): Maximum Y coordinate.
	@param maxZ (number): Maximum Z coordinate.
	@return (AABB): A pooled AABB object.
]]
function AABB.fromPool(minX, minY, minZ, maxX, maxY, maxZ)
	-- Ensure min <= max for consistent pooling keys
	if maxX < minX then minX, maxX = maxX, minX end
	if maxY < minY then minY, maxY = maxY, minY end
	if maxZ < minZ then minZ, maxZ = maxZ, minZ end

	local key = getPoolKey(minX, minY, minZ, maxX, maxY, maxZ)
	local existing = AABB.pooledAABBs[key]

	if existing then
		return existing
	end

	-- Create a new one, mark as pooled, and store it
	local newPooled = AABB.new(minX, minY, minZ, maxX, maxY, maxZ)
	newPooled.pooled = true
	AABB.pooledAABBs[key] = newPooled
	return newPooled
end

--[[
	Checks if the AABB has zero volume (i.e., it's a point, line, or plane).
	Original logic was flawed; this version checks if *any* dimension has zero size.

	@return (boolean): True if the AABB has zero volume, false otherwise.
]]
function AABB:IsEmpty()
	-- An AABB is considered "empty" or degenerate if any dimension has zero length.
	return self.minX == self.maxX or self.minY == self.maxY or self.minZ == self.maxZ
end

--[[
	Creates a *new* AABB translated by the given vector components.

	@param dx (number): Translation amount along the X-axis.
	@param dy (number): Translation amount along the Y-axis.
	@param dz (number): Translation amount along the Z-axis.
	@return (AABB): A new, translated AABB instance.
]]
function AABB:Translate(dx, dy, dz)
	local newMinX = self.minX + dx
	local newMinY = self.minY + dy
	local newMinZ = self.minZ + dz
	local newMaxX = self.maxX + dx
	local newMaxY = self.maxY + dy
	local newMaxZ = self.maxZ + dz

	if self.pooled then
		return AABB.fromPool(newMinX, newMinY, newMinZ, newMaxX, newMaxY, newMaxZ)
	else
		return AABB.new(newMinX, newMinY, newMinZ, newMaxX, newMaxY, newMaxZ)
	end
end

--[[
	*Modifies* this AABB instance by translating it by the given vector components.
	Warns and does nothing if the AABB is pooled (pooled instances should be immutable).

	@param dx (number): Translation amount along the X-axis.
	@param dy (number): Translation amount along the Y-axis.
	@param dz (number): Translation amount along the Z-axis.
	@return (AABB): Returns self after modification (or unmodified if pooled).
]]
function AABB:Offset(dx, dy, dz)
	if self.pooled then
		warn("AABB:Offset: Attempting to modify a pooled AABB. Operation ignored.")
		return self -- Return self without changes
	end

	self.minX = self.minX + dx
	self.maxX = self.maxX + dx
	self.minY = self.minY + dy
	self.maxY = self.maxY + dy
	self.minZ = self.minZ + dz
	self.maxZ = self.maxZ + dz
	return self
end

--[[
	Creates a *new* AABB expanded outward based on the direction vector.
	Positive components expand the max bounds, negative components expand the min bounds.

	@param direction (Vector3): The vector indicating the expansion direction and magnitude.
	@return (AABB): A new, expanded AABB instance.
]]
function AABB:DirectionalExpand(direction)
	local newMinX = self.minX
	local newMaxX = self.maxX
	local newMinY = self.minY
	local newMaxY = self.maxY
	local newMinZ = self.minZ
	local newMaxZ = self.maxZ

	if direction.X < 0 then
		newMinX = newMinX + direction.X -- Adding negative expands min
	elseif direction.X > 0 then
		newMaxX = newMaxX + direction.X -- Adding positive expands max
	end

	if direction.Y < 0 then
		newMinY = newMinY + direction.Y
	elseif direction.Y > 0 then
		newMaxY = newMaxY + direction.Y
	end

	if direction.Z < 0 then
		newMinZ = newMinZ + direction.Z
	elseif direction.Z > 0 then
		newMaxZ = newMaxZ + direction.Z
	end

	if self.pooled then
		return AABB.fromPool(newMinX, newMinY, newMinZ, newMaxX, newMaxY, newMaxZ)
	else
		return AABB.new(newMinX, newMinY, newMinZ, newMaxX, newMaxY, newMaxZ)
	end
end

--[[
	Creates a *new* AABB scaled relative to the origin (0,0,0).

	@param scaleX (number): Scaling factor along the X-axis.
	@param scaleY (number): Scaling factor along the Y-axis.
	@param scaleZ (number): Scaling factor along the Z-axis.
	@return (AABB): A new, scaled AABB instance.
]]
function AABB:Scale(scaleX, scaleY, scaleZ)
	local newMinX = self.minX * scaleX
	local newMinY = self.minY * scaleY
	local newMinZ = self.minZ * scaleZ
	local newMaxX = self.maxX * scaleX
	local newMaxY = self.maxY * scaleY
	local newMaxZ = self.maxZ * scaleZ

	-- Scaling might invert min/max if scale factors are negative, so re-check
	if newMaxX < newMinX then newMinX, newMaxX = newMaxX, newMinX end
	if newMaxY < newMinY then newMinY, newMaxY = newMaxY, newMinY end
	if newMaxZ < newMinZ then newMinZ, newMaxZ = newMaxZ, newMinZ end

	if self.pooled then
		return AABB.fromPool(newMinX, newMinY, newMinZ, newMaxX, newMaxY, newMaxZ)
	else
		return AABB.new(newMinX, newMinY, newMinZ, newMaxX, newMaxY, newMaxZ)
	end
end

--[[
	Creates a *new* AABB scaled uniformly relative to the origin (0,0,0).

	@param scaleFactor (number): The uniform scaling factor for all axes.
	@return (AABB): A new, uniformly scaled AABB instance.
]]
function AABB:UniformScale(scaleFactor)
	return self:Scale(scaleFactor, scaleFactor, scaleFactor)
end

--[[
	Creates a *new* AABB representing the intersection (overlap) of this AABB and another.
	If the boxes do not overlap, the resulting AABB will have min > max for at least one axis.

	@param other (AABB): The other AABB to intersect with.
	@return (AABB): A new AABB representing the intersection.
]]
function AABB:Intersection(other)
	local intersectMinX = math.max(self.minX, other.minX)
	local intersectMinY = math.max(self.minY, other.minY)
	local intersectMinZ = math.max(self.minZ, other.minZ)
	local intersectMaxX = math.min(self.maxX, other.maxX)
	local intersectMaxY = math.min(self.maxY, other.maxY)
	local intersectMaxZ = math.min(self.maxZ, other.maxZ)

	-- Note: If no overlap, min > max on some axis. Caller might need to check IsEmpty or validity.
	if self.pooled then
		-- Intersection might result in a non-pooled size, so use .new unless exact match found
		return AABB.fromPool(intersectMinX, intersectMinY, intersectMinZ, intersectMaxX, intersectMaxY, intersectMaxZ)
	else
		return AABB.new(intersectMinX, intersectMinY, intersectMinZ, intersectMaxX, intersectMaxY, intersectMaxZ)
	end
end

--[[
	Creates a *new* AABB that encompasses both this AABB and another (their union).

	@param other (AABB): The other AABB to include in the bounds.
	@return (AABB): A new AABB encompassing both original AABBs.
]]
function AABB:Extents(other)
	local extentMinX = math.min(self.minX, other.minX)
	local extentMinY = math.min(self.minY, other.minY)
	local extentMinZ = math.min(self.minZ, other.minZ)
	local extentMaxX = math.max(self.maxX, other.maxX)
	local extentMaxY = math.max(self.maxY, other.maxY)
	local extentMaxZ = math.max(self.maxZ, other.maxZ)

	if self.pooled then
		return AABB.fromPool(extentMinX, extentMinY, extentMinZ, extentMaxX, extentMaxY, extentMaxZ)
	else
		return AABB.new(extentMinX, extentMinY, extentMinZ, extentMaxX, extentMaxY, extentMaxZ)
	end
end

--[[
	Checks if a 3D point lies within or on the boundary of this AABB.

	@param point (Vector3): The point to check.
	@return (boolean): True if the point is inside or on the boundary, false otherwise.
]]
function AABB:IntersectsPoint(point)
	-- More readable and efficient check than nested ifs
	return point.X >= self.minX and point.X <= self.maxX and
	       point.Y >= self.minY and point.Y <= self.maxY and
	       point.Z >= self.minZ and point.Z <= self.maxZ
end

--[[
	Checks if a ray intersects with this AABB using the Slab method.

	@param rayOrigin (Vector3): The starting point of the ray.
	@param rayDirection (Vector3): The direction vector of the ray (should be normalized for correct distance).
	@return (boolean): True if the ray intersects, false otherwise.
	@return (Vector3?): The point of intersection (if intersects), nil otherwise.
	@return (Vector3?): The surface normal at the point of intersection (if intersects), nil otherwise.
]]
function AABB:IntersectsRay(rayOrigin, rayDirection)
	-- If the origin is inside the box, it's an immediate intersection.
	if self:IntersectsPoint(rayOrigin) then
		-- Normal is tricky here, could be considered pointing inward from origin?
		-- Or maybe return nil normal? For simplicity, return origin and nil normal.
		return true, rayOrigin, nil
	end

	-- Avoid division by zero if ray is axis-aligned
	local invDirX = rayDirection.X == 0 and math.huge or 1 / rayDirection.X
	local invDirY = rayDirection.Y == 0 and math.huge or 1 / rayDirection.Y
	local invDirZ = rayDirection.Z == 0 and math.huge or 1 / rayDirection.Z

	-- Calculate intersection distances with the planes forming the AABB
	local t1 = (self.minX - rayOrigin.X) * invDirX
	local t2 = (self.maxX - rayOrigin.X) * invDirX
	local t3 = (self.minY - rayOrigin.Y) * invDirY
	local t4 = (self.maxY - rayOrigin.Y) * invDirY
	local t5 = (self.minZ - rayOrigin.Z) * invDirZ
	local t6 = (self.maxZ - rayOrigin.Z) * invDirZ

	-- Find the maximum of the minimum intersection times (entry point)
	local tmin = math.max(math.max(math.min(t1, t2), math.min(t3, t4)), math.min(t5, t6))
	-- Find the minimum of the maximum intersection times (exit point)
	local tmax = math.min(math.min(math.max(t1, t2), math.max(t3, t4)), math.max(t5, t6))

	-- If tmax < 0, ray is intersecting AABB behind the origin
	if tmax < 0 then
		return false, nil, nil
	end

	-- If tmin > tmax, ray doesn't intersect AABB
	if tmin > tmax then
		return false, nil, nil
	end

	-- Intersection point
	local intersectionPoint = rayOrigin + rayDirection * tmin

	-- Calculate the normal based on which plane was hit at tmin
	local normal = Vector3.zero
	local epsilon = 0.0001 -- Tolerance for floating point comparison
	if math.abs(tmin - t1) < epsilon then normal = Vector3.new(-1, 0, 0)
	elseif math.abs(tmin - t2) < epsilon then normal = Vector3.new(1, 0, 0)
	elseif math.abs(tmin - t3) < epsilon then normal = Vector3.new(0, -1, 0)
	elseif math.abs(tmin - t4) < epsilon then normal = Vector3.new(0, 1, 0)
	elseif math.abs(tmin - t5) < epsilon then normal = Vector3.new(0, 0, -1)
	elseif math.abs(tmin - t6) < epsilon then normal = Vector3.new(0, 0, 1)
	end

	return true, intersectionPoint, normal
end


--[[
	Checks if this AABB overlaps with another AABB.

	@param other (AABB): The other AABB to check for intersection.
	@return (boolean): True if the AABBs intersect, false otherwise.
]]
function AABB:Intersects(other)
	-- Check for non-overlap on each axis. If no separating axis is found, they intersect.
	local noOverlapX = self.maxX <= other.minX or self.minX >= other.maxX
	local noOverlapY = self.maxY <= other.minY or self.minY >= other.maxY
	local noOverlapZ = self.maxZ <= other.minZ or self.minZ >= other.maxZ

	return not (noOverlapX or noOverlapY or noOverlapZ)
end

--[[
	Creates a *new*, non-pooled copy of this AABB.

	@return (AABB): A new AABB instance with the same dimensions.
]]
function AABB:Clone()
	return AABB.new(self.minX, self.minY, self.minZ, self.maxX, self.maxY, self.maxZ)
end

--[[
	Calculates the maximum distance this AABB ('self') can move along the X-axis
	in the direction specified by 'deltaX' before colliding with the 'other' AABB.

	@param other (AABB): The AABB to check collision against.
	@param deltaX (number): The intended movement distance along X.
	@return (number): The adjusted deltaX, clamped to prevent collision.
]]
function AABB:CalculateXOffset(other, deltaX)
	-- If no overlap on Y or Z planes, they can't collide along X
	if self.maxY <= other.minY or self.minY >= other.maxY or self.maxZ <= other.minZ or self.minZ >= other.maxZ then
		return deltaX
	end

	-- Moving right (positive deltaX)
	if deltaX > 0 and self.maxX <= other.minX then
		local gap = other.minX - self.maxX
		if gap < deltaX then
			-- Clamp movement just before collision (small epsilon to avoid floating point issues)
			deltaX = math.max(0, gap - 0.0001)
		end
	-- Moving left (negative deltaX)
	elseif deltaX < 0 and self.minX >= other.maxX then
		local gap = other.maxX - self.minX -- Gap will be negative
		if gap > deltaX then -- Compare negative numbers
			-- Clamp movement just before collision
			deltaX = math.min(0, gap + 0.0001)
		end
	end

	return deltaX
end

--[[
	Calculates the maximum distance this AABB ('self') can move along the Y-axis
	in the direction specified by 'deltaY' before colliding with the 'other' AABB.

	@param other (AABB): The AABB to check collision against.
	@param deltaY (number): The intended movement distance along Y.
	@return (number): The adjusted deltaY, clamped to prevent collision.
]]
function AABB:CalculateYOffset(other, deltaY)
	-- If no overlap on X or Z planes, they can't collide along Y
	if self.maxX <= other.minX or self.minX >= other.maxX or self.maxZ <= other.minZ or self.minZ >= other.maxZ then
		return deltaY
	end

	-- Moving up (positive deltaY)
	if deltaY > 0 and self.maxY <= other.minY then
		local gap = other.minY - self.maxY
		if gap < deltaY then
			deltaY = math.max(0, gap - 0.0001)
		end
	-- Moving down (negative deltaY)
	elseif deltaY < 0 and self.minY >= other.maxY then
		local gap = other.maxY - self.minY -- Negative
		if gap > deltaY then
			deltaY = math.min(0, gap + 0.0001)
		end
	end

	return deltaY
end

--[[
	Calculates the maximum distance this AABB ('self') can move along the Z-axis
	in the direction specified by 'deltaZ' before colliding with the 'other' AABB.

	@param other (AABB): The AABB to check collision against.
	@param deltaZ (number): The intended movement distance along Z.
	@return (number): The adjusted deltaZ, clamped to prevent collision.
]]
function AABB:CalculateZOffset(other, deltaZ)
	-- If no overlap on X or Y planes, they can't collide along Z
	if self.maxX <= other.minX or self.minX >= other.maxX or self.maxY <= other.minY or self.minY >= other.maxY then
		return deltaZ
	end

	-- Moving forward (positive deltaZ)
	if deltaZ > 0 and self.maxZ <= other.minZ then
		local gap = other.minZ - self.maxZ
		if gap < deltaZ then
			deltaZ = math.max(0, gap - 0.0001)
		end
	-- Moving backward (negative deltaZ)
	elseif deltaZ < 0 and self.minZ >= other.maxZ then
		local gap = other.maxZ - self.minZ -- Negative
		if gap > deltaZ then
			deltaZ = math.min(0, gap + 0.0001)
		end
	end

	return deltaZ
end
return AABB
