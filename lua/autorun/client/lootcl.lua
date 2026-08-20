
local tab = nil
local function GetlowerModel(ent)
    if not IsValid(ent) then return "" end
    local model = ent:GetModel()
    if not model or model == "" then return "" end
    return model:lower()
end
local function getinittable(ent)
    local fulltbl = {}
    for i=1,ent:GetNumBodyGroups()-1 do
        local name = ent:GetBodygroupName(i)
        fulltbl[name]={}
        fulltbl[name]['looted']=false 
        for c = 0,ent:GetBodygroupCount(i)-1 do
            fulltbl[name][c]=0
        end
    end
    return fulltbl
end

local function getinitfctable(ent)
    local fulltbl = {}
    for i = 1,4 do
        local st = 'state'..i
        fulltbl[st]={['flexs']={},['time']=1}
        for i=1,ent:GetFlexNum() - 1 do
            local name = ent:GetFlexName(i)
            fulltbl[st]['flexs'][name] = {}
            fulltbl[st]['flexs'][name]['start']=0
            fulltbl[st]['flexs'][name]['end']=0
        end
    end
    return fulltbl
end

local function tablesHaveSameElements(t1, t2)
    if #t1 ~= #t2 then return false end
    
    local seen = {}
    for _, v in ipairs(t1) do
        seen[v] = (seen[v] or 0) + 1
    end
    
    for _, v in ipairs(t2) do
        if not seen[v] then return false end
        seen[v] = seen[v] - 1
        if seen[v] == 0 then seen[v] = nil end
    end
    
    return next(seen) == nil
end


local function lmp(ent)
	local model = ent:GetModel()
	if not model or model == '' then return end
	model = model:lower()
   
    if file.Exists("H_model_presets.txt", "DATA") then
        --print('preset exists')
        local data = file.Read("H_model_presets.txt", "DATA")
        if data then
            local fulltbl = util.JSONToTable(data) or {}
            for k,v in pairs(fulltbl) do

                local ksub = k:sub(1, -5) 
                local modelsub = model:sub(1, -5) 


                if (modelsub:find(ksub)) then model = k end
            end
            if fulltbl[model] then
                tab=fulltbl[model]
            elseif tab then

                local initslottb = table.GetKeys(tab['loottable'])
                for k,v in pairs(fulltbl) do
                    local exittb = table.GetKeys(v['loottable'])
                    if tablesHaveSameElements(initslottb, exittb) then 
                        tab=table.Copy(fulltbl[k])
                    end
                end

            end

        end
    end

end
local function openmenu(ent)
    
    lmp(ent)
    if !tab or !tab['loottable'] or !tab['facialexp'] then
        tab = {}
        tab['banned'] = false
        tab['female'] = false
        tab['loottable'] = getinittable(ent)
        tab['facialexp'] = getinitfctable(ent)
        lmp(ent)
        
    end
    




    local sex_menu = vgui.Create('DFrame')
    sex_menu:SetTitle('Gexlab_menu')
    sex_menu:MakePopup(true)
    sex_menu:SetSizable( true)
    sex_menu:SetDraggable(true)
    sex_menu:SetSize(300,6*30)
    sex_menu:SetPos(500,300)
    local lootb = sex_menu:Add('DButton')
    lootb:SetText( 'lootmenu' )
    lootb:Dock(TOP)
    lootb.DoClick = function()	
        if sex_menu.o then sex_menu.o:Remove() end
        local Lmenu = vgui.Create('DFrame')
        sex_menu.o = Lmenu
        Lmenu:SetDraggable(true)
        Lmenu:SetTitle('NPC_loot_list')
        local n = 0
        for k,v in pairs(tab['loottable']) do
            local group = Lmenu:Add('DButton')
            group:SetText( k )
            group:Dock(TOP)
            
            group.DoClick = function()	
                local weight = vgui.Create('DFrame')
                weight:SetDraggable(true)
                weight:SetSize(200,150)
                weight:SetPos(1200,300)
                weight:SetTitle(k..'state list')
                
                local pot = weight:Add('DButton')
                pot.DoClick=function()
                    local chance = vgui.Create('DFrame')
                    chance:SetDraggable(true)
                    chance:SetSize(300,80)
                    chance:SetPos(1400,300)
                    chance:SetTitle('lootprotection')
                    local check = chance:Add('DCheckBoxLabel')
                    check:Dock(TOP)
                    check:SetChecked(tab['loottable'][k]['looted'])
                    check:SetText('不许拿走'..k..'(Protection_enable)')
                    check.OnChange = function(bool)
                        tab['loottable'][k]['looted']=check:GetChecked()
                        --print(check:GetChecked())
                    end
                    local oldthink = chance.Think
                    chance.Think=function(self)
                        if !IsValid(weight) then
                            self:Remove()
                        end
                        return oldthink(self)
                    end
                    
                end
                pot:SetText('loot_protection')
                pot:Dock(TOP)



                local chanc = weight:Add('DButton') 
                    chanc.DoClick=function()
                        local chance = vgui.Create('DFrame')
                        chance:SetDraggable(true)
                        chance:SetPos(1400,300)
                        chance:SetTitle('state')
                        local n = 0 
                        for s,c in pairs(tab['loottable'][k]) do
                            n=n+1
                            if s=='looted' then continue end
                            local cslider = chance:Add('DNumSlider')
                            cslider:SetText('state '..s..' chance')
                            cslider:Dock(TOP)
                            cslider:SetDecimals(0)
                            cslider:SetMinMax(0,10)  
                            cslider:SetValue(tab['loottable'][k][s] or 0)
                            cslider.OnValueChanged=function()
                                tab['loottable'][k][s]=cslider:GetValue()
                            end
                        end
                        chance:SetSize(200,50*n)
                        local help = chance:Add('DLabel')
                        help:SetAutoStretchVertical(true)
                        help:Dock(BOTTOM)
                        help:SetText('chance概率为A = A/(A+B)')
                        local oldthink = chance.Think
                        chance.Think=function(self)
                            if !IsValid(weight) then
                                self:Remove()
                            end
                            return oldthink(self)
                        end
                        
                    end
                chanc:SetText('state_chance')
                chanc:Dock(TOP)
                
                
                local oldthink = weight.Think
                weight.Think=function(self)
                    if !IsValid(Lmenu) then
                        self:Remove()
                    end
                    return oldthink(self)
                end
            end
            n=n+1
        end
        Lmenu:SetSize(400,(n+1)*30)
        Lmenu:SetPos(800,300)
        local save = Lmenu:Add('DButton')
        save:SetText( 'save' )
        save:Dock(BOTTOM)
        save.DoClick = function()
            Lmenu:Remove()
            net.Start('setlootvalue')
                net.WriteTable(tab)
                net.WriteEntity(ent)
            net.SendToServer()
        end
        local rand = Lmenu:Add('DButton')
        rand:SetText( 'random loot chance' )
        rand:Dock(BOTTOM)
        rand.DoClick = function()
            local random = vgui.Create('DFrame')
            random:SetDraggable(true)
            random:SetSize(200,150)
            random:SetPos(1200,900)
            random:SetText('random loot chance')
            local rslider = random:Add('DNumSlider')
            rslider:SetText('chance')
            rslider:Dock(TOP)
            rslider:SetDecimals(1)
            rslider:SetMinMax(0,1)  
            rslider:SetValue(GetConVar("gex_randlootrhance"):GetFloat() or 0)
            rslider:SetConVar("gex_randlootrhance")
            local oldthink = random.Think
            random.Think=function(self)
                if !IsValid(Lmenu) then
                    self:Remove()
                end
                return oldthink(self)
            end
        end
        
        local oldthink = Lmenu.Think
        Lmenu.Think=function(self)
            if !IsValid(sex_menu) then
                self:Remove()
            end
            return oldthink(self)
        end
    end
    local face = sex_menu:Add('DButton')
    face:SetText( 'sex_facialexprss' )
    face:Dock(TOP)
    face.DoClick = function()
        if sex_menu.o then sex_menu.o:Remove() end
        local facialmenu = vgui.Create('DFrame')
        sex_menu.o = facialmenu
        facialmenu:SetTitle('facialmenu')
        facialmenu:SetDraggable(true)
        facialmenu:SetSizable( true)
        facialmenu:SetSize(1000,1000)
        facialmenu:SetPos(sex_menu:GetX ()+300,sex_menu:GetY())
        
        local Model = facialmenu:Add("DModelPanel") 
        Model:SetModel( ent:GetModel() )
        Model:SetAnimated( true )
        --Model:SetPos(800,600)
        Model:SetSize(500,500)
        Model:Dock(TOP)
        function Model:LayoutEntity( ent )
            if !ent.flextb then ent.flextb = {} end
            for i=1, ent:GetFlexNum() - 1 do
                ent:SetFlexWeight(i,ent.flextb[i] or 0)
            end
            local attatchment = ent:GetAttachment(ent:LookupAttachment('eyes'))
            if !attatchment then return end
            local eyepos = attatchment.Pos + attatchment.Ang:Forward()*10
            ent:SetEyeTarget(eyepos)
            Model:SetCamPos(Vector(eyepos.x, eyepos.y, eyepos.z ))
            Model:SetLookAt( Vector(attatchment.Pos.x, attatchment.Pos.y, attatchment.Pos.z ) )
        end
        local penmodel = Model:GetEntity()
        for sti=1,4 do
            local st=facialmenu:Add('DButton')
            st:Dock(TOP)
            st:SetText( 'sex_state_'..sti )
            st.DoClick = function()
                for n,w in pairs(tab['facialexp']['state'..sti]['flexs']) do
                    penmodel.flextb[penmodel:GetFlexIDByName(n)] = w['start']
                end
                if facialmenu.scr then facialmenu.scr:Remove() end
                local facialop = facialmenu:Add('DScrollPanel')
                facialmenu.scr = facialop
                facialop:Dock(BOTTOM)
                local help = facialop:Add('DLabel')
                help:Dock(TOP)
                help:SetHeight( 100 )
                help:SetText('init express')
                for i=1, ent:GetFlexNum() - 1 do
                    local fcbt = facialop:Add('DNumSlider')
                    fcbt:SetText('(start)'..ent:GetFlexName(i))
                    fcbt:Dock(TOP)
                    fcbt:SetDecimals(1)
                    fcbt:SetMinMax(0,1) 
                    fcbt:SetValue(tab['facialexp']['state'..sti]['flexs'][ent:GetFlexName(i)]['start'] or 0)
                    fcbt.OnValueChanged=function(self,value)
                        tab['facialexp']['state'..sti]['flexs'][ent:GetFlexName(i)]['start']=value
                        for n,w in pairs(tab['facialexp']['state'..sti]['flexs']) do
                            penmodel.flextb[penmodel:GetFlexIDByName(n)] = w['start']
                        end
                    end
                end
                local help2 = facialop:Add('DLabel')
                help2:SetHeight( 100 )
                help2:Dock(TOP)
                help2:SetText('fin express')
                for i=1, ent:GetFlexNum() - 1 do
                    local fcbt = facialop:Add('DNumSlider')
                    fcbt:SetText('(end)'..ent:GetFlexName(i))
                    fcbt:Dock(TOP)
                    fcbt:SetDecimals(1)
                    fcbt:SetMinMax(0,1) 
                    fcbt:SetValue(tab['facialexp']['state'..sti]['flexs'][ent:GetFlexName(i)]['end'] or 0)
                    fcbt.OnValueChanged=function(self,value)
                        tab['facialexp']['state'..sti]['flexs'][ent:GetFlexName(i)]['end']=value
                        for n,w in pairs(tab['facialexp']['state'..sti]['flexs']) do
                            penmodel.flextb[penmodel:GetFlexIDByName(n)] = w['end']
                        end
                    end
                end
                local help3 = facialop:Add('DLabel')
                help3:Dock(TOP)
                help3:SetHeight( 100 )
                help3:SetText('express duration')
                local t = facialop:Add('DNumSlider')
                t:SetText('facial_change_duration')
                t:Dock(TOP)
                t:SetDecimals(1)
                t:SetMinMax(0,10)
                t:SetValue(tab['facialexp']['state'..sti]['time'] or 2)
                t.OnValueChanged=function(self,value)
                    tab['facialexp']['state'..sti]['time']=value
                end
                facialop:SetSize(300,300)
            end
        end

        local savef = facialmenu:Add('DButton')
        savef:SetText( 'save' )
        savef:Dock(BOTTOM)
        savef.DoClick = function()
            facialmenu:Remove()
            net.Start('setlootvalue')
                net.WriteTable(tab)
                net.WriteEntity(ent)
            net.SendToServer()
        end    
        local oldthink = facialmenu.Think
        facialmenu.Think=function(self)
            if !IsValid(sex_menu) then
                self:Remove()
            end
            return oldthink(self)
        end

    end
    local gender = sex_menu:Add('DCheckBoxLabel')
    gender:Dock(TOP)
    gender:SetChecked(tab['female'])
    gender:SetText('female(女性)')
    gender.OnChange = function(bool)
        tab['female']=gender:GetChecked()

    end
    local bl = sex_menu:Add('DCheckBoxLabel')
    bl:Dock(TOP)
    bl:SetChecked(tab['banned'])
    bl:SetText('add to blacklist(将该模型加入黑名单)')
    bl.OnChange = function(bool)
        tab['banned']=bl:GetChecked()

    end
    local save = sex_menu:Add('DButton')
    save:SetText( 'save' )
    save:Dock(BOTTOM)
    save.DoClick = function()
        sex_menu:Remove()
        net.Start('setlootvalue')
            net.WriteTable(tab)
            net.WriteEntity(ent)
        net.SendToServer()
    end

    



    local help = sex_menu:Add('DLabel')
    help:Dock(BOTTOM)
    help:SetText('current model:'..ent:GetModel())
    sex_menu.OnClose= function()
        tab=nil
    end
end

concommand.Add('GexLab_menu',function()
    local ply = LocalPlayer()
    local tgr = ply:GetEyeTrace()
    local ent=ply
    if tgr.Entity:IsNPC() or tgr.Entity:IsRagdoll() then
        ent = tgr.Entity
    end
    --print(ent)
    openmenu(ent)
end)
--[[local customMesh=nil
net.Receive('test',function()

customMesh = Mesh()
customMesh:BuildFromTriangles(net.ReadTable())

end)

hook.Add("PostDrawOpaqueRenderables", "RenderCustomMesh", function()
    if customMesh then
        render.SetMaterial(Material("models/wireframe"))
        --arender.SetColorModulation(1, 0.5, 0.5)

        -- 使用矩阵控制位置和旋转
        cam.PushModelMatrix(Matrix())
            customMesh:Draw()
        cam.PopModelMatrix()
    end
end)]]

