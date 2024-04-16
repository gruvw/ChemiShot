import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

import "./intro/intro"
import "./logic/logic"

local pd <const> = playdate
local gfx <const> = pd.graphics

local musicplayer = pd.sound.sampleplayer.new('./musics/main.wav')
musicplayer:play(0)

---@diagnostic disable-next-line: duplicate-set-field
function playdate.update()
    LogicUpdate()
end
