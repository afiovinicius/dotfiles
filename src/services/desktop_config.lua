--- ============================================================================
--- AFIO ARCH - CONFIGURAÇÕES GLOBAIS
--- ============================================================================
--- Configurações gerais para o desktop conforme o ambiente selecionado
--- Terminal
--- ZSH
--- ZSH Plugins
--- Theme Terminal (starship)
--- GitHub
--- Packages Managers (uv, poetry, angular cli)
--- Docker
--- Wallpapers
--- System Sound
--- ============================================================================

local desktopConfig = {}
local aux = require("src.utils.aux")
local envs = require("src.core.envs")
local files = require("src.utils.files")

--- ============================================================================
--- EXPORTAÇÃO DO MÓDULO
--- ============================================================================

return desktopConfig