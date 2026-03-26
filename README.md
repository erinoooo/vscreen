# vscreen

**A real virtual display for headless Linux. Connect with any VNC client.**

vscreen tricks your headless Linux server into thinking a physical monitor is plugged in — then exposes that display over VNC so you can connect from anywhere with any VNC client.

No browser required. No relay servers. No accounts. Your VNC client talks directly to your machine.

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/erinoooo/vscreen/main/install.sh | sudo bash
```

That's it. One command installs everything, sets your VNC password, and you're ready to go.

---

## Start

```bash
sudo vscreen start
```

```
→ Starting virtual display...
→ Starting XFCE4 desktop...
→ Starting VNC server...

vscreen is running.

  Connect:  YOUR.SERVER.IP:5900

  Open any VNC client and connect to the address above.
  Use your VNC password when prompted.
```

---

## How it works

```
Xorg (dummy driver)
  └─ virtual display at DISPLAY=:1
  └─ spoofed EDID: Dell P2419H, 1920x1080@60Hz
  └─ kernel sees it as a real connected monitor

XFCE4 desktop session
  └─ full DE: taskbar, file manager, terminal, app menu

x11vnc
  └─ captures DISPLAY=:1
  └─ serves it over VNC on port 5900
  └─ password protected

Your VNC client → YOUR.IP:5900 → desktop
```

---

## Commands

```bash
sudo vscreen start                  # start display + VNC server
sudo vscreen stop                   # stop everything
sudo vscreen restart                # stop then start
sudo vscreen status                 # show services + connection info
sudo vscreen password               # set or change VNC password
sudo vscreen resolution 2560x1440   # change resolution
sudo vscreen port 5901              # change VNC port
sudo vscreen uninstall              # remove everything
```

---

## VNC clients

| Platform | Recommended |
|---|---|
| macOS | RealVNC Viewer — or Finder → Go → Connect to Server → `vnc://YOUR.IP` |
| Windows | RealVNC Viewer, TigerVNC Viewer |
| Linux | Remmina, TigerVNC, KRDC |
| iOS | RealVNC Viewer, Screens for iOS |
| Android | RealVNC Viewer |

---

## Requirements

- **Ubuntu 22.04 or 24.04**
- Port **5900** open inbound on your server's firewall

### Opening port 5900

| Provider | How |
|---|---|
| AWS | EC2 → Security Groups → Inbound rules → Add rule → TCP 5900 → 0.0.0.0/0 |
| GCP | VPC Network → Firewall → Create rule → tcp:5900 → 0.0.0.0/0 |
| Hetzner | Firewall → Add rule → TCP 5900 ingress |
| DigitalOcean | No firewall by default — just works |
| Linode/Akamai | Firewall → Add rule → TCP 5900 |

---

## Security

VNC is password protected out of the box. For stronger security, tunnel over SSH instead of opening port 5900 publicly:

```bash
ssh -L 5900:localhost:5900 user@your-server
```

Then connect your VNC client to `localhost:5900`. Port 5900 never needs to be open on the firewall.

---

## Why not Xvfb?

Xvfb is a fake framebuffer — the kernel knows it's fake. Apps can detect it and behave differently: reduced quality, disabled acceleration, "headless mode" throttling.

vscreen uses the `dummy` Xorg driver with a spoofed EDID that tells the system a real Dell monitor is connected. The kernel believes it. Apps believe it. Everything runs at full quality.

| | Xvfb | vscreen |
|---|---|---|
| Kernel sees it as | Fake framebuffer | Real connected monitor |
| EDID | None | Spoofed (Dell P2419H) |
| Apps detect headless | Sometimes | No |
| Setup | Manual | One command |

---

## License

MIT
