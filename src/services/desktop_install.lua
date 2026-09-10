--- ============================================================================
--- ORZHOV ARCH - SELEÇÃO DO AMBIENTE GRÁFICO
--- ============================================================================
--- Função auxiliar para seleção e gestão do ambiente gráfico a ser instalado
--- ============================================================================

local desktopInstall = {}
local aux = require("src.utils.aux")
local envs = require("src.core.envs")
local packages = require("src.core.packages")
local kdeInstall = require("src.interfaces.kde.kde")
local hyprlandInstall = require("src.interfaces.hyprland.hyprland")

--- ============================================================================
--- AMBIENTE GRÁFICO
--- ============================================================================

local desktop_map = {
	{
		name = "KDE Plasma",
		vendor = envs.DESKTOP_ENVIRONMENTS.KDE,
		base_category = packages.KDE,
		extra_categories = { "KDE_EXTRA" },
		setup_func = kdeInstall.setup,
	},
	{
		name = "Hyprland",
		vendor = envs.DESKTOP_ENVIRONMENTS.HYPRLAND,
		base_category = packages.HYPRLAND,
		extra_categories = { "HYPRLAND_EXTRA" },
		setup_func = hyprlandInstall.setup,
	},
}

function desktopInstall.install_environment()
	aux.panel("Seleção do Ambiente Gráfico")

	local desktop_options = {}
	local option_lookup = {}

	for _, env_config in ipairs(desktop_map) do
		table.insert(desktop_options, env_config.name)
		option_lookup[env_config.name] = env_config
	end

	local selected_desktop = aux.choose_per_number("Qual ambiente você deseja instalar?", desktop_options)

	if not selected_desktop then
		aux.pf("Seleção do ambiente cancelada.", "error")
		return false
	end

	local selected_config = option_lookup[selected_desktop]

	envs.DYNAMIC.DESKTOP_ENVIRONMENT = selected_config.vendor
	print(envs.COLORS.YELLOW .. "  → Selecionado: " .. selected_desktop .. envs.COLORS.RESET)

	if selected_config.base_category and #selected_config.base_category > 0 then
		local desktop_packages = aux.get_names(selected_config.base_category)

		if not aux.installation(desktop_packages) then
			aux.pf("Erro ao instalar a base do ambiente gráfico", "error")
			return false
		else
			aux.register_installed_packages(selected_config.vendor, desktop_packages)
		end
	end

	if selected_config.extra_categories and #selected_config.extra_categories > 0 then
		aux.interactive_install(selected_config.extra_categories)
	end

	if selected_config.setup_func then
		selected_config.setup_func()
	end

	return true
end

--- ============================================================================
--- EXPORTAÇÃO DO MÓDULO
--- ============================================================================

return desktopInstall
