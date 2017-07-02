local eisuu = 0x66
local kana = 0x68

local isEisuuDown = false
local isKanaDown = false

eventtap = hs.eventtap.new({hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp}, function(ev)
    local keyCode = ev:getKeyCode()
    local eventType = ev:getType()
    local key = hs.keycodes.map[keyCode]
    local isDown = eventType == hs.eventtap.event.types.keyDown

    if keyCode == eisuu then
        isEisuuDown = isDown
    end
    if keyCode == kana then
        isKanaDown = isDown
    end
    if not isEisuuDown and not isKanaDown then
        -- 英数かなどちらも押されてないならスルー
        return false
    elseif isEisuuDown and isKanaDown then 
        -- 英数かな同時押し
        -- ESCとして扱う
        return true, {
            hs.eventtap.event.newKeyEvent({}, hs.keycodes.map["escape"], isDown)
        }
    else
        -- 英数かな、いずれか押されている
        local remapTable = {
            space = hs.keycodes.map["return"],
            h = hs.keycodes.map["left"],
            j = hs.keycodes.map["up"],
            k = hs.keycodes.map["down"],
            l = hs.keycodes.map["right"],
            n = hs.keycodes.map["delete"],
            m = hs.keycodes.map["forwarddelete"],
        }
        for k, v in pairs(remapTable) do
            if key == k then
                -- 該当するキーがあればリマップする
--                 print(eventType, v, isDown)
                return true, {
                    hs.eventtap.event.newKeyEvent({}, v, isDown)
                }
            end
        end
        -- リマップ不要
        return false
    end
end)
eventtap:start()

hs.alert.show("Config Loaded!!")