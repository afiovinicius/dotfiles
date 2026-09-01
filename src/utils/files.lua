--- ============================================================================
--- AFIO ARCH - FILESYSTEM UTILITIES
--- ============================================================================
--- Funções auxiliares para manipulação de arquivos e diretórios.
--- Responsável por validação de paths, leitura, backup, escrita e criação
--- segura de arquivos.
--- ============================================================================

local files = {}


--- ============================================================================
--- EXISTS
--- ============================================================================

--- Verifica se um path existe no sistema.
---
--- @param path string: Caminho do arquivo ou diretório
--- @return boolean: true se o path existir, false caso contrário
function files.exists(path)
  if type(path) ~= "string" or path == "" then
    return false
  end

  local result = os.execute('test -e "' .. path .. '" 2>/dev/null')

  return result == true or result == 0
end


--- ============================================================================
--- IS PATH
--- ============================================================================

--- Verifica se um path existe e corresponde ao tipo esperado.
---
--- Tipos disponíveis:
---   "file" = arquivo regular
---   "dir"  = diretório
---
--- A função não cria nem modifica o path.
--- Caso ele não exista, retorna false com a informação correspondente.
--- Caso exista com outro tipo, informa qual tipo foi encontrado.
---
--- @param path string: Caminho a ser verificado
--- @param type_path string: Tipo esperado ("file" ou "dir")
--- @return boolean, string|nil: Resultado da validação e mensagem de erro
function files.is_path(path, type_path)
  if type(path) ~= "string" or path == "" then
    return false, "Path inválido"
  end

  if type_path ~= "file" and type_path ~= "dir" then
    return false, 'Tipo inválido. Use "file" ou "dir"'
  end

  local is_file = os.execute('test -f "' .. path .. '" 2>/dev/null')

  if is_file == true or is_file == 0 then
    if type_path == "file" then
      return true, nil
    end

    return false, "O path existe, mas é um arquivo"
  end

  local is_dir = os.execute('test -d "' .. path .. '" 2>/dev/null')

  if is_dir == true or is_dir == 0 then
    if type_path == "dir" then
      return true, nil
    end

    return false, "O path existe, mas é um diretório"
  end

  return false, "O path não existe ou possui um tipo não suportado"
end


--- ============================================================================
--- READ
--- ============================================================================

--- Lê todo o conteúdo de um arquivo.
---
--- O path precisa existir e ser um arquivo regular.
---
--- @param path string: Caminho do arquivo a ser lido
--- @return string|nil, string|nil: Conteúdo do arquivo ou mensagem de erro
function files.read(path)
  local valid, message = files.is_path(path, "file")

  if not valid then
    return nil, message
  end

  local file, error_message = io.open(path, "r")

  if not file then
    return nil, "Não foi possível abrir o arquivo: " .. tostring(error_message)
  end

  local content = file:read("*a")

  file:close()

  if not content then
    return nil, "Não foi possível ler o arquivo: " .. path
  end

  return content, nil
end


--- ============================================================================
--- BACKUP
--- ============================================================================

--- Cria um backup de um arquivo existente.
---
--- O backup é criado no mesmo diretório utilizando o sufixo ".bak".
---
--- Exemplo:
---   /etc/fstab
---   /etc/fstab.bak
---
--- @param path string: Caminho do arquivo que será copiado
--- @param sudo boolean: true para executar a operação com sudo
--- @return boolean, string|nil: true em sucesso ou false e mensagem de erro
function files.backup(path, sudo)
  local valid, message = files.is_path(path, "file")

  if not valid then
    return false, message
  end

  local backup_path = path .. ".bak"

  local command = string.format(
    'cp "%s" "%s"',
    path,
    backup_path
  )

  if sudo == true then
    command = "sudo " .. command
  end

  local result = os.execute(command)

  if result == true or result == 0 then
    return true, nil
  end

  return false, "Não foi possível criar backup de: " .. path
end


--- ============================================================================
--- WRITE
--- ============================================================================

--- Escreve conteúdo em um arquivo existente.
---
--- Antes da alteração, cria automaticamente um backup do arquivo.
---
--- O arquivo precisa existir e ser um arquivo regular.
--- A escrita utiliza um arquivo temporário quando sudo=true para evitar
--- escrever diretamente em um arquivo protegido do sistema.
---
--- @param path string: Caminho do arquivo existente
--- @param content string: Novo conteúdo do arquivo
--- @param sudo boolean: true para executar a substituição com sudo
--- @return boolean, string|nil: true em sucesso ou false e mensagem de erro
function files.write(path, content, sudo)
  local valid, message = files.is_path(path, "file")

  if not valid then
    return false, message
  end

  if type(content) ~= "string" then
    return false, "O conteúdo precisa ser uma string"
  end

  local backup_success, backup_error = files.backup(path, sudo)

  if not backup_success then
    return false, "Falha ao criar backup: " .. backup_error
  end

  local temp_path = os.tmpname()

  local temp_file, temp_error = io.open(temp_path, "w")

  if not temp_file then
    return false, "Não foi possível criar arquivo temporário: " .. tostring(temp_error)
  end

  local write_success, write_error = temp_file:write(content)

  temp_file:close()

  if not write_success then
    os.remove(temp_path)

    return false, "Não foi possível escrever arquivo temporário: " .. tostring(write_error)
  end

  local command

  if sudo == true then
    command = string.format(
      'sudo mv "%s" "%s"',
      temp_path,
      path
    )
  else
    command = string.format(
      'mv "%s" "%s"',
      temp_path,
      path
    )
  end

  local result = os.execute(command)

  if result == true or result == 0 then
    return true, nil
  end

  os.remove(temp_path)

  return false, "Não foi possível substituir o arquivo: " .. path
end


--- ============================================================================
--- CREATE
--- ============================================================================

--- Cria um novo arquivo utilizando um arquivo temporário.
---
--- O diretório de destino é criado automaticamente caso não exista.
---
--- Fluxo:
---   1. Verifica se o destino já existe.
---   2. Identifica o diretório pai.
---   3. Cria o diretório caso necessário.
---   4. Cria o arquivo em /tmp.
---   5. Escreve o conteúdo.
---   6. Move o arquivo para o destino.
---
--- O destino não pode existir previamente.
---
--- @param path string: Caminho completo do novo arquivo
--- @param content string: Conteúdo do novo arquivo
--- @param sudo boolean: true para executar a operação final com sudo
--- @return boolean, string|nil: true em sucesso ou false e mensagem de erro
function files.create(path, content, sudo)
  if type(path) ~= "string" or path == "" then
    return false, "Path inválido"
  end

  if type(content) ~= "string" then
    return false, "O conteúdo precisa ser uma string"
  end

  if files.exists(path) then
    local is_file = os.execute('test -f "' .. path .. '" 2>/dev/null')

    if is_file == true or is_file == 0 then
      return false, "O arquivo já existe: " .. path
    end

    local is_dir = os.execute('test -d "' .. path .. '" 2>/dev/null')

    if is_dir == true or is_dir == 0 then
      return false, "O destino já existe e é um diretório: " .. path
    end

    return false, "O destino já existe: " .. path
  end

  local directory = path:match("^(.*)/[^/]+$")

  if not directory or directory == "" then
    directory = "."
  end

  local directory_exists = files.is_path(directory, "dir")

  if not directory_exists then
    local command = string.format(
      'mkdir -p "%s"',
      directory
    )

    if sudo == true then
      command = "sudo " .. command
    end

    local result = os.execute(command)

    if not (result == true or result == 0) then
      return false, "Não foi possível criar o diretório: " .. directory
    end
  end

  local temp_path = os.tmpname()

  local temp_file, temp_error = io.open(temp_path, "w")

  if not temp_file then
    return false, "Não foi possível criar arquivo temporário: " .. tostring(temp_error)
  end

  local write_success, write_error = temp_file:write(content)

  temp_file:close()

  if not write_success then
    os.remove(temp_path)

    return false, "Não foi possível escrever arquivo temporário: " .. tostring(write_error)
  end

  local command = string.format(
    'mv "%s" "%s"',
    temp_path,
    path
  )

  if sudo == true then
    command = "sudo " .. command
  end

  local result = os.execute(command)

  if result == true or result == 0 then
    return true, nil
  end

  os.remove(temp_path)

  return false, "Não foi possível mover o arquivo para: " .. path
end

--- ============================================================================
--- COPY DIRECTORY
--- ============================================================================

--- Copia um diretório recursivamente para o destino.
---
--- Remove o destino previamente caso ele já exista, garantindo uma
--- sobrescrita limpa (sem misturar arquivos antigos com novos).
---
--- @param src string: Caminho do diretório de origem
--- @param dest string: Caminho do diretório de destino
--- @param sudo boolean: true para executar as operações com sudo
--- @return boolean, string|nil: true em sucesso ou false e mensagem de erro
function files.copy_dir(src, dest, sudo)
  local valid_src, msg = files.is_path(src, "dir")

  if not valid_src then
    return false, "Diretório de origem inválido: " .. tostring(msg)
  end

  -- Se o destino já existe, remove para evitar arquivos fantasmas residuais
  if files.exists(dest) then
    local rm_cmd = string.format('rm -rf "%s"', dest)
    if sudo == true then rm_cmd = "sudo " .. rm_cmd end
    os.execute(rm_cmd)
  end

  -- Garante que o diretório pai (/.config) exista
  local parent_dest = dest:match("^(.*)/[^/]+$")
  if parent_dest then
    os.execute('mkdir -p "' .. parent_dest .. '"')
  end

  -- Realiza a cópia recursiva
  local cp_cmd = string.format('cp -r "%s" "%s"', src, dest)
  if sudo == true then cp_cmd = "sudo " .. cp_cmd end

  local result = os.execute(cp_cmd)

  if result == true or result == 0 then
    return true, nil
  end

  return false, "Não foi possível copiar o diretório para: " .. dest
end

--- ============================================================================
--- EXPORTAÇÃO
--- ============================================================================

return files
