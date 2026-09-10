--- ============================================================================
--- ORZHOV ARCH - CONFIGURAÇÕES PADRÕES PARA O SISTEMA
--- ============================================================================
--- Configurações globais do sistema para pacman, habilitar e iniciar serviços
--- do systemd, otimização inteligente para SSD e Memória (SWAP & RAM),reflector
--- ============================================================================

local systemConfig = {}
local aux = require("src.utils.aux")
local envs = require("src.core.envs")
local files = require("src.utils.files")

--- ============================================================================
--- CONFIGURAÇÃO DO PACMAN
--- ============================================================================

function systemConfig.config_pacman()
	aux.panel("Configuração do Pacman")

	local modified = false
	local pacman_conf_path = "/etc/pacman.conf"

	local content, read_error = files.read(pacman_conf_path)

	if not content then
		aux.pf(read_error, "error")
		return false
	end

	if content:match("#ParallelDownloads = 5") then
		content = content:gsub("#ParallelDownloads = 5", "ParallelDownloads = " .. envs.PACMAN_CONF.parallel_downloads)
		modified = true
		aux.pf("Habilitado ParallelDownloads = " .. envs.PACMAN_CONF.parallel_downloads, "success")
	else
		aux.pf("Não foi possível encontrar ParallelDownloads", "warn")
	end

	if not content:match("ILoveCandy") then
		content = content:gsub("(ParallelDownloads = %d+)", "%1\n" .. envs.PACMAN_CONF.enable_candy)
		modified = true
		aux.pf("Habilitado ILoveCandy", "success")
	else
		aux.pf("ILoveCandy já está habilitado", "warn")
	end

	if content:match("#Color") then
		content = content:gsub("#Color", "Color")
		modified = true
		aux.pf("Textos coloridos no pacman ativados", "success")
	else
		aux.pf("Não foi possível ativar os textos coloridos no pacman", "warn")
	end

	if modified then
		local success, write_error = files.write(pacman_conf_path, content, true)

		if not success then
			aux.pf("[Pacman] " .. write_error, "error")
			return false
		end

		aux.pf("Configurações salvas.", "success")

		if not aux.run_cmd_valid(envs.SYSTEM.PKG_MANAGER_UPGRADE, "[Pacman] Sincronizando Pacman. ") then
			return false
		end
	end

	return true
end

--- ============================================================================
--- CONFIGURAÇÃO DO SYSTEMD
--- ============================================================================

function systemConfig.config_systemd()
	aux.panel("Configuração do Systemd")

	local targets = {
		{ service = "graphical.target", desc = "Interface gráfica" },
		{ service = "fstrim.timer", desc = "TRIM para SSD" },
		{ service = "NetworkManager", desc = "Gerenciamento de rede" },
		{ service = "sddm", desc = "Display Manager" },
		{ service = "bluetooth.service", desc = "Bluetooth" },
		{ service = "reflector.service", desc = "Atualização de mirrors" },
		{ service = "polkit.service", desc = "Habilitando Polkit" },
		{ service = "power-profiles-daemon.service", desc = "Perfis de energia" },
		{ service = "docker.service", desc = "Habilitando Docker" },
	}

	local all_success = true

	for _, item in ipairs(targets) do
		local cmd = "sudo systemctl enable " .. item.service
		if not aux.run_cmd_valid(cmd, "[Systemd " .. item.desc .. "] ") then
			all_success = false
		end
	end

	return all_success
end

--- ============================================================================
--- CONFIGURAÇÃO DO FSTAB
--- ============================================================================

function systemConfig.config_fstab()
	aux.panel("Configurando FSTAB para SSD")

	local fstab_path = "/etc/fstab"

	local content, read_error = files.read(fstab_path)

	if not content then
		aux.pf(read_error, "error")
		return false
	end

	if not content:match("relatime") then
		aux.pf("FSTAB já está otimizado (sem relatime encontrado)", "warn")
		return true
	end

	content = content:gsub("relatime", "noatime")

	local success, write_error = files.write(fstab_path, content, true)

	if not success then
		aux.pf("[FSTAB] " .. write_error, "error")
		return false
	end

	aux.pf("FSTAB otimizado com noatime", "success")

	return true
end

--- ============================================================================
--- INSTALANDO E CONFIGURANDO YAY
--- ============================================================================

function systemConfig.config_aur()
	aux.panel("Configurando e Instalando YAY")

	local aur_path = envs.PATHS.HOME .. "/aur"
	local yay_path = aur_path .. "/yay"

	if not files.exists(aur_path) then
		if not aux.run_cmd_valid("mkdir -p " .. yay_path, "[AUR] Criação do diretório ") then
			return false
		end
	end

	local clone_cmd = string.format('git clone https://aur.archlinux.org/yay.git "%s"', yay_path)
	if not aux.run_cmd_valid(clone_cmd, "[YAY] Instalando YAY") then
		return false
	end

	local build_cmd = string.format('env -C "%s" makepkg -sic --skippgpcheck', yay_path)
	if not aux.run_cmd_valid(build_cmd, "[YAY] Compilação e instalação") then
		return false
	end

	return true
end

--- ============================================================================
--- CONFIGURAÇÃO DO SWAP E ZRAM
--- ============================================================================

function systemConfig.config_memory()
	aux.panel("Configurando SWAPINESS & ZRAM")

	local total_ram_mb, ram_error = aux.get_ram_mb()

	if not total_ram_mb then
		aux.pf("[SWAPINESS & ZRAM] " .. ram_error, "error")
		return false
	end

	aux.pf("[SWAPINESS & ZRAM] RAM Total Detectada: " .. total_ram_mb .. " MB", "success")

	local zram_size_val
	local swappiness_val

	if total_ram_mb <= envs.LIMITS.ZRAM_RAM_SMALL then
		zram_size_val = "ram"
		swappiness_val = envs.SWAPPINESS_LEVELS.small
	elseif total_ram_mb <= envs.LIMITS.ZRAM_RAM_MEDIUM then
		zram_size_val = "ram/2"
		swappiness_val = envs.SWAPPINESS_LEVELS.medium
	else
		zram_size_val = "ram/2"
		swappiness_val = envs.SWAPPINESS_LEVELS.large
	end

	local zram_path = "/etc/systemd/zram-generator.conf"

	local zram_content = string.format(
		"[zram0]\n"
			.. "zram-size = %s\n"
			.. "compression-algorithm = %s\n"
			.. "swap-priority = %s\n"
			.. "fs-type = %s\n",
		zram_size_val,
		envs.ZRAM_CONFIG.compression,
		envs.ZRAM_CONFIG.swap_priority,
		envs.ZRAM_CONFIG.fs_type
	)

	local swapiness_path = "/etc/sysctl.d/99-zram.conf"

	local swappiness_content = string.format(
		"vm.swappiness = %s\n"
			.. "vm.watermark_boost_factor = %s\n"
			.. "vm.watermark_scale_factor = %s\n"
			.. "vm.page-cluster = %s\n",
		swappiness_val,
		envs.SYSCTL_CONFIG.watermark_boost_factor,
		envs.SYSCTL_CONFIG.watermark_scale_factor,
		envs.SYSCTL_CONFIG.page_cluster
	)

	aux.pf("[SWAPINESS & ZRAM] Gerando arquivo " .. zram_path .. "...", "warn")
	local success_zram, create_error_zram = files.create(zram_path, zram_content, true)

	if not success_zram then
		aux.pf("[SWAPINESS & ZRAM] Erro ao criar configuração do ZRAM: " .. tostring(create_error_zram), "error")
		return false
	end

	aux.pf("[SWAPINESS & ZRAM] Ajustando o Swappiness e gerenciamento de memória...", "warn")
	local success_swapiness, create_error_swapiness = files.create(swapiness_path, swappiness_content, true)

	if not success_swapiness then
		aux.pf(
			"[SWAPINESS & ZRAM] Erro ao criar configuração do Sysctl: " .. tostring(create_error_swapiness),
			"error"
		)
		return false
	end

	aux.run_cmd_valid("sudo systemctl daemon-reload", "[SWAPINESS & ZRAM] Recarregando daemon do systemd")
	aux.run_cmd_valid("sudo systemctl enable --now /dev/zram0", "[SWAPINESS & ZRAM] Habilitando módulo zram0")
	aux.run_cmd_valid(
		"sudo systemctl restart systemd-zram-setup@zram0.service",
		"[SWAPINESS & ZRAM] Reiniciando serviço ZRAM"
	)
	aux.run_cmd_valid("sudo sysctl --system", "[SWAPINESS & ZRAM] Aplicando parâmetros do sysctl")

	aux.run_cmd_valid("zramctl && swapon --show", "[SWAPINESS & ZRAM] ")

	aux.pf("[SWAPINESS & ZRAM] Configuração do SWAPINESS e ZRAM concluída!", "success")

	return true
end

--- ============================================================================
--- CONFIGURAÇÃO DO REFLECTOR
--- ============================================================================

function systemConfig.config_reflector()
	aux.panel("Atualizando o mirror Brazil com Reflector")

	local hooks_dir = "/etc/pacman.d/hooks"
	local hook_path = "/etc/pacman.d/hooks/mirrorupgrade.hook"

	if not files.is_path(hooks_dir, "dir") then
		aux.pf("Criando diretório " .. hooks_dir, "warn")
		aux.run_cmd_valid("sudo mkdir -p " .. hooks_dir, "[Reflector] Criando diretório " .. hooks_dir .. " ")
	end

	aux.run_cmd_valid(envs.SYSTEM.REFLECTOR_CMD, "[Reflector] ")

	local hook_content = [[
  [Trigger]
  Operation = Upgrade
  Type = Package
  Target = pacman-mirrorlist

  [Action]
  Description = Updating pacman-mirrorlist with reflector and removing pacnew...
  When = PostTransaction
  Depends = reflector
  Exec = /bin/sh -c "sudo reflector --verbose --country BR --age 24 --p http --p https --sort rate --save /etc/pacman.d/mirrorlist; rm -f /etc/pacman.d/mirrorlist.pacnew"
  ]]

	local success, create_error = files.create(hook_path, hook_content, true)

	if not success then
		aux.pf("[Reflector] " .. create_error, "error")
		return false
	end

	aux.pf("Hook criado em " .. hook_path, "success")

	return true
end

--- ============================================================================
--- EXPORTAÇÃO DO MÓDULO
--- ============================================================================

return systemConfig
