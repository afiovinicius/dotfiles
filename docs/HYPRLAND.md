# Afio Arch - Hyprland

A integração do Afio Arch é ser um serviço de desktop omakase baseada no [Arch](https://archlinux.org/) e que usa o [Hyprland](https://hypr.land/), entregando ferramentas, funcionalidades leves e produtivas, criadas com o [Quickshell](https://quickshell.org/), seguindo alguns principios do [Omarchy](https://omarchy.org/manual/getting-started/), é um workstation personalizado e com uma camada de integração.

---

## Princípios

- Fluido
- Responsivo
- Leve
- Coeso
- Discreto
- Keyboard-first
- Motion-driven
- GPU accelerated
- Zero configuração desnecessária

---

## Ferramentas

### Shell

- [ ] Top Bar
- [ ] Dock
- [ ] Launcher
- [ ] Search
- [ ] Command Palette
- [ ] Notifications
- [ ] Quick Settings
- [ ] Workspace Overview
- [ ] Clipboard
- [ ] Screenshot
- [ ] OSD
- [ ] Lock Screen
- [ ] Login Screen
- [ ] Window Management

### System Settings

- [ ] Appearance
- [ ] Display
- [ ] Audio
- [ ] Bluetooth
- [ ] Network
- [ ] Power
- [ ] Input
- [ ] Keyboard
- [ ] Mouse
- [ ] Color
- [ ] Printers
- [ ] Devices
- [ ] Security
- [ ] Phone

### Desktop Services

- [ ] Media
- [ ] Clipboard
- [ ] Thumbnailing
- [ ] File Actions
- [ ] Screenshot
- [ ] Camera
- [ ] Mobile
- [ ] System Monitoring

### Productivity Tools

- [ ] Color Tool
- [ ] Contrast
- [ ] Disk Analyzer
- [ ] Universal Preview
- [ ] System Monitor
- [ ] Snapshot Manager
- [ ] Mobile Debug
- [ ] Calendar
- [ ] Document Preview

---

## Camada de Integraçãoes

├── Bluetooth Center
├── Color Center
├── Display Center
├── Energy
├── Input
├── Audio
├── Network
├── Printers
├── Security
├── Mouse
├── Keyboard
├── Headphones
├── Phone
├── Media
├── Devices

---

## Modelos

Por baixo, cada serviço pode usar a tecnologia adequada.

```txt
Bluetooth Center
│
├── UI → QML
│
└── backend → BlueZ / D-Bus

Display:

Display Center
│
├── UI → QML
│
└── backend → Hyprland IPC / Wayland

Audio:

Audio Center
│
├── UI → QML
│
└── backend → PipeWire / WirePlumber

Power:

Power Center
│
├── UI → QML
│
└── backend → power-profiles-daemon / UPower
```

| Necessidade       | Afio cria? | Tecnologia             |
| ----------------- | :--------: | ---------------------- |
| Top Bar           |  **SIM**   | QML                    |
| Dock              |  **SIM**   | QML                    |
| Launcher          |  **SIM**   | QML                    |
| Search            |  **SIM**   | QML + backend          |
| Quick Settings    |  **SIM**   | QML                    |
| Notifications     |  **SIM**   | QML                    |
| OSD               |  **SIM**   | QML                    |
| Display Settings  |  **SIM**   | QML + Wayland/Hyprland |
| Audio UI          |  **SIM**   | QML + PipeWire         |
| Bluetooth UI      |  **SIM**   | QML + BlueZ            |
| Power UI          |  **SIM**   | QML + UPower/systemd   |
| Color Tools       |  **SIM**   | QML                    |
| Clipboard UI      |  **SIM**   | QML                    |
| System Monitor    |  **SIM**   | QML + system APIs      |
| Calendar mini UI  |  **SIM**   | QML                    |
| Mobile Center     |  **SIM**   | QML + ADB/etc.         |
| File Manager      |  **NÃO**   | Dolphin/Thunar/etc.    |
| Browser           |  **NÃO**   | Firefox/Brave          |
| Editor            |  **NÃO**   | VSCode/Zed             |
| Terminal          |  **NÃO**   | Ghostty                |
| 3D                |  **NÃO**   | Blender                |
| Image Editor      |  **NÃO**   | Krita/GIMP             |
| Video Editor      |  **NÃO**   | Kdenlive               |
| PDF               |  **NÃO**   | Okular                 |
| Archive Manager   |  **NÃO**   | Ark                    |
| Partition Manager |  **NÃO**   | existente              |
| Password Manager  |  **NÃO**   | backend existente      |
