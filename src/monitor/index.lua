SIDES = {"front", "back", "left", "right", "top", "bottom"}

monitor = nil
for i,side in ipairs(SIDES) do
  local present = peripheral.isPresent(side)
  if present and peripheral.getType(side) == "monitor" then
    print("Found monitor on side "..side)
    monitor = peripheral.wrap(side)
  end
end

-- monitor.write( "Hello World!" )

local oldterm = term.redirect(monitor)
-- Now all term calls will go to the monitor instead
local image = paintutils.loadImage("happy.put")
paintutils.loadImage(image, 1, 1)
term.redirect( oldterm )
-- Now the term.* calls will draw on the terminal again
