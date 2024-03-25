Script de instalação customizada para Arch Linux
===
### Estrutura
```
|—— .gitignore
|—— files
|    |—— .zshrc
|    |—— assets
|        |—— icon-menu.png
|        |—— set-wallpaper.sh
|        |—— wallpapers
|            |—— bg-01.jpg
|            |—— bg-02.jpg
|            |—— bg-03.jpg
|            |—— bg-04.jpg
|            |—— bg-05.jpg
|            |—— bg-06.jpg
|            |—— bg-07.jpg
|            |—— bg-08.jpg
|            |—— bg-09.jpg
|            |—— bg-10.jpg
|            |—— bg-11.jpg
|            |—— bg-12.jpg
|            |—— bg-13.jpg
|            |—— bg-14.jpg
|            |—— bg-15.jpg
|    |—— kde
|        |—— install.sh
|    |—— xfce
|        |—— install.sh
|—— setup.sh
|—— utils
```
## Guia de Instalação
### Configuração do Teclado

1. Lista os layouts disponíveis para vocês escolher qual se adequa ao seu teclado:
  ```bash
  localectl list-keymaps
  ```
2. Carregue a configuração para o teclado (exemplo para ABNT2):
  ```bash
  loadkeys br-abnt2
  ```
### Configuração de Região e Idioma (Opcional)

1. Abra o arquivo de configuração de localidades para edição:
```bash
nano /etc/locale.gen
```
    > Remova o “#” na frente da linha do idioma da sua escolha por exemplo: #pt_BR.UTF-8 UTF-8 > pt_BR.UTF-8 UTF-8 . Após isso use os atalhos CTRL+O e aperte ENTER depois CTRL+X e aperte ENTER.
    > 
2. Gera as localidade definida no arquivo /etc/locale.gen:
    
    ```bash
    locale-gen
    ```
    
3. Define o idioma padrão do sistema (exemplo para pt-br):
    
    ```bash
    export LANG=pt_BR.UTF-8
    ```
    

### **Atualizar o relógio do sistema**

1. Ativa a sincronização automática de hora e data pela rede utilizando NTP (Network Time Protocol).
    
    ```bash
    timedatectl set-ntp true
    ```
    
2. Verificando mudança na configuração de hora e data:
    
    ```bash
    timedatectl status
    ```
    

### Modo de inicialização

1. Verifica se o sistema utiliza UEFI (mais moderno), o que é importante para alguns ajustes posteriores.
    
    ```bash
    ls /sys/firmware/efi/efivars
    ```
    
2. Verifique o número de bits do UEFI:
    
    ```bash
    cat /sys/firmware/efi/fw_platform_size
    ```
    

### **Configuração de Rede sem Fio**

> Para instalar o Arch Linux precisa ter conexão via Wi-Fi ou Ethernet. Siga as instruções abaixo para caso queira usar internet sem fio.
> 
1. Liste as interfaces de rede disponíveis no sistema:
    
    ```bash
    ip link
    ```
    
2. Ativa a interface de rede especificada (por exemplo, `ip link set wlan0 up` para ativar a rede sem fio):
    
    ```bash
    sudo rfkill unblock wifi && ip link set {interface} up
    ```
    
    > Aqui estamos desbloqueando a placa de rede e ativando ela… Não esqueça de trocar “{interface}” pela sua placa de rede.
    > 
3. Inicie a ferramenta de configuração de rede sem fio:
    
    ```bash
    iwctl
    ```
    
4. Liste os dispositivos de rede sem fio disponíveis:
    
    ```bash
    device list
    ```
    
5. Faz uma busca por redes sem fio disponíveis na interface escolhida (por exemplo, `station wlan0 scan`  para busca na rede sem fio):
    
    ```bash
    station {interface} scan
    ```
    
6. Mostra as redes da busca anterior:
    
    ```bash
    station {interface} get-networks
    ```
    
7. Conecta à rede sem fio especificada pelo SSID:
    
    ```bash
    station {interface} connect SSID
    ```
    
    > Vai abrir um campo no console para preencher com a senha da rede.
    > 
8. Mostra detalhes da conexão atual na interface:
    
    ```bash
    station {interface} show
    ```
    
9. Saia do iwctl:
    
    ```bash
    exit
    ```
    
    Em seguida teste a rede:
    
    ```bash
    
    ping -c 5 vicit.studio
    ```
    

### Instalação

1. O arch linux tem um script de instalação intuitivo ([https://archinstall.archlinux.page/](https://archinstall.archlinux.page/)):
    
    ```bash
    archinstall
    ```
    
    ![arch](https://www.edivaldobrito.com.br/wp-content/uploads/2023/03/archinstall-2-5-4-lancado-com-novos-recursos-e-varias-melhorias.webp)
    
    > No perfil escolha o tipo **MINIMAL.**
    > 

###