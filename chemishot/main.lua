import "CoreLibs/graphics"

import "./intro/intro"
import "./launch/launch"
import "./logic/logic"
import "./wheel/wheel"

---@diagnostic disable-next-line: duplicate-set-field
function playdate.update()
  IntroUpdate()
  LaunchUpdate()
  LogicUpdate()
  WheelUpdate()
end
