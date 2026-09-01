--- ============================================================================
--- AFIO ARCH - INSTALAÇÃO DO KDE PLASMA
--- ============================================================================
--- Configuração do ambiente desktop kde plasma minimal
--- paths para configuração do kde que ficam em models/config/kde
--- numlock = mover kcminputrc para ~/.config
--- theme = unzip do tema em ~/.local/share/plasma/look-and-feel/
--- ============================================================================

local kdeInstall = {}
local aux = require("src.utils.aux")
local envs = require("src.core.envs")
local files = require("src.utils.files")

--- ============================================================================
--- CONFIGURAÇÃO
--- ============================================================================
--- 
--- Sobrescreve ou cria o arquivo kcminputrc com as configurações de input
-- @return boolean: Status da execução
local function setup_numlock()
    local dest_dir = os.getenv("HOME") .. "/.config"
    local dest_path = dest_dir .. "/kcminputrc"

    if not files.exists(dest_dir) then
      aux.run_cmd_valid("mkdir -p " .. dest_dir, "[NUMLOCK] Criando diretório. ")
    end

    local cmd = string.format("kwriteconfig6 --file %s --group Keyboard --key NumLock 0", dest_path)

    local success = aux.run_cmd_valid(cmd, "[NUMLOCK] ")

    if success == 0 or success == true then
        aux.pf("[NUMLOCK] Numlock configurado para iniciar ativado no KDE Plasma", "success")
        return true
    else
        print("[NUMLOCK] Falha ao configurar o Numlock no kcminputrc", "error")
        return false
    end
end

--- Extrai e instala o tema Look-and-Feel do KDE
-- @return boolean: Status da execução
local function setup_theme()
  local theme_archive = envs.PATHS.MODELS .. "/config/kde/vct-kde-theme.tar.gz"
  local target_dir = envs.PATHS.HOME .. "/.local/share/plasma/look-and-feel/"
  local installed_theme_dir = target_dir .. "vct-kde-theme"

  if files.is_path(installed_theme_dir, "dir") then
    aux.pf("[THEME] Tema afio-arch já está instalado. Pulando...", "warn")
    return true
  end

  if not files.is_path(theme_archive, "file") then
    aux.pf("[THEME] Arquivo do tema não encontrado: " .. theme_archive, "error")
    return false
  end

  local cmd = string.format("mkdir -p %q && tar -xvzf %q -C %q", target_dir, theme_archive, target_dir)
  return aux.run_cmd_valid(cmd, "[THEME] Aplicando configurações.")
end

--- ============================================================================
--- INSTALAÇÃO
--- ============================================================================

--- Configuração completa do ambiente KDE Plasma
-- @return boolean: Confirmação que tudo foi instalado e configurado com sucesso
function kdeInstall.setup()
  aux.pf("Setup do KDE Plasma...", "warn")

  local numlock_ok = setup_numlock()
  local theme_ok = setup_theme()

  return numlock_ok and theme_ok
end

--- ============================================================================
--- EXPORTAÇÃO DO MÓDULO
--- ============================================================================

return kdeInstall