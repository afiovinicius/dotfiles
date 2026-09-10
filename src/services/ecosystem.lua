--- ============================================================================
--- ORZHOV ARCH - INSTALAÇÃO DOS PACOTES DE FERRAMENTA
--- ============================================================================
--- Função para instalação das ferramentas do sistema (Ecossistema)
--- ============================================================================

local ecosystem = {}
local aux = require("src.utils.aux")
local packages = require("src.core.packages")

--- ============================================================================
--- PACOTES DO ECOSSISTEMA
--- ============================================================================

function ecosystem.packages_install()
	aux.panel("Pacotes do Ecossistema")

	local excluded_groups = {
		["Ambiente Hyprland"] = true,
		["Ambiente KDE Plasma"] = true,
		["Pacotes Padrões"] = true,
		["Pacotes da Comunidade"] = true,
	}

	local ecosystem_groups = {}

	for group_name, _ in pairs(aux.groups_categories) do
		if not excluded_groups[group_name] then
			table.insert(ecosystem_groups, group_name)
		end
	end

	table.sort(ecosystem_groups)

	if #ecosystem_groups == 0 then
		aux.pf("Nenhum grupo disponível para instalação.", "warn")
		return true
	end

	aux.pf("Selecione quais áreas de software você deseja explorar para instalação.", "warn")

	local selected_groups = aux.multiselect("Áreas do Ecossistema (Espaço marca, Enter confirma):", ecosystem_groups)

	if not selected_groups or #selected_groups == 0 then
		aux.pf("Nenhuma área do ecossistema selecionada. Pulando etapa...", "warn")
		return true
	end

	for _, group_name in ipairs(selected_groups) do
		aux.panel("Explorando Área: " .. group_name)
		aux.interactive_install(group_name)
	end

	local aur_packages = aux.get_names(packages.AUR)

	if not aux.multiselect("Pacotes do AUR (Espaço marca, Enter confirma):", aur_packages) then
		aux.pf("Erro ao tentar instalar os pacotes do AUR", "error")
	end

	aux.pf("Configuração do ecossistema finalizada!", "success")

	return true
end

--- ============================================================================
--- EXPORTAÇÃO DO MÓDULO
--- ============================================================================

return ecosystem
