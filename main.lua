local Players = game:GetService("Players")
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local targetPlayer = nil
local ChatConn = nil
local LeaveConn = nil
local Channel = "All"
local MimicDelay = 0
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Chat Mimicker V1",
    LoadingTitle = "Chat Mimicker V1",
    LoadingSubtitle = "by HexDev on discord",
    ConfigurationSaving = {
       Enabled = false,
       FolderName = nil,
       FileName = "Chat Mimicker"
    },
    Discord = {
       Enabled = false,
       Invite = "",
       RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
       Title = "",
       Subtitle = "",
       Note = "",
       FileName = "",
       SaveKey = true,
       GrabKeyFromSite = false,
       Key = {""}
    }
})

local Home = Window:CreateTab("Home", nil)
Home:CreateSection("Main")

Home:CreateInput({
    Name = "Target Player",
    PlaceholderText = "hexdev",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local Player = Players:FindFirstChild(Text)
        if Player then 
            targetPlayer = Player
        else
            Rayfield:Notify({
                Title = "Error!",
                Content = "Target player not found!",
                Duration = 6.5,
                Image = nil,
                Actions = {
                   Ignore = {
                      Name = "Okay!",
                      Callback = function()
                      end
                   },
                },
            })
        end
    end,
})

local Toggle = Home:CreateToggle({
    Name = "Toggle Mimicker",
    CurrentValue = false,
    Flag = "mimic",
    Callback = function(Value)
        if Value then 
            if targetPlayer then
                if not ChatConn then
                    ChatConn = targetPlayer.Chatted:Connect(function(message)
                        wait(MimicDelay)
                        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, Channel)
                    end)
                end
            else
                Rayfield:Notify({
                    Title = "Error!",
                    Content = "Target Player not set!",
                    Duration = 6.5,
                    Image = nil,
                    Actions = {
                        Ignore = {
                            Name = "Okay!",
                            Callback = function()
                            end
                        },
                    },
                })
            end
        else
            if ChatConn then
                ChatConn:Disconnect()
                ChatConn = nil
            end
        end
    end,
})
Toggle:Set(false)

Home:CreateSection("Extras")
Home:CreateSlider({
    Name = "Mimic Delay",
    Range = {0, 100},
    Increment = 1,
    Suffix = "Seconds",
    CurrentValue = 0,
    Flag = "MimicDelay",
    Callback = function(Value)
        MimicDelay = Value
    end,
})
 Home:CreateInput({
    Name = "Chat Channel",
    PlaceholderText = "All",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        Channel = Text
    end,
})

LeaveConn = game.Players.ChildRemoved:Connect(function(player) 
    if targetPlayer and player == targetPlayer then
        Rayfield:Notify({
            Title = "Warning!",
            Content = "Target Player left the game.",
            Duration = 6.5,
            Image = nil,
            Actions = { 
               Ignore = {
                  Name = "Okay!",
                  Callback = function()
                  Toggle:Set(false)
               end
            },
         },
         })
        end
end)

Home:CreateButton({
    Name = "Destroy Gui",
    Callback = function()
        if LeaveConn then
            LeaveConn:Disconnect()
        end
        if ChatConn then
            ChatConn:Disconnect()
        end
        Rayfield:Destroy()
    end,
 })

local Binds = Window:CreateTab("Keybinds", nil)
Binds:CreateKeybind({
    Name = "Start Mimicker",
    CurrentKeybind = "RightControl",
    HoldToInteract = false,
    Flag = "MimicKeybind",
    Callback = function(Keybind)
    Toggle:Set(not Toggle.CurrentValue)
    end,
})
Binds:CreateKeybind({
    Name = "Close Gui",
    CurrentKeybind = "RightAlt",
    HoldToInteract = false,
    Flag = "CloseKeybind",
    Callback = function(Keybind)
        if LeaveConn then
            LeaveConn:Disconnect()
        end
        if ChatConn then
            ChatConn:Disconnect()
        end
        Rayfield:Destroy()
    end,
})
 
local Credits = Window:CreateTab("Credits", nil)
Credits:CreateSection("Developers")
Credits:CreateLabel("hexdev on Discord")
Credits:CreateSection("Design")
Credits:CreateLabel("starplatinum5498 on Discord")
Credits:CreateSection("Testers")
Credits:CreateLabel("wsglost on Discord")