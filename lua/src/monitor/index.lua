SIDES = {"front", "back", "left", "right", "top", "bottom"}

monitor = nil
for i,side in ipairs(SIDES) do
  local present = peripheral.isPresent(side)
  if present then
    local type = peripheral.getType(side)
    if type == "monitor" then
      print("Found monitor on side "..side)
      monitor = peripheral.wrap(side)
    elseif type == "modem" then
      print("Found modem on side "..side)
      local modem = peripheral.wrap(side)
      for i,name in ipairs(model.getNamesRemote()) do
        local rtype = modem.getTypeRemote(name)
        if rtype == "monitor" then
          print("Found monitor on modem "..name)
          monitor = peripheral.wrap(side)
        end
      end
    end
  end

  if monitor then
    break
  end
end

-- monitor.write( "Hello World!" )
monitor.setTextScale(0.5)

local oldterm = term.redirect(monitor)
-- Now all term calls will go to the monitor instead
local image = paintutils.loadImage("happy.nfp")
paintutils.drawImage(image, 1, 1)
term.redirect( oldterm )
-- Now the term.* calls will draw on the terminal again
