-- My ImGui Builder Library
local Builder = {}
Builder.__index = Builder

-- Fungsi untuk membuat instance GUI baru
function Builder.New(config)
    local self = setmetatable({}, Builder)
    self.title = config.title or "Window"
    self.size = config.size or {300, 200}
    self.OnRender = config.OnRender or function() end
    return self
end

-- Function wrapper untuk Render Window
function Builder:Render()
    -- Set ukuran awal window jika diperlukan
    if ImGui.SetNextWindowSize then
        ImGui.SetNextWindowSize(self.size[1], self.size[2], 1) -- 1 = ImGuiCond_FirstUseEver
    end

    if ImGui.Begin(self.title) then
        -- Kirim helper method 'crt' ke callback OnRender
        self.OnRender(self)
        ImGui.End()
    end
end

-- Helper: InputInt dengan SetNextItemWidth otomatis
function Builder:InputInt(label, value, width)
    if width and width > 0 then
        ImGui.SetNextItemWidth(width)
    end
    local changed, new_val = ImGui.InputInt(label, value)
    return changed and new_val or value
end

-- Helper: Child Window dengan perlindungan ukuran (mencegah overflow)
function Builder:Child(id, width, height, border, callback)
    local w = width or 0.0
    local h = height or 0.0
    local b = border or false

    if ImGui.BeginChild(id, w, h, b) then
        if type(callback) == "function" then
            callback()
        end
        ImGui.EndChild()
    end
end

-- Helper: Button sederhana yang kompatibel dengan berbagai executor
function Builder:Button(label, callback, width, height)
    if width and width > 0 then
        ImGui.SetNextItemWidth(width)
    end
    
    if ImGui.Button(label) then
        if type(callback) == "function" then
            callback()
        end
    end
end

-- Helper: Text
function Builder:Text(text)
    ImGui.Text(text)
end

return Builder
