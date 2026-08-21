-- ZCity compatibility shared module (GexLab edition)
-- 命名约定：公开 API 使用 PascalCase；模块内部局部变量/函数使用 snake_case。
-- 该文件幂等，多个 Mod 共用同一个 GZCompat 表，后加载的不覆盖已存在函数。
if GZCompat == nil then GZCompat = {} end

if not ConVarExists("gmod_zcity_compat_debug") then
    CreateConVar("gmod_zcity_compat_debug", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "GZCity compat debug logging", 0, 1)
end

-- 只在 zcity 或兼容的 hg.Ragdoll_Create 环境启用。
function GZCompat.IsActive()
    return engine.ActiveGamemode() == "zcity" or (hg ~= nil and isfunction(hg.Ragdoll_Create))
end

function GZCompat.GetCorpse(ply)
    if not IsValid(ply) then return nil end
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

local npc_cache = {}
local npc_cache_time = -1
function GZCompat.GetCachedNPCs()
    if npc_cache_time ~= CurTime() then
        npc_cache = ents.FindByClass("npc_*")
        npc_cache_time = CurTime()
    end
    return npc_cache
end

-- ==================== 骨骼/Ragdoll 占用仲裁 ====================

-- 统一“谁在驱动这具尸体”的标记，避免 EDA / GexLab / GPEE 同时抢同一具尸体的骨骼。
function GZCompat.ClaimRagdoll(rag, owner, reason)
    if not IsValid(rag) then return false end
    if rag.gmod_claimed and rag.gmod_claimed_by ~= owner then
        return false
    end
    rag.gmod_claimed = true
    rag.gmod_claimed_by = owner
    rag.gmod_claim_reason = reason or "unknown"
    -- 兼容旧字段：部分旧代码直接检查 gmod_occupied / glex_occupied
    rag.gmod_occupied = true
    rag.glex_occupied = true
    return true
end

function GZCompat.ReleaseRagdoll(rag)
    if not IsValid(rag) then return false end
    rag.gmod_claimed = false
    rag.gmod_claimed_by = nil
    rag.gmod_claim_reason = nil
    rag.gmod_occupied = false
    rag.glex_occupied = false
    return true
end

function GZCompat.IsRagdollClaimed(rag)
    return IsValid(rag) and rag.gmod_claimed == true
end

function GZCompat.IsRagdollOccupied(rag)
    return IsValid(rag) and (rag.gmod_claimed == true or rag.gmod_occupied == true or rag.glex_occupied == true)
end

function GZCompat.GetRagdollClaimOwner(rag)
    if not IsValid(rag) then return nil end
    return rag.gmod_claimed_by
end

-- ==================== 统一 Ragdoll 设置 ====================
-- opts:
--   collision_group: 碰撞组
--   body_groups:     { [group_id] = value }
--   scale:           Vector / number（SetModelScale）
--   scale_time:      SetModelScale 第二参数
--   no_draw:         bool
--   solid:           bool（true=solid）
function GZCompat.ApplyRagdollSettings(rag, opts)
    if not IsValid(rag) then return false end
    opts = opts or {}
    if opts.collision_group ~= nil then
        rag:SetCollisionGroup(opts.collision_group)
    end
    if opts.no_draw ~= nil then
        rag:SetNoDraw(opts.no_draw)
    end
    if opts.solid ~= nil then
        rag:SetNotSolid(not opts.solid)
    end
    if opts.scale ~= nil then
        rag:SetModelScale(opts.scale, opts.scale_time or 0)
    end
    if opts.body_groups ~= nil then
        for group_id, value in pairs(opts.body_groups) do
            rag:SetBodygroup(group_id, value)
        end
    end
    return true
end

-- ==================== 统一尸体血量（鞭尸） ====================

function GZCompat.SetCorpseHealth(rag, health)
    if not IsValid(rag) then return false end
    rag.gz_corpse_health = health
    return true
end

function GZCompat.GetCorpseHealth(rag)
    if not IsValid(rag) then return nil end
    return rag.gz_corpse_health
end

-- 返回 killed, remaining
function GZCompat.DamageCorpse(rag, amount)
    if not IsValid(rag) or not rag.gz_corpse_health then return false, 0 end
    rag.gz_corpse_health = rag.gz_corpse_health - amount
    if rag.gz_corpse_health <= 0 then
        rag.gz_corpse_health = 0
        return true, 0
    end
    return false, rag.gz_corpse_health
end