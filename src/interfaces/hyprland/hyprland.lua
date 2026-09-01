--- ============================================================================
--- AFIO ARCH - INSTALAÇÃO DO HYPRLAND
--- ============================================================================
--- Configuração do ambiente desktop hyrpland
--- ============================================================================

local hyprlandInstall = {}
local aux = require("src.utils.aux")
local envs = require("src.core.envs")
local files = require("src.utils.files")

--- ============================================================================
--- INSTALAÇÃO
--- ============================================================================

--- Configuração do ambiente HYPRLAND
-- @return boolean: Confirmação que tudo foi instalado e configurado
function hyprlandInstall.setup()
  aux.pf("Setup Hyprland", "warn")

  local config_folders = {
    "afioarch",
    "colors",
    "hypr",
    "rofi",
    "swaync",
    "waybar",
    "wlogout"
  }

  local current_dir = os.getenv("PWD") or io.popen("pwd"):read("*l")
  local src_base = current_dir .. "/src/models/config/"
  local dest_base = envs.PATHS.HOME .. "/.config/"

  for _, folder in ipairs(config_folders) do
    local src_path = src_base .. folder
    local dest_path = dest_base .. folder

    local success, err = files.copy_dir(src_path, dest_path, false)

    if success then
      aux.run_cmd_valid("true", "[HYPRLAND] Configuração aplicada: " .. folder)
    else
      aux.run_cmd_valid("false", "[HYPRLAND] Falha ao configurar " .. folder .. " - " .. tostring(err))
    end
  end

  print()

  local targets = {
    { service = "polkit.service", desc = "Habilitando Polkit" },
  }

  for _, item in ipairs(targets) do
    local cmd = "sudo systemctl enable " .. item.service
    aux.run_cmd_valid(cmd, "[Systemd " .. item.desc .. "] ")
  end

  return true
end

--- ============================================================================
--- EXPORTAÇÃO
--- ============================================================================

return hyprlandInstall