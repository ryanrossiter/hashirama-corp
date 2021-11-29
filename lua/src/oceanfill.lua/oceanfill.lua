FILL_ITEM_ID="minecraft:sand"

-- find fuel in inv and restore current slot after
function checkFuel()
    if turtle.getFuelLevel() < 100 then
        print("Refuelling...")
        local startSlot = turtle.getSelectedSlot()
        local tries = 16
        repeat
            local refuelled = turtle.refuel()
            if refuelled == false then
                -- change slots
                turtle.select((turtle.getSelectedSlot() % 16) + 1)

                tries = tries - 1
                if tries == 0 then
                    print("ERROR: Ran out of fuel, will search again in 3 seconds")
                    sleep(3)
                    tries = 16
                end
            end
        until(refuelled == false)
        turtle.select(startSlot)
        print("Done refueling")
    end
end

function locateItemInInv(itemId)
    local currentSlot = turtle.getSelectedSlot()
    local tries = 16
    
    local currentItem = turtle.getItemDetail(currentSlot)
    while currentItem == nil or currentItem.name ~= itemId do
        if currentItem ~= nil then print(currentItem.name) end
        -- change slots
        currentSlot = (turtle.getSelectedSlot() % 16) + 1
        turtle.select(currentSlot)
        currentItem = turtle.getItemDetail(currentSlot)

        tries = tries - 1
        if tries == 0 then
            print("ERROR: Failed to find item ".. itemId ..", will search again in 3 seconds")
            sleep(3)
            tries = 16
        end
    end
end

-- fills the column directly in front
function fillCol(itemId)
    local success = false
    repeat
        locateItemInInv(itemId)
        success = turtle.place()
    until(success == false)
end

function oceanFill(x, y)
    print("Filling w="..x.." h="..y)
    local xx, yy = 0, 0
    while xx < x do
        yy = 0
        while yy < y do
            checkFuel()
            print("Filling column")
            fillCol(FILL_ITEM_ID)
            print("Done")

            -- break directly in front so we can move forward
            turtle.dig()
            turtle.forward()
            yy = yy + 1
        end

        if xx % 2 == 0 then
            turtle.turnRight()
            turtle.forward()
            turtle.turnRight()
            turtle.back()
        else
            turtle.turnLeft()
            turtle.forward()
            turtle.turnLeft()
            turtle.back()
        end
        xx = xx + 1
    end
    print("Done filling")
end


args = {...}
x = tonumber(args[1])
y = tonumber(args[2])
print(x, y)
oceanFill(x,y)
