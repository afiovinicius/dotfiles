--- ============================================================================
--- ORZHOV ARCH - CONFIGURAÇÕES GLOBAIS
--- ============================================================================
--- Configurações gerais para o desktop conforme o ambiente selecionado
--- Terminal
--- ZSH
--- ZSH Plugins
--- Theme Terminal (starship)
--- Packages Managers (uv, poetry, angular cli)
--- GitHub
--- Wallpapers
--- Theme Login Screen SDDM
--- Theme Desktop per enrironment
--- ============================================================================

local desktopConfig = {}
local aux = require("src.utils.aux")
local envs = require("src.core.envs")
local files = require("src.utils.files")

--- ============================================================================
--- CONFIGURAÇÕES
--- ============================================================================

function desktopConfig.config_desktop()
	aux.panel("Configurações do Desktop")

	local path_base = envs.PATHS.HOME .. "/.config/"
	local current_dir = os.getenv("PWD") or io.popen("pwd"):read("*l")
	local src_base = current_dir .. "/src/models/config/"

	local success_alacritty, error_alacritty = files.is_path(path_base .. "alacritty", "dir")

	if not success_alacritty then
		if not aux.run_cmd_valid("cp -r " .. src_base .. "alacritty/ " .. path_base, "[ALACRITTY] ") then
			aux.pf("Não foi possível fazer a configuração do alacritty", "error")
		end
	else
		aux.pf(error_alacritty, "error")
	end

	local success_ghostty, error_ghostty = files.is_path(path_base .. "ghostty", "dir")

	if not success_ghostty then
		if not aux.run_cmd_valid("cp -r " .. src_base .. "ghostty/ " .. path_base, "[GHOSTTY] ") then
			aux.pf("Não foi possível fazer a configuração do ghostty", "error")
		end
		aux.run_cmd_valid("sudo systemctl enable app-com.mitchellh.ghostty.service", "[GHOSTTY] ")
	else
		aux.pf(error_ghostty, "error")
	end

	local success_zsh, error_zsh = files.is_path(path_base .. "zsh", "dir")

	if not success_zsh then
		if not aux.run_cmd_valid("cp -r " .. src_base .. "zsh/ " .. path_base, "[ZSH] ") then
			aux.pf("Não foi possível fazer a configuração do zsh", "error")
		end

		aux.run_cmd_valid(path_base .. "zsh/.zshenv" .. " ~/.zshenv", "[ZSH] ")

		local targets_plugins = {
			{ repo = "https://github.com/zsh-users/zsh-autosuggestions", folder = "zsh-autosuggestions" },
			{ repo = "https://github.com/zsh-users/zsh-syntax-highlighting", folder = "zsh-syntax-highlighting" },
			{ repo = "https://github.com/zsh-users/zsh-completions", folder = "zsh-completions" },
			{ repo = "https://github.com/johannjhang/zsh-interactive-cd.git", folder = "zsh-interactive-cd" },
			{ repo = "https://github.com/z-shell/zsh-navigation-tools.git", folder = "zsh-navigation-tools" },
		}

		for _, item in ipairs(targets_plugins) do
			local cmd = "git clone " .. item.repo .. " " .. path_base .. "zsh/plugins/" .. item.folder
			aux.run_cmd_valid(cmd, "[GITCLONE] ")
		end
	else
		aux.pf(error_zsh, "error")
	end

	aux.run_cmd_valid("cp -r " .. src_base .. "starship/starship.toml " .. path_base, "[STARSHIP] ")

	aux.run_cmd_valid("pipx ensurepath && pipx install uv && pipx inject poetry poetry-plugin-shell", "[POETRY & UV] ")

	aux.run_cmd_valid("npm install -g @angular/cli", "[ANGULAR] Angular CLI ")

	if aux.confirm("Vamos começar com as configurações do GitHub?") then
		local success_user, res_user = aux.input_text("Qual seu nome de usuário no github?")
		if success_user then
			aux.run_cmd_valid('git config --global user.name "' .. res_user .. '"', "Configurando nome de usuário")
		end

		local success_mail, res_mail = aux.input_text("Qual seu email do github?")
		if success_mail then
			aux.run_cmd_valid('git config --global user.email "' .. res_mail .. '"', "Configurando email")
		end

		local success_branch, res_branch = aux.input_text("Qual nome padrão você deseja para sua branch inicial?")
		if success_branch then
			aux.run_cmd_valid('git config --global init.defaultBranch "' .. res_branch .. '"', "Configurando branchs")
		end
		if aux.run_cmd_valid("command -v gh >/dev/null 2>&1", "[GITHUB] ") then
			aux.pf(
				"Você já tem o GitHub CLI instalado. Ao iniciar o sistema com a interface, use o comando 'gh auth login' em seu terminal.",
				"success"
			)
		end
	else
		aux.pf("Pulando configurações do Github")
	end

	-- configuração do tema do sddm, fazendo glone do github para dentro de /usr/share/sddm/themes/

	return true
end

--- ============================================================================
--- EXPORTAÇÃO DO MÓDULO
--- ============================================================================

return desktopConfig
