function draw_stats(camera_y)
    local offset_y=camera_y or 0
    print("mem: "..stat(0),0,6+offset_y,7)
    print("cpu: "..stat(1),0,12+offset_y,7)
    print("fps: "..stat(7),0,18+offset_y,7)
end
