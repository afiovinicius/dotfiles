--- ============================================================================
--- ORZHOV ARCH - AUXILIARY FUNCTIONS & GUM WRAPPERS
--- ============================================================================
--- Módulo com funções auxiliares de renderização, gum wrappers para UX
--- e lógica de instalação de pacotes com segurança e validação.
--- ============================================================================

local aux = {}
local envs = require("src.core.envs")
local packages = require("src.core.packages")
local files = require("src.utils.files")

--- ============================================================================
--- CACHE DO BANNER (Pré-compilado na memória para 0 alocações no runtime)
--- ============================================================================

local CACHED_BANNER = string.format(
	"\n%s%s%s\n  %s%s v%s%s\n\n  %s%s%s\n\n",
	envs.COLORS.CYAN,
	envs.BANNER,
	envs.COLORS.RESET,
	envs.COLORS.BOLD,
	envs.PROJECT_NAME,
	envs.PROJECT_VERSION,
	envs.COLORS.RESET,
	envs.COLORS.DIM,
	envs.MESSAGES.WELCOME,
	envs.COLORS.RESET
)

local CACHED_BANNER_RAW = envs.COLORS.CYAN .. envs.BANNER .. envs.COLORS.RESET .. "\n"

--- ============================================================================
--- FUNÇÕES LEGADAS E AUXILIARES NOVAS
--- ============================================================================

--- Imprime mensagem formatada com timestamp e cor
-- @param message string: Mensagem a exibir
-- @param color_type string: 'error', 'warn', 'success' ou padrão (cyan)
function aux.pf(message, color_type)
	local timestamp = os.date("%H:%M:%S")
	local color_code = envs.COLORS.CYAN

	if color_type == "error" then
		color_code = envs.COLORS.RED
	elseif color_type == "warn" then
		color_code = envs.COLORS.YELLOW
	elseif color_type == "success" then
		color_code = envs.COLORS.GREEN
	end

	local formatted = string.format(
		"\n%s[%s]%s - %s%s%s\n",
		envs.COLORS.BOLD,
		timestamp,
		envs.COLORS.RESET,
		color_code,
		message,
		envs.COLORS.RESET
	)

	io.write(formatted)
end

--- Lista items com índice
-- @param items table: Array de strings para listar
function aux.plist(items)
	local count = 1
	for _, item in ipairs(items) do
		print(string.format("%s[%d]: %s%s", envs.COLORS.CYAN .. envs.COLORS.BOLD, count, item, envs.COLORS.RESET))
		count = count + 1
	end
end

--- Executa comando com tratamento de erro e feedback visual
-- @param cmd string: Comando a executar
-- @param flagLog string: Descrição da operação
-- @return boolean: true se sucesso, false se erro
function aux.run_cmd_valid(cmd, flagLog)
	print()

	local result = os.execute(cmd)
	local success = (result == true or result == 0)

	if success then
		print()
		aux.pf(flagLog .. " " .. envs.MESSAGES.COMPLETE, "success")
	else
		print()
		aux.pf(flagLog .. " " .. envs.MESSAGES.ERROR, "error")
	end

	return success
end

--- Verifica se está em Arch Linux
-- @return boolean: true se Arch Linux, false caso contrário
function aux.is_arch_linux()
	local result = os.execute("pacman --version >/dev/null 2>&1")
	return result == true or result == 0
end

--- Apresenta o banner com informações
-- @return string: Banner e informações do projeto
function aux.show_banner()
	io.write(CACHED_BANNER)
end

function aux.show_congratulation()
	local final_messages = {
		"🎉 Parabéns! Seu Arch Linux está pronto!",
		"⚡ Orzhov Arch instalado e configurado!",
		"✨ Arch Linux Otimizado!",
	}

	local random_message = final_messages[math.random(#final_messages)]

	-- Banner
	io.write(CACHED_BANNER_RAW)
	print(envs.COLORS.BLUE .. string.rep("═", 70) .. envs.COLORS.RESET)
	print()
	print(envs.COLORS.BOLD .. envs.COLORS.GREEN .. "   " .. random_message .. envs.COLORS.RESET)
	print()

	-- Timing e info
	print(envs.COLORS.DIM .. "   " .. os.date("%Y-%m-%d %H:%M:%S") .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. "   Projeto: " .. envs.PROJECT_NAME .. " v" .. envs.PROJECT_VERSION .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. "   Repositório: " .. envs.REPOSITORY .. envs.COLORS.RESET)
	print()

	-- Linha separadora
	print(envs.COLORS.BLUE .. string.rep("═", 70) .. envs.COLORS.RESET)
	print()

	-- ========================================================================
	-- INSTALAÇÃO BASE
	-- ========================================================================

	print(envs.COLORS.BOLD .. envs.COLORS.CYAN .. "📦 INSTALAÇÃO BASE" .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. string.rep("─", 70) .. envs.COLORS.RESET)
	print()

	-- Pacotes Base
	print(envs.COLORS.GREEN .. "  ✓ Pacotes Base do Sistema" .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. "    (base, linux, linux-firmware, etc)" .. envs.COLORS.RESET)
	print()

	-- Display Server
	if envs.DYNAMIC.DISPLAY_SERVER then
		local display_name = (envs.DYNAMIC.DISPLAY_SERVER == "xorg") and "Xorg (X11)" or "Wayland"
		print(envs.COLORS.GREEN .. "  ✓ Servidor Gráfico: " .. display_name .. envs.COLORS.RESET)
	else
		print(envs.COLORS.YELLOW .. "  ⚠ Servidor Gráfico: Não Selecionado" .. envs.COLORS.RESET)
	end
	print()

	-- Desktop Environment
	local desktop_map = {
		{
			name = "KDE Plasma",
			vendor = envs.DESKTOP_ENVIRONMENTS.KDE,
		},
		{
			name = "Hyprland",
			vendor = envs.DESKTOP_ENVIRONMENTS.HYPRLAND,
		},
	}

	local desktop_options = {}
	local option_lookup = {}

	for _, env_config in ipairs(desktop_map) do
		table.insert(desktop_options, env_config.vendor)
		option_lookup[env_config.vendor] = env_config
	end

	local selected_config = option_lookup[envs.DYNAMIC.DESKTOP_ENVIRONMENT]
	if envs.DYNAMIC.DESKTOP_ENVIRONMENT then
		print(envs.COLORS.GREEN .. "  ✓ Ambiente Gráfico: " .. selected_config.name .. envs.COLORS.RESET)
	else
		print(envs.COLORS.YELLOW .. "  ⚠ Ambiente Gráfico: Não Selecionado" .. envs.COLORS.RESET)
	end
	print()

	-- CPU
	if envs.DYNAMIC.CPU_VENDOR then
		local cpu_name = (envs.DYNAMIC.CPU_VENDOR == "AMD") and "AMD Ryzen" or "Intel Core"
		print(envs.COLORS.GREEN .. "  ✓ Processador (CPU): " .. cpu_name .. envs.COLORS.RESET)
		print(
			envs.COLORS.DIM
				.. "    Drivers: "
				.. (envs.DYNAMIC.CPU_VENDOR == "AMD" and "amd-ucode, vulkan-swrast" or "intel-ucode")
				.. envs.COLORS.RESET
		)
	else
		print(envs.COLORS.YELLOW .. "  ⚠ Processador (CPU): Não Selecionado" .. envs.COLORS.RESET)
	end
	print()

	-- GPU
	if envs.DYNAMIC.GPU_VENDORS and #envs.DYNAMIC.GPU_VENDORS > 0 then
		print(
			envs.COLORS.GREEN
				.. "  ✓ Placas Gráficas (GPU): "
				.. table.concat(envs.DYNAMIC.GPU_VENDORS, ", ")
				.. envs.COLORS.RESET
		)
		print(envs.COLORS.DIM .. "    (Drivers instalados para cada uma)" .. envs.COLORS.RESET)
	else
		print(envs.COLORS.YELLOW .. "  ⚠ Placas Gráficas (GPU): Nenhuma selecionada" .. envs.COLORS.RESET)
	end
	print()

	-- Multimídia e Áudio
	print(envs.COLORS.GREEN .. "  ✓ Multimídia e Codecs" .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. "    (ffmpeg, gstreamer, opus, vorbis, etc)" .. envs.COLORS.RESET)
	print()

	print(envs.COLORS.GREEN .. "  ✓ Áudio (PipeWire)" .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. "    (pipewire, pipewire-pulse, wireplumber, bluez)" .. envs.COLORS.RESET)
	print()

	print(envs.COLORS.GREEN .. "  ✓ Fontes do Sistema" .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. "    (noto-fonts, jetbrains-mono, nerd-fonts)" .. envs.COLORS.RESET)
	print()

	-- ========================================================================
	-- CONFIGURAÇÕES DO SISTEMA
	-- ========================================================================

	print(envs.COLORS.BOLD .. envs.COLORS.CYAN .. "⚙️  CONFIGURAÇÕES DO SISTEMA" .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. string.rep("─", 70) .. envs.COLORS.RESET)
	print()

	print(envs.COLORS.GREEN .. "  ✓ Pacman" .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. "    ├─ ParallelDownloads ativado (10 conexões simultâneas)" .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. "    ├─ ILoveCandy ativado (animação durante pacman)" .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. "    └─ Database sincronizado" .. envs.COLORS.RESET)
	print()

	print(envs.COLORS.GREEN .. "  ✓ Systemd Services" .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. "    ├─ graphical.target (interface gráfica)" .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. "    ├─ fstrim.timer (otimização SSD)" .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. "    ├─ NetworkManager (gerenciamento de rede)" .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. "    ├─ SDDM (display manager)" .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. "    ├─ bluetooth.service (Bluetooth)" .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. "    ├─ reflector.service (mirrors automáticos)" .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. "    └─ power-profiles-daemon (perfis de energia)" .. envs.COLORS.RESET)
	print()

	print(envs.COLORS.GREEN .. "  ✓ FSTAB" .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. "    └─ SSD otimizado (noatime em vez de relatime)" .. envs.COLORS.RESET)
	print()

	print(envs.COLORS.GREEN .. "  ✓ Memória (ZRAM + Swap)" .. envs.COLORS.RESET)

	-- Detectar RAM para mostrar configuração
	local total_ram_mb = aux.get_ram_mb()

	if total_ram_mb then
		local zram_config = ""
		local swappiness = ""

		if total_ram_mb <= 9000 then
			zram_config = "Tamanho ZRAM = 100% da RAM"
			swappiness = "Swappiness = 180 (agressivo)"
		elseif total_ram_mb <= 25000 then
			zram_config = "Tamanho ZRAM = 50% da RAM"
			swappiness = "Swappiness = 150 (balanceado)"
		else
			zram_config = "Tamanho ZRAM = 50% da RAM"
			swappiness = "Swappiness = 100 (conservador)"
		end

		print(envs.COLORS.DIM .. "    ├─ RAM Detectada: " .. total_ram_mb .. " MB" .. envs.COLORS.RESET)
		print(envs.COLORS.DIM .. "    ├─ " .. zram_config .. envs.COLORS.RESET)
		print(envs.COLORS.DIM .. "    ├─ " .. swappiness .. envs.COLORS.RESET)
		print(envs.COLORS.DIM .. "    ├─ Watermark otimizado" .. envs.COLORS.RESET)
		print(envs.COLORS.DIM .. "    └─ Page cluster otimizado" .. envs.COLORS.RESET)
	else
		print(envs.COLORS.DIM .. "    └─ ZRAM configurado com padrões otimizados" .. envs.COLORS.RESET)
	end
	print()

	print(envs.COLORS.GREEN .. "  ✓ Reflector (Mirror List)" .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. "    ├─ Mirrors Brasil atualizados" .. envs.COLORS.RESET)
	print(
		envs.COLORS.DIM
			.. "    └─ Hook automático criado (próximas atualizações serão automáticas)"
			.. envs.COLORS.RESET
	)
	print()

	-- ========================================================================
	-- RESUMO DE ESTATÍSTICAS
	-- ========================================================================

	print()
	print(envs.COLORS.BOLD .. envs.COLORS.CYAN .. "📊 ESTATÍSTICAS" .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. string.rep("─", 70) .. envs.COLORS.RESET)
	print()

	local total_packages = envs.DYNAMIC.PACKAGES_TOTAL or 0
	local end_time = os.time()
	local diff_seconds = os.difftime(end_time, envs.DYNAMIC.START_TIME or end_time)
	envs.DYNAMIC.TIME_TOTAL = math.floor(diff_seconds / 60)
	local time_formatted = string.format("%d minutos e %d segundos", envs.DYNAMIC.TIME_TOTAL, diff_seconds % 60)
	-- local total_size = aux.calculate_sizing_total()

	print()
	print(envs.COLORS.GREEN .. "  ✓ Pacotes Instalados: ~" .. total_packages .. envs.COLORS.RESET)
	-- print(envs.COLORS.GREEN .. "  ✓ Tamanho total: " .. total_size .. envs.COLORS.RESET)
	print(envs.COLORS.GREEN .. "  ✓ Tempo estimado: " .. time_formatted .. envs.COLORS.RESET)
	print()

	-- ========================================================================
	-- BACKUP
	-- ========================================================================

	aux.save_config_backup()

	-- ========================================================================
	-- MENSAGEM FINAL
	-- ========================================================================

	print()
	print(envs.COLORS.BLUE .. string.rep("═", 70) .. envs.COLORS.RESET)
	print()
	print(envs.COLORS.BOLD .. envs.COLORS.YELLOW .. "  Obrigado por usar Orzhov Arch!" .. envs.COLORS.RESET)
	print(envs.COLORS.DIM .. "  Se tiver dúvidas, consulte a documentação ou abra uma issue." .. envs.COLORS.RESET)
	print()
end

function aux.save_config_backup()
	local backup_data = {
		system_info = {
			timestamp = os.date("%Y-%m-%d %H:%M:%S"),
			backuptimestamp = os.date("%Y-%m-%d-%H-%M-%S"),
			project = envs.PROJECT_NAME,
			version = envs.PROJECT_VERSION,
			repo = envs.REPOSITORY,
		},
		system_config = {
			cpu_vendor = envs.DYNAMIC.CPU_VENDOR,
			gpu_vendors = envs.DYNAMIC.GPU_VENDORS,
			display_server = envs.DYNAMIC.DISPLAY_SERVER,
			desktop_environment = envs.DYNAMIC.DESKTOP_ENVIRONMENT,
		},
		installed = envs.DYNAMIC.PACKAGES_INSTALLED,
	}

	local backup_path = envs.PATHS.BACKUP .. "/afio-arch-config-" .. backup_data.system_info.backuptimestamp .. ".json"

	local json_string = "{\n"
	json_string = json_string .. '  "system_info": {\n'
	json_string = json_string .. '    "timestamp": "' .. backup_data.system_info.timestamp .. '",\n'
	json_string = json_string .. '    "project": "' .. backup_data.system_info.project .. '",\n'
	json_string = json_string .. '    "version": "' .. backup_data.system_info.version .. '",\n'
	json_string = json_string .. '    "repository": "' .. backup_data.system_info.repo .. '",\n'
	json_string = json_string .. "  },\n"
	json_string = json_string .. '  "system_config": {\n'
	json_string = json_string
		.. '    "display_server": "'
		.. (backup_data.system_config.display_server or "none")
		.. '",\n'
	json_string = json_string .. '    "cpu_vendor": "' .. (backup_data.system_config.cpu_vendor or "none") .. '",\n'
	json_string = json_string
		.. '    "gpu_vendors": ["'
		.. (backup_data.system_config.gpu_vendors and table.concat(backup_data.system_config.gpu_vendors, '", "') or "")
		.. '"],\n'
	json_string = json_string
		.. '    "desktop_environment": "'
		.. (backup_data.system_config.desktop_environment or "none")
		.. '",\n'
	json_string = json_string .. "  },\n"
	json_string = json_string .. '  "installed": {\n'
	if backup_data.installed then
		local cat_lines = {}
		for cat, pkgs in pairs(backup_data.installed) do
			local arr_str = '["' .. table.concat(pkgs, '", "') .. '"]'
			table.insert(cat_lines, '    "' .. cat .. '": ' .. arr_str)
		end
		json_string = json_string .. table.concat(cat_lines, ",\n") .. "\n"
	end
	json_string = json_string .. "  }\n"
	json_string = json_string .. "}\n"

	local backup_success, backup_create_error = files.create(backup_path, json_string, false)

	if backup_success then
		print()
		print(envs.COLORS.BOLD .. envs.COLORS.CYAN .. "💾 BACKUP DE CONFIGURAÇÃO" .. envs.COLORS.RESET)
		print(envs.COLORS.DIM .. string.rep("─", 70) .. envs.COLORS.RESET)
		print()
		print(envs.COLORS.GREEN .. "  ✓ Configurações salvas em:" .. envs.COLORS.RESET)
		print(envs.COLORS.DIM .. "  |--" .. backup_path .. envs.COLORS.RESET)
		print()
		return true
	else
		aux.pf("Erro ao salvar configuração" .. backup_create_error, "error")
		return false
	end
end

--- Busca um pacote específico retornando sua descrição
-- @param pkg_name string: Nome do pacote
-- @return pkg string: Retorna a descrição do pacote
function aux.get_description(pkg_name)
	for _, pkg_list in pairs(packages) do
		if type(pkg_list) == "table" then
			for _, pkg in ipairs(pkg_list) do
				if type(pkg) == "table" and pkg.name == pkg_name then
					return pkg.desc
				end
			end
		end
	end
	return "Pacote não descrito"
end

--- Retorna todos os pacotes de uma categoria em formato de array
-- @param category_name string: Nome da categoria
-- @return packages table: Array de strings com nomes e descrição dos pacotes
function aux.get_category(category_name)
	if packages[category_name] then
		return packages[category_name]
	else
		return {}
	end
end

--- Retorna nomes de pacotes sem descrição
-- @param pkg_list table: Array com os pacotes a serem instalados
-- @return names table: Array de strings com nomes dos pacotes para instalação
function aux.get_names(pkg_list)
	local names = {}
	for _, pkg in ipairs(pkg_list) do
		table.insert(names, pkg.name)
	end
	return names
end

--- Pausa e aguarda usuário pressionar ENTER
-- @return: Interação do usuário ao apertar ENTER
function aux.pause_screen()
	print()
	print(envs.COLORS.YELLOW .. "Pressione ENTER para continuar..." .. envs.COLORS.RESET)
	local _ = io.read()
end

--- Pausa e aguarda e depois limpa o shell
-- @return: Interação do usuário ao apertar ENTER e limpa o shell para continuar
function aux.sequence()
	aux.pause_screen()
end

--- Instruções para caso usuário cancele com CTRL + C
-- @return: Cancelamento do script com CTRL + C
function aux.canceled_instruction()
	print()
	aux.pf("Instalação Cancelada", "warn")
	print()
	print(envs.COLORS.BOLD .. "Para reiniciar a instalação, execute:" .. envs.COLORS.YELLOW)
	print()
	print(envs.COLORS.BLUE .. "  " .. envs.PATHS.DOTFILES .. "/init-setup" .. envs.COLORS.RESET)
	print()
	os.exit(1)
end

--- Grupos de categorias
-- @return table: Retorna uma tabela com chave e tabela
aux.groups_categories = {
	["Pacotes Padrões"] = { "DEFAULT", "MULTIMEDIA_BASE", "AUDIO", "FONTS" },
	["Desenvolvimento"] = { "DEVELOPMENT", "DATABASE", "PHP", "PYTHON", "NODE", "RUST", "QT", "ENGINEERING" },
	["Games"] = { "GAMING", "GAMING_LIBS" },
	["Multimídia"] = { "MEDIA_TOOLS" },
	["Internet & Comunicação"] = { "INTERNET" },
	["Ferramentas de Design"] = { "GRAPHICS" },
	["Utilitários do Sistema"] = { "ACCESSORIES" },
	["Segurança & Firewall"] = { "SECURITY" },
	["Mobile"] = { "MOBILE" },
	["Pacotes da Comunidade"] = { "AUR" },
	["Ambiente Hyprland"] = { "HYPRLAND_EXTRA" },
	["Ambiente KDE Plasma"] = { "KDE_EXTRA" },
}

--- ============================================================================
--- WRAPPERS DE GUM - MENU INTERATIVO
--- ============================================================================

--- Painel visual com título e conteúdo
-- @param title string: Título do painel
function aux.panel(title)
	print()
	print(envs.COLORS.BOLD .. envs.COLORS.BLUE .. "┌─ " .. title .. " ─┐" .. envs.COLORS.RESET)
	print()
end

--- Confirmação sim/não com gum
-- @param prompt string: Pergunta a exibir
-- @return boolean: true se confirmado, false se negado
function aux.confirm(prompt)
	print()
	local cmd = string.format('gum confirm "%s" --affirmative="Confirmar" --negative="Cancelar"', prompt)
	local result = os.execute(cmd)
	return result == true or result == 0
end

--- Executa instalação com validação de segurança
-- @param packages_to_install table: Array de nomes de pacotes
-- @return boolean: true se sucesso, false se erro
function aux.installation(packages_to_install)
	if #packages_to_install == 0 then
		aux.pf("Nenhum pacote para instalar", "warn")
		return false
	end

	local unique_packages = {}
	local seen = {}
	for _, pkg in ipairs(packages_to_install) do
		if not seen[pkg] then
			seen[pkg] = true
			table.insert(unique_packages, pkg)
		end
	end

	print()
	aux.pf("Iniciando instalação de " .. #unique_packages .. " pacotes...", "warn")
	print()

	local cmd = envs.SYSTEM.PKG_MANAGER_INSTALL .. " " .. table.concat(unique_packages, " ")

	print(envs.COLORS.DIM .. "Comando: " .. cmd .. envs.COLORS.RESET)
	print()

	if not aux.confirm("Executar este comando de instalação?") then
		aux.pf("Instalação cancelada pelo usuário", "warn")
		return false
	end

	return aux.run_cmd_valid(cmd, "[INSTALL] ")
end

--- Ler o arquivo de meminfo e retorna o valor de MemTotal em megabytes (MB)
-- @return boolean, string|nil: Resultado da leitura e mensagem de erro
function aux.get_ram_mb()
	local file, error_message = io.open("/proc/meminfo", "r")

	if not file then
		return nil, "Não foi possível acessar /proc/meminfo: " .. tostring(error_message)
	end

	for line in file:lines() do
		local memory_kb = line:match("^MemTotal:%s+(%d+)%s+kB")

		if memory_kb then
			file:close()

			return math.floor(tonumber(memory_kb) / 1024), nil
		end
	end

	file:close()

	return nil, "MemTotal não encontrado em /proc/meminfo"
end

function aux.calculate_sizing_total()
	local all_pkgs = {}
	if envs.DYNAMIC.PACKAGES_INSTALLED then
		for _, cat in pairs(envs.DYNAMIC.PACKAGES_INSTALLED) do
			for _, pkg in ipairs(cat) do
				table.insert(all_pkgs, pkg)
			end
		end
	end

	if #all_pkgs == 0 then
		return "0 MB"
	end

	local awk_script =
		'\'/^Installed Size/ { if ($5 == "MiB") sum += $4; else if ($5 == "KiB") sum += $4/1024; else if ($5 == "GiB") sum += $4*1024 } END { printf "%.2f MB\\n", sum }\''
	local cmd = string.format("pacman -Qi %s 2>/dev/null | awk %s", table.concat(all_pkgs, " "), awk_script)

	local handle = io.popen(cmd)
	if handle then
		local result = handle:read("*a"):gsub("\n", "")
		handle:close()
		envs.DYNAMIC.SIZING_TOTAL = result
		return result
	end
	return "0 MB"
end

--- Registra os pacotes instalados e a categoria para o sumário/backup
-- @param category string: Nome da categoria (ex: DEFAULT, GPU_AMD)
-- @param packages_list table: Array com os nomes dos pacotes
function aux.register_installed_packages(category, packages_list)
	-- Inicializa as variáveis se não existirem
	envs.DYNAMIC.PACKAGES_INSTALLED = envs.DYNAMIC.PACKAGES_INSTALLED or {}
	envs.DYNAMIC.PACKAGES_TOTAL = envs.DYNAMIC.PACKAGES_TOTAL or 0

	-- Inicializa a categoria se não existir
	envs.DYNAMIC.PACKAGES_INSTALLED[category] = envs.DYNAMIC.PACKAGES_INSTALLED[category] or {}

	for _, pkg in ipairs(packages_list) do
		table.insert(envs.DYNAMIC.PACKAGES_INSTALLED[category], pkg)
		envs.DYNAMIC.PACKAGES_TOTAL = envs.DYNAMIC.PACKAGES_TOTAL + 1
	end
end

--- Seleção de opção por número utilizando interface interativa
-- @param prompt string: Título/Pergunta exibida no topo do menu
-- @param options table: Array de strings contendo as opções
-- @return string|nil: Retorna a string selecionada ou nil em caso de cancelamento/erro
function aux.choose_per_number(prompt, options)
	if not options or #options == 0 then
		return nil
	end

	local formatted_args = {}
	local option_map = {}

	for i, opt in ipairs(options) do
		local formatted_item = string.format("[%d] %s", i, opt)
		table.insert(formatted_args, string.format("%q", formatted_item))
		option_map[formatted_item] = opt
	end

	local list_height = #options + 2

	local cmd =
		string.format('gum choose --height=%d --header="%s" %s', list_height, prompt, table.concat(formatted_args, " "))

	local handle = io.popen(cmd)
	if not handle then
		return nil
	end

	local result = handle:read("*l")
	handle:close()

	if not result or result == "" then
		return nil
	end

	result = result:gsub("^%s*(.-)%s*$", "%1")
	return option_map[result] or result:gsub("^%[%d+%]%s*", "")
end

--- Menu multi-select com gum (espaço para marcar, enter para confirmar)
-- @param prompt string: Pergunta a exibir
-- @param options table: Array de opções
-- @return table: Array de opções selecionadas
function aux.multiselect(prompt, options)
	if #options == 0 then
		aux.pf("Nenhuma opção disponível", "warn")
		return {}
	end

	local opts_formatted = {}
	for _, opt in ipairs(options) do
		table.insert(opts_formatted, string.format('"%s"', opt))
	end
	local opts_str = table.concat(opts_formatted, " ")
	local list_height = #options + 2

	local cmd = string.format('gum choose --no-limit --height=%d --header="%s" %s', list_height, prompt, opts_str)

	local handle = io.popen(cmd)
	if not handle then
		aux.pf("Erro ao abrir gum multiselect", "error")
		return {}
	end

	local selected = {}
	for line in handle:lines() do
		if line ~= "" then
			table.insert(selected, line)
		end
	end
	handle:close()

	return selected
end

--- Navega por uma ou múltiplas categorias (ou grupos) exibindo um sumário
--- interativo para o usuário selecionar quais pacotes deseja instalar.
-- @param target string|table: Nome da categoria, nome do grupo ou array de categorias
-- @return boolean: true se a instalação concluiu, false se cancelada/erros
function aux.interactive_install(target)
	local categories = {}
	if type(target) == "string" then
		if aux.groups_categories[target] then
			categories = aux.groups_categories[target]
		else
			categories = { target }
		end
	elseif type(target) == "table" then
		categories = target
	else
		aux.pf("Parâmetro inválido para instalação interativa.", "error")
		return false
	end

	local packages_to_install = {}
	local packages_by_category = {}

	for _, cat_name in ipairs(categories) do
		local pkgs = aux.get_category(cat_name)

		if pkgs and #pkgs > 0 then
			aux.panel("Explorando Categoria: " .. cat_name)

			local options = {}
			local map_names = {}

			for i, pkg in ipairs(pkgs) do
				local safe_desc = pkg.desc:gsub('"', "'")
				-- Adicionado [%d] para colocar o número do índice na frente
				local text_option = string.format("[%d] %s - %s", i, pkg.name, safe_desc)
				table.insert(options, text_option)
				map_names[text_option] = pkg.name -- O map continuará funcionando perfeitamente
			end

			local prompt = string.format("Selecione pacotes de %s (Espaço marca, Enter confirma):", cat_name)
			local selected = aux.multiselect(prompt, options)

			if selected and #selected > 0 then
				packages_by_category[cat_name] = {}
				for _, sel_line in ipairs(selected) do
					local real_name = map_names[sel_line]
					if real_name then
						table.insert(packages_to_install, real_name)
						table.insert(packages_by_category[cat_name], real_name)
					end
				end
				aux.pf(#selected .. " pacote(s) selecionado(s) em " .. cat_name, "success")
			else
				aux.pf("Nenhum pacote selecionado em " .. cat_name .. ". Pulando...", "warn")
			end
		else
			aux.pf("Categoria '" .. tostring(cat_name) .. "' não encontrada ou vazia.", "warn")
		end
	end
	if #packages_to_install > 0 then
		aux.pf("Total de pacotes selecionados para instalação: " .. #packages_to_install, "success")
		local success = aux.installation(packages_to_install)

		if success then
			for cat_name, pkgs in pairs(packages_by_category) do
				aux.register_installed_packages(cat_name, pkgs)
			end
		end
		return success
	else
		aux.pf("Nenhum pacote foi selecionado no total. Instalação cancelada.", "warn")
		return false
	end
end

--- Recebe uma entrada de texto do usuário utilizando interface interativa
-- @param prompt string: Pergunta ou instrução a ser exibida acima do campo de texto
-- @return boolean, string|nil: true e o texto digitado se sucesso/preenchido, false e nil caso contrário
function aux.input_text(prompt)
	print()
	-- Utiliza o gum input com um header contendo a pergunta
	local cmd = string.format('gum input --header="%s" --placeholder="Digite aqui..."', prompt)

	local handle = io.popen(cmd)
	if not handle then
		return false, nil
	end

	local result = handle:read("*l")
	handle:close()

	-- Verifica se o usuário cancelou (Ctrl+C) ou deixou em branco
	if not result or result:match("^%s*$") then
		return false, nil
	end

	-- Remove espaços em branco nas pontas, caso existam
	result = result:gsub("^%s*(.-)%s*$", "%1")
	return true, result
end

--- ============================================================================
--- EXPORTAÇÃO DO MÓDULO
--- ============================================================================

return aux
