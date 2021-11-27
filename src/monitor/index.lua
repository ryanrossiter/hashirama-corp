SIDES = {"front", "back", "left", "right", "top", "bottom"}

for i,side in ipairs(SIDES) do
  local present = peripheral.isPresent(side)
  if present then
    print("Found peripheral "..peripheral.getType(side).." on side "..side)
  end
end

peripheral.call( "left", "write", "Hello World!" )
