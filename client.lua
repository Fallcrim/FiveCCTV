local cameraActive = false
local cameraEntity = nil

local rotationSpeed = 1.0
local isRotatingLeft = false
local isRotatingRight = false
local isRotatingUp = false
local isRotatingDown = false


-- Function to display debug messages on the screen
function DisplayDebugMessage(message)
    TriggerEvent(
        "chatMessage",
        "[FiveCCTV | DEBUG]",
        { 255, 0, 0 },
        message
    )
end

-- Function to create the camera entity
function CreateCamera(coords)
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(cam, coords.x, coords.y, coords.z)
    SetCamRot(cam, 0.0, 0.0, coords.heading, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)

    cameraEntity = cam
end

-- Function to destroy the camera entity
function DestroyCamera()
    if cameraEntity then
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(cameraEntity, true)
        cameraEntity = nil
    end
end

-- Function to update the camera rotation
function UpdateCameraRotation()
    if cameraEntity then
        local newHeading = GetCamRot(cameraEntity, 0).z
        local newPitch = GetCamRot(cameraEntity, 2).x
        if isRotatingLeft then
            newHeading = newHeading + rotationSpeed
        elseif isRotatingRight then
            newHeading = newHeading - rotationSpeed
        end
        if isRotatingUp then
            newPitch = math.max(-89.0, newPitch - rotationSpeed)
        elseif isRotatingDown then
            newPitch = math.min(89.0, newPitch + rotationSpeed)
        end
        SetCamRot(cameraEntity, newPitch, 0.0, newHeading, 2)
    end
end

-- Event handler for key press
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if cameraActive then
            if IsControlPressed(0, 108) then -- NUMPAD4 key
                isRotatingLeft = true
                isRotatingRight = false
            elseif IsControlPressed(0, 109) then -- NUMPAD6 key
                isRotatingLeft = false
                isRotatingRight = true
            else
                isRotatingLeft = false
                isRotatingRight = false
            end

            if IsControlPressed(0, 110) then -- NUMPAD5 key
                isRotatingUp = true
                isRotatingDown = false
            elseif IsControlPressed(0, 111) then -- NUMPAD8 key
                isRotatingUp = false
                isRotatingDown = true
            else
                isRotatingUp = false
                isRotatingDown = false
            end

            UpdateCameraRotation()
        elseif IsControlJustPressed(0, 194) then
                SetNuiFocus(false, false)
        end
    end
end)

-- get cam from config
function GetCam(ip)
    for i = 1, #Cameras do
        if Cameras[i].cam_ip == ip then
            return Cameras[i]
        end
    end
end

-- Event handler to toggle camera and open NUI
RegisterCommand("togglecamera", function()
    cameraActive = not cameraActive

    if cameraActive then
        local playerCoords = GetEntityCoords(PlayerPedId())
        CreateCamera({
            x = playerCoords.x,
            y = playerCoords.y,
            z = playerCoords.z + 2.3, -- Adjust height offset as needed
            heading = 0.0,            -- Adjust heading as needed
        })

        SendNUIMessage({
            action = "show_camera",
        })
    else
        DestroyCamera()

        SendNUIMessage({
            action = "hide_camera",
        })
    end
end, false)

RegisterCommand(
    "cctv",
    function()
        DisplayDebugMessage("Opening login screen")
        SendNUIMessage({
            action = "show_login"
        })
        SetNuiFocus(true, true)
    end,
    false
)

-- NUI Callbacks
RegisterNUICallback("closeCamera", function(data, cb)
    cameraActive = false
    DestroyCamera()
    DisplayDebugMessage("Closing camera view")
    cb("ok")
end)

RegisterNUICallback(
    "validateLogin",
    function(data, cb)
        DisplayDebugMessage("Validating login")
        -- print("Data: " .. json.encode(data))
        -- local ip = data.ip
        -- local user = data.user
        -- local password = data.password
        -- local cam_data = GetCam(ip)
        -- DisplayDebugMessage("IP: " .. ip .. " User: " .. user .. " Password: " .. password)
        -- DisplayDebugMessage("Cam data: " .. json.encode(cam_data))
        -- if cam_data then
        --     if cam_data.cam_user == user and cam_data.cam_passwd == password then
        --         cameraActive = true
        --         local coords = { x = cam_data.x, y = cam_data.y, z = cam_data.z, heading = cam_data.heading }
        --         CreateCamera(coords)
        --         DisplayDebugMessage("Camera created; opening camera_view")

        --         cb("true")
        --     else
        --         -- SendNUIMessage({
        --         --     action = "hide_login",
        --         -- })
        --         cb("false")
        --     end
        -- else
        --     SetNuiFocus(false, false)
        --     SendNUIMessage({
        --         action = "hide_login",
        --     })
        --     cb("false")
        -- end
    end
)
