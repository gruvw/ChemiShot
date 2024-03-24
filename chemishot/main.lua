import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

import "./intro/intro"
import "./launch/launch"
import "./logic/logic"
import "./wheel/wheel"

local pd <const> = playdate
local gfx <const> = pd.graphics

initWheel()

---@diagnostic disable-next-line: duplicate-set-field
function playdate.update()
    IntroUpdate()
    LaunchUpdate()
    LogicUpdate()
    WheelUpdate()
    gfx.sprite.update()
end
