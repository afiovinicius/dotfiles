package = "dotfiles"
version = "1.0"
source = {
   url = "git+https://github.com/afiovinicius/dotfiles.git"
}
description = {
   summary = "Este é uma base de instalação simples e rápida do Arch Linux, acompanhado de ferramentas auxiliares para instalar e configurar uma interface gráfica, um conjunto abrangente de pacotes que cobre áreas como jogos, programação, design & 3D, IoT e a base para seu SO.",
   detailed = "Este é uma base de instalação simples e rápida do Arch Linux, acompanhado de ferramentas auxiliares para instalar e configurar uma interface gráfica, um conjunto abrangente de pacotes que cobre áreas como jogos, programação, design & 3D, IoT e a base para seu SO. Com esta abordagem, você pode realizar uma instalação rápida sem a necessidade de gastar muito tempo baixando ou configurando componentes iniciais com acesso rápido a uma variedade de ferramentas e recursos para facilitar o seu dia a dia.",
   homepage = "https://github.com/afiovinicius/dotfiles",
   license = "*** please specify a license ***"
}
dependencies = {
   queries = {}
}
build_dependencies = {
   queries = {}
}
build = {
   type = "builtin",
   modules = {
      ["core.envs"] = "src/core/envs.lua",
      ["core.packages"] = "src/core/packages.lua",
      ["interfaces.hyprland.hyprland"] = "src/interfaces/hyprland/hyprland.lua",
      ["interfaces.kde.kde"] = "src/interfaces/kde/kde.lua",
      main = "src/main.lua",
      ["services.desktop"] = "src/services/desktop.lua",
      ["services.ecosystem"] = "src/services/ecosystem.lua",
      ["services.system"] = "src/services/system.lua",
      ["utils.aux"] = "src/utils/aux.lua"
   },
   copy_directories = {
      "docs"
   }
}
test_dependencies = {
   queries = {}
}
