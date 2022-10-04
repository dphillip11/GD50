function love.load()
    generate_times = {}
    generate_numbers = {}
    reproduce_times = {}
    reproduce_numbers = {}
    temp_times = {}
    state = 'generate'
    math.randomseed(1)
    Timer = 0
end

function love.update(dt)
    if state == 'generate' then
        Timer = Timer + dt
        if Timer > 5 then
            for i, time in pairs(generate_times) do
                table.insert(temp_times, time)
            end
            table.sort(temp_times)
            state = 'reproduce'
            math.randomseed(1)
            Timer = 0
        end
    end
    if state == 'reproduce' then
        Timer = Timer + dt
        if temp_times[1] then
            if Timer > temp_times[1] then
                table.insert(reproduce_times, Timer)
                table.insert( reproduce_numbers, math.random(10,100))
                table.remove(temp_times, 1)  
            end          
        end
        if Timer > 5 then
            state = 'stop'
        end
    end
end

function love.mousepressed()
    if state == 'generate' then
        table.insert(generate_times, Timer)
        table.insert( generate_numbers, math.random(10,100))
    end
end


function love.draw()
    love.graphics.setBackgroundColor( 255, 255, 255)
    c = 0
    for i, number in pairs(generate_times) do
        love.graphics.print({{0,0,0}, string.format("%.2f : %.2f", generate_numbers[i], number)}, 0, c * 50)
        c = c + 1
    end
    d = 0
    for i, number in pairs(reproduce_times) do
        love.graphics.print({{0,0,0}, string.format("%.2f : %.2f", reproduce_numbers[i], number)}, 200, d * 50)
        d = d + 1
    end
    love.graphics.print({{0,0,0},Timer}, 400, 10)
end