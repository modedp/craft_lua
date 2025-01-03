local WorldProto = {}
--[[
; proto unknown
; linedefined: 01
;
; maxstacksize: 06
; numparams: 00
; nups: 00
; is_vararg: 01
;
; sizecode: 85
; sizek: 42
[000] PREPVARARGS  0  0  0
[001] GETIMPORT  0  1 ; multi-index(1): game
[003] LOADK  2  2 ; K(Bx): ReplicatedStorage
[004] NAMECALL  0  0 22 ; K(Code[PC + 1]): GetService
[006] CALL  0  3  2
[007] GETIMPORT  1  5 ; multi-index(1): require
[009] GETTABLEKS  3  0 ; K(Code[PC + 1]): Libs
[011] GETTABLEKS  2  3 ; K(Code[PC + 1]): Class
[013] CALL  1  2  2
[014] GETIMPORT  2  5 ; multi-index(1): require
[016] GETTABLEKS  4  0 ; K(Code[PC + 1]): Libs
[018] GETTABLEKS  3  4 ; K(Code[PC + 1]): Arrays
[020] CALL  2  2  2
[021] GETIMPORT  3  5 ; multi-index(1): require
[023] GETTABLEKS  4  0 ; K(Code[PC + 1]): Block
[025] CALL  3  2  2
[026] MOVE  4  1
[027] CALL  4  1  2
[028] DUPCLOSURE  5 10 ; static function K(Bx) copied to R(A)
[029] CAPTURE  2  0
[030] SETTABLEKS  5  4 215 ; K(Code[PC + 1]): constructor
[032] DUPCLOSURE  5 12 ; static function K(Bx) copied to R(A)
[033] SETTABLEKS  5  4 177 ; K(Code[PC + 1]): spawnLocalEntity
[035] DUPCLOSURE  5 14 ; static function K(Bx) copied to R(A)
[036] SETTABLEKS  5  4 200 ; K(Code[PC + 1]): setBlock
[038] DUPCLOSURE  5 16 ; static function K(Bx) copied to R(A)
[039] CAPTURE  3  0
[040] SETTABLEKS  5  4 48 ; K(Code[PC + 1]): setBlockIfAir
[042] DUPCLOSURE  5 18 ; static function K(Bx) copied to R(A)
[043] CAPTURE  3  0
[044] SETTABLEKS  5  4 52 ; K(Code[PC + 1]): getBlock
[046] DUPCLOSURE  5 20 ; static function K(Bx) copied to R(A)
[047] CAPTURE  3  0
[048] SETTABLEKS  5  4 226 ; K(Code[PC + 1]): canPlaceBlockAt
[050] DUPCLOSURE  5 22 ; static function K(Bx) copied to R(A)
[051] CAPTURE  3  0
[052] SETTABLEKS  5  4 245 ; K(Code[PC + 1]): canBlockSeeSky
[054] DUPCLOSURE  5 24 ; static function K(Bx) copied to R(A)
[055] CAPTURE  3  0
[056] SETTABLEKS  5  4 219 ; K(Code[PC + 1]): getCollidingAABBs
[058] DUPCLOSURE  5 26 ; static function K(Bx) copied to R(A)
[059] CAPTURE  3  0
[060] SETTABLEKS  5  4 201 ; K(Code[PC + 1]): isWaterInAABB
[062] DUPCLOSURE  5 28 ; static function K(Bx) copied to R(A)
[063] CAPTURE  3  0
[064] SETTABLEKS  5  4 146 ; K(Code[PC + 1]): isLavaInAABB
[066] DUPCLOSURE  5 30 ; static function K(Bx) copied to R(A)
[067] SETTABLEKS  5  4 10 ; K(Code[PC + 1]): isAABBFree
[069] DUPCLOSURE  5 32 ; static function K(Bx) copied to R(A)
[070] SETTABLEKS  5  4 17 ; K(Code[PC + 1]): getEntitiesInAABB
[072] DUPCLOSURE  5 34 ; static function K(Bx) copied to R(A)
[073] SETTABLEKS  5  4 75 ; K(Code[PC + 1]): getEntityByUUID
[075] DUPCLOSURE  5 36 ; static function K(Bx) copied to R(A)
[076] SETTABLEKS  5  4 83 ; K(Code[PC + 1]): getClosestPlayerTo
[078] DUPCLOSURE  5 38 ; static function K(Bx) copied to R(A)
[079] SETTABLEKS  5  4 67 ; K(Code[PC + 1]): playSoundAtPosition
[081] DUPCLOSURE  5 40 ; static function K(Bx) copied to R(A)
[082] SETTABLEKS  5  4 77 ; K(Code[PC + 1]): playSoundAtEntity
[084] RETURN  4  2  0 ; 1 returns
]]
local l_Replicated_l = game:GetService("ReplicatedStorage")
local l_Class_l = require(l_Replicated_l.Libs.Class)
local l_Arrays_l = require(l_Replicated_l.Libs.Arrays)
local l_Block_l = require(l_Replicated_l.Block)
WorldProto = l_Class_l()
--[[
; proto name: constructor
; linedefined: 19
;
; maxstacksize: 07
; numparams: 03
; nups: 01
; is_vararg: 00
;
; sizecode: 34
; sizek: 11
[000]   SETTABLEKS  1  0 187 ; K(Code[PC + 1]): seed
[002]   SETTABLEKS  2  0 15 ; K(Code[PC + 1]): size
[004]   LOADN  3 64
[005]   SETTABLEKS  3  0 220 ; K(Code[PC + 1]): height
[007]   GETIMPORT  3  5 ; multi-index(2): Random.new
[009]   MOVE  4  1
[010]   CALL  3  2  2
[011]   SETTABLEKS  3  0 64 ; K(Code[PC + 1]): rand
[013]   LOADN  3  0
[014]   SETTABLEKS  3  0 157 ; K(Code[PC + 1]): numTicks
[016]   LOADN  3  0
[017]   SETTABLEKS  3  0 69 ; K(Code[PC + 1]): lastTickTime
[019]   GETUPVAL  4  0
[020]   GETTABLEKS  3  4 ; K(Code[PC + 1]): new
[022]   MOVE  4  2
[023]   MOVE  5  2
[024]   GETTABLEKS  6  0 ; K(Code[PC + 1]): height
[026]   CALL  3  4  2
[027]   SETTABLEKS  3  0  9 ; K(Code[PC + 1]): blocks
[029]   NEWTABLE  3  0  0
[031]   SETTABLEKS  3  0 157 ; K(Code[PC + 1]): entities
[033]   RETURN  0  1  0 ; 0 returns
]]
function WorldProto.constructor(p1,seed,size)
	p1.seed = seed
	p1.size = size
	p1.height = 64
	p1.rand = Random.new(seed,size)
	p1.numTicks = 0
	p1.lastTickTime = 0
	p1.blocks = l_Block_l.new(p1.height)
	p1.entities = {}
	return
end
--[[
; proto name: spawnLocalEntity
; linedefined: 35
;
; maxstacksize: 11
; numparams: 05
; nups: 00
; is_vararg: 01
;
; sizecode: 26
; sizek: 06
[000]   PREPVARARGS  5  0  0
[001]   GETTABLEKS  5  1 ; K(Code[PC + 1]): new
[003]   MOVE  6  0
[004]   MOVE  7  2
[005]   MOVE  8  3
[006]   MOVE  9  4
[007]   GETVARARGS 10  0
[008]   CALL  5  0  2
[009]   LOADB  6  0  0
[010]   SETTABLEKS  6  5 124 ; K(Code[PC + 1]): isRemote
[012]   GETTABLEKS  6  0 ; K(Code[PC + 1]): entities
[014]   GETTABLEKS  9  0 ; K(Code[PC + 1]): entities
[016]   LENGTH  8  9  0
[017]   ADDK  7  8  3 ; K(C): 1.00
[018]   SETTABLE  5  6  7
[019]   LOADB  6  1  0
[020]   SETTABLEKS  6  5 161 ; K(Code[PC + 1]): addedToWorld
[022]   NAMECALL  6  5 224 ; K(Code[PC + 1]): onSpawn
[024]   CALL  6  2  1
[025]   RETURN  5  2  0 ; 1 returns
]]
function WorldProto.spawnLocalEntity(p5, p6, p7, p8, p9, ...)
	local v16 = p6.new(p5, p7, p8, p9, ...);
	v16.isRemote = false;
	p5.entities[#p5.entities + 1] = v16;
	v16.addedToWorld = true;
	v16:onSpawn();
	p5.renderer:startRenderingEntity(v16);
	return v16;
end;
--[[
; proto name: setBlock
; linedefined: 49
;
; maxstacksize: 09
; numparams: 05
; nups: 00
; is_vararg: 00
;
; sizecode: 36
; sizek: 03
[000]   LOADN  5  1
[001]   JUMPIFNOTLE  5 19 ; jump to 21
[003]   LOADN  5  1
[004]   JUMPIFNOTLE  5 16 ; jump to 21
[006]   LOADN  5  1
[007]   JUMPIFNOTLE  5 13 ; jump to 21
[009]   GETTABLEKS  5  0 ; K(Code[PC + 1]): size
[011]   JUMPIFNOTLE  1  9 ; jump to 21
[013]   GETTABLEKS  5  0 ; K(Code[PC + 1]): height
[015]   JUMPIFNOTLE  2  5 ; jump to 21
[017]   GETTABLEKS  5  0 ; K(Code[PC + 1]): size
[019]   JUMPIFLE  3  2 ; jump to 22
[021]   RETURN  0  1  0 ; 0 returns
[022]   GETTABLEKS  8  0 ; K(Code[PC + 1]): blocks
[024]   GETTABLE  7  8  1
[025]   GETTABLE  6  7  3
[026]   GETTABLE  5  6  2
[027]   JUMPIFNOTEQ  4  2 ; jump to 30
[029]   RETURN  0  1  0 ; 0 returns
[030]   GETTABLEKS  8  0 ; K(Code[PC + 1]): blocks
[032]   GETTABLE  7  8  1
[033]   GETTABLE  6  7  3
[034]   SETTABLE  4  6  2
[035]   RETURN  0  1  0 ; 0 returns
]]
function WorldProto.setBlock(p1,x,y,z,id)
	if x >= 1 and y >= 1 and z >= 1 and x <= p1.size and y <= p1.height and z <= p1.size then
		local block = p1.blocks[x][y][z]
        if block == id then return end 
        p1.blocks[x][y][z] = id
	end
end
--[[
; proto name: setBlockIfAir
; linedefined: 61
;
; maxstacksize: 13
; numparams: 06
; nups: 01
; is_vararg: 00
;
; sizecode: 24
; sizek: 04
[000]   MOVE  9  1
[001]   MOVE 10  2
[002]   MOVE 11  3
[003]   NAMECALL  7  0 52 ; K(Code[PC + 1]): getBlock
[005]   CALL  7  5  2
[006]   NOT  6  7
[007]   GETUPVAL  9  0
[008]   GETTABLEKS  8  9 ; K(Code[PC + 1]): air
[010]   GETTABLEKS  7  8 ; K(Code[PC + 1]): blockID
[012]   JUMPIFNOTEQ  6  2 ; jump to 15
[014]   RETURN  0  1  0 ; 0 returns
[015]   MOVE  8  1
[016]   MOVE  9  2
[017]   MOVE 10  3
[018]   MOVE 11  4
[019]   MOVE 12  5
[020]   NAMECALL  6  0 200 ; K(Code[PC + 1]): setBlock
[022]   CALL  6  7  1
[023]   RETURN  0  1  0 ; 0 returns
]]
function WorldProto.setBlockIfAir(p1,x,y,z,id,updatenear)
	local Block = p1.getBlock(p1,x,y,z)
	if Block ~= l_Block_l.air.blockID then
        return
	end
    p1.setBlock(p1,x,y,z,id,updatenear)
	return 
end
--[[
; proto name: getBlock
; linedefined: 69
;
; maxstacksize: 08
; numparams: 04
; nups: 01
; is_vararg: 00
;
; sizecode: 65
; sizek: 07
[000]   LOADN  4  1
[001]   JUMPIFNOTLE  4 19 ; jump to 21
[003]   LOADN  4  1
[004]   JUMPIFNOTLE  4 16 ; jump to 21
[006]   LOADN  4  1
[007]   JUMPIFNOTLE  4 13 ; jump to 21
[009]   GETTABLEKS  4  0 ; K(Code[PC + 1]): size
[011]   JUMPIFNOTLE  1  9 ; jump to 21
[013]   GETTABLEKS  4  0 ; K(Code[PC + 1]): height
[015]   JUMPIFNOTLE  2  5 ; jump to 21
[017]   GETTABLEKS  4  0 ; K(Code[PC + 1]): size
[019]   JUMPIFLE  3 39 ; jump to 59
[021]   LOADN  5  1
[022]   JUMPIFNOTLE  5 21 ; jump to 44
[024]   LOADN  5  1
[025]   JUMPIFNOTLE  5 18 ; jump to 44
[027]   LOADN  5  1
[028]   JUMPIFNOTLE  5 15 ; jump to 44
[030]   GETTABLEKS  5  0 ; K(Code[PC + 1]): size
[032]   JUMPIFNOTLE  1 11 ; jump to 44
[034]   GETTABLEKS  5  0 ; K(Code[PC + 1]): size
[036]   JUMPIFNOTLE  3  7 ; jump to 44
[038]   GETUPVAL  6  0
[039]   GETTABLEKS  5  6 ; K(Code[PC + 1]): air
[041]   GETTABLEKS  4  5 ; K(Code[PC + 1]): blockID
[043]   JUMPIF  4 14 ; jump to 57
[044]   LOADN  5 30
[045]   JUMPIFNOTLT  2  7 ; jump to 53
[047]   GETUPVAL  6  0
[048]   GETTABLEKS  5  6 ; K(Code[PC + 1]): bedrock
[050]   GETTABLEKS  4  5 ; K(Code[PC + 1]): blockID
[052]   JUMPIF  4  5 ; jump to 57
[053]   GETUPVAL  6  0
[054]   GETTABLEKS  5  6 ; K(Code[PC + 1]): void
[056]   GETTABLEKS  4  5 ; K(Code[PC + 1]): blockID
[058]   RETURN  4  2  0 ; 1 returns
[059]   GETTABLEKS  7  0 ; K(Code[PC + 1]): blocks
[061]   GETTABLE  6  7  1
[062]   GETTABLE  5  6  3
[063]   GETTABLE  4  5  2
[064]   RETURN  4  2  0 ; 1 returns
]]
function WorldProto.getBlock(p1,x,y,z)
	if x >= 1 and y >= 1 and z >= 1 and x <= p1.size and y <= p1.height and z <= p1.size then
        return p1.blocks[x][y][z]
    elseif y < 1 then
        return l_Block_l.bedrock.blockID
    else
        return l_Block_l.void.blockID
    end
end
--[[
; proto name: canPlaceBlockAt
; linedefined: 77
;
; maxstacksize: 18
; numparams: 05
; nups: 01
; is_vararg: 00
;
; sizecode: 103
; sizek: 14
[000]   LOADN  5  1
[001]   JUMPIFNOTLE  5 19 ; jump to 21
[003]   LOADN  5  1
[004]   JUMPIFNOTLE  5 16 ; jump to 21
[006]   LOADN  5  1
[007]   JUMPIFNOTLE  5 13 ; jump to 21
[009]   GETTABLEKS  5  0 ; K(Code[PC + 1]): size
[011]   JUMPIFNOTLE  1  9 ; jump to 21
[013]   GETTABLEKS  5  0 ; K(Code[PC + 1]): height
[015]   JUMPIFNOTLE  2  5 ; jump to 21
[017]   GETTABLEKS  5  0 ; K(Code[PC + 1]): size
[019]   JUMPIFLE  3  3 ; jump to 23
[021]   LOADB  5  0  0
[022]   RETURN  5  2  0 ; 1 returns
[023]   MOVE  7  1
[024]   MOVE  8  2
[025]   MOVE  9  3
[026]   NAMECALL  5  0 52 ; K(Code[PC + 1]): getBlock
[028]   CALL  5  5  2
[029]   GETUPVAL  8  0
[030]   GETTABLEKS  7  8 ; K(Code[PC + 1]): blocks
[032]   GETTABLE  6  7  4
[033]   GETUPVAL  9  0
[034]   GETTABLEKS  8  9 ; K(Code[PC + 1]): slab
[036]   GETTABLEKS  7  8 ; K(Code[PC + 1]): blockID
[038]   JUMPIFNOTEQ  5 11 ; jump to 50
[040]   GETUPVAL  9  0
[041]   GETTABLEKS  8  9 ; K(Code[PC + 1]): slab
[043]   GETTABLEKS  7  8 ; K(Code[PC + 1]): blockID
[045]   JUMPIFNOTEQ  4  4 ; jump to 50
[047]   GETUPVAL  7  0
[048]   GETTABLEKS  6  7 ; K(Code[PC + 1]): doubleSlab
[050]   NAMECALL  7  6 139 ; K(Code[PC + 1]): isCollidable
[052]   CALL  7  2  2
[053]   JUMPIFNOT  7 25 ; jump to 78
[054]   NAMECALL  7  6 186 ; K(Code[PC + 1]): getCollisionBoxes
[056]   CALL  7  2  2
[057]   JUMPIF  7  2 ; jump to 59
[058]   NEWTABLE  7  0  0
[060]   GETIMPORT  8 10 ; multi-index(1): ipairs
[062]   MOVE  9  7
[063]   CALL  8  2  4
[064]   FORGPREP_INEXT  8 13 ; jump to 77
[065]   MOVE 15  1
[066]   MOVE 16  2
[067]   MOVE 17  3
[068]   NAMECALL 13 12 75 ; K(Code[PC + 1]): Translate
[070]   CALL 13  5  2
[071]   MOVE 16 13
[072]   NAMECALL 14  0 10 ; K(Code[PC + 1]): isAABBFree
[074]   CALL 14  3  2
[075]   JUMPIF 14  2 ; jump to 77
[076]   LOADB 14  0  0
[077]   RETURN 14  2  0 ; 1 returns
[078]   FORGLOOP_INEXT  8 -14 ; jump to 64
[079]   GETUPVAL  9  0
[080]   GETTABLEKS  8  9 ; K(Code[PC + 1]): slab
[082]   GETTABLEKS  7  8 ; K(Code[PC + 1]): blockID
[084]   JUMPIFNOTEQ  5 10 ; jump to 95
[086]   GETUPVAL  9  0
[087]   GETTABLEKS  8  9 ; K(Code[PC + 1]): slab
[089]   GETTABLEKS  7  8 ; K(Code[PC + 1]): blockID
[091]   JUMPIFNOTEQ  4  3 ; jump to 95
[093]   LOADB  7  1  0
[094]   RETURN  7  2  0 ; 1 returns
[095]   GETUPVAL  9  0
[096]   GETTABLEKS  8  9 ; K(Code[PC + 1]): blocks
[098]   GETTABLE  7  8  5
[099]   NAMECALL  7  7 115 ; K(Code[PC + 1]): isReplaceable
[101]   CALL  7  2  0
[102]   RETURN  7  0  0 ; variadic return
]]
function WorldProto.canPlaceBlockAt(p1,x,y,z,id)
	if x >= 1 and y >= 1 and z >= 1 and x <= p1.size and y <= p1.height and z <= p1.size then
        local block = p1.getBlock(p1, x, y, z)
        if block == l_Block_l.slab.blockID and id == l_Block_l.slab.blockID then
            return l_Block_l.doubleSlab:isCollidable()
        end

        if block ~= l_Block_l.air.blockID then
            local collisionBoxes = block:getCollisionBoxes()
            if collisionBoxes then
                for _, box in ipairs(collisionBoxes) do
                    if not p1:isAABBFree(box:Translate(x, y, z)) then
                        return false
                    end
                end
            end
        end

        if block == l_Block_l.slab.blockID and id == l_Block_l.slab.blockID then
            return true
        end

        return block:isReplaceable()
    end
    return false
end
--[[
; proto name: canBlockSeeSky
; linedefined: 105
;
; maxstacksize: 14
; numparams: 04
; nups: 01
; is_vararg: 00
;
; sizecode: 46
; sizek: 06
[000]   LOADN  4  1
[001]   JUMPIFNOTLE  4 19 ; jump to 21
[003]   LOADN  4  1
[004]   JUMPIFNOTLE  4 16 ; jump to 21
[006]   LOADN  4  1
[007]   JUMPIFNOTLE  4 13 ; jump to 21
[009]   GETTABLEKS  4  0 ; K(Code[PC + 1]): size
[011]   JUMPIFNOTLE  1  9 ; jump to 21
[013]   GETTABLEKS  4  0 ; K(Code[PC + 1]): height
[015]   JUMPIFNOTLE  2  5 ; jump to 21
[017]   GETTABLEKS  4  0 ; K(Code[PC + 1]): size
[019]   JUMPIFLE  3  3 ; jump to 23
[021]   LOADB  4  0  0
[022]   RETURN  4  2  0 ; 1 returns
[023]   ADDK  6  2  2 ; K(C): 1.00
[024]   LOADN  4 64
[025]   LOADN  5  1
[026]   FORNPREP  4 17 ; jump to 43
[027]   GETUPVAL  9  0
[028]   GETTABLEKS  8  9 ; K(Code[PC + 1]): blocks
[030]   MOVE 11  1
[031]   MOVE 12  6
[032]   MOVE 13  3
[033]   NAMECALL  9  0 52 ; K(Code[PC + 1]): getBlock
[035]   CALL  9  5  2
[036]   GETTABLE  7  8  9
[037]   NAMECALL  8  7 24 ; K(Code[PC + 1]): isSunlightBlocking
[039]   CALL  8  2  2
[040]   JUMPIFNOT  8  2 ; jump to 42
[041]   LOADB  8  0  0
[042]   RETURN  8  2  0 ; 1 returns
[043]   FORNLOOP  4 -17 ; jump to 26
[044]   LOADB  4  1  0
[045]   RETURN  4  2  0 ; 1 returns
]]
function WorldProto.canBlockSeeSky(p1,x,y,z)
	if x >= 1 and y >= 1 and z >= 1 and x <= p1.size and y <= p1.height and z <= p1.size then
        for i = y + 1, p1.height do
            local block = p1.getBlock(p1, x, i, z)
            if block:isSunlightBlocking() then
                return false
            end
        end
        return true
    end
    return false
end
--[[
; proto name: getCollidingAABBs
; linedefined: 117
;
; maxstacksize: 31
; numparams: 03
; nups: 01
; is_vararg: 00
;
; sizecode: 94
; sizek: 18
[000]   NEWTABLE  3  0  0
[002]   GETTABLEKS  5  2 ; K(Code[PC + 1]): minX
[004]   FASTCALL1 12  5  2 ; fastcalling 'math.floor' ; jump to 6
[005]   GETIMPORT  4  3 ; multi-index(2): math.floor
[007]   CALL  4  2  2
[008]   GETTABLEKS  7  2 ; K(Code[PC + 1]): maxX
[010]   ADDK  6  7  4 ; K(C): 1.00
[011]   FASTCALL1 12  6  2 ; fastcalling 'math.floor' ; jump to 13
[012]   GETIMPORT  5  3 ; multi-index(2): math.floor
[014]   CALL  5  2  2
[015]   GETTABLEKS  7  2 ; K(Code[PC + 1]): minY
[017]   FASTCALL1 12  7  2 ; fastcalling 'math.floor' ; jump to 19
[018]   GETIMPORT  6  3 ; multi-index(2): math.floor
[020]   CALL  6  2  2
[021]   GETTABLEKS  9  2 ; K(Code[PC + 1]): maxY
[023]   ADDK  8  9  4 ; K(C): 1.00
[024]   FASTCALL1 12  8  2 ; fastcalling 'math.floor' ; jump to 26
[025]   GETIMPORT  7  3 ; multi-index(2): math.floor
[027]   CALL  7  2  2
[028]   GETTABLEKS  9  2 ; K(Code[PC + 1]): minZ
[030]   FASTCALL1 12  9  2 ; fastcalling 'math.floor' ; jump to 32
[031]   GETIMPORT  8  3 ; multi-index(2): math.floor
[033]   CALL  8  2  2
[034]   GETTABLEKS 11  2 ; K(Code[PC + 1]): maxZ
[036]   ADDK 10 11  4 ; K(C): 1.00
[037]   FASTCALL1 12 10  2 ; fastcalling 'math.floor' ; jump to 39
[038]   GETIMPORT  9  3 ; multi-index(2): math.floor
[040]   CALL  9  2  2
[041]   MOVE 12  4
[042]   SUBK 10  5  4 ; K(C): 1.00
[043]   LOADN 11  1
[044]   FORNPREP 10 48 ; jump to 92
[045]   MOVE 15  8
[046]   SUBK 13  9  4 ; K(C): 1.00
[047]   LOADN 14  1
[048]   FORNPREP 13 43 ; jump to 91
[049]   SUBK 18  6  4 ; K(C): 1.00
[050]   SUBK 16  7  4 ; K(C): 1.00
[051]   LOADN 17  1
[052]   FORNPREP 16 38 ; jump to 90
[053]   GETUPVAL 21  0
[054]   GETTABLEKS 20 21 ; K(Code[PC + 1]): blocks
[056]   MOVE 23 12
[057]   MOVE 24 18
[058]   MOVE 25 15
[059]   NAMECALL 21  0 52 ; K(Code[PC + 1]): getBlock
[061]   CALL 21  5  2
[062]   GETTABLE 19 20 21
[063]   NAMECALL 20 19 139 ; K(Code[PC + 1]): isCollidable
[065]   CALL 20  2  2
[066]   JUMPIFNOT 20 23 ; jump to 89
[067]   NAMECALL 20 19 186 ; K(Code[PC + 1]): getCollisionBoxes
[069]   CALL 20  2  2
[070]   GETIMPORT 21 15 ; multi-index(1): ipairs
[072]   MOVE 22 20
[073]   CALL 21  2  4
[074]   FORGPREP_INEXT 21 14 ; jump to 88
[075]   MOVE 28 12
[076]   MOVE 29 18
[077]   MOVE 30 15
[078]   NAMECALL 26 25 75 ; K(Code[PC + 1]): Translate
[080]   CALL 26  5  2
[081]   MOVE 29  2
[082]   NAMECALL 27 26 250 ; K(Code[PC + 1]): Intersects
[084]   CALL 27  3  2
[085]   JUMPIFNOT 27  3 ; jump to 88
[086]   LENGTH 28  3  0
[087]   ADDK 27 28  4 ; K(C): 1.00
[088]   SETTABLE 26  3 27
[089]   FORGLOOP_INEXT 21 -15 ; jump to 74
[090]   FORNLOOP 16 -38 ; jump to 52
[091]   FORNLOOP 13 -43 ; jump to 48
[092]   FORNLOOP 10 -48 ; jump to 44
[093]   RETURN  3  2  0 ; 1 returns
]]
function WorldProto.getCollidingAABBs(p1,entityCollision,position)
	local collidingAABBs = {}

    local minX = math.floor(entityCollision.minX)
    local maxX = math.floor(entityCollision.maxX + 1)
    local minY = math.floor(entityCollision.minY)
    local maxY = math.floor(entityCollision.maxY + 1)
    local minZ = math.floor(entityCollision.minZ)
    local maxZ = math.floor(entityCollision.maxZ + 1)

    for x = minX, maxX - 1 do
        for y = minY, maxY - 1 do
            for z = minZ, maxZ - 1 do
                local block = p1.getBlock(p1, x, y, z)
                if block:isCollidable() then
                    local collisionBoxes = block:getCollisionBoxes()
                    for _, box in ipairs(collisionBoxes) do
                        if box:Translate(x, y, z):Intersects(entityCollision) then
                            table.insert(collidingAABBs, box)
                        end
                    end
                end
            end
        end
    end

    return collidingAABBs
end
--[[
; proto name: isWaterInAABB
; linedefined: 154
;
; maxstacksize: 23
; numparams: 02
; nups: 01
; is_vararg: 00
;
; sizecode: 80
; sizek: 14
[000]   NEWTABLE  2  0  0
[002]   GETTABLEKS  4  1 ; K(Code[PC + 1]): minX
[004]   FASTCALL1 12  4  2 ; fastcalling 'math.floor' ; jump to 6
[005]   GETIMPORT  3  3 ; multi-index(2): math.floor
[007]   CALL  3  2  2
[008]   GETTABLEKS  6  1 ; K(Code[PC + 1]): maxX
[010]   ADDK  5  6  4 ; K(C): 1.00
[011]   FASTCALL1 12  5  2 ; fastcalling 'math.floor' ; jump to 13
[012]   GETIMPORT  4  3 ; multi-index(2): math.floor
[014]   CALL  4  2  2
[015]   GETTABLEKS  6  1 ; K(Code[PC + 1]): minY
[017]   FASTCALL1 12  6  2 ; fastcalling 'math.floor' ; jump to 19
[018]   GETIMPORT  5  3 ; multi-index(2): math.floor
[020]   CALL  5  2  2
[021]   GETTABLEKS  8  1 ; K(Code[PC + 1]): maxY
[023]   ADDK  7  8  4 ; K(C): 1.00
[024]   FASTCALL1 12  7  2 ; fastcalling 'math.floor' ; jump to 26
[025]   GETIMPORT  6  3 ; multi-index(2): math.floor
[027]   CALL  6  2  2
[028]   GETTABLEKS  8  1 ; K(Code[PC + 1]): minZ
[030]   FASTCALL1 12  8  2 ; fastcalling 'math.floor' ; jump to 32
[031]   GETIMPORT  7  3 ; multi-index(2): math.floor
[033]   CALL  7  2  2
[034]   GETTABLEKS 10  1 ; K(Code[PC + 1]): maxZ
[036]   ADDK  9 10  4 ; K(C): 1.00
[037]   FASTCALL1 12  9  2 ; fastcalling 'math.floor' ; jump to 39
[038]   GETIMPORT  8  3 ; multi-index(2): math.floor
[040]   CALL  8  2  2
[041]   MOVE 11  3
[042]   SUBK  9  4  4 ; K(C): 1.00
[043]   LOADN 10  1
[044]   FORNPREP  9 33 ; jump to 77
[045]   MOVE 14  7
[046]   SUBK 12  8  4 ; K(C): 1.00
[047]   LOADN 13  1
[048]   FORNPREP 12 28 ; jump to 76
[049]   MOVE 17  5
[050]   SUBK 15  6  4 ; K(C): 1.00
[051]   LOADN 16  1
[052]   FORNPREP 15 23 ; jump to 75
[053]   MOVE 20 11
[054]   MOVE 21 17
[055]   MOVE 22 14
[056]   NAMECALL 18  0 52 ; K(Code[PC + 1]): getBlock
[058]   CALL 18  5  2
[059]   GETUPVAL 21  0
[060]   GETTABLEKS 20 21 ; K(Code[PC + 1]): water
[062]   GETTABLEKS 19 20 ; K(Code[PC + 1]): blockID
[064]   JUMPIFEQ 18  8 ; jump to 73
[066]   GETUPVAL 21  0
[067]   GETTABLEKS 20 21 ; K(Code[PC + 1]): waterMoving
[069]   GETTABLEKS 19 20 ; K(Code[PC + 1]): blockID
[071]   JUMPIFNOTEQ 18  3 ; jump to 75
[073]   LOADB 19  1  0
[074]   RETURN 19  2  0 ; 1 returns
[075]   FORNLOOP 15 -23 ; jump to 52
[076]   FORNLOOP 12 -28 ; jump to 48
[077]   FORNLOOP  9 -33 ; jump to 44
[078]   LOADB  9  0  0
[079]   RETURN  9  2  0 ; 1 returns
]]
function WorldProto.isWaterInAABB(p1,entityCollision)
	local minX = math.floor(entityCollision.minX)
    local maxX = math.floor(entityCollision.maxX + 1)
    local minY = math.floor(entityCollision.minY)
    local maxY = math.floor(entityCollision.maxY + 1)
    local minZ = math.floor(entityCollision.minZ)
    local maxZ = math.floor(entityCollision.maxZ + 1)

    for x = minX, maxX - 1 do
        for y = minY, maxY - 1 do
            for z = minZ, maxZ - 1 do
                local block = p1.getBlock(p1, x, y, z)
                if block == l_Block_l.water.blockID or block == l_Block_l.waterMoving.blockID then
                    return true
                end
            end
        end
    end

    return false
end
--[[
; proto name: isLavaInAABB
; linedefined: 183
;
; maxstacksize: 23
; numparams: 02
; nups: 01
; is_vararg: 00
;
; sizecode: 77
; sizek: 16
[000]   NEWTABLE  2  0  0
[002]   GETTABLEKS  4  1 ; K(Code[PC + 1]): minX
[004]   FASTCALL1 12  4  2 ; fastcalling 'math.floor' ; jump to 6
[005]   GETIMPORT  3  3 ; multi-index(2): math.floor
[007]   CALL  3  2  2
[008]   GETTABLEKS  5  1 ; K(Code[PC + 1]): maxX
[010]   FASTCALL1  7  5  2 ; fastcalling 'math.ceil' ; jump to 12
[011]   GETIMPORT  4  6 ; multi-index(2): math.ceil
[013]   CALL  4  2  2
[014]   GETTABLEKS  6  1 ; K(Code[PC + 1]): minY
[016]   FASTCALL1 12  6  2 ; fastcalling 'math.floor' ; jump to 18
[017]   GETIMPORT  5  3 ; multi-index(2): math.floor
[019]   CALL  5  2  2
[020]   GETTABLEKS  7  1 ; K(Code[PC + 1]): maxY
[022]   FASTCALL1  7  7  2 ; fastcalling 'math.ceil' ; jump to 24
[023]   GETIMPORT  6  6 ; multi-index(2): math.ceil
[025]   CALL  6  2  2
[026]   GETTABLEKS  8  1 ; K(Code[PC + 1]): minZ
[028]   FASTCALL1 12  8  2 ; fastcalling 'math.floor' ; jump to 30
[029]   GETIMPORT  7  3 ; multi-index(2): math.floor
[031]   CALL  7  2  2
[032]   GETTABLEKS  9  1 ; K(Code[PC + 1]): maxZ
[034]   FASTCALL1  7  9  2 ; fastcalling 'math.ceil' ; jump to 36
[035]   GETIMPORT  8  6 ; multi-index(2): math.ceil
[037]   CALL  8  2  2
[038]   MOVE 11  3
[039]   SUBK  9  4 11 ; K(C): 1.00
[040]   LOADN 10  1
[041]   FORNPREP  9 33 ; jump to 74
[042]   MOVE 14  7
[043]   SUBK 12  8 11 ; K(C): 1.00
[044]   LOADN 13  1
[045]   FORNPREP 12 28 ; jump to 73
[046]   MOVE 17  5
[047]   SUBK 15  6 11 ; K(C): 1.00
[048]   LOADN 16  1
[049]   FORNPREP 15 23 ; jump to 72
[050]   MOVE 20 11
[051]   MOVE 21 17
[052]   MOVE 22 14
[053]   NAMECALL 18  0 52 ; K(Code[PC + 1]): getBlock
[055]   CALL 18  5  2
[056]   GETUPVAL 21  0
[057]   GETTABLEKS 20 21 ; K(Code[PC + 1]): lava
[059]   GETTABLEKS 19 20 ; K(Code[PC + 1]): blockID
[061]   JUMPIFEQ 18  8 ; jump to 70
[063]   GETUPVAL 21  0
[064]   GETTABLEKS 20 21 ; K(Code[PC + 1]): lavaMoving
[066]   GETTABLEKS 19 20 ; K(Code[PC + 1]): blockID
[068]   JUMPIFNOTEQ 18  3 ; jump to 72
[070]   LOADB 19  1  0
[071]   RETURN 19  2  0 ; 1 returns
[072]   FORNLOOP 15 -23 ; jump to 49
[073]   FORNLOOP 12 -28 ; jump to 45
[074]   FORNLOOP  9 -33 ; jump to 41
[075]   LOADB  9  0  0
[076]   RETURN  9  2  0 ; 1 returns
]]
function WorldProto.isLavaInAABB(p1,entityCollision)
	local minX = math.floor(entityCollision.minX)
    local maxX = math.ceil(entityCollision.maxX)
    local minY = math.floor(entityCollision.minY)
    local maxY = math.ceil(entityCollision.maxY)
    local minZ = math.floor(entityCollision.minZ)
    local maxZ = math.ceil(entityCollision.maxZ)

    for x = minX, maxX - 1 do
        for y = minY, maxY - 1 do
            for z = minZ, maxZ - 1 do
                local block = p1.getBlock(p1, x, y, z)
                if block == l_Block_l.lava.blockID or block == l_Block_l.lavaMoving.blockID then
                    return true
                end
            end
        end
    end

    return false
end
--[[
; proto name: isAABBFree
; linedefined: 212
;
; maxstacksize: 09
; numparams: 02
; nups: 00
; is_vararg: 00
;
; sizecode: 20
; sizek: 05
[000]   MOVE  4  1
[001]   NAMECALL  2  0 17 ; K(Code[PC + 1]): getEntitiesInAABB
[003]   CALL  2  3  2
[004]   GETIMPORT  3  2 ; multi-index(1): pairs
[006]   MOVE  4  2
[007]   CALL  3  2  4
[008]   FORGPREP_NEXT  3  8 ; jump to 16
[009]   GETTABLEKS  8  7 ; K(Code[PC + 1]): dead
[011]   JUMPIF  8  5 ; jump to 16
[012]   GETTABLEKS  8  7 ; K(Code[PC + 1]): preventEntitySpawning
[014]   JUMPIFNOT  8  2 ; jump to 16
[015]   LOADB  8  0  0
[016]   RETURN  8  2  0 ; 1 returns
[017]   FORGLOOP_NEXT  3 -9 ; jump to 8
[018]   LOADB  3  1  0
[019]   RETURN  3  2  0 ; 1 returns
]]
function WorldProto.isAABBFree(p1,Box)
	local existing = Box.getEntitiesInAABB(p1, Box)
    for _, x1 in pairs(existing) do
        if not x1.dead and x1.preventEntitySpawning then
            return false
        end
    end
    return true
end
--[[
; proto name: getEntitiesInAABB
; linedefined: 225
;
; maxstacksize: 11
; numparams: 02
; nups: 00
; is_vararg: 00
;
; sizecode: 21
; sizek: 06
[000]   NEWTABLE  2  0  0
[002]   GETIMPORT  3  1 ; multi-index(1): pairs
[004]   GETTABLEKS  4  0 ; K(Code[PC + 1]): entities
[006]   CALL  3  2  4
[007]   FORGPREP_NEXT  3 11 ; jump to 18
[008]   NAMECALL  8  7 177 ; K(Code[PC + 1]): getCollisionBox
[010]   CALL  8  2  2
[011]   MOVE 10  1
[012]   NAMECALL  8  8 250 ; K(Code[PC + 1]): Intersects
[014]   CALL  8  3  2
[015]   JUMPIFNOT  8  3 ; jump to 18
[016]   LENGTH  9  2  0
[017]   ADDK  8  9  5 ; K(C): 1.00
[018]   SETTABLE  7  2  8
[019]   FORGLOOP_NEXT  3 -12 ; jump to 7
[020]   RETURN  2  2  0 ; 1 returns
]]
function WorldProto.getEntitiesInAABB(p1,collisionBox)
	local ents = {}
	for _,e1 in pairs(p1.entities) do
		local box = e1.getCollisionBox(e1)
		if box.Intersects(box,collisionBox) then
			ents[#ents + 1] = e1
		end
	end
	return ents
end
--[[
; proto name: getEntityByUUID
; linedefined: 238
;
; maxstacksize: 08
; numparams: 02
; nups: 00
; is_vararg: 00
;
; sizecode: 13
; sizek: 04
[000]   GETIMPORT  2  1 ; multi-index(1): pairs
[002]   GETTABLEKS  3  0 ; K(Code[PC + 1]): entities
[004]   CALL  2  2  4
[005]   FORGPREP_NEXT  2  5 ; jump to 10
[006]   GETTABLEKS  7  6 ; K(Code[PC + 1]): uuid
[008]   JUMPIFNOTEQ  7  2 ; jump to 11
[010]   RETURN  6  2  0 ; 1 returns
[011]   FORGLOOP_NEXT  2 -6 ; jump to 5
[012]   RETURN  0  1  0 ; 0 returns
]]
function WorldProto.getEntityByUUID(p1,uuid)
	for _,u1 in pairs(p1.entities) do
		if u1.uuid == uuid then
			return u1
		end
	end
	return nil
end
--[[
; proto name: getClosestPlayerTo
; linedefined: 249
;
; maxstacksize: 17
; numparams: 05
; nups: 00
; is_vararg: 00
;
; sizecode: 23
; sizek: 07
[000]   LOADNIL  5
[001]   GETIMPORT  6  2 ; multi-index(2): math.huge
[003]   GETIMPORT  7  4 ; multi-index(1): pairs
[005]   GETTABLEKS  8  0 ; K(Code[PC + 1]): playerEntities
[007]   CALL  7  2  4
[008]   FORGPREP_NEXT  7 12 ; jump to 20
[009]   MOVE 14  1
[010]   MOVE 15  2
[011]   MOVE 16  3
[012]   NAMECALL 12 11 105 ; K(Code[PC + 1]): getDistanceTo
[014]   CALL 12  5  2
[015]   JUMPIFNOTLE 12  5 ; jump to 21
[017]   JUMPIFNOTLT 12  3 ; jump to 21
[019]   MOVE  5 11
[020]   MOVE  6 12
[021]   FORGLOOP_NEXT  7 -13 ; jump to 8
[022]   RETURN  5  2  0 ; 1 returns
]]
function WorldProto.getClosestPlayerTo()
	local closestPlayer = nil
    local minDistance = math.huge

    for _, player in pairs(p1.playerEntities) do
        local distance = player:getDistanceTo(x, y, z)
        if distance <= maxDistance and distance < minDistance then
            closestPlayer = player
            minDistance = distance
        end
    end

    return closestPlayer
end
function WorldProto.playSoundAtPosition(p1,p2,p3,p4,p5,p6,p7)
	warn("This must be implemented by the client or server world!")
	return 
end
--[[
; proto name: playSoundAtEntity
; linedefined: 272
;
; maxstacksize: 13
; numparams: 05
; nups: 00
; is_vararg: 00
;
; sizecode: 13
; sizek: 04
[000]   GETTABLEKS  7  1 ; K(Code[PC + 1]): x
[002]   GETTABLEKS  8  1 ; K(Code[PC + 1]): y
[004]   GETTABLEKS  9  1 ; K(Code[PC + 1]): z
[006]   MOVE 10  2
[007]   MOVE 11  3
[008]   MOVE 12  4
[009]   NAMECALL  5  0 67 ; K(Code[PC + 1]): playSoundAtPosition
[011]   CALL  5  8  0
[012]   RETURN  5  0  0 ; variadic return
]]
function WorldProto.playSoundAtEntity(p1,entity,SName,var1,var2)
	local x,y,z = entity.x,entity.y,entity.z
	return p1.playSoundAtPosition(p1,x,y,z,SName,var1,var2)
end

return WorldProto
