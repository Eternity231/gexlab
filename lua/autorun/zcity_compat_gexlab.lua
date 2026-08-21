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

-- Optional: per-player custom model memory, works without editing zcity.
if SERVER and not GZCompat._modelsLoaded then
    GZCompat._modelsLoaded = true
    GZCompat.savedModels = GZCompat.savedModels or {}
    local modelsFile = "gmod_zcity_compat_models.json"

    local function LoadModels()
        local data = file.Read(modelsFile, "DATA")
        if data then
            GZCompat.savedModels = util.JSONToTable(data) or {}
        end
    end
    local function SaveModels()
        file.Write(modelsFile, util.TableToJSON(GZCompat.savedModels, true))
    end
    LoadModels()

    function GZCompat.SetCustomModel(ply, mdl)
        if not IsValid(ply) or not isstring(mdl) then return false end
        GZCompat.savedModels[ply:SteamID64()] = mdl
        SaveModels()
        return true
    end

    function GZCompat.ResetCustomModel(ply)
        if not IsValid(ply) then return end
        GZCompat.savedModels[ply:SteamID64()] = nil
        SaveModels()
    end

    hook.Add("PlayerSpawn", "GZCompat_ReapplyModel", function(ply)
        if not IsValid(ply) then return end
        local mdl = GZCompat.savedModels[ply:SteamID64()]
        if not mdl or mdl == ply:GetModel() then return end

        -- 等一帧，让 zcity 自己的 ApplyAppearance 先执行，再覆盖成自定义模型
        timer.Simple(0, function()
            if IsValid(ply) and GZCompat.savedModels[ply:SteamID64()] == mdl and ply:GetModel() ~= mdl then
                ply:SetModel(mdl)
                GZCompat.Debug("Reapplied custom model to", ply, mdl)
            end
        end)
    end)

    concommand.Add("gmod_setplayermodel", function(ply, cmd, args)
        if not IsValid(ply) then return end
        local mdl = args[1]
        if not mdl or not string.StartWith(mdl, "models/") or not string.EndsWith(mdl, ".mdl") then
            ply:ChatPrint("[GZCompat] 用法: gmod_setplayermodel models/xxx/xxx.mdl")
            return
        end
        if not util.IsValidModel(mdl) then
            ply:ChatPrint("[GZCompat] 模型不存在或未加载: " .. mdl)
            return
        end
        util.PrecacheModel(mdl)
        if GZCompat.SetCustomModel(ply, mdl) then
            ply:SetModel(mdl)
            ply:ChatPrint("[GZCompat] 已保存自定义模型: " .. mdl)
        end
    end)

    concommand.Add("gmod_resetplayermodel", function(ply)
        if not IsValid(ply) then return end
        GZCompat.ResetCustomModel(ply)
        ply:ChatPrint("[GZCompat] 已清除自定义模型，下次重生用 zcity 默认外观")
    end)
end