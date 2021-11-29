FILL_ITEM_ID="sand"

function digLine(distance)
    print("Digging line with distance: " .. distance)
    for var=1, distance do
        -- this while loop will continue to mine gravel
        while true do
            checkFuel()
            if turtle.detect() then
                turtle.dig()
            else
                turtle.forward()
                break
            end
        end
    end
end

-- find fuel in inv and restore current slot after
function checkFuel()
    if turtle.getFuelLevel() < 100 then
        local startSlot = turtle.getSelectedSlot()
        local tries = 16
        repeat
            local refuelled = turtle.refuel()
            if refuelled == false then
                -- change slots
                turtle.select((turtle.getSelectedSlot() + 1) % 17 + 1)

                tries = tries - 1
                if tries <= then
                    print("ERROR: Ran out of fuel, will search again in 3 seconds")
                    sleep(3)
                    tries = 16
                end
            end
        until(refuelled == false)
        turtle.select(startSlot)
    end
end

function locateItemInInv(itemId)
    local currentSlot = turtle.getSelectedSlot()
    local tries = 16
    
    while turtle.getItemDetail(currentSlot) ~= itemId do
        -- change slots
        turtle.select((turtle.getSelectedSlot() + 1) % 17 + 1)

        tries = tries - 1
        if tries <= then
            print("ERROR: Failed to find item ".. itemId ..", will search again in 3 seconds")
            sleep(3)
            tries = 16
        end
    end
end

function turn(direction)
    if direction == "left" then
        print("Turning left")
        turtle.turnLeft()
        turtle.dig()
        turtle.forward()
        turtle.turnLeft()
    elseif direction == "right" then
        print("Turning right")
        turtle.turnRight()
        turtle.dig()
        turtle.forward()
        turtle.turnRight()
    end
end

function digLayer(x, y)
    turtle.digDown()
    turtle.down()

    -- initial dig line
    layerY = 1
    digLine(x - 1)
    while true do
        turn("left")
        digLine(x - 1)
        layerY = layerY + 1
        if layerY == y then
            print("LayerY is complete (1)")
            break
        end

        turn("right")
        digLine(x - 1)
        layerY = layerY + 1
        if layerY == y then
            print("LayerY is complete (2)")
            break
        end
    end
    
    if y % 2 == 0 then
        print("Input y is even number")
        turtle.turnLeft()
        for distance = 1, y - 1 do
            turtle.forward()
        end
        turtle.turnLeft()
    elseif y % 2 == 1 then
        print("Input y is odd number")
        turtle.turnRight()
        for distance = 1, y - 1 do
            turtle.forward()
        end
        turtle.turnRight()
        for distance = 1, x - 1 do
            turtle.forward()
        end
        turtle.turnRight()
        turtle.turnRight()
    end
end

-- fills the column directly in front
function fillCol(itemId) {
    while turtle.inspect() != itemId do
        locateItemInInv(itemId)
        turtle.place()
    end
}

function oceanFill(x, y)
    print("Filling layer")
    checkFuel()
    fillCol(FILL_ITEM_ID)
end


args = {...}
x = tonumber(args[1])
y = tonumber(args[2])
print(x, y)
oceanFill(x,y)
