-- ZCity compatibility shared module (GexLab edition)
-- This file is intentionally idempotent.
if GZCompat == nil then GZCompat = {} end

if not ConVarExists("gmod_zcity_compat_debug") then
    CreateConVar("gmod_zcity_compat_debug", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "GZCity compat debug logging", 0, 1)
end

function GZCompat.IsActive()
    return engine.ActiveGamemode() == "zcity" or (hg ~= nil and isfunction(hg.Ragdoll_Create))
end

function GZCompat.GetCorpse(ply)
    local rag = ply.FakeRagdoll
    if IsValid(rag) then return rag end
    rag = ply.RagdollDeath
    if IsValid(rag) then return rag end
    rag = ply:GetNWEntity("RagdollDeath")
    if IsValid(rag) then return rag end
    rag = ply:GetNWEntity("FakeRagdoll")
    if IsValid(rag) then return rag end
    return nil
end

function GZCompat.MarkCorpse(rag, owner)
    if not IsValid(rag) then return false end
    if rag.gmod_corpse_marked then return false end
    rag.gmod_corpse_marked = true
    rag.gmod_corpse_owner = owner
    rag.gmod_corpse_time = CurTime()
    rag:SetNWEntity("GModCorpseOwner", owner)
    rag:SetNWFloat("GModCorpseTime", CurTime())
    return true
end

function GZCompat.Debug(...)
    local cvar = GetConVar("gmod_zcity_compat_debug")
    if cvar and cvar:GetBool() then
        print("[GZCompat][DEBUG]", ...)
    end
end

local npcCache = {}
local npcCacheTime = -1
function GZCompat.GetCachedNPCs()
    if npcCacheTime ~= CurTime() then
        npcCache = ents.FindByClass("npc_*")
        npcCacheTime = CurTime()
    end
    return npcCache
end
