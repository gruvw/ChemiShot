import "CoreLibs/graphics"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics
local geo <const> = playdate.geometry


local scene1 = gfx.image.new("images/scene1")
local scene2 = gfx.image.new("images/scene2")
local scene3 = gfx.image.new("images/scene3")
local startScreen = gfx.image.new("images/start_screen")
local level_one = gfx.image.new("images/level_one")
local currentScene = scene1 -- Start with scene 1

local displayWidth, displayHeight = playdate.display.getSize()
local overlay = gfx.image.new(displayWidth, displayHeight, gfx.kColorBlack)
local mask = gfx.image.new(displayWidth, displayHeight)

local transitionDuration = 3000
local transitionPoint = geo.point.new(260, 90)

local function drawCircleCutout(point, radius)
  gfx.pushContext(mask)
      gfx.clear(gfx.kColorWhite)
      gfx.setColor(gfx.kColorBlack)
      gfx.fillCircleAtPoint(point, radius)
  gfx.popContext()

  overlay:setMaskImage(mask)
  overlay:draw(0, 0)
end

local function getDistanceToFarthestCorner(point)
  return math.max(
      point:distanceToPoint(geo.point.new(0, 0)),
      point:distanceToPoint(geo.point.new(displayWidth, 0)),
      point:distanceToPoint(geo.point.new(0, displayHeight)),
      point:distanceToPoint(geo.point.new(displayWidth, displayHeight))
  )
end

local function switchScene()
  if currentScene == scene1 then
      currentScene = scene2
  elseif currentScene == scene2 then
      currentScene = scene3
  elseif currentScene == scene3 then
      currentScene = startScreen
  else
      currentScene = scene1 -- Loop back to scene 1 after the start screen
  end
end

function playdate.rightButtonDown()
  local maxRadius = getDistanceToFarthestCorner(transitionPoint)
  local timer = playdate.timer.new(transitionDuration, -maxRadius, maxRadius, playdate.easingFunctions.inOutQuad)

  timer.updateCallback = function()
      local radius = math.abs(timer.value)
      drawCircleCutout(transitionPoint, radius)
  end

  -- switch scene at transition midpoint when screen is fully black
  playdate.timer.performAfterDelay(transitionDuration / 2, switchScene)
end

function playdate.buttonAButtonDown()
  if currentScene == startScreen then
      currentScene = level_one
  end
end

function IntroUpdate()

      currentScene:draw(0, 0)
      playdate.timer.updateTimers()

end

