Point = {
    x = 0,
    y = 0
}

function Point:new_inside(square)
    local newPoint = {
        x = math.random(square.left, square.left + square.width),
        y = math.random(square.top, square.top + square.height),
    }
    self.__index = self
    return setmetatable(newPoint, self)
end

function Point:is_inside(circle)
    local x = self.x - circle.center.x
    local y = self.y - circle.center.y
    return (x * x + y * y < circle.r * circle.r)
end

function love.load()
    A_point = {}
    To_be_draw = {}
    Points_in_square = 0
    Points_in_circle = 0
    Square = {
        width = 300,
        height = 300,
        left = 100,
        top = 60,
    }
    Circle = {
        center = {
            x = Square.width / 2 + Square.left,
            y = Square.height / 2 + Square.top
        },
        r = Square.width / 2
    }
    Pi = 0
    Paused = false
    Print_position = {
        circle = {
            string = {
                x = Square.left,
                y = Square.height + Square.top + 10
            },
            value = {
                x = Square.left + 250,
                y = Square.height + Square.top + 10
            }
        },
        square = {
            string = {
                x = Square.left,
                y = Square.height + Square.top + 50
            },
            value = {
                x = Square.left + 250,
                y = Square.height + Square.top + 50
            }
        },
        pi = {
            string = {
                x = Square.left,
                y = Square.height + Square.top + 90
            },
            value = {
                x = Square.left + 80,
                y = Square.height + Square.top + 90
            }
        },
        memory = {
            string = {
                x = 5,
                y = love.graphics.getHeight() - 20
            },
            value = {
                x = 180,
                y = love.graphics.getHeight() - 20
            }
        }
    }
    love.graphics.setFont(love.graphics.newFont('monospace.ttf', 24))
end

function love.keypressed(key)
    if key == 'q' then
        love.event.quit()
    elseif key == 'p' then
        Paused = not Paused
    end
end

function love.update()
    if not Paused then
        A_point = Point:new_inside(Square)
        table.insert(To_be_draw, A_point)
        Points_in_square = Points_in_square + 1
        if A_point:is_inside(Circle) then
            Points_in_circle = Points_in_circle + 1
        end
        Pi = (4 * Points_in_circle) / Points_in_square
    end
    collectgarbage('collect')
end

function love.draw()
    love.graphics.rectangle('line', Square.left, Square.top, Square.width, Square.height)
    love.graphics.circle('line', Circle.center.x, Circle.center.y, Circle.r)

    love.graphics.print('inside circle = \ninside square = \npi = ', Print_position.circle.string.x,
        Print_position.circle.string.y)

    love.graphics.print(Points_in_circle, Print_position.circle.value.x, Print_position.circle.value.y)
    love.graphics.print(Points_in_square, Print_position.square.value.x, Print_position.square.value.y)
    love.graphics.print(Pi, Print_position.pi.value.x, Print_position.pi.value.y)

    for _, p in pairs(To_be_draw) do
        love.graphics.points({ p.x, p.y })
    end

    love.graphics.print('Memory using (in kB): ', Print_position.memory.string.x, Print_position.memory.string.y, 0, 0.5
        , 0.5)
    love.graphics.print(collectgarbage('count'), Print_position.memory.value.x, Print_position.memory.value.y, 0, 0.5,
        0.5)
end
