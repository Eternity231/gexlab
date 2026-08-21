util.AddNetworkString('setlootvalue')
local randlootrhance = CreateConVar("gex_randlootrhance",0.5, {FCVAR_REPLICATED, FCVAR_ARCHIVE},'',0,1)
local NPCrapeenable = CreateConVar("gex_NPCrapeenable",1, {FCVAR_REPLICATED, FCVAR_ARCHIVE},'',0,1)
local gex_max_time = CreateConVar("gex_max_time",120, {FCVAR_REPLICATED, FCVAR_ARCHIVE},'',0,360)
local gex_min_time = CreateConVar("gex_min_time",60, {FCVAR_REPLICATED, FCVAR_ARCHIVE},'',0,360)
local dikenable = CreateConVar("gex_Combinedikenable",1, {FCVAR_REPLICATED, FCVAR_ARCHIVE},'',0,1)
local autofix = CreateConVar("gex_auto_positionfix_enable",1, {FCVAR_REPLICATED, FCVAR_ARCHIVE},'',0,1)
local thp = CreateConVar("gex_3p_chance",50, {FCVAR_REPLICATED, FCVAR_ARCHIVE},'',0,100)
local lootenable = CreateConVar("gex_NPClootnable",1, {FCVAR_REPLICATED, FCVAR_ARCHIVE},'',0,1)
local gexfacenable = CreateConVar("gex_gexfacenable",1, {FCVAR_REPLICATED, FCVAR_ARCHIVE},'',0,1)

local function IsZCityActive()
	return GZCompat ~= nil and GZCompat.IsActive ~= nil and GZCompat.IsActive()
end

local gex_debug = CreateConVar("gex_debug", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "GexLab debug logging", 0, 1)
local function GexDebug(...)
	if gex_debug:GetBool() then
		print("[GexLab][DEBUG]", ...)
	end
end

local function GetZCityRagdoll(ply)
	if GZCompat ~= nil and GZCompat.GetCorpse ~= nil then
		return GZCompat.GetCorpse(ply)
	end
	return nil
end

Animrag_CSC = {		
	secondstoarrive = 0.01,
	pos = Vector(0, 0, 0),
	angle = Angle(0, 0, 0),
	maxangular = 400,
	maxangulardamp = 200,
	maxspeed = 400,
	maxspeeddamp = 300,
	teleportdistance = 0
}
local HTB =  {	
	["ValveBiped.Bip01_Pelvis"] = true,
	["ValveBiped.Bip01_Spine1"] = true,
	//["ValveBiped.Bip01_Spine4"] = true,
	["ValveBiped.Bip01_R_Thigh"] = true,
	//["ValveBiped.Bip01_R_Calf"] = true,
	//["ValveBiped.Bip01_R_Foot"] = true,
	["ValveBiped.Bip01_L_Thigh"] = true,
	//a["ValveBiped.Bip01_L_Calf"] = true,
	//["ValveBiped.Bip01_L_Foot"] = true,
	//["ValveBiped.Bip01_R_Clavicle"] = true,
	//["ValveBiped.Bip01_R_UpperArm"] = true,
	//["ValveBiped.Bip01_R_Forearm"] = true,
	//["ValveBiped.Bip01_R_Hand"] = true,
	//["ValveBiped.Bip01_L_Clavicle"] = true,
	//["ValveBiped.Bip01_L_UpperArm"] = true,
	//["ValveBiped.Bip01_L_Forearm"] = true,
	//["ValveBiped.Bip01_L_Hand"] = true,
	//["ValveBiped.Bip01_Head1"] = true
}
local HTB2 =  {	
	["ValveBiped.Bip01_Pelvis"] = true,
	["ValveBiped.Bip01_Spine1"] = true,
	//["ValveBiped.Bip01_Spine4"] = true,
	["ValveBiped.Bip01_R_Thigh"] = true,
	["ValveBiped.Bip01_R_Calf"] = true,
	//["ValveBiped.Bip01_R_Foot"] = true,
	["ValveBiped.Bip01_L_Thigh"] = true,
	["ValveBiped.Bip01_L_Calf"] = true,
	//["ValveBiped.Bip01_L_Foot"] = true,
	//["ValveBiped.Bip01_R_Clavicle"] = true,
	//["ValveBiped.Bip01_R_UpperArm"] = true,
	//["ValveBiped.Bip01_R_Forearm"] = true,
	//["ValveBiped.Bip01_R_Hand"] = true,
	//["ValveBiped.Bip01_L_Clavicle"] = true,
	//["ValveBiped.Bip01_L_UpperArm"] = true,
	//["ValveBiped.Bip01_L_Forearm"] = true,
	//["ValveBiped.Bip01_L_Hand"] = true,
	//["ValveBiped.Bip01_Head1"] = true
}
local HTB3 =  {	
	--["ValveBiped.Bip01_Pelvis"] = true,
	--["ValveBiped.Bip01_Spine1"] = true,
	//["ValveBiped.Bip01_Spine4"] = true,
	--["ValveBiped.Bip01_R_Thigh"] = true,
	--["ValveBiped.Bip01_R_Calf"] = true,
	//["ValveBiped.Bip01_R_Foot"] = true,
	--["ValveBiped.Bip01_L_Thigh"] = true,
	--["ValveBiped.Bip01_L_Calf"] = true,
	//["ValveBiped.Bip01_L_Foot"] = true,
	--["ValveBiped.Bip01_R_Clavicle"] = true,
	//["ValveBiped.Bip01_R_UpperArm"] = true,
	--["ValveBiped.Bip01_R_Forearm"] = true,
	//["ValveBiped.Bip01_R_Hand"] = true,
	--["ValveBiped.Bip01_L_Clavicle"] = true,
	//["ValveBiped.Bip01_L_UpperArm"] = true,
	--["ValveBiped.Bip01_L_Forearm"] = true,
	//["ValveBiped.Bip01_L_Hand"] = true,
	["ValveBiped.Bip01_Head1"] = true
}

local ATB2 = {	
		["ValveBiped.Bip01_Pelvis"] = true,
		["ValveBiped.Bip01_Spine1"] = true,
		["ValveBiped.Bip01_Spine4"] = true,
		["ValveBiped.Bip01_R_Thigh"] = true,
		//["ValveBiped.Bip01_R_Calf"] = true,
		//["ValveBiped.Bip01_R_Foot"] = true,
		["ValveBiped.Bip01_L_Thigh"] = true,
		["ValveBiped.Bip01_L_Calf"] = true,
		["ValveBiped.Bip01_L_Foot"] = true,
		["ValveBiped.Bip01_R_Clavicle"] = true,
		["ValveBiped.Bip01_R_UpperArm"] = true,
		["ValveBiped.Bip01_R_Forearm"] = true,
		//["ValveBiped.Bip01_R_Hand"] = true,
		["ValveBiped.Bip01_L_Clavicle"] = true,
		["ValveBiped.Bip01_L_UpperArm"] = true,
		["ValveBiped.Bip01_L_Forearm"] = true,
		["ValveBiped.Bip01_L_Hand"] = true,
		["ValveBiped.Bip01_Head1"] = true
	}
local ATB3 = {	
		["ValveBiped.Bip01_Pelvis"] = true,
		["ValveBiped.Bip01_Spine1"] = true,
		["ValveBiped.Bip01_Spine4"] = true,
		["ValveBiped.Bip01_R_Thigh"] = true,
		["ValveBiped.Bip01_R_Calf"] = true,
		--["ValveBiped.Bip01_R_Foot"] = true,
		["ValveBiped.Bip01_L_Thigh"] = true,
		["ValveBiped.Bip01_L_Calf"] = true,
		--["ValveBiped.Bip01_L_Foot"] = true,
		["ValveBiped.Bip01_R_Clavicle"] = true,
		["ValveBiped.Bip01_R_UpperArm"] = true,
		["ValveBiped.Bip01_R_Forearm"] = true,
		["ValveBiped.Bip01_R_Hand"] = true,
		["ValveBiped.Bip01_L_Clavicle"] = true,
		["ValveBiped.Bip01_L_UpperArm"] = true,
		["ValveBiped.Bip01_L_Forearm"] = true,
		["ValveBiped.Bip01_L_Hand"] = true,
		["ValveBiped.Bip01_Head1"] = true
	}
local ATB  =  {	
	["ValveBiped.Bip01_Pelvis"] = true,
	["ValveBiped.Bip01_Spine1"] = true,
	["ValveBiped.Bip01_Spine4"] = true,
	["ValveBiped.Bip01_R_Thigh"] = true,
	["ValveBiped.Bip01_R_Calf"] = true,
	["ValveBiped.Bip01_R_Foot"] = true,
	["ValveBiped.Bip01_L_Thigh"] = true,
	["ValveBiped.Bip01_L_Calf"] = true,
	["ValveBiped.Bip01_L_Foot"] = true,
	["ValveBiped.Bip01_R_Clavicle"] = true,
	["ValveBiped.Bip01_R_UpperArm"] = true,
	["ValveBiped.Bip01_R_Forearm"] = true,
	["ValveBiped.Bip01_R_Hand"] = true,
	["ValveBiped.Bip01_L_Clavicle"] = true,
	["ValveBiped.Bip01_L_UpperArm"] = true,
	["ValveBiped.Bip01_L_Forearm"] = true,
	["ValveBiped.Bip01_L_Hand"] = true,
	["ValveBiped.Bip01_Head1"] = true
}



local function bodyfacedircheck(ent)
	ent.facingup = true 
	ent.facingright = true
	local _,ang =ent:GetBonePosition( ent:LookupBone("ValveBiped.Bip01_Pelvis") )
	local vec = ang:Up()
	local vec2 = ang:Forward()
	
	if vec.z <= 0 then
		ent.facingup = false
	end
	if vec2.z <=0 then
		ent.facingright = false
	end
end	

local function placecheck(ent)
	local _,ang =ent:GetBonePosition( ent:LookupBone("ValveBiped.Bip01_Pelvis") )
	local v1 = ang:Right()--上
	local v2 =  ang:Forward()--左
	local vec = Vector(v1.x,v1.y,0):GetNormalized()
	local vec2 =Vector(v2.x,v2.y,0):GetNormalized()
	local npcclass = {}
	local trup = util.TraceLine({
		start = ent:GetPos(),
		endpos = ent:GetPos()-vec*45,
		mask = MASK_SOLID,
		filter =function(e) return e!=ent and !e:IsNPC() and !e:IsPlayer() end
		} )
	local trdown = util.TraceLine({
		start = ent:GetPos(),
		endpos = ent:GetPos()+vec*25,
		mask = MASK_SOLID,
		filter =function(e) return e!=ent and !e:IsNPC() and !e:IsPlayer() end
		} )
	local trleft = util.TraceLine({
		start = ent:GetPos(),
		endpos = ent:GetPos()+vec2*20,
		mask = MASK_SOLID,
		filter =function(e) return e!=ent and !e:IsNPC() and !e:IsPlayer() end
		} )
	local trright = util.TraceLine({
		start = ent:GetPos(),
		endpos = ent:GetPos()-vec2*20,
		mask = MASK_SOLID,
		filter =function(e) return e!=ent and !e:IsNPC() and !e:IsPlayer() end
		} )
	if trup.Hit then
		ent.upblock = true
	else
		ent.upblock = false
	end
	if trdown.Hit then
		ent.downblock = true
	else
		ent.downblock = false
	end
	if trleft.Hit then
		ent.leftblock = true
	else
		ent.leftblock = false
	end
	if trright.Hit then
		ent.rightblock = true
	else
		ent.rightblock = false
	end
end

local function getb(ent,vec,bone)
	for i=0, ent:GetPhysicsObjectCount()-1 do
		local bonename = ent:GetBoneName(ent:TranslatePhysBoneToBone(i))
		if bonename == bone or bonename == "ValveBiped.Bip01_Pelvis" then
			local phy = ent:GetPhysicsObjectNum(i)
			local pos,ang = ent:GetBonePosition( ent:LookupBone(bonename) )
			local evec = ang:Right()
			if vec then evec = vec:GetNormalized() end
			local meshtb=phy:GetMesh()
			
			for k,v in pairs(meshtb) do
				meshtb[k]['pos']=phy:LocalToWorld(meshtb[k]['pos'])
			end
			--[[net.Start('test')
			net.WriteTable(meshtb)
			net.Broadcast()]]
			local minDist = math.huge
			local closestPoint = nil
			local closestProjection = 0
			
			for _, point in ipairs(meshtb) do
				local toPoint = point['pos'] - pos
				local projection = toPoint:Dot(evec)  -- 沿射线的投影
				
				-- 点到射线的垂直距离公式
				if projection<0 then continue end
				local verticalVec = toPoint - evec * projection
				local dist = verticalVec:Length()
				
				if dist < minDist then
					minDist = dist
					closestPoint = pos+projection*evec
					closestProjection = projection
				end
			end

			return closestPoint, closestProjection
		end
	end 
end


-------------------------------------------
local function dds(i,state)----身体面朝下的-身体下方的-受方-第i个动作（以此类推）
	local gen=0
	local tb = HTB
	if state == 1 then
		tb =HTB2
	end
	local d = 0
	local w = 0
	local h = 0
	local a = Angle(0,0,0)
	if i == 1 then
		h = 3
		d = -15
		tb = HTB
	end
	return 'h_anim_down_downside_s_'..i,tb,d,w,Vector(0,0,h),a,gen
end
local dds0 = {}
local dds1 = {1}
-----------------------------------
local function dls(i,state)
	local gen=0
	local tb = HTB
	if state == 1 then

	end
	local d = 0
	local w = 0
	local h = 0
	local a = Angle(0,180,0)
	if i == 1 then

	end
	return 'h_anim_down_leftside_s_'..i,tb,d,w,Vector(0,0,h),a,gen
end
local dls0 = {}
local dls1 = {}
-----------------------------------
local function drs(i,state)
	local gen=0
	local tb = HTB
	if state == 1 then

	end
	local d = 0
	local w = 0
	local h = 0
	local a = Angle(0,180,0)
	if i == 1 then
	end
	return 'h_anim_down_rightside_s_'..i,tb,d,w,Vector(0,0,h),a,gen
end
local drs0 = {}
local drs1 = {}
--------------------------------
local function dus(i,state)
	local gen=0
	local tb = HTB
	if state == 1 then

	end
	local d = 0
	local w = 0
	local h = 0
	local a = Angle(0,180,0)
	if i == 1 then
	end
	return 'h_anim_down_upside_s_'..i,tb,d,w,Vector(0,0,h),a,gen
end
local dus0 = {}
local dus1 = {}


---------------------------------
local function uds(i,state)
	local gen=0
	local tb = HTB
	if state == 1 then
		tb = ATB
	end

	local d = 0
	local w= 0
	local h = 0
	local a = Angle(0,0,0)
	if i == 1 then
		h = 12
		d = -13
	elseif i == 2 then
		d = -8
		w = -1
		a = Angle(0,0,-15)
	elseif i == 3 then
		h = 8
		d = -13
		tb = HTB2
	end
	return 'h_anim_up_downside_s_'..i,tb,d,w,Vector(0,0,h),a,gen
end
local uds0 = {2}
local uds1 = {1,3}


--------------------------------
local function uls(i,state)
	local gen=0
	local tb = HTB
	if state == 1 then
		tb = ATB
	end
	local d = 0
	local w = 0
	local h = 0
	local a = Angle(0,180,0)
	return 'h_anim_up_leftside_s_'..i,tb,d,w,Vector(0,0,h),a,gen
end
local uls0 = {}
local uls1 = {}

-----------------------------------------
local function urs(i,state)
	local gen=0
	local tb = HTB
	if state == 1 then
		tb = ATB
	end
	local d = 0
	local w = 0
	local h = 0
	local a = Angle(0,180,0)
	return 'h_anim_up_rightside_s_'..i,tb,d,w,Vector(0,0,h),a,gen
end
local urs0 = {}
local urs1 = {}
----------------------------------------------------



local function uus(i,state)
	local gen=0
	local tb = HTB
	if state == 1 then
		tb = ATB
	end
	local d = 0
	local w = 0
	local h = 0
	local a = Angle(0,180,0)
	return 'h_anim_up_upside_s_'..i,tb,d,w,Vector(0,0,h),a,gen
end
local uus0 = {}
local uus1 = {}

----------------------------------------------------



local function sfs(i,state)
	local gen=0
	local tb = HTB
	if state == 1 then
		tb = ATB
	end
	local d = 0
	local w = 0
	local h = 0
	local a = Angle(0,0,0)
	return 'h_anim_stand_front_s_'..i,tb,d,w,Vector(0,0,h),a,gen
end
local sfs0 = {}
local sfs1 = {1}


----------------------------------------------------



local function sbs(i,state)
	local gen=0
	local tb = HTB
	
	local d = 0
	local w = 0
	local h = 0
	local a = Angle(0,0,0)
	
	if i == 1 then
		d = -15
		h = 12
		a = Angle(0,180,0)
	end
	if state == 1 then
		tb = HTB3
		d = 12
		h = 0
		
	elseif state ==3 then
		tb = HTB3
		d = 10
		h = 5
	elseif state ==4 then
		

		h = 6
	end
	return 'h_anim_stand_back_s_'..i,tb,d,w,Vector(0,0,h),a,gen
end
local sbs0 = {}
local sbs1 = {1}


--------------------------------

-----------------------------------------------------------
local function udg(i,state)----身体面朝上的-身体下方的-攻方-第i个动作（以此类推）
	local gen=1
	local up = 1
	local spin = 0
	local tb = ATB
	local h =0
	local d = 0
	local w = 0
	local a = Angle(0,180,0)
	if i == 2 then
		gen = 0
		tb = ATB2
		up = -1
	elseif i == 1 then
		h =3
	
		
	end
	return 'h_anim_up_downside_g_'..i,tb,d,w,Vector(0,0,h),a,gen,up,spin
end
local udg1 = {1}
local udg0 = {2}
-----------------------------------------------------------


local function sbg(i,state)
	local gen=1
	local tb = ATB
	local up = 1
	local spin = 0
	local d = 0
	local w = 0
	local h = 0
	local a = Angle(0,0,0)
	if i == 1 then
		h=0
		a = Angle(0,180,0)
	end
	if state == 1 then
		tb = ATB3
		h = 0
		d = -23
		up = -1
		a = Angle(0,0,0)
		spin = 180
	end
	return 'h_anim_stand_back_g_'..i,tb,d,w,Vector(0,0,h),a,gen,up,spin
end
local sbg0 = {}
local sbg1 = {1}



-----------------------------------------------------------


local function sfg(i,state)
	local gen=1
	local tb = ATB
	local up = 1
	local spin = 0
	local d = 0
	local w = 0
	local h = 0
	local a = Angle(0,0,0)
	if i == 1 then
		
		tb=ATB3
		a = Angle(0,180,0)
		d = -31
		h=-3
		up = -1
		spin = 180
	end

	return 'h_anim_stand_front_g_'..i,tb,d,w,Vector(0,0,h),a,gen,up,spin
end
local sfg0 = {}
local sfg1 = {1}


--------------------------------------------------------------------------------------

local function hanimcsc(ORag,Hrag)-----------------------learn it from HuyangE
	for i=0, ORag:GetPhysicsObjectCount()-1 do
		local bonename = ORag:GetBoneName(ORag:TranslatePhysBoneToBone(i))
		--print(bonename)
		if Hrag.bonetb and Hrag.bonetb[bonename] then
			local phyobj = ORag:GetPhysicsObjectNum(i)
			if phyobj then			
				local pos0, bone_ang = Hrag:GetBonePosition(Hrag:LookupBone(bonename)) 
				if pos0 and bone_ang then
					ORag.boneangtbl[bonename] = bone_ang
					bone_ang = bone_ang + ORag.Bone[bonename]["random"]									
					local bone_pos = pos0 
					if ORag.Bone[bonename]["reppos"] then 
						bone_pos = pos0 + ORag.Bone[bonename]["reppos"]
					else
						bone_pos = pos0 - ORag.Bone[bonename]["addpos"]
					end	
					Animrag_CSC.pos = bone_pos
					Animrag_CSC.angle = bone_ang	
					--[[if bonename == "ValveBiped.Bip01_R_Hand" and IsValid(ORag.npc) and IsValid(ORag.npc.onrag) then
						local target = ORag.npc.onrag
						local tgrpel = target:LookupBone("ValveBiped.Bip01_Pelvis")
						if tgrpel then
							local tgrpelpos,ang = target:GetBonePosition(tgrpel)
							Animrag_CSC.pos = tgrpelpos +  ang:Up()*(10)
						end
					elseif bonename == "ValveBiped.Bip01_L_Hand" and IsValid(ORag.npc) and IsValid(ORag.npc.onrag) then
						local target = ORag.npc.onrag
						local tgrpel = target:LookupBone("ValveBiped.Bip01_Pelvis")
						if tgrpel then
							local tgrpelpos,ang = target:GetBonePosition(tgrpel)
							Animrag_CSC.pos = tgrpelpos + ang:Up()*(-10)
						end
					end]]
					phyobj:Wake()
					phyobj:ComputeShadowControl(Animrag_CSC)
				end
			end
		end
	end
end


local function H_scale(ORag)
	if !ORag.HBHeight then return end
	local scale = ORag.HBHeight/23

	for k,v in pairs(ORag.HRag) do
		if IsValid(v) then
			v:SetModelScale(scale, 0)
		end
	end

end

local function getscale(npc,rag)
	if npc:LookupBone('ValveBiped.Bip01_Head1') and npc:LookupBone('ValveBiped.Bip01_Head1') > 0 then
		local pos1 = npc:GetBonePosition( npc:LookupBone("ValveBiped.Bip01_Head1"))
		local pos2 = npc:GetBonePosition( npc:LookupBone("ValveBiped.Bip01_Neck1"))
		local pos3 = npc:GetBonePosition( npc:LookupBone("ValveBiped.Bip01_Spine4"))
		local pos4 = npc:GetBonePosition( npc:LookupBone("ValveBiped.Bip01_Spine2"))
		local pos5 = npc:GetBonePosition( npc:LookupBone("ValveBiped.Bip01_Spine1"))
		local pos6 = npc:GetBonePosition( npc:LookupBone("ValveBiped.Bip01_Spine"))
		local pos7 = npc:GetBonePosition( npc:LookupBone("ValveBiped.Bip01_Pelvis"))
		local hight = (pos2-pos1):Length()+(pos3-pos2):Length()+(pos4-pos3):Length()+(pos5-pos4):Length()+(pos6-pos5):Length()+(pos7-pos6):Length()

		rag.HBHeight = hight
	end
end

hook.Add("CreateEntityRagdoll", "scale", function(ONPC, Orgn_Rag)
	if ONPC:IsPlayer() then return end
	getscale(ONPC,Orgn_Rag)
end)

hook.Add("PlayerDeath", "scalep", function(ply)
	local rag=ply.ORag or ply:GetRagdollEntity() 
	if IsValid(rag) then
		getscale(ply,rag)
	end
end)

local function createHrag(ent,pos,tosetang,bonetable)
	local Anim_Rag = ents.Create("prop_dynamic")
	Anim_Rag:SetModel("models/sexdoll/hanimref.mdl")
	Anim_Rag:SetPos(pos)
	Anim_Rag:SetAngles(tosetang)
	Anim_Rag:SetNoDraw(true)
	Anim_Rag:Spawn()
	Anim_Rag:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	Anim_Rag.ORag = ent
	Anim_Rag.bonetb = bonetable
	if !ent.HRag then
		print('init table')
		ent.HRag = {}
	
	end
	table.insert(ent.HRag,Anim_Rag)
	------------------------------------
	--缩放AnimRag以适应ent的尺寸
	H_scale(ent)
	return Anim_Rag
end

local function preprag(ent,pos,ang,bonetable,gender)
	
	ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	ent:SetAngles(ang)
	if gender == 1 then
		if dikenable:GetBool() then 
			local dpos,ang = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Pelvis"))
			local vec = ang:Up()
			local dik = ents.Create("prop_dynamic")
			dik:SetModel("models/dik/dik.mdl")
			dik:Spawn()
			dik:SetPos(dpos)
			dik:SetAngles(vec:Angle())
			ent.dik = dik
			timer.Create("dikcheck"..dik:EntIndex(),1,0,function()
				if !IsValid(ent) or ent.reallykilled then dik:Remove() timer.Remove("dikcheck"..dik:EntIndex()) return end
			end)
		end
	end
	--[[if !ent.h_bonetb then
		ent.h_bonetb = {}
	end
	table.Merge( ent.h_bonetb, bonetable )]]
	ent.Bone = {}
	ent.boneangtbl = {}
	for bonename, _ in pairs(ATB) do
		ent.Bone[bonename] = {
			random = Angle(0, 0, 0),
			addpos = Vector(0, 0, 0),
			reppos = nil
		}
	end
			
	ent.StopAnim = false

	return createHrag(ent,pos,ang,bonetable)
end 

local function prepnpcrag(ply,ent,up,spin,existingRag)
	if !IsValid(ent) or !IsValid(ply) then return end
	-- 调用方传了 existingRag 但无效时，说明 zcity 尸体还没创建好，放弃本次。
	if existingRag ~= nil and not IsValid(existingRag) then return end

	ply.onrag = ent
	local pelvis = ent:LookupBone("ValveBiped.Bip01_Pelvis")
	if !pelvis then return end
	local pelvispos, pelvisang = ent:GetBonePosition(pelvis)
	local facevec = pelvisang:Right()
	local sidevec = pelvisang:Forward()
	facevec = Vector(facevec.x,facevec.y,0):GetNormalized()
	local tosetang = facevec:Angle()
	local npcragpos = pelvispos+facevec*(up*30)
	local npcragang = tosetang+Angle(up*90,180,0)+Angle(0,spin,0)

	local plyrag = existingRag
	if IsValid(existingRag) then
		-- zcity 模式：复用 zcity 已经创建的 FakeRagdoll / RagdollDeath
		existingRag:SetPos(npcragpos)
		existingRag:SetAngles(npcragang)
	else
		-- 非 zcity 旧逻辑：自己创建一张演员布娃娃
		plyrag = ents.Create("prop_ragdoll")
		plyrag:SetModel(ply:GetModel())
		plyrag:SetPos(npcragpos)
		plyrag:SetAngles(npcragang)
		if GZCompat ~= nil and GZCompat.ApplyRagdollSettings ~= nil then
			GZCompat.ApplyRagdollSettings(plyrag, { collision_group = COLLISION_GROUP_DEBRIS })
		else
			plyrag:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		end
		plyrag:SetNoDraw(true)
		for k, v in pairs(ply:GetBodyGroups()) do
			local current = ply:GetBodygroup(v.id)
			plyrag:SetBodygroup(v.id,  current)
		end
		plyrag:Spawn()
		plyrag:Activate()
		plyrag:SetOwner(nil)
		timer.Create("ragcheck"..plyrag:EntIndex(),1,0,function()
			if plyrag.reallykilled or !IsValid(plyrag) then timer.Remove("ragcheck"..plyrag:EntIndex()) return end
			if !IsValid(ply) then plyrag:Remove() timer.Remove("ragcheck"..plyrag:EntIndex()) return end
		end)
	end

	if GZCompat ~= nil and GZCompat.MarkCorpse ~= nil then
		GZCompat.MarkCorpse(plyrag, ply)
	end
	plyrag.AnimatedBlood_RedBlood = true
	-- 标记该尸体已被 GexLab 使用：只在 zcity 适配启用时通知 EDA 跳过，
	-- 避免抢骨骼/手部动作/裙子物理。
	if IsZCityActive() and GZCompat ~= nil and GZCompat.ClaimRagdoll ~= nil then
		GZCompat.ClaimRagdoll(plyrag, ply, "gexlab")
	end
	if GPEE and not IsValid(plyrag.emmeter) then
		Spawnurineemter(plyrag)
	end

	-- 量身高时优先用尸体骨骼；旧流程（自己建 ragdoll）才用活人骨骼量。
	local measureEnt = IsValid(existingRag) and plyrag or ply
	if measureEnt:LookupBone('ValveBiped.Bip01_Head1') then
		local pos1 = measureEnt:GetBonePosition( measureEnt:LookupBone("ValveBiped.Bip01_Head1"))
		local pos2 = measureEnt:GetBonePosition( measureEnt:LookupBone("ValveBiped.Bip01_Neck1"))
		local pos3 = measureEnt:GetBonePosition( measureEnt:LookupBone("ValveBiped.Bip01_Spine4"))
		local pos4 = measureEnt:GetBonePosition( measureEnt:LookupBone("ValveBiped.Bip01_Spine2"))
		local pos5 = measureEnt:GetBonePosition( measureEnt:LookupBone("ValveBiped.Bip01_Spine1"))
		local pos6 = measureEnt:GetBonePosition( measureEnt:LookupBone("ValveBiped.Bip01_Spine"))
		local pos7 = measureEnt:GetBonePosition( measureEnt:LookupBone("ValveBiped.Bip01_Pelvis"))
		local hight = (pos2-pos1):Length()+(pos3-pos2):Length()+(pos4-pos3):Length()+(pos5-pos4):Length()+(pos6-pos5):Length()+(pos7-pos6):Length()
		plyrag.HBHeight =hight
	else
		return
	end

	ply.rag = plyrag
	if not IsValid(existingRag) then
		ply:SetModelScale(0.2)
	end
	plyrag.npc = ply
	ent.mainrag = true
	local tr1 = util.TraceLine( {
		start = pelvispos + Vector(0,0,10),--目标位置
		endpos = pelvispos - Vector(0,0,100),
		mask = MASK_NPCWORLDSTATIC,

	})
	local pos = tr1.HitPos
	return pos,facevec,sidevec,tosetang
end
-----------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------

local modellist = {}
local modelPresetsFile = "H_model_presets.txt"





local function LoadModelPresets()--读取文件
    if file.Exists(modelPresetsFile, "DATA") then
        --print('preset exists')
        local data = file.Read(modelPresetsFile, "DATA")
        if data then
            modellist = util.JSONToTable(data) or {}
        end
    end
end
LoadModelPresets()
local function SaveModelPresets()
    file.Write(modelPresetsFile, util.TableToJSON(modellist, true))
end


local function GetlowerModel(ent)
    if not IsValid(ent) then return "" end
    local model = ent:GetModel()
    if not model or model == "" then return "" end
    return model:lower()
end

local function SaveCurrentModelSettings(ent,tbl)
    if not IsValid(ent) then return false end
    
    local model = GetlowerModel(ent)
    if not model or model == "" then return false end
    LoadModelPresets()
	if !modellist[model] then modellist[model] = {} end
    modellist[model] = tbl
    --PrintTable(modellist)
    SaveModelPresets()
    print("[GexLab]已保存模型 " .. model .. " 的设置")
    return true
end

net.Receive('setlootvalue',function()
	local tab = net.ReadTable()
	local ent = net.ReadEntity()
	SaveCurrentModelSettings(ent,tab)
end)
---------------------------------------------------------------------------------------

local function bascicfacial(i,tgr,st,todo,rt)
	if !i:GetFlexIDByName(tgr) then return end
	local r = rt/0.04 or 300
	local state = i.Hstate[#i.HRag]
	local tname = 'gex_basicfacial'..tostring(i)..tgr..'state'..state
	if timer.Exists(tname) then timer.Remove(tname) return end
	if !i.sexfcnum then i.sexfcnum={} end
	
	local start = i:GetFlexWeight(i:GetFlexIDByName(tgr))


	i.sexfcnum[tgr]=0
		
	
	local count = 0
	timer.Create(tname,0.04,-1,function()
		count = count+1
		if not IsValid(i) or !i.Hstate or i.Hstate[#i.HRag]!= state then
			timer.Remove(tname)
			return
		end
		local sr
		if count <r/2 then
			sr = start
		elseif st then
			sr = st
		else
			sr = 0
		end
		local range = todo - sr
		if IsValid(i) and i.sexfcnum[tgr]<r/2 then
			local dua = i.sexfcnum[tgr]*2/r
			i:SetFlexWeight(i:GetFlexIDByName(tgr),sr + dua*range) 
			i.sexfcnum[tgr] = i.sexfcnum[tgr] + 1
			--print(i.fcnum)
		elseif IsValid(i) and i.sexfcnum[tgr]>=r/2 and i.sexfcnum[tgr]< r then
			local dua = (r-i.sexfcnum[tgr] )*2/r
			i:SetFlexWeight(i:GetFlexIDByName(tgr),sr + dua*range) 
			i.sexfcnum[tgr] = i.sexfcnum[tgr]+1

		elseif IsValid(i) and i.sexfcnum[tgr]>=r then
			i.sexfcnum[tgr] =0
		end
	end)
end



local function startfacial(i)
	if !IsValid(i) or !gexfacenable:GetBool() then return end
	if IsValid(i.ARag) or IsValid(i.npc) then 
		local model = GetlowerModel(i)
		local facialtb
		if modellist and modellist[model] then
			facialtb = table.Copy(modellist[model]['facialexp'])
		else
			return
		end
		local state = i.Hstate[#i.HRag]
		local ftb = facialtb['state'..state]


		for k,v in pairs(ftb['flexs']) do
			bascicfacial(i,k,v['start'],v['end'],ftb['time'])
		end
	end
end



local function loot(ent,b,i,weight)
	if !ent.pickmovement then
		ent:SetActivity(ACT_PICKUP_GROUND)
		ent.pickmovement=true 
	else
		ent.pickmovement=false
	end
	
	b:SetBodygroup(i,weight )
	local phy = b:GetPhysicsObjectNum(0)
	phy:ApplyForceOffset(Vector(0,0,1*phy:GetMass()), phy:GetMassCenter())
	--print(i..b:GetBodygroupName(i)..',being looted')
	if IsValid(b.owner) and b.owner:IsPlayer() then
		b.owner:ChatPrint(b:GetBodygroupName(i)..',being looted')
	end
end


local function npcloot(ent,b)
	if !IsValid(ent) or !IsValid(b) then return end
	local model = GetlowerModel(b)
	--[[if modellist then
		for k,v in pairs(modellist) do

			local ksub = k:sub(1, -5) 
			local modelsub = model:sub(1, -5) 


			if (modelsub:find(ksub)) and !modellist[model] then model = k end
		end
	end]]
	if !b.whitelist then
		b.whitelist = {}
		if modellist and modellist[model] then
			b.whitelist = table.Copy(modellist[model]['loottable'])
		else
			for i=1,b:GetNumBodyGroups()-1 do
				b.whitelist[b:GetBodygroupName(i)]={}
				b.whitelist[b:GetBodygroupName(i)]['looted']=false 
				for c = 0,b:GetBodygroupCount(i)-1 do
					if c == b:GetBodygroupCount(i)-1 then
						b.whitelist[b:GetBodygroupName(i)][c]=0
					end
				end
			end
		end
	else
		local finsihloot = true
		for k,v in pairs(b.whitelist) do
			if k == 'Body' and not v['looted'] then 
				local id = b:FindBodygroupByName(k)
				loot(ent,b,id,b:GetBodygroupCount(id)-1)
				v['looted']=true
				return
			end
		end
		for k,v in pairs(b.whitelist) do
			if !v['looted'] then 
				finsihloot = false 
			
				local id = b:FindBodygroupByName(k)
				local total = 0
				local toloot = b:GetBodygroupCount(id)-1
				if toloot == 0 then v['looted']=true v.looting = 0 end
				for state,chance in pairs(v) do
					if chance == 0 or state=='looted' then continue end
					total = total+chance
				end
				if total==0 then 
					if randlootrhance:GetFloat()!=0 and math.Rand(0,1)<=randlootrhance:GetFloat() then
						loot(ent,b,id,toloot)
						v['looted']=true
					else
						v['looted']=true
						v.looting = 0
					end
				else
					for state,chance in pairs(v) do
						if chance == 0 or state=='looted' then continue end
						if math.Rand(0,total) <= chance and !v['looted'] then
							toloot=state
							v['looted']=true
							loot(ent,b,id,toloot)
						else
							total=total-chance
							continue 
						end
					end
					
				end
				
				return
			else
				continue 
			end
		end
		b.croplooted = finsihloot
	end

	
end

local function animtable(i)--动画组
local anims,tbs,d,w,h,ang,genders
local animg,tbg,dg,wg,hg,angg,genderg,up,spin
if i == 1 then
	anims,tbs,d,w,h,ang,genders = uds(uds1[math.random(1,2)],0)
	animg,tbg,dg,wg,hg,angg,genderg,up,spin = udg(udg1[1],0)
elseif i == 2 then
	anims,tbs,d,w,h,ang,genders = uds(uds0[1],0)
	animg,tbg,dg,wg,hg,angg,genderg,up,spin = udg(udg0[1],0)
	
elseif i == 3 then
	anims,tbs,d,w,h,ang,genders = dds(dds1[1],0)
	animg,tbg,dg,wg,hg,angg,genderg,up,spin = udg(udg1[1],0)

elseif i == 4 then


elseif i == 5 then
	anims,tbs,d,w,h,ang,genders = sbs(sbs1[1],1)
	animg,tbg,dg,wg,hg,angg,genderg,up,spin =sbg(sbg1[1],1)
elseif i == 6 then
	anims,tbs,d,w,h,ang,genders = sbs(sbs1[1],3)
	animg,tbg,dg,wg,hg,angg,genderg,up,spin =sbg(sbg1[1],1)
elseif i == 7 then
	anims,tbs,d,w,h,ang,genders = sbs(sbs1[1],4)
	animg,tbg,dg,wg,hg,angg,genderg,up,spin = sbg(sbg1[1],0)	


end
return anims,tbs,d,w,h,ang,genders,animg,tbg,dg,wg,hg,angg,genderg,up,spin
end 






local function selectanim(rag,g,rapercount)
	local model = GetlowerModel(g)
	local femaleg = false 
	if modellist and modellist[model] then
		femaleg = modellist[model]['female']
	end
	bodyfacedircheck(rag)
	local bodyfacingup = rag.facingup
	local bodyfacingright = rag.facingright
	placecheck(rag)
	local anims,tbs,d,w,h,ang,genders
	local animg,tbg,dg,wg,hg,angg,genderg,up,spin

	if !femaleg then
		if bodyfacingup then
			anims,tbs,d,w,h,ang,genders,animg,tbg,dg,wg,hg,angg,genderg,up,spin = animtable(1)
			return anims,tbs,d,w,h,ang,genders,animg,tbg,dg,wg,hg,angg,genderg,up,spin
		else
			if rapercount == 1 then--not stand
				local choice = math.random(1,3)
				if choice == 1 then
					anims,tbs,d,w,h,ang,genders,animg,tbg,dg,wg,hg,angg,genderg,up,spin = animtable(3)
				elseif choice == 2 then
					anims,tbs,d,w,h,ang,genders,animg,tbg,dg,wg,hg,angg,genderg,up,spin = animtable(6)
				else
					anims,tbs,d,w,h,ang,genders,animg,tbg,dg,wg,hg,angg,genderg,up,spin = animtable(7)
				end
			else

				if rag.HRag and #rag.HRag >= 1 then
					
					anims,tbs,d,w,h,ang,genders,animg,tbg,dg,wg,hg,angg,genderg,up,spin = animtable(5)
				else	
					anims,tbs,d,w,h,ang,genders,animg,tbg,dg,wg,hg,angg,genderg,up,spin = animtable(3)
				end
			end
			return anims,tbs,d,w,h,ang,genders,animg,tbg,dg,wg,hg,angg,genderg,up,spin
		end
	else

		if bodyfacingup then
			
			anims,tbs,d,w,h,ang,genders,animg,tbg,dg,wg,hg,angg,genderg,up,spin = animtable(2)

			return anims,tbs,d,w,h,ang,genders,animg,tbg,dg,wg,hg,angg,genderg,up,spin
		else	
			------------暂未做朝下的动作，先用着

			anims,tbs,d,w,h,ang,genders,animg,tbg,dg,wg,hg,angg,genderg,up,spin = animtable(2)

			return anims,tbs,d,w,h,ang,genders,animg,tbg,dg,wg,hg,angg,genderg,up,spin
		end
	end
end

---------------------------------------------------------------------------------------------

local function autoposfixer(ent,HRag,bone)
	if !bone then bone = "ValveBiped.Bip01_Pelvis" end
	local grag = HRag.oppo.ORag
	local spos,sang = ent:GetBonePosition(ent:LookupBone(bone)) 
	local gpos,gang = grag:GetBonePosition(grag:LookupBone("ValveBiped.Bip01_Pelvis")) 
	local hspos,hsang = HRag:GetBonePosition(HRag:LookupBone(bone)) 

	local tofitvec = (gpos-spos):GetNormalized()

	local delta_sr_sh = ( math.abs((hspos-spos):Length()))
	local correctvec = tofitvec
	if bone == 'ValveBiped.Bip01_Pelvis' then
		correctvec = sang:Right()+sang:Up()*0.5
	elseif bone == 'ValveBiped.Bip01_Head1' then
		correctvec = sang:Right()
	end
	local Npos=getb(ent,correctvec,bone)
	
	local togopos=gpos + gang:Up()*7 - gang:Right()*1
	
	if Npos and togopos then
		local step = togopos - Npos
		local truedist = ( math.abs((step):Length()))
		--print(truedist,delta_sr_sh)
		if truedist>5 and delta_sr_sh<6 then
			

			ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

			HRag:SetPos(HRag:GetPos()+step:GetNormalized())

			
			ent:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
		else
			ent:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
		end
	end



end










local function startcycle(ent,anim,v,gen,HRag)


	local _, sexAnim_time = HRag:LookupSequence(anim)
	--print(sexAnim_time)
	HRag:Fire("SetAnimation", anim)
	if !ent.StartTime then ent.StartTime = {} end
	if !ent.count then ent.count = {} end
	if !ent.Hstate then ent.Hstate = {} end
	if !ent.fixtime then ent.fixtime = {} end
	local id = #ent.HRag
	ent.StartTime[id] = CurTime()
	local entname = tostring(ent)
	local HRagname = tostring(HRag)
	local bonetbl = HRag.bonetb
	ent.fixtime[id] = CurTime()
	HRag.gen = gen
	local muti = ent.gex_multi or 0.5
	local st1 = ent.gex_state1_time and math.ceil(ent.gex_state1_time) or 10-----1阶段结束时间
	local st2 = ent.gex_state2_time and math.ceil(ent.gex_state2_time) or 20
	local st3 = ent.gex_state3_time and math.ceil(ent.gex_state3_time) or 30
	print('rapestart')
	timer.Create('corpseanim'..entname..HRagname, 0.01, 0, function()
		if (IsValid(ent) and IsValid(HRag) and IsValid(HRag.oppo)) and (IsValid(ent.npc) or ent.mainrag)then
			if ent.mainrag then----尸体
				if !ent.count then ent.count = {} end
				if !ent.Hstate then ent.Hstate = {} end
				ent.count[id] = ent.count[id] and ent.count[id] + 1 or 1
				
				if !ent.Hstate[id] then ent.Hstate[id] = 0 end
				if !ent.Hrand then ent.Hrand = 1 end
				if ent.count[id] < sexAnim_time*st1*67 and ent.Hstate[id]!=1 then
					muti = muti 
					ent.Hstate[id] = 1
					startfacial(ent)
				elseif ent.count[id] >= sexAnim_time*st1*67 and ent.count[id] < sexAnim_time*st2*67 and ent.Hstate[id]!=2 then
					muti = muti*2
					ent.Hstate[id] = 2
					startfacial(ent)
				elseif ent.count[id] >= sexAnim_time*st2*67 and ent.count[id] < sexAnim_time*st3*67 and ent.Hstate[id]!=3 then
					muti = muti*2
					ent.Hstate[id] = 3
					startfacial(ent)
				elseif ent.count[id] >= sexAnim_time*st3*67 and ent.Hstate[id]!=4 then
					muti = muti*3/2
					ent.Hstate[id] = 4
					startfacial(ent)
					timer.Simple(5,function()
						if GPEE then 
							startpee(ent.emmeter,ent)
							startpee(ent.emmeter,ent)
							timer.Simple(6,function()
								staggeredpee(ent.emmeter,ent)
							end)
						else
							print('未安装GPEE，无法使用喷尿功能')
						end
					end)
				end
				
				--print(muti)
				HRag:SetPlaybackRate(muti)
				hanimcsc(ent,HRag)
				if CurTime() - ent.StartTime[id] >= sexAnim_time/muti then
					timer.Simple(sexAnim_time/(3*muti),function()
						if !IsValid(ent) then return end
						EmitSound( 'bodyhit/splat'..math.random(1,9)..'.wav',ent:GetPos())
						ent:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
					end)
					
					
					HRag:Fire("SetAnimation", anim)
					ent.StartTime[id] = CurTime()
				end



				
				if CurTime() - ent.fixtime[id] >= 1 and HRag.oppo.gen==1 and autofix:GetBool() then
					if HRag.bonetb == HTB3 then
						autoposfixer(ent,HRag,'ValveBiped.Bip01_Head1')
					else
						autoposfixer(ent,HRag,nil)
					end
					
					ent.fixtime[id] = CurTime()
				end
				
				
			end
-----------------------------------------------------------------------------------------------------------------
			if IsValid(ent.npc) then--活的
				
				if !ent.count then ent.count = {} end
				ent.count[id] = IsValid(ent.npc.onrag) and IsValid(ent.npc.onrag.count) and ent.npc.onrag.count[id] or ent.count[id] and ent.count[id] + 1 or 1
				if !ent.Hstate then ent.Hstate = {} end
				if !ent.Hstate[id] then ent.Hstate[id] = 0 end
				if !ent.Hrand then ent.Hrand = 1 end
				if ent.count[id] < sexAnim_time*st1*67 and ent.Hstate[id]!=1 then
					muti = muti 
					ent.Hstate[id] = 1
					startfacial(ent)
				elseif ent.count[id] >= sexAnim_time*st1*67 and ent.count[id] < sexAnim_time*st2*67 and ent.Hstate[id]!=2 then
					muti = muti*2
					ent.Hstate[id] = 2
					startfacial(ent)
				elseif ent.count[id] >= sexAnim_time*st2*67 and ent.count[id] < sexAnim_time*st3*67 and ent.Hstate[id]!=3 then
					muti = muti*2
					ent.Hstate[id] = 3
					startfacial(ent)
				elseif ent.count[id] >= sexAnim_time*st3*67 and ent.Hstate[id]!=4 then
					muti = muti*3/2
					ent.Hstate[id] = 4
					startfacial(ent)
					--[[timer.Simple(5,function()
						if GPEE then 
							startpee(ent.emmeter,ent)
							startpee(ent.emmeter,ent)
							timer.Simple(6,function()
								staggeredpee(ent.emmeter,ent)
							end)
						else
							print('未安装GPEE，无法使用喷尿功能')
						end
					end)]]
				end
				

				HRag:SetPlaybackRate(muti)
				hanimcsc(ent,HRag)
				if CurTime() - ent.StartTime[id] >= sexAnim_time/muti then
					timer.Simple(sexAnim_time/(3*muti),function()
						if !IsValid(ent) then return end
						EmitSound( 'bodyhit/splat'..math.random(1,9)..'.wav',ent:GetPos())
						ent:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
					end)
					
					
					HRag:Fire("SetAnimation", anim)
					ent.StartTime[id] = CurTime()
				end

				-----------------------------------------------------------------------------------------------------------
				if !ent.emsotimer then ent.emsotimer = 0 ent.soundtime=0 end
				--print(CurTime() - ent.emsotimer..'比较'..ent.soundtime)
				if CurTime() - ent.emsotimer > ent.soundtime and gen==0 then
					ent.emsotimer = CurTime()
					

					if ent.Hstate[id] == 1 then
						local Hrand = math.random(1,8) 
						while Hrand == ent.Hrand do
							Hrand=math.random(1,8) 
						end
						ent.Hrand=Hrand
					elseif ent.Hstate[id] == 2 then
						local Hrand = math.random(1,3) 
						while Hrand == ent.Hrand do
							Hrand=math.random(1,3) 
						end
						ent.Hrand=Hrand
					elseif ent.Hstate[id] == 3 then
						local Hrand = math.random(1,4) 
						while Hrand == ent.Hrand do
							Hrand=math.random(1,4) 
						end
						ent.Hrand=Hrand
					elseif ent.Hstate[id] == 4 then
						local Hrand = math.random(1,3) 
						while Hrand == ent.Hrand do
							Hrand=math.random(1,3) 
						end
						ent.Hrand=Hrand
					end

					local soundname = 'sexf/A/'..ent.Hstate[id]..'_'..ent.Hrand..'.wav'
					ent.soundtime = SoundDuration(soundname)
					ent:EmitSound(soundname)
				end
				
				if ent.npc:IsNPC() then
					local tr = util.TraceLine( {
						start = ent:GetPos() + Vector(0,0,100),--目标位置
						endpos = ent:GetPos() - Vector(0,0,100),
						mask = MASK_NPCWORLDSTATIC,

					})
					ent.npc:SetPos(tr.HitPos)
				end

				if IsValid(ent.dik) then
					local trag = ent.npc.onrag
					if !IsValid(ent.npc.onrag) then return end
					local entpo = ent:GetPos()
					local ragheadpos = trag:GetBonePosition(trag:LookupBone("ValveBiped.Bip01_Head1"))
					local overpo = trag:GetPos()
					local vec

					vec = (overpo-entpo):GetNormalized()
					if HRag.oppo.bonetb == HTB3 then
						vec = (ragheadpos-entpo):GetNormalized()
					end	

					ent.dik:SetPos(entpo+vec*3.5)
					ent.dik:SetAngles(vec:Angle())
				end


				if CurTime() - ent.fixtime[id] >= 1 and HRag.gen==1 and autofix:GetBool() then
					local tr1 = util.TraceLine( {
						start = ent:GetPos() + Vector(0,0,10),--目标位置
						endpos = ent:GetPos() - Vector(0,0,100),
						mask = MASK_NPCWORLDSTATIC,

					})
					local groundz = tr1.HitPos.z
					local lfeetpos = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_L_Foot"))
					local rfeetpos = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_R_Foot"))
					local hlfeetpos = HRag:GetBonePosition(HRag:LookupBone("ValveBiped.Bip01_L_Foot"))
					local hrfeetpos = HRag:GetBonePosition(HRag:LookupBone("ValveBiped.Bip01_R_Foot"))

					local lz,rz = lfeetpos.z,rfeetpos.z
					local deltal = lz-groundz
					local deltar = rz - groundz
					local hdeltal = hlfeetpos.z - groundz
					local hdeltar = hrfeetpos.z - groundz
					if hdeltal<-5 or hdeltar < -5 or deltal<0 or deltar<0 then
						print('向上调整')
						HRag:SetPos(HRag:GetPos()+Vector(0,0,1))
					elseif deltal>5 or deltar>5 then
						print('向下调整')
						HRag:SetPos(HRag:GetPos()-Vector(0,0,1))
					end
					ent.fixtime[id] = CurTime()

				end




			end
			----------------------------------------------------------------------------------------------------

			
			
		else
			ent.count = nil
			
			endcycle(ent,HRag,entname,HRagname,bonetbl)
		end
	end)
end

function endcycle(ent,h,entname,HRagname,bonetbl)
	
	if timer.Exists('corpseanim'..entname..HRagname) then timer.Remove('corpseanim'..entname..HRagname) 
		ent.count = nil 
		
		if IsValid(h) then
			h:Remove() 
		end
	end
	if IsValid(ent.npc) then ent.npc:SetModelScale(1) ent:Remove() end
	if IsValid(ent) then 



	local pel = ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(ent:LookupBone("ValveBiped.Bip01_Pelvis")))
	if IsValid(pel) then
		pel:EnableCollisions(true)
	end
	local legr = ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(ent:LookupBone("ValveBiped.Bip01_R_Thigh")))
	local legl = ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(ent:LookupBone("ValveBiped.Bip01_L_Thigh")))
	if IsValid(legl) then
		legl:EnableCollisions(true)
	end
	if IsValid(legr) then
		legr:EnableCollisions(true)
	end


	


	print('动画结束，移除HRag')
	ent.Hstate = nil
	end
	
end

function startanim(ent,pos,ang,bonetable,anim,v,gender)
	if !IsValid(ent) then return end
	ent:SetNoDraw(false)
	local HRag
	HRag = preprag(ent,pos,ang,bonetable,gender)
	startcycle(ent,anim,v,gender,HRag)
	return HRag
end 


----------------------------------------------------------------------
local function StartZCitySex(ply, ent, anims,tbs,d,w,h,ang,genders,animg,tbg,dg,wg,hg,angg,genderg,up,spin,tries)
	local plyrag = GZCompat.GetCorpse(ply) or GetZCityRagdoll(ply)
	if not IsValid(plyrag) then
		GexDebug("StartZCitySex waiting for zcity ragdoll, tries=", tries or 0)
		if (tries or 0) >= 20 then
			if IsValid(ply) then ply:Spawn() end
			return
		end
		timer.Simple(0.05, function()
			if IsValid(ply) and IsValid(ent) then
				StartZCitySex(ply, ent, anims,tbs,d,w,h,ang,genders,animg,tbg,dg,wg,hg,angg,genderg,up,spin,(tries or 0)+1)
			end
		end)
		return
	end
	GexDebug("StartZCitySex using zcity ragdoll", plyrag)

	local pos,facevec,sidevec,tosetang = prepnpcrag(ply, ent, up, spin, plyrag)
	if not pos then
		-- 失败时至少让玩家恢复，避免卡在死亡状态。
		ply.onrag = nil
		if IsValid(ply) then ply:Spawn() end
		return
	end

	local gHRag, sHRag
	dg,wg,hg = dg*(ply.rag.HBHeight/27),wg*(ply.rag.HBHeight/27),hg*(ply.rag.HBHeight/27)

	if Enhanced_death_used then
		net.Start("PlayerRag_StartDeathCam")
			net.WriteInt(ply.rag:EntIndex(), 32)
			net.WritePlayer(ply)
		net.Broadcast()
	end

	timer.Simple(2,function()
		print(genderg)
		gHRag = startanim(ply.rag,pos+hg+facevec*dg+sidevec*wg,tosetang+angg,tbg,animg,facevec,genderg)
		sHRag = startanim(ent,pos+h+facevec*d+sidevec*w,tosetang+ang,tbs,anims,facevec,genders)
		gHRag.oppo = sHRag
		sHRag.oppo = gHRag
		RunConsoleCommand('noclip')
	end)

	timer.Create("playerchecker",1,0,function()
		if ply:Alive() then
			if IsValid(gHRag) then
				gHRag:Remove()
			end
			ply.onrag = nil
			timer.Remove("playerchecker")
			return
		end
	end)
end

concommand.Add('sex',function(ply,cmd,args)
	if not IsValid(ply) then return end
	local trace = ply:GetEyeTrace()
	local ent = nil
    	if IsValid(trace.Entity) then
		--print(trace.Entity)
		ent = trace.Entity
	end

	
	if IsValid(ent) and ent:IsRagdoll() and !IsValid(ply.rag) then
		
		local anims,tbs,d,w,h,ang,genders,animg,tbg,dg,wg,hg,angg,genderg,up,spin = selectanim(ent,ply,1)

		if IsZCityActive() then
			-- zcity 模式：先杀掉玩家，等 zcity 生成 FakeRagdoll/RagdollDeath，
			-- 再复用这个 zcity 尸体作为场景演员，避免额外再生成一张布娃娃。
			ply:KillSilent()
			ply:Spectate(OBS_MODE_ROAMING)
			ply:SpectateEntity(NULL)
			StartZCitySex(ply, ent, anims,tbs,d,w,h,ang,genders,animg,tbg,dg,wg,hg,angg,genderg,up,spin,0)
			return
		end

		local pos,facevec,sidevec,tosetang = prepnpcrag(ply,ent,up,spin)
		local gHRag,sHRag
		dg,wg,hg = dg*(ply.rag.HBHeight/27),wg*(ply.rag.HBHeight/27),hg*(ply.rag.HBHeight/27)

		--[[ply:SetNoDraw(true)
		ply:SetNotSolid(true)
		ply:DrawViewModel(false)]]
		
		ply:KillSilent()
		ply:Spectate(OBS_MODE_ROAMING)
		ply:SpectateEntity(NULL)
		
		if Enhanced_death_used then
		net.Start("PlayerRag_StartDeathCam")
			net.WriteInt(ply.rag:EntIndex(), 32)
			net.WritePlayer(ply)
		net.Broadcast()
		end
		
		timer.Simple(2,function()
			print(genderg)
			gHRag = startanim(ply.rag,pos+hg+facevec*dg+sidevec*wg,tosetang+angg,tbg,animg,facevec,genderg)
			sHRag = startanim(ent,pos+h+facevec*d+sidevec*w,tosetang+ang,tbs,anims,facevec,genders)
			gHRag.oppo = sHRag
			sHRag.oppo = gHRag
			RunConsoleCommand('noclip')
		end)
		timer.Create("playerchecker",1,0,function()
			if ply:Alive() then 
				
				
				
				gHRag:Remove()
				
				ply.onrag = nil 
				
				
				
				timer.Remove("playerchecker") 
				return
			end
		end)

	elseif IsValid(ply.rag) then
		
		
	
		
		
		ply:SetPos(ply.rag:GetPos())
		ply:SetAngles(ply.rag:GetAngles())
		ply:Spawn()--------不知道为啥不这样玩家受不到伤害了。。。
		
		--[[ply:SetNoDraw(false)
		ply:SetNotSolid(false)
		ply:DrawViewModel(true)
		ply:UnSpectate()]]
		if Enhanced_death_used then
		net.Start("PlayerRag_PlayerSpawn")
			net.WritePlayer(ply)
			net.WriteBool(true)
		net.Broadcast()
		end
	
		
	end

end)



--------------------------------------------------------------------------------------------------------------
local tickover = 0



hook.Add('Think','bodyrape',function()
	if !NPCrapeenable:GetBool() then return end
	if CurTime() - tickover < 0.2 then return end
	tickover = CurTime()
	local npcs = GZCompat.GetCachedNPCs()
	for k, v in ipairs( ents.FindByClass("prop_ragdoll") ) do
		
		if !v.tchecker then v.tchecker = CurTime() end
		if !v:LookupBone("ValveBiped.Bip01_Pelvis") or !v:LookupBone("ValveBiped.Bip01_Head1") or v.raped or (Enhanced_death_used and not IsZCityActive() and ((!v.reallykilled))) or IsValid(v.npc) then continue end

		bodyfacedircheck(v)
		


		local ply
		for _,p in ipairs( player.GetAll() ) do
			if IsValid(p) then
				ply = p
				break
			end
		end

		local pos = v:GetPos()
		if !v.HRag then v.HRag = {} end
		if !v.rapertb then v.rapertb = {} end
		local emy = v.rapertb[#v.HRag+1]
		
		--print(emy)
		
		
		if Enhanced_death_used and (IsValid(v.excEnemy) and v.excEnemy !=v.owner) and v.excEnemy.cantrape !=v and !IsValid(v.excEnemy.rag) and (!v.HRag or #v.HRag == 0) and !IsValid(emy) then
			emy = v.excEnemy
			
			if !emy:IsNPC() or (modellist and modellist[GetlowerModel(emy)] and modellist[GetlowerModel(emy)]['banned']) then v.excEnemy=nil continue end
			
			if IsValid(emy.target) and emy.target.reallykilled then
				emy.target = nil
			end
			
			v.rapertb[#v.HRag+1] = emy
			--print(IsValid(emy),emy:IsNPC(),emy.target,emy.fktg,v.TB,emy)

			
		
		elseif (!v.HRag or #v.HRag == 0) and !IsValid(emy) then
			for n, m in ipairs( npcs ) do

				if IsValid(m) and m:IsNPC() and m:Alive() then 
					
					if (!Enhanced_death_used and m:GetClass()=="npc_citizen")  or IsValid(m.rag) or IsValid(m.target) or m.cantrape==v or (modellist and modellist[GetlowerModel(m)] and modellist[GetlowerModel(m)]['banned']) or (IsValid(ply) and v.isplayerside and m:Disposition(ply) == D_LI) or (IsValid(ply) and !v.isplayerside and m:Disposition(ply) == D_HT) then  continue end
					if IsValid(m.fktg) then 
						
						if m.fktg.raped then
							m.fktg=nil
						
						else
							--print(m.fktg:EntIndex())
							continue 
						end
						
					end
					emy = m
		
					v.rapertb[#v.HRag+1] = emy
					break
				end
				
			end
			--print(IsValid(emy),emy:IsNPC(),emy)
		elseif v.HRag and v.rapercount and #v.HRag < v.rapercount and !IsValid(emy) then
			
			for n, m in ipairs( npcs ) do
				
				if IsValid(m) and m:IsNPC() and m:Alive()  then 
					
					if (!Enhanced_death_used and m:GetClass()=="npc_citizen") or  m.fkedtg == v or IsValid(m.rag) or IsValid(m.target) or m.cantrape==v or (modellist and modellist[GetlowerModel(m)] and modellist[GetlowerModel(m)]['banned']) or (IsValid(ply) and v.isplayerside and m:Disposition(ply) == D_LI) or (IsValid(ply) and !v.isplayerside and m:Disposition(ply) == D_HT) then continue end
					if IsValid(m.fktg) then 
						if m.fktg.raped then
							m.fktg=nil
						
						else
							continue 
						end
						
					end
					emy = m

					v.rapertb[#v.HRag+1] = emy
					break
				end
				
			end
			--print(IsValid(emy),emy:IsNPC(),emy)
		end
		--if v:EntIndex() == 308 then print(v.rapertb[#v.HRag+1]) end
		if !IsValid(emy) then  continue end
		if (#v.HRag>0 and !IsValid(v.HRag[1])) then v.raped = true  continue end
		
		
		if !emy:IsNPC()  or (Enhanced_death_used and (IsValid(emy.target))) or IsValid(emy.rag) or IsValid(emy:GetEnemy()) then v.excEnemy=nil v.rapertb[#v.HRag+1] = nil emy.fktg = nil continue end
		
		local emypos = emy:GetPos()
		local dist = pos:Distance(emypos)

		emy.fktg = v
		
		
		
		if dist < 30 then
			--v.croplooted = true
			--emy:ClearSchedule()
			if !v.looting then v.looting = CurTime() end
			if CurTime()-v.looting>0.5 and lootenable:GetBool() then
				npcloot(emy,v)
				v.looting = CurTime()
			elseif !lootenable:GetBool() then
				v.croplooted = true
			end
			if v.croplooted and !IsValid(emy.rag) then
				
				timer.Simple(1,function()
					if !v.rapercount then
						if v.facingup then
							
							v.rapercount = 1
						else
							if math.random(0,100)<=thp:GetFloat() then
								v.rapercount = 2
							else
								v.rapercount = 1
							end
						end
					
					end
					
					if v.HRag and #v.HRag >= v.rapercount then
						v.raped = true
						
						return
					end
					if !IsValid(emy) or (IsValid(emy) and IsValid(emy.rag)) then return end
					
					print('raper count = '..v.rapercount)

					if v.owner:IsPlayer() then
						v.owner:ChatPrint('raper count = '..v.rapercount)
					end

					local anims,tbs,d,w,h,ang,genders,animg,tbg,dg,wg,hg,angg,genderg,up,spin = selectanim(v,emy,v.rapercount)
					local pos,facevec,sidevec,tosetang = prepnpcrag(emy,v,up,spin)
					local gHRag,sHRag
					
					emy:SetNoDraw(true)
					emy:SetNotSolid(true)
					emy:SetMaxLookDistance(1)
					local wpn = emy:GetActiveWeapon()
					
					if IsValid(wpn) then
						wpn:SetNoDraw(true)
					end
					timer.Simple(2,function()
						if !IsValid(v) then return end
						if v.HRag and #v.HRag >= 1 and IsValid(v.HRag[1]) then
							gHRag = startanim(emy.rag,pos+hg+facevec*dg*(v.HBHeight/20)+sidevec*wg,tosetang+angg,tbg,animg,facevec,genderg)	
							sHRag = startanim(v,v.HRag[1]:GetPos()+h+facevec*d+sidevec*w,v.HRag[1]:GetAngles()+ang,tbs,anims,facevec,genders)
						else
							gHRag = startanim(emy.rag,pos+hg+facevec*dg+sidevec*wg,tosetang+angg,tbg,animg,facevec,genderg)
							sHRag = startanim(v,pos+h+facevec*d+sidevec*w,tosetang+ang,tbs,anims,facevec,genders)
						end
						gHRag.oppo = sHRag
						sHRag.oppo = gHRag
				
					end)


					local gex_total_time = math.random(gex_min_time:GetFloat(),gex_max_time:GetFloat())
					timer.Simple(gex_total_time or 60,function()
						if IsValid(emy.rag) then
							if IsValid(gHRag) then
								gHRag:Remove()
							end
							for k, v in pairs(emy.rag:GetBodyGroups()) do
								local current = emy.rag:GetBodygroup(v.id)
								emy:SetBodygroup(v.id,  current)
							end

							emy:SetNoDraw(false)
							emy:SetNotSolid(false)
							emy:SetForceCrouch(false)
							emy:SetLastPosition(v:GetPos()+Vector(math.random(100,200),math.random(100,200),0))
							emy:SetSchedule( SCHED_FORCED_GO )
							emy:SetMaxLookDistance(6000)
							if IsValid(wpn) then wpn:SetNoDraw(false) end
							
						end
						if IsValid(emy.onrag) then
							if IsValid(sHRag) then
								sHRag:Remove()
							end
							
							
							emy.onrag = nil
							emy.fkedtg = v
							emy.fktg = nil
						end

					end)
				end)
			end

		elseif ((emy:GetCurrentSchedule() !=72 and emy:GetCurrentSchedule() != 51) or emy:GetLastPosition():Distance(v:GetPos())>50) then
			
			if emy:GetCurrentSchedule() == 81 then 
				v.nilcount = v.nilcount and v.nilcount + 1 or 1
				
				if v.nilcount >3 then
					print(emy,'failed to rape')
					v.excEnemy = nil
					emy.fktg = nil
					emy.cantrape = v
					v.rapertb[#v.HRag+1] = nil
					v.nilcount = 0
				end
			end

			
			--[[if CurTime()-v.tchecker>120 then
				emy:ClearSchedule()
				v.raped = true
			end]]
			emy:SetLastPosition(v:GetPos()+Vector(20,20,0))
			emy:SetSchedule( SCHED_FORCED_GO_RUN )
			

		end

	end

end)



hook.Add('EntityTakeDamage','hurtfker',function(ent,dmg)
	--print(ent,dmg:GetInflictor():IsVehicle())

	if IsValid(ent.npc) and ent.npc:Alive() and (dmg:GetAttacker():IsNPC() or dmg:GetAttacker():IsPlayer()) then 

		dmg:SetDamageForce( 0.3*dmg:GetDamageForce())
		--ent.npc:TakeDamage(ent.npc:Health())
		--EmitSound( "npc/combine_soldier/die"..math.random(1,3)..'.wav',ent:GetPos())
		ent.reallykilled = true
		

		if ent.npc:IsNPC() then
			
			--ent.npc:TakeDamage( 999)
			ent.npc:Remove()
		else
			ent.npc:KillSilent()
		end
		if Enhanced_death_used then
		runallhooks(ent) 
		end
		
	end
end)



concommand.Add('debugsex',function(ply,cmd,args)
	
	if not IsValid(ply) then return end
	local trace = ply:GetEyeTrace()
	local ent = nil
    	if IsValid(trace.Entity) then
		--print(trace.Entity)
		ent = trace.Entity
		--preprag(ent,trace.HitPos,Angle(0,0,0),ATB,1)
		--[[for i=0, ent:GetPhysicsObjectCount()-1 do
			local phy = ent:GetPhysicsObjectNum(i)
			print(ent:GetBoneName( ent:TranslatePhysBoneToBone(i) ))
			--print(phy)
		end]]
		--print(ent:Disposition(ply))
		--print(ent:LookupBone("ValveBiped.Bip01_R_Finger01"))
		--ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_R_Finger01"), Angle(0,0,0))
		--print(ent.HBHeight)
		--PrintTable(FindMetaTable("NPC"))
		--overrideNPClogic(ent)
		--resetNPClogic(ent)
		--ent:SetGoalPos(Vector(534.536011,-405.551971,-148.000000))
		--ent:SetLastPosition(Vector(534.536011,-405.551971,-148.000000))
		--print(ent:IsWeapon())
	end

	--[[local RevivedNPC = ents.Create("prop_physics")
	RevivedNPC:SetModel("models/dik/dik.mdl")
	RevivedNPC:Spawn()
	RevivedNPC:SetPos(trace.HitPos)]]
	


	

	--[[if no-t IsValid(ent) then return end
	ent.Hstate = 4]]
	--bascicfacial(ent,'blink',0.2,0.6,2)
	--startfacial(ent)
	--local tbl = table.Copy(modellist[ent:GetModel():lower()])
	--PrintTable(tbl)
	--[[npcloot(ply,ent)
	print(ent.croplooted)
	if ent.croplooted then
		PrintTable(ent.whitelist)
	end]]
	--[[if !ent.oldthink then 
		ent.oldthink = ent.Think
	end]]
	--print(placecheck(ent))
	--[[if ent:GetNoDraw() then
		ent:SetNoDraw(false)
	else
		ent:SetNoDraw(true)
	end]]
	--ent:ClearSchedule()
	--print(ent:GetSubMaterial(14))
	--PrintTable(ent:GetMaterials())
	--print(ent:GetBonePosition( ent:LookupBone("ValveBiped.Bip01_Pelvis") ))
	--print(ent:GetBodygroupCount(ent:FindBodygroupByName('panty'))-1)
	--ent:SetAngles(Angle(0,90,0))
	--[[local vec = trace.StartPos-trace.HitPos
	local pos=getb(ent,vec)
	local button = ents.Create( "prop_dynamic" )
	button:SetModel( "models/dav0r/buttons/button.mdl" )
	button:SetPos(pos)
	button:Spawn()]]
	--[[if ! timer.Exists('debug') then
		timer.Create('debug',0.01,0,function()
			
			ent:SetFlexWeight(1, 1)

			local tr1 = util.TraceLine({
				start = pos+Vector(0,0,-100),
				endpos = pos+Vector(0,0,-200),
				mask = MASK_SOLID
			})
			
			
		end)
	else
		timer.Remove('debug')
	end]]
	
end)



--[[hook.Add( "OnEntityCreated", "longviscom", function( ent )
	if ( ent:GetClass() == "npc_combine_s" ) then
		ent:AddSpawnFlags(256)
	end
end )]]
