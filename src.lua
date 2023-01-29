local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/WetCheezit/Bracket-V2/main/src.lua"))()
_G.Window, MainGUI = Library:CreateWindow("YVNG NENNO")

local Tab1 = _G.Window:CreateTab("main")
local Groupbox1 = Tab1:CreateGroupbox("funcs", "Left")

local ExampleToggle2 = Groupbox1:CreateToggle("fruit farm", function(state)
   print(state)
   _G.Toggul = state
end)

local toggleGui =  Groupbox1:CreateToggle("Close Gui", function(state)
   print(state)
end)

local keybind1 = toggleGui:CreateKeyBind("NONE", function(state)
    game.CoreGui['YVNG NENNO'].Enabled = not game.CoreGui['YVNG NENNO'].Enabled
end)

local ExampleButton = Groupbox1:CreateButton("exclusive serverhop", function()
    print("Pressed")
    local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
local File = pcall(function()
    AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
end)
if not File then
    table.insert(AllIDs, actualHour)
    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
end
function TPReturner()
    local Site;
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0;
    for i,v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _,Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        local delFile = pcall(function()
                            delfile("NotSameServers.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end
            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(function()
                    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                    wait()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                end)
                wait(4)
            end
        end
    end
end

function Teleport()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end
Teleport()
end)

_G.Toggul = false
print('toggle')

local function fireproximityprompt(Obj, Amount, Skip)
    if Obj.ClassName == "ProximityPrompt" then 
        Amount = Amount or 1
        local PromptTime = Obj.HoldDuration
        if Skip then 
            print('skip ',Skip)
            Obj.HoldDuration = 0
        end
        for i = 1, Amount do 
            Obj:InputHoldBegin()
            wait(Obj.HoldDuration+.5)
            Obj:InputHoldEnd()
        end
        --Obj.HoldDuration = PromptTime
    else 
        error("userdata<ProximityPrompt> expected")
    end
end

local function magic(model)
    print('modelname '..model.Name)
    local prompt
    repeat wait() until model.PrimaryPart~=nil
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(model.PrimaryPart.Position)
    task.wait(1)
    for i,v in next,model:GetDescendants() do
        if v:IsA('ProximityPrompt') then
            fireproximityprompt(v,1,true)
        end
    end
end

workspace.Terrain.World.TargetFilter.Map.DescendantAdded:Connect(function(part)
    if not _G.Toggul then return end
    print(part:GetFullName())
    if part:IsA('Model') then
        print('DETECTED A MODEL, RENAMING')
        part.Name = 'FRUIT MODEL'
        magic(part)
    end
end)
