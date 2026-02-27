local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local WORDLIST_URL = "https://raw.githubusercontent.com/ZannsXD/txt/refs/heads/main/teks.txt"
local DatabaseKata = {}
local HurufAktif = ""

task.spawn(function()
    local success, result = pcall(function()
        return game:HttpGet(WORDLIST_URL)
    end)
    
    if success then
        for word in string.gmatch(result, "([^\n\r]+)") do
            local clean = word:gsub("%s+", ""):lower()
            if #clean > 0 then
                table.insert(DatabaseKata, clean)
            end
        end
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PANEL VANYLA"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 160)
MainFrame.Position = UDim2.new(0.5, -130, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2.5
UIStroke.Color = Color3.fromRGB(157, 34, 53)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.Text = "PANEL HUB"
Title.TextColor3 = Color3.fromRGB(157, 34, 53)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.Parent = MainFrame

local LetterLabel = Instance.new("TextLabel")
LetterLabel.Size = UDim2.new(1, 0, 0, 25)
LetterLabel.Position = UDim2.new(0, 0, 0, 35)
LetterLabel.Text = "TARGET: -"
LetterLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
LetterLabel.BackgroundTransparency = 1
LetterLabel.Font = Enum.Font.GothamMedium
LetterLabel.TextSize = 13
LetterLabel.Parent = MainFrame

local AnswerBox = Instance.new("TextLabel")
AnswerBox.Size = UDim2.new(0, 220, 0, 45)
AnswerBox.Position = UDim2.new(0.5, -110, 0, 65)
AnswerBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
AnswerBox.Text = "---"
AnswerBox.TextColor3 = Color3.fromRGB(255, 255, 255)
AnswerBox.TextSize = 18
AnswerBox.Font = Enum.Font.GothamBold
AnswerBox.Parent = MainFrame
Instance.new("UICorner", AnswerBox)

local BoxStroke = Instance.new("UIStroke")
BoxStroke.Thickness = 1
BoxStroke.Color = Color3.fromRGB(157, 34, 53)
BoxStroke.Parent = AnswerBox

local RollBtn = Instance.new("TextButton")
RollBtn.Size = UDim2.new(0, 120, 0, 32)
RollBtn.Position = UDim2.new(0.5, -60, 0, 120)
RollBtn.BackgroundColor3 = Color3.fromRGB(157, 34, 53)
RollBtn.Text = "RE-ROLL"
RollBtn.TextColor3 = Color3.new(1, 1, 1)
RollBtn.Font = Enum.Font.GothamBold
RollBtn.TextSize = 13
RollBtn.AutoButtonColor = true
RollBtn.Parent = MainFrame
Instance.new("UICorner", RollBtn)

local function CariSaran(hurufTarget)
    if #DatabaseKata == 0 then return "LOADING..." end
    local target = hurufTarget:lower()
    local panjangTarget = string.len(target)
    local matches = {}
    for _, kata in ipairs(DatabaseKata) do
        if string.sub(kata, 1, panjangTarget) == target then
            table.insert(matches, kata)
        end
    end
    if #matches > 0 then
        local kataPilihan = matches[math.random(1, #matches)]:upper()
        return kataPilihan
    end
    return "TIDAK DITEMUKAN"
end

local MatchRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("MatchUI")

MatchRemote.OnClientEvent:Connect(function(action, value)
    if action == "UpdateServerLetter" then
        HurufAktif = tostring(value)
        LetterLabel.Text = "TARGET: " .. HurufAktif:upper()
        AnswerBox.Text = CariSaran(HurufAktif)
    elseif action == "MatchEnd" or action == "HideMatchUI" then
        HurufAktif = ""
        LetterLabel.Text = "TARGET: -"
        AnswerBox.Text = "---"
    end
end)

RollBtn.MouseButton1Click:Connect(function()
    if HurufAktif ~= "" then
        AnswerBox.Text = CariSaran(HurufAktif)
    else
        AnswerBox.Text = "TUNGGU GILIRAN"
    end
end)
