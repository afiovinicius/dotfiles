--- ============================================================================
--- ORZHOV ARCH - INSTALAÇÃO DO KDE PLASMA
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

	if aux.run_cmd_valid(cmd, "[THEME] Aplicando configurações.") then
		aux.run_cmd_valid("lookandfeeltool -a vct-kde-theme", "[THEME] Aplicando LookAndFeel no Plasma")

		-- Função auxiliar local para salvar arquivos utilizando 'files'
		-- local function save_file(path, content, sudo)
		--   if files.exists(path) then
		--     return files.write(path, content, sudo)
		--   end
		--   return files.create(path, content, sudo)
		-- end

		-- -- 2. Configurar o SDDM
		-- aux.pf("Configurando tema do SDDM...", "warn")

		-- local sddm_theme_dir = "/usr/share/sddm/themes/vct-kde-theme"
		-- local sddm_conf_path = "/etc/sddm.conf.d/theme.conf"
		-- local sddm_content   = "[Theme]\nCurrent=vct-kde-theme\n"

		-- -- Copia a pasta do tema extraída para o diretório do sistema (requer sudo)
		-- local copy_ok, copy_err = files.copy_dir(target_dir, sddm_theme_dir, true)

		-- if not copy_ok then
		--   aux.pf("Erro ao copiar pasta do tema para o SDDM: " .. tostring(copy_err), "error")
		-- else
		--   -- Salva ou atualiza a configuração do SDDM em /etc/sddm.conf.d/
		--   local sddm_ok, sddm_err = save_file(sddm_conf_path, sddm_content, true)
		--   if sddm_ok then
		--     aux.pf("SDDM configurado com sucesso!", "success")
		--   else
		--     aux.pf("Erro ao escrever configuração do SDDM: " .. tostring(sddm_err), "error")
		--   end
		-- end

		-- -- 3. Sincronizar tema GTK (GTK3, GTK4 e gsettings)
		-- aux.pf("Sincronizando estilo das aplicações GTK...", "warn")

		-- local gtk_content = "[Settings]\n" ..
		--   "gtk-theme-name=Breeze-Dark\n" ..
		--   "gtk-icon-theme-name=breeze-dark\n" ..
		--   "gtk-cursor-theme-name=breeze_cursors\n" ..
		--   "gtk-application-prefer-dark-theme=1\n"

		-- local gtk_paths = {
		--   envs.PATHS.HOME .. "/.config/gtk-3.0/settings.ini",
		--   envs.PATHS.HOME .. "/.config/gtk-4.0/settings.ini"
		-- }

		-- for _, gtk_file in ipairs(gtk_paths) do
		--   local gtk_ok, gtk_err = save_file(gtk_file, gtk_content, false)
		--   if not gtk_ok then
		--     aux.pf("Falha ao salvar " .. gtk_file .. ": " .. tostring(gtk_err), "warn")
		--   end
		-- end

		-- -- Aplica instantaneamente em tempo de execução para sessões Wayland/Hyprland/KDE
		-- local gsettings_cmds = {
		--   'gsettings set org.gnome.desktop.interface gtk-theme "Breeze-Dark"',
		--   'gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"',
		--   'gsettings set org.gnome.desktop.interface icon-theme "breeze-dark"',
		--   'gsettings set org.gnome.desktop.interface cursor-theme "breeze_cursors"'
		-- }

		-- for _, gcmd in ipairs(gsettings_cmds) do
		--   aux.run_cmd_valid(gcmd, "[GTK] Atualizando interface gsettings")
		-- end

		-- aux.pf("Tema, SDDM e aplicações GTK configurados com sucesso!", "success")
	end

	return true
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
