# 🌍 ValheimPlus Server (Docker)

This Dockerfile sets up a Valheim server with [ValheimPlus](https://github.com/valheimPlus/ValheimPlus). The server is based on Ubuntu 22.04 and uses SteamCMD to install the Valheim server.

## ⭐ Features
- Ubuntu 22.04 base image.
- SteamCMD installation for Valheim server.
- Valheim Plus mod installation and setup.
- Configurable server name, port, world name, and server password.
- Exposes ports 2456-2458/UDP.
- Volumes for persistence of configuration and world files.

## 🚀 Quickstart

1. **Build the Docker image**:
   ```bash
   docker build -t docker-valheim-plus:latest . 
   ```
2. **Run the Docker container** : Map the ports and volumes to your host system:
   ```bash
	docker run -d \
	-p 2456-2458:2456-2458/udp \
	-v /path/to/your/host/worlddata:/home/valheim/.config/unity3d/IronGate/Valheim \
	-v /path/to/your/host/configdata:/opt/valheim/BepInEx/config \
	--name=valheim-server docker-valheim-plus:latest
   ```
3. **Optional**: To modify the server settings like name, world name, etc., you can override the environment variables:
   ```bash
	docker run -d \
	-p 2456-2458:2456-2458/udp \
	-e SERVER_NAME="A.L.I.E" \
	-e WORLD_NAME="Etherea" \
	-v /path/to/your/host/worlddata:/home/valheim/.config/unity3d/IronGate/Valheim \
	-v /path/to/your/host/configdata:/opt/valheim/BepInEx/config \
	--name=valheim-server docker-valheim-plus:latest
   ```

## 📝 Configuration
- **SERVER_NAME**: The name of the Valheim server. Default: "Docker Valheim Server"
- **SERVER_PORT**: The port of the Valheim server. Default: 2456
- **WORLD_NAME**: The name of the Valheim world. Default: "Dedicated"
- **SERVER_PASSWORD**: The password for the Valheim server. Default: "Odin#0202"

### 📁 Volumes
- **World files**: Located at /home/valheim/.config/unity3d/IronGate/Valheim. You can map this to a local directory to persist your world data.

- **Valheim Plus Config files**: Located at /opt/valheim/BepInEx/config. You can map this to a local directory to persist your Valheim Plus configurations.


# 🤝Contributing
Im open to contributions! If you'd like to contribute, please create a pull request and I'll review it as soon as I can.