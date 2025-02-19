-- Находим монитор
local monitor = peripheral.find("monitor")
if not monitor then
    print("Монитор не найден!")
    return
end

-- Функция для очистки экрана
local function clearScreen()
    monitor.clear()
    monitor.setCursorPos(1, 1)
end

-- Функция для рисования графика температуры
local function drawTemperatureGraph(tempData)
    local width, height = monitor.getSize()
    local graphHeight = math.floor(height / 2) -- Высота графика
    local scale = 5 -- Масштаб для температуры

    -- Очищаем область графика
    for y = 1, graphHeight do
        monitor.setCursorPos(1, y)
        monitor.write(string.rep(" ", width))
    end

    -- Рисуем график
    for i, temp in ipairs(tempData) do
        local barHeight = math.min(math.floor(temp / scale), graphHeight)
        for j = 1, barHeight do
            monitor.setCursorPos(i, graphHeight - j + 1)
            if temp > 0 then
                monitor.write("|") -- Для положительной температуры
            else
                monitor.write("-") -- Для отрицательной температуры
            end
        end
    end
end

-- Функция для получения случайных погодных данных
local function getWeatherData()
    local weatherStates = {"Clear", "Rain", "Thunder"}
    local temperature = math.random(-10, 30) -- Случайная температура от -10 до 30
    local weather = weatherStates[math.random(1, #weatherStates)]
    return temperature, weather
end

-- Основной цикл программы
local tempData = {} -- Храним историю температур
while true do
    -- Получаем текущие погодные данные
    local temperature, weather = getWeatherData()

    -- Добавляем текущую температуру в историю
    table.insert(tempData, temperature)
    if #tempData > 20 then -- Ограничиваем количество точек на графике
        table.remove(tempData, 1)
    end

    -- Очищаем экран
    clearScreen()

    -- Выводим текущую погоду
    monitor.setCursorPos(1, 1)
    monitor.write("Current Weather: " .. weather)
    monitor.setCursorPos(1, 2)
    monitor.write("Temperature: " .. temperature .. "°C")

    -- Рисуем график температуры
    drawTemperatureGraph(tempData)

    -- Ждём 2 секунды перед обновлением
    os.sleep(2)
end
