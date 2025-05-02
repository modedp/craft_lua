--[[
	Entity.lua
	Base class for all entities within the game world.
	Handles position, movement, collision, updates, and replication.
]]

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Libraries
local Class = require(ReplicatedStorage.Libs.Class)
local AABB = require(ReplicatedStorage.Libs.AABB)
local UUID = require(ReplicatedStorage.Libs.UUID)

-- Modules (Load BlockManager synchronously, assuming no circular dependency issues)
local BlockManager = require(ReplicatedStorage.Block)
--[[
	Note: Original code used task.spawn to load Block module, potentially to handle
	load order or circular dependencies. Changed to synchronous require for simplicity.
	If issues arise, revert to:
	local BlockManager = nil
	task.spawn(function()
		BlockManager = require(ReplicatedStorage.Block)
	end)
	Ensure BlockManager is loaded before use in moveEntity if using task.spawn.
]]

-- Create the Entity class
local Entity = Class()
Entity.entities = {} -- Registry for different entity types

-- Static method to register a new entity type
function Entity.registerEntity(entityTypeId, entityModule)
	--[[
		Registers an entity class with a specific ID.
		Args:
			entityTypeId (number): The unique ID for this entity type.
			entityModule (ModuleScript): The module script containing the entity's class definition.
		Returns:
			table: The registered entity class.
	]]
	local entityClass = require(entityModule)(Entity) -- Pass base Entity class for inheritance
	entityClass.entityID = entityTypeId
	Entity.entities[entityTypeId] = entityClass
	return entityClass
end

-- Constructor for new Entity instances
function Entity:constructor(world, x, y, z)
	--[[
		Initializes a new entity instance.
		Args:
			world (World): The world instance this entity belongs to.
			x (number): Initial X position.
			y (number): Initial Y position.
			z (number): Initial Z position.
	]]
	self.world = world
	self.uuid = UUID() -- Unique identifier for this specific entity instance

	-- Position and Rotation
	self.x = x
	self.y = y
	self.z = z
	self.yaw = 0 -- Horizontal rotation
	self.pitch = 0 -- Vertical rotation
	self.renderYawOffset = 0 -- Used for rendering, separate from physics yaw

	-- Previous State (for interpolation and physics)
	self.prevX = x
	self.prevY = y
	self.prevZ = z
	self.prevYaw = 0
	self.prevPitch = 0
	self.prevRenderYawOffset = 0

	-- Velocity
	self.xVel = 0
	self.yVel = 0
	self.zVel = 0

	-- Physics State
	self.onGround = false
	self.isCollidedHorz = false -- Collided horizontally
	self.isCollidedVert = false -- Collided vertically
	self.isCollided = false -- Collided horizontally or vertically
	self.inWater = false
	self.fallDistance = 0
	self.noClip = false -- If true, ignores collision
	self.isSneaking = false
	self.doSliding = true -- Whether the entity slides along walls
	self.stepHeight = 0 -- How high the entity can step up automatically
	self.yOffset = 0 -- Vertical offset of the collision box origin from the entity's y position
	self.ySize = 0 -- ??? Seems related to vertical movement/bobbing, needs clarification
	self.prevYSize = 0

	-- Entity State
	self.dead = false
	self.ticksExisted = 0
	self.addedToWorld = false -- Flag indicating if added to the world simulation

	-- Replication State (for networking)
	self.isRemote = false -- If true, this entity is controlled by a remote client/server
	self.isReplicating = false -- If true, this entity's state is being sent over the network
	self.lastReplicateTime = 0 -- Timestamp of the last received network update

	-- Movement Properties
	self.entityWalks = true -- Does this entity produce walking sounds/effects?
	self.preventEntitySpawning = true -- Does this entity prevent other entities spawning nearby?

	-- Rendering/Animation State
	self.renderDistanceWalked = 0
	self.nextStepDistance = 1 -- Counter used for step sounds
	self.renderMoveBobbing = 0 -- View bobbing amount due to movement
	self.renderFallBobbing = 0 -- View bobbing amount due to falling
	self.prevRenderDistanceWalked = 0
	self.prevRenderMoveBobbing = 0
	self.prevRenderFallBobbing = 0

	-- Collision Box (initialized later)
	self.collisionBox = nil

	self:onInit() -- Call subclass initialization hook
end

--[[ Core Methods ]]

-- Get the width/depth size of the entity (assumes square base)
function Entity:getSize()
	--[[ Returns (number): The width/depth of the entity. ]]
	return 1 -- Default size
end

-- Get the height of the entity
function Entity:getHeight()
	--[[ Returns (number): The height of the entity. ]]
	return 1 -- Default height
end

-- Calculate and return the entity's current collision bounding box
function Entity:getCollisionBox()
	--[[ Returns (AABB): The entity's world-space collision box. ]]
	local halfSize = self:getSize() / 2
	-- Note: Y position is adjusted by yOffset for the collision box calculation
	self.collisionBox = AABB.new(
		self.x - halfSize,
		self.y - self.yOffset,
		self.z - halfSize,
		self.x + halfSize,
		self.y - self.yOffset + self:getHeight(),
		self.z + halfSize
	)
	return self.collisionBox
end

-- Mark the entity as dead, scheduling it for removal
function Entity:markDead()
	self.dead = true
end

-- Immediately kill the entity (marks as dead)
function Entity:kill()
	self:markDead()
end

--[[ Update Loop ]]

-- Main update function called every tick by the world
function Entity:update()
	self:onEntityUpdate()
end

-- Core entity update logic
function Entity:onEntityUpdate()
	self.ticksExisted = self.ticksExisted + 1

	-- Store previous state for interpolation/physics
	self.prevRenderDistanceWalked = self.renderDistanceWalked
	self.prevX = self.x
	self.prevY = self.y
	self.prevYSize = self.ySize -- ??? Still unclear what ySize represents
	self.prevZ = self.z
	self.prevYaw = self.yaw
	self.prevPitch = self.pitch
	self.prevRenderYawOffset = self.renderYawOffset

	-- Handle environmental effects (water)
	if self:handleWaterMovement() then
		if not self.inWater then -- Just entered water
			-- Play splash sound based on velocity
			local impactSpeed = math.sqrt(self.xVel^2 * 0.2 + self.yVel^2 + self.zVel^2 * 0.2) * 0.2
			if impactSpeed > 1 then impactSpeed = 1 end
			self.world:playSoundAtEntity(self, "random.splash", impactSpeed, 1 + (math.random() - math.random()) * 0.4)

			-- Spawn splash and bubble particles
			local particleCount = 1 + self:getSize() * 20
			for _ = 1, particleCount do
				local randX = self.x + (math.random() * 2 - 1) * self:getSize()
				local randZ = self.z + (math.random() * 2 - 1) * self:getSize()
				local bubbleY = math.floor(self.y) + 1 -- Bubbles start slightly above floor
				self.world:spawnLocalEntity(Entity.particleBubble, randX, bubbleY, randZ, self.xVel, self.yVel - math.random() * 0.2, self.zVel)
				self.world:spawnLocalEntity(Entity.particleSplash, randX, bubbleY, randZ, self.xVel, self.yVel, self.zVel) -- Splashes use current Y vel
			end

			self.fallDistance = 0 -- Reset fall distance upon entering water
			self.inWater = true
		end
	else
		self.inWater = false -- Not in water this tick
	end

	-- Kill entity if it falls into the void
	if self.y < -64 then
		self:kill()
	end
end

--[[ Movement and Collision ]]

-- Check if the entity is currently in water
function Entity:handleWaterMovement()
	--[[ Returns (boolean): True if the entity's collision box intersects water. ]]
	local isInWater = self.world:isWaterInAABB(self:getCollisionBox())
	-- Ensure inWater flag is updated even if already true
	-- self.inWater = isInWater -- Redundant assignment, handled in onEntityUpdate
	return isInWater
end

-- Check if the entity is currently in lava
function Entity:handleLavaMovement()
	--[[ Returns (boolean): True if the entity's collision box intersects lava. ]]
	return self.world:isLavaInAABB(self:getCollisionBox())
end

-- Apply movement input when flying (ignores collision)
function Entity:moveFlying(strafe, vertical, forward)
	--[[
		Applies movement based on input relative to the entity's yaw, typically used when flying.
		Args:
			strafe (number): Sideways movement input.
			vertical (number): Up/down movement input (unused in original, but kept for signature).
			forward (number): Forward/backward movement input.
	]]
	local horizontalSpeed = math.sqrt(strafe^2 + forward^2)
	if horizontalSpeed < 0.01 then return end -- Ignore tiny movements

	-- Normalize horizontal movement if necessary (original code logic)
	if horizontalSpeed < 1 then horizontalSpeed = 1 end

	local moveScale = forward / horizontalSpeed -- Original code used 'p23' (forward) here, seems odd? Should it be a speed factor? Assuming 'forward' is intended magnitude.
	-- Re-scaling based on original logic:
	strafe = strafe * moveScale
	forward = forward * moveScale -- This seems to scale based on the 'forward' component, might need review based on intended behavior.

	local sinYaw = math.sin(math.rad(self.yaw))
	local cosYaw = math.cos(math.rad(self.yaw))

	-- Apply velocity changes based on yaw
	self.xVel = self.xVel + (strafe * cosYaw - forward * sinYaw)
	self.zVel = self.zVel + (forward * cosYaw + strafe * sinYaw)
end

-- Move the entity by a delta amount, handling collisions
function Entity:moveEntity(deltaX, deltaY, deltaZ)
	--[[
		Moves the entity by the given delta vector, resolving collisions with the world.
		Updates position, velocity, and collision state flags.
		Args:
			deltaX (number): Change in X position.
			deltaY (number): Change in Y position.
			deltaZ (number): Change in Z position.
	]]
	if self.noClip then -- Skip collision if noClip is enabled
		self.x = self.x + deltaX
		self.y = self.y + deltaY
		self.z = self.z + deltaZ
		self:getCollisionBox() -- Update collision box position even if not colliding
		return
	end

	-- Store original inputs and position
	local originalY = self.y
	local inputDeltaX = deltaX
	local inputDeltaZ = deltaZ
	local currentAABB = self:getCollisionBox()
	local initialAABB = currentAABB:Clone() -- For step-up logic

	local isSneakingAndOnGround = self.onGround and self.isSneaking

	-- Sneaking logic: Prevent moving off edges
	if isSneakingAndOnGround then
		local stepCheckDist = 0.05
		-- Check X direction
		while deltaX ~= 0 and #self.world:getCollidingAABBs(self, currentAABB:Translate(deltaX, -1, 0)) == 0 do
			if deltaX < stepCheckDist and deltaX >= -stepCheckDist then
				deltaX = 0
			else
				deltaX = deltaX - math.sign(deltaX) * stepCheckDist
			end
			inputDeltaX = deltaX -- Update inputDeltaX to reflect adjusted deltaX
		end
		self.xVel = 0 -- Stop horizontal velocity if blocked by sneaking edge check

		-- Check Z direction
		while deltaZ ~= 0 and #self.world:getCollidingAABBs(self, currentAABB:Translate(0, -1, deltaZ)) == 0 do
			if deltaZ < stepCheckDist and deltaZ >= -stepCheckDist then
				deltaZ = 0
			else
				deltaZ = deltaZ - math.sign(deltaZ) * stepCheckDist
			end
			inputDeltaZ = deltaZ -- Update inputDeltaZ to reflect adjusted deltaZ
		end
		self.zVel = 0 -- Stop horizontal velocity if blocked by sneaking edge check
	end

	-- Get potential colliders in the path of movement
	local movementVector = Vector3.new(deltaX, deltaY, deltaZ)
	local collidingAABBs = self.world:getCollidingAABBs(self, currentAABB:DirectionalExpand(movementVector))

	-- Resolve Y collision first
	for _, aabb in ipairs(collidingAABBs) do
		deltaY = aabb:CalculateYOffset(currentAABB, deltaY)
	end
	currentAABB:Offset(0, deltaY, 0)

	-- Check for NaN in deltaY (can happen with invalid AABB calculations)
	-- Original used `deltaY ~= deltaY`. Using `type` check is slightly clearer.
	local verticalCollisionNaN = (type(deltaY) ~= "number")
	if not self.doSliding and verticalCollisionNaN then
		-- If sliding is disabled and Y collision resulted in NaN, stop all movement
		deltaX, deltaY, deltaZ = 0, 0, 0
	end

	-- Determine if collision occurred below the entity
	local collidedBelow = deltaY < 0 -- Check original deltaY before potential step-up adjustment

	-- Resolve X collision
	for _, aabb in ipairs(collidingAABBs) do
		deltaX = aabb:CalculateXOffset(currentAABB, deltaX)
	end
	currentAABB:Offset(deltaX, 0, 0)

	local horizontalCollisionNaN_X = (type(deltaX) ~= "number")
	if not self.doSliding and horizontalCollisionNaN_X then
		-- If sliding is disabled and X collision resulted in NaN, stop all movement
		deltaX, deltaY, deltaZ = 0, 0, 0
	end

	-- Resolve Z collision
	for _, aabb in ipairs(collidingAABBs) do
		deltaZ = aabb:CalculateZOffset(currentAABB, deltaZ)
	end
	currentAABB:Offset(0, 0, deltaZ)

	local horizontalCollisionNaN_Z = (type(deltaZ) ~= "number")
	if not self.doSliding and horizontalCollisionNaN_Z then
		-- If sliding is disabled and Z collision resulted in NaN, stop all movement
		deltaX, deltaY, deltaZ = 0, 0, 0
	end

	-- Step-up logic
	-- Check if:
	-- 1. Entity has step height > 0
	-- 2. Collided vertically downwards (collidedBelow)
	-- 3. Vertical bobbing/size is small (self.ySize < 0.05) - ??? Purpose unclear
	-- 4. Horizontal movement was attempted but resulted in collision (inputDeltaX ~= deltaX or inputDeltaZ ~= deltaZ)
	local horizontalMovementStopped = (inputDeltaX ~= deltaX or inputDeltaZ ~= deltaZ)
	if self.stepHeight > 0 and collidedBelow and self.ySize < 0.05 and horizontalMovementStopped then
		-- Store current resolved movement
		local currentDeltaX, currentDeltaY, currentDeltaZ = deltaX, deltaY, deltaZ
		local currentResolvedAABB = currentAABB:Clone()

		-- Reset deltas to original input, but use stepHeight for Y
		deltaX = inputDeltaX
		deltaY = self.stepHeight
		deltaZ = inputDeltaZ

		-- Re-check collisions with the potential step-up movement
		local stepUpAABB = initialAABB:Clone() -- Use the AABB from *before* any movement this frame
		local stepUpMovement = Vector3.new(deltaX, deltaY, deltaZ)
		local stepUpColliders = self.world:getCollidingAABBs(self, stepUpAABB:DirectionalExpand(stepUpMovement))

		-- Resolve Y collision for step-up
		for _, aabb in ipairs(stepUpColliders) do
			deltaY = aabb:CalculateYOffset(stepUpAABB, deltaY)
		end
		stepUpAABB:Offset(0, deltaY, 0)

		-- Resolve X collision for step-up
		for _, aabb in ipairs(stepUpColliders) do
			deltaX = aabb:CalculateXOffset(stepUpAABB, deltaX)
		end
		stepUpAABB:Offset(deltaX, 0, 0)

		-- Resolve Z collision for step-up
		for _, aabb in ipairs(stepUpColliders) do
			deltaZ = aabb:CalculateZOffset(stepUpAABB, deltaZ) -- Original used currentAABB here, likely a bug, should be stepUpAABB
		end
		stepUpAABB:Offset(0, 0, deltaZ)

		-- Compare squared horizontal distance moved in both scenarios (original vs step-up)
		local originalHorzDistSq = currentDeltaX^2 + currentDeltaZ^2
		local stepUpHorzDistSq = deltaX^2 + deltaZ^2

		if stepUpHorzDistSq > originalHorzDistSq then
			-- Step-up movement allows more horizontal travel, use it
			currentAABB = stepUpAABB -- Adopt the AABB state from the successful step-up
			-- Keep the deltaX, deltaY, deltaZ calculated during the step-up check
			self.ySize = self.ySize + 0.5 -- ??? Increase ySize after step-up? Needs clarification.
		else
			-- Step-up didn't help or was worse, revert to original resolved movement
			deltaX, deltaY, deltaZ = currentDeltaX, currentDeltaY, currentDeltaZ
			currentAABB = currentResolvedAABB
		end
	end

	-- Finalize position based on the resolved AABB
	self.x = (currentAABB.minX + currentAABB.maxX) / 2
	self.y = currentAABB.minY + self.yOffset -- Position is bottom of collision box + offset
	self.z = (currentAABB.minZ + currentAABB.maxZ) / 2

	-- Update collision flags based on final resolved movement vs original input
	self.isCollidedHorz = (inputDeltaX ~= deltaX) or (inputDeltaZ ~= deltaZ)
	self.isCollidedVert = (inputDeltaY ~= deltaY) -- Compare original Y input with final Y delta
	self.onGround = (inputDeltaY ~= deltaY) and inputDeltaY < 0 -- On ground if Y movement was stopped while moving down
	self.isCollided = self.isCollidedHorz or self.isCollidedVert

	-- Update fall distance based on vertical movement and ground state
	self:updateFallState(deltaY, self.onGround)

	-- Zero out velocity components corresponding to collisions
	if inputDeltaX ~= deltaX then self.xVel = 0 end
	if inputDeltaY ~= deltaY then self.yVel = 0 end
	if inputDeltaZ ~= deltaZ then self.zVel = 0 end

	-- Handle walking effects (distance, sound)
	if self.entityWalks and not isSneakingAndOnGround and self.onGround then
		-- Calculate distance walked using current and previous positions (BUG FIX: original used x-x and z-z)
		local distWalked = math.sqrt((self.x - self.prevX)^2 + (self.z - self.prevZ)^2) * 0.6
		self.renderDistanceWalked = self.renderDistanceWalked + distWalked

		-- Check block below for step sound
		local blockX = math.floor(self.x)
		local blockY = math.floor(self.y - 0.2 - self.yOffset) -- Check slightly below feet
		local blockZ = math.floor(self.z)
		local blockId = self.world:getBlock(blockX, blockY, blockZ)

		-- Ensure BlockManager is loaded before accessing blocks property
		if BlockManager and BlockManager.blocks[blockId] then
			local blockBelow = BlockManager.blocks[blockId]
			-- Check if crossed the threshold for the next step sound
			-- BUG FIX: Original compared floor(dist - 0.5) which seems wrong. Comparing integer part of distance.
			if math.floor(self.renderDistanceWalked) > math.floor(self.prevRenderDistanceWalked) and blockBelow:isCollidable() then
				-- Play step sound using the block's sound properties
				if blockBelow.stepSound then
					-- Assuming stepSound is a sound group name or similar identifier
					-- self.world:playSoundAtEntity(self, blockBelow.stepSound.name, blockBelow.stepSound.volume, blockBelow.stepSound.pitch)
					-- Placeholder: Actual sound playing needs implementation based on how stepSound is defined
					-- print("Step sound:", blockBelow.stepSound)
				end
				-- Original incremented nextStepDistance, purpose unclear, removed for now unless needed.
				-- self.nextStepDistance = self.nextStepDistance + 1
			end
		end
	end

	-- Apply damping/friction to ySize ???
	self.ySize = self.ySize * 0.4
end

-- Update fall distance and trigger fall event if necessary
function Entity:updateFallState(deltaY, isOnGround)
	--[[
		Updates the entity's fall distance based on vertical movement.
		Args:
			deltaY (number): The vertical distance moved this tick.
			isOnGround (boolean): Whether the entity is currently on the ground.
	]]
	if isOnGround then
		if self.fallDistance > 0 then
			self:onFall(self.fallDistance) -- Landed, trigger fall event
			self.fallDistance = 0 -- Reset fall distance
		end
	else
		-- If moving downwards while airborne, increase fall distance
		if deltaY < 0 then
			self.fallDistance = self.fallDistance - deltaY
		end
	end
end

--[[ Hooks/Callbacks ]]

-- Called when the entity is first initialized (constructor)
function Entity:onInit()
	-- Override in subclasses for specific initialization logic
end

-- Called when the entity is added to the world
function Entity:onSpawn()
	-- Override in subclasses
end

-- Called when the entity is removed from the world
function Entity:onDespawn()
	-- Override in subclasses
end

-- Called when the entity lands after falling
function Entity:onFall(distance)
	--[[
		Args:
			distance (number): The distance the entity fell.
	]]
	-- Override in subclasses to handle fall damage, effects, etc.
end

--[[ Utility Methods ]]

-- Get the light level at the entity's position
function Entity:getEntityBrightness()
	--[[ Returns (number): Light level (0-1). ]]
	-- Placeholder: Needs implementation based on world lighting system
	return 1 -- Default to full brightness
end

-- Get the direction the entity is looking
function Entity:getLookVector()
	--[[ Returns (Vector3): A normalized vector representing the look direction. ]]
	local yawRad = math.rad(self.yaw)
	local pitchRad = math.rad(self.pitch)
	local cosPitch = math.cos(pitchRad)
	return Vector3.new(
		-math.sin(yawRad) * cosPitch,
		-math.sin(pitchRad),
		math.cos(yawRad) * cosPitch
	)
end

-- Set the entity's position directly, updating previous position as well
function Entity:setPosition(x, y, z)
	self.x = x
	self.y = y
	self.z = z
	-- Update previous position to prevent large interpolation jumps
	self.prevX = x
	self.prevY = y
	self.prevZ = z
	-- Update collision box
	self:getCollisionBox()
end

-- Calculate the squared distance to a point
function Entity:getSqDistanceTo(x, y, z)
	--[[ Returns (number): Squared distance. ]]
	local dx = self.x - x
	local dy = self.y - y
	local dz = self.z - z
	return dx*dx + dy*dy + dz*dz
end

-- Calculate the distance to a point
function Entity:getDistanceTo(x, y, z)
	--[[ Returns (number): Distance. ]]
	return math.sqrt(self:getSqDistanceTo(x, y, z))
end

--[[ Networking/Replication ]]

-- Get the data payload for network updates
function Entity:getRemoteUpdatePayload()
	--[[ Returns (table): Data to be sent to remote clients/server. ]]
	return {
		x = self.x,
		y = self.y,
		ySize = self.ySize, -- Include ySize if it's visually relevant
		z = self.z,
		yaw = self.yaw,
		renderYawOffset = self.renderYawOffset,
		pitch = self.pitch,
		ticksExisted = self.ticksExisted, -- Sync ticks for animations/effects
		isSneaking = self.isSneaking, -- Sync sneaking state for visual changes
		-- Add other relevant properties needed for remote representation
	}
end

-- Process incoming network update data
function Entity:processRemoteUpdatePayload(payload)
	--[[
		Applies state received from a remote source.
		Args:
			payload (table): The data received over the network.
	]]
	self.lastReplicateTime = tick() -- Record time of update for interpolation/smoothing

	-- Store current state as previous state before applying new data
	self.prevX = self.x
	self.prevY = self.y
	self.prevYSize = self.ySize
	self.prevZ = self.z
	self.prevYaw = self.yaw
	self.prevPitch = self.pitch
	self.prevRenderYawOffset = self.renderYawOffset

	-- Apply received state (consider interpolation/smoothing here for smoother visuals)
	self.x = payload.x
	self.y = payload.y
	self.ySize = payload.ySize
	self.z = payload.z
	self.yaw = payload.yaw
	self.renderYawOffset = payload.renderYawOffset
	self.pitch = payload.pitch
	self.isSneaking = payload.isSneaking
	self.ticksExisted = payload.ticksExisted -- Directly set ticksExisted from payload

	-- Potentially recalculate collision box after position update
	-- self:getCollisionBox() -- Only if needed immediately after update
end

--[[ Register Default Entity Types ]]
-- Assumes entity implementation scripts are located relative to this script.
-- Adjust paths if necessary.

-- Particles
Entity.particleDig = Entity.registerEntity(-1, script.EntityDiggingParticle)
Entity.particleSplash = Entity.registerEntity(-2, script.EntitySplashParticle)
Entity.particleBubble = Entity.registerEntity(-3, script.EntityBubbleParticle)
Entity.particleWaterSuspend = Entity.registerEntity(-4, script.EntityWaterSuspendParticle)

-- Blocks/Objects
Entity.fallingBlock = Entity.registerEntity(2, script.EntityFallingBlock)

-- Living Entities
Entity.player = Entity.registerEntity(3, script.EntityPlayer)

-- Return the base Entity class
return Entity
