local Window = {}

Window.design_width = tonumber(sys.get_config("display.width"))
Window.design_height = tonumber(sys.get_config("display.height"))
Window.width = Window.design_width
Window.height = Window.design_height

return Window