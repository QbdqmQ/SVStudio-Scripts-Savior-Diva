--[[
    MIT License

    Copyright (c) 2026 Q不懂取名Q

    Savior Diva - Growl

    I would appreciate it if you could credit me in the work.
    如果能在工程或作品标注我的名字，我将不胜感激。

    This plugin was made with the assistance of Deepseek.
    本插件使用 Deepseek 辅助制作。
--]]

--[[
    【关于本插件的使用】

    如果需要保存配置文件，则需要在英文目录下使用，工程也需命名为英文。

    “动态方向” 针对每一个音符，而不是选中的区域。

    若将非音高偏差的参数设为 0 ，则生成参数时不会生成该参数的控制点。

    “振幅上限” “振幅下限” 决定 “动态方向” 的最大值和最小值， “动态方向” 为 “无” 时这两个参数无效。

    个人建议：在使用本插件生成参数后，提升音区偏移的数值，更有利于得到本插件预想的效果。

    在 "动态方向" 不为 “无” 时， “平滑参数” 可用于控制振幅峰值的变化速度。 
    “平滑参数” 越大，振幅峰值变化越快（类似指数函数）。
    “平滑参数” 越小，振幅峰值变化越慢（类似对数函数）。

    如果你需要在一个工程内使用多个本插件的设置，你可以复制本插件，然后：
    在 “获取项目文件名（用于配置文件）” 这个注释的下方代码修改 “ .SDGrowl.cfg ” 的名字。推荐修改成如 “ .SDGrowl.1.cfg ” 等以数字命名的后缀。
    在下方 “getClientInfo” 修改本插件的名字。推荐修改成如 “Savior Diva - Growl_1” 等以数字命名的后缀。

    本插件已经有预设好的参数。如果你需要修改参数的默认值，可以在下方 “local defaults” 修改。
--]]

--[[
    [About Using This Plugin]

    If you need to save the config file, it must be used in an English-named directory, and the project must also be named in English.

    "Dynamics" applies to each individual note, not the selected area.

    If parameters other than pitch are set to 0, control points for those parameters will not be generated during parameter generation.

    "Range Min" and "Range Max" determine the maximum and minimum values of the "Dynamics". These two parameters are invalid when "Dynamics" is set to "None".

    Personally recommend: Increasing the Tune Shift value after generating parameters with this plugin may better achieve its intended effect.

    When "Dynamics" is not "None", the "Smooth" can be used to control the rate of change of the amplitude peak.
    The larger the "Smooth", the faster the amplitude peak changes (similar to an exponential function).
    The smaller the "Smooth", the slower the amplitude peak changes (similar to a logarithmic function).

    If you need to use multiple settings of this plugin within one project, you can duplicate this plugin and then:
    Modify the name of ".SDGrowl.cfg" in the code below the comment "获取项目文件名（用于配置文件）". It is recommended to change it to a numerically suffixed name such as ".SDGrowl.1.cfg".
    Modify the name of this plugin in "getClientInfo" below. It is recommended to change it to a numerically suffixed name such as "Savior Diva - Growl_1".

    This plugin already has preset parameters. If you need to modify the default values of the parameters, you can do so in "local defaults" below.
--]]

function getClientInfo()
    return {
        name = SV:T("Savior Diva - Growl"),
        author = "Q不懂取名Q",
        category = SV:T("Savior Diva"),
        versionNumber = 1,
        minEditorVersion = 65540
    }
end

function getTranslations(langCode)
    if langCode == "zh-cn" then
        return {
            -- 命名
            {"Savior Diva", "救世歌姬"},
            {"Savior Diva - Growl", "SD 咆哮"},
            -- 参数标签
            {"Pitch Base", "音高偏差基准值"},
            {"Fixed Range", "固定抖动振幅"},
            {"Dynamics", "动态方向"},
            {"Range Min", "振幅下限"},
            {"Range Max", "振幅上限"},
            {"Smooth", "平滑参数"},
            {"Loudness Base", "响度基准值"},
            {"Loudness Range", "响度范围"},
            {"Tension Base", "张力基准值"},
            {"Tension Range", "张力范围"},
            {"Breath Base", "气声基准值"},
            {"Breath Range", "气声范围"},
            {"Gender Base", "性别基准值"},
            {"Gender Range", "性别范围"},
            {"Points per Quarter", "点/四分音符"},
            {"Overwrite", "覆盖已有参数"},
            {"Enable Pitch", "启用音高调校"},
            -- 组合框选项
            {"None", "无"},
            {"Crescendo", "渐强"},
            {"Decrescendo", "渐弱"},
            -- 错误/提示信息
            {"Error", "错误"},
            {"Tip", "提示"},
            {"Warning", "警告"},
            {"Unable to get current project", "无法获取当前项目"},
            {"Unable to get main editor", "无法获取主编辑器"},
            {"Unable to get current group", "无法获取当前组"},
            {"Unable to get current group target", "无法获取当前组目标"},
            {"Unable to get current selection", "无法获取当前选择"},
            {"Please select one or more notes first", "请先选中一个或多个音符"},
            {"Done", "完成"},
            {"Generated reference parameters for %d notes", "已为 %d 个音符生成参考参数"},
            {"Unable to save configuration file", "无法保存配置文件"},
            {"Unable to load configuration file", "无法加载配置文件"},
            {"Configuration file format error", "配置文件格式错误"},
            -- 注释
            {"For details on using this plugin, please read the accompanying txt file or open the plugin to read.", "关于本插件的使用详情，请阅读本插件附带的txt文件，或打开本插件阅读。"}
        }
    end
    return {}
end

function main()
    -- 获取当前项目实例
    local project = SV:getProject()
    if not project then
        SV:showMessageBox(SV:T("Error"), SV:T("Unable to get current project"))
        SV:finish()
        return
    end

    -- 获取项目文件名（用于配置文件）
    local projectFileName = project:getFileName()
    local configFileName = nil
    if projectFileName ~= "" then
        configFileName = projectFileName .. ".SDGrowl.cfg"
    end

    -- 获取主编辑器对象
    local mainEditor = SV:getMainEditor()
    if not mainEditor then
        SV:showMessageBox(SV:T("Error"), SV:T("Unable to get main editor"))
        SV:finish()
        return
    end

    -- 获取当前激活的组（音符所在的组）
    local scope = mainEditor:getCurrentGroup()
    if not scope then
        SV:showMessageBox(SV:T("Error"), SV:T("Unable to get current group"))
        SV:finish()
        return
    end
    local group = scope:getTarget()
    if not group then
        SV:showMessageBox(SV:T("Error"), SV:T("Unable to get current group target"))
        SV:finish()
        return
    end

    -- 获取当前选中的对象
    local selection = mainEditor:getSelection()
    if not selection then
        SV:showMessageBox(SV:T("Error"), SV:T("Unable to get current selection"))
        SV:finish()
        return
    end

    -- 检查是否有选中的音符
    local selectedNotes = selection:getSelectedNotes()
    if #selectedNotes == 0 then
        SV:showMessageBox(SV:T("Tip"), SV:T("Please select one or more notes first"))
        SV:finish()
        return
    end

    -- 定义默认值
    local defaults = {
        pitchBase = 0,
        pitchRange = 370,
        dynamics = 0,
        pitchMin = 20,
        pitchMax = 600,
        smooth = 0,
        loudnessBase = 3,
        loudnessRange = 2.3,
        tensionBase = 0.68,
        tensionRange = 0.15,
        breathBase = 0.54,
        breathRange = 0.15,
        genderBase = 0,
        genderRange = 0.15,
        pointsPerQuarter = 460,
        overwrite = true,
        enablePitch = true
    }

    -- 如果存在配置文件，尝试加载并覆盖默认值
    if configFileName then
        local file = io.open(configFileName, "r")
        if file then
            local content = file:read("*a")
            file:close()
            local loadFunc, err = load("return " .. content)
            if loadFunc then
                local ok, loadedConfig = pcall(loadFunc)
                if ok and type(loadedConfig) == "table" then
                    for key, value in pairs(loadedConfig) do
                        if defaults[key] ~= nil then
                            defaults[key] = value
                        end
                    end
                else
                    SV:showMessageBox(SV:T("Warning"), SV:T("Configuration file format error"))
                end
            else
                SV:showMessageBox(SV:T("Warning"), SV:T("Unable to load configuration file"))
            end
        end
    end

    -- 构建对话框表单（所有标签使用英文键）
    local form = {
        title = "SD - Growl",
        message = SV:T("For details on using this plugin, please read the accompanying txt file or open the plugin to read."),
        buttons = "OkCancel",
        widgets = {
            { name = "pitchBase", type = "Slider", label = SV:T("Pitch Base"), format = "%.0f", minValue = -800, maxValue = 800, interval = 1, default = defaults.pitchBase },
            { name = "pitchRange", type = "Slider", label = SV:T("Fixed Range"), format = "%.0f", minValue = 0, maxValue = 800, interval = 1, default = defaults.pitchRange },
            { name = "dynamics", type = "ComboBox", label = SV:T("Dynamics"), choices = {SV:T("None"), SV:T("Crescendo"), SV:T("Decrescendo")}, default = defaults.dynamics },
            { name = "pitchMin", type = "Slider", label = SV:T("Range Min"), format = "%.0f", minValue = 0, maxValue = 800, interval = 1, default = defaults.pitchMin },
            { name = "pitchMax", type = "Slider", label = SV:T("Range Max"), format = "%.0f", minValue = 0, maxValue = 800, interval = 1, default = defaults.pitchMax },
            { name = "smooth", type = "Slider", label = SV:T("Smooth"), format = "%.2f", minValue = -1, maxValue = 1, interval = 0.01, default = defaults.smooth },
            { name = "loudnessBase", type = "Slider", label = SV:T("Loudness Base"), format = "%.1f", minValue = -12, maxValue = 12, interval = 0.1, default = defaults.loudnessBase },
            { name = "loudnessRange", type = "Slider", label = SV:T("Loudness Range"), format = "%.1f", minValue = 0, maxValue = 12, interval = 0.1, default = defaults.loudnessRange },
            { name = "tensionBase", type = "Slider", label = SV:T("Tension Base"), format = "%.2f", minValue = -2, maxValue = 2, interval = 0.01, default = defaults.tensionBase },
            { name = "tensionRange", type = "Slider", label = SV:T("Tension Range"), format = "%.2f", minValue = 0, maxValue = 2, interval = 0.01, default = defaults.tensionRange },
            { name = "breathBase", type = "Slider", label = SV:T("Breath Base"), format = "%.2f", minValue = -2, maxValue = 2, interval = 0.01, default = defaults.breathBase },
            { name = "breathRange", type = "Slider", label = SV:T("Breath Range"), format = "%.2f", minValue = 0, maxValue = 2, interval = 0.01, default = defaults.breathRange },
            { name = "genderBase", type = "Slider", label = SV:T("Gender Base"), format = "%.2f", minValue = -2, maxValue = 2, interval = 0.01, default = defaults.genderBase },
            { name = "genderRange", type = "Slider", label = SV:T("Gender Range"), format = "%.2f", minValue = 0, maxValue = 2, interval = 0.01, default = defaults.genderRange },
            { name = "pointsPerQuarter", type = "Slider", label = SV:T("Points per Quarter"), format = "%.0f", minValue = 1, maxValue = 1000, interval = 1, default = defaults.pointsPerQuarter },
            { name = "overwrite", type = "CheckBox", text = SV:T("Overwrite"), default = defaults.overwrite },
            { name = "enablePitch", type = "CheckBox", text = SV:T("Enable Pitch"), default = defaults.enablePitch }
        }
    }

    -- 显示对话框
    local result = SV:showCustomDialog(form)
    if not result or not result.status then
        SV:finish()
        return
    end

    -- 获取用户输入的值
    local answers = result.answers
    local enablePitch = answers.enablePitch
    local pitchBase = answers.pitchBase
    local pitchRange = answers.pitchRange
    local dynamics = answers.dynamics
    local pitchMin = answers.pitchMin
    local pitchMax = answers.pitchMax
    local smooth = answers.smooth
    local pointsPerQuarter = answers.pointsPerQuarter
    local tensionBase = answers.tensionBase
    local tensionRange = answers.tensionRange
    local breathBase = answers.breathBase
    local breathRange = answers.breathRange
    local loudnessBase = answers.loudnessBase
    local loudnessRange = answers.loudnessRange
    local genderBase = answers.genderBase
    local genderRange = answers.genderRange
    local overwrite = answers.overwrite

    -- 保存配置到文件
    if configFileName then
        local file, err = io.open(configFileName, "w")
        if file then
            file:write("{\n")
            file:write("pitchBase = " .. pitchBase .. ",\n")
            file:write("pitchRange = " .. pitchRange .. ",\n")
            file:write("dynamics = " .. dynamics .. ",\n")
            file:write("pitchMin = " .. pitchMin .. ",\n")
            file:write("pitchMax = " .. pitchMax .. ",\n")
            file:write("smooth = " .. smooth .. ",\n")
            file:write("loudnessBase = " .. loudnessBase .. ",\n")
            file:write("loudnessRange = " .. loudnessRange .. ",\n")
            file:write("tensionBase = " .. tensionBase .. ",\n")
            file:write("tensionRange = " .. tensionRange .. ",\n")
            file:write("breathBase = " .. breathBase .. ",\n")
            file:write("breathRange = " .. breathRange .. ",\n")
            file:write("genderBase = " .. genderBase .. ",\n")
            file:write("genderRange = " .. genderRange .. ",\n")
            file:write("pointsPerQuarter = " .. pointsPerQuarter .. ",\n")
            file:write("overwrite = " .. (overwrite and 1 or 0) .. ",\n")
            file:write("enablePitch = " .. (enablePitch and 1 or 0) .. "\n")
            file:write("}\n")
            file:close()
        else
            SV:showMessageBox(SV:T("Warning"), SV:T("Unable to save configuration file"))
        end
    end

    -- 计算步长
    local stepBlicks = SV.QUARTER / pointsPerQuarter
    math.randomseed(os.time())

    -- 辅助函数：为指定音符的指定非音高参数生成随机包络
    local function applyParameterWithJitter(paramName, note, baseValue, rangeValue, minVal, maxVal)
        local param = group:getParameter(paramName)
        if not param then
            return
        end

        if baseValue == 0 and rangeValue == 0 then
            return
        end

        local onset = note:getOnset()
        local endPos = note:getEnd()

        local originalStart = param:get(onset)
        local originalEnd = param:get(endPos)

        if overwrite then
            param:remove(onset, endPos)
        end

        if rangeValue == 0 then
            local value = math.max(minVal, math.min(maxVal, baseValue))
            param:add(onset, value)
            param:add(endPos, value)
        else
            local time = onset
            while time <= endPos do
                local randomOffset = (math.random() - 0.5) * rangeValue * 2
                local value = baseValue + randomOffset
                value = math.max(minVal, math.min(maxVal, value))
                param:add(time, value)
                time = time + stepBlicks
            end
            param:add(onset, originalStart)
            param:add(endPos, originalEnd)
        end
    end

    -- 音高专用函数
    local function applyPitch(note)
        local param = group:getParameter("pitchDelta")
        if not param then
            return
        end

        if pitchBase == 0 and (
            (dynamics == 0 and pitchRange == 0) or
            (dynamics ~= 0 and pitchMin == 0 and pitchMax == 0)
        ) then
            return
        end

        local onset = note:getOnset()
        local endPos = note:getEnd()
        local durationBlicks = endPos - onset
        if durationBlicks <= 0 then
            return
        end

        local originalStart = param:get(onset)
        local originalEnd = param:get(endPos)

        if overwrite then
            param:remove(onset, endPos)
        end

        local time = onset
        while time <= endPos do
            local t = (time - onset) / durationBlicks

            local f
            if dynamics == 0 then
                f = t
            else
                local exponent
                if smooth >= 0 then
                    exponent = 1 / (1 + smooth)
                else
                    exponent = 1 / (1 + smooth)
                end
                exponent = math.max(0.01, math.min(100, exponent))
                f = t ^ exponent
            end

            local curRange
            if dynamics == 0 then
                curRange = pitchRange
            elseif dynamics == 1 then
                curRange = pitchMin + (pitchMax - pitchMin) * f
            else
                curRange = pitchMin + (pitchMax - pitchMin) * (1 - f)
            end

            local randomOffset = (math.random() - 0.5) * curRange * 2
            local value = pitchBase + randomOffset
            value = math.max(-800, math.min(800, value))

            param:add(time, value)
            time = time + stepBlicks
        end

        param:add(onset, originalStart)
        param:add(endPos, originalEnd)
    end

    -- 开始撤销记录
    project:newUndoRecord()

    -- 为每个选中的音符应用所有参数
    for _, note in ipairs(selectedNotes) do
        if enablePitch then
            applyPitch(note)
        end

        applyParameterWithJitter("tension", note, tensionBase, tensionRange, -2, 2)
        applyParameterWithJitter("breathiness", note, breathBase, breathRange, -2, 2)
        applyParameterWithJitter("loudness", note, loudnessBase, loudnessRange, -12, 12)
        applyParameterWithJitter("gender", note, genderBase, genderRange, -2, 2)
    end

    SV:showMessageBox(SV:T("Done"), string.format(SV:T("Generated reference parameters for %d notes"), #selectedNotes))
    SV:finish()
end