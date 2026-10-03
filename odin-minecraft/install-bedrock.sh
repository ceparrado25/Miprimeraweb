#!/usr/bin/env bash
# Instala un servidor de Minecraft Bedrock en Odin usando Docker.
# Uso: sudo ./install-bedrock.sh [directorio_de_datos]
set -euo pipefail

DATA_DIR="${1:-/opt/minecraft-bedrock}"
IMAGE="itzg/minecraft-bedrock-server"
NAME="minecraft-bedrock"

if [ "$(id -u)" -ne 0 ]; then
  echo "Ejecuta con sudo/root." >&2
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker no esta instalado. Instalando..."
  curl -fsSL https://get.docker.com | sh
  systemctl enable --now docker
fi

mkdir -p "$DATA_DIR"

docker rm -f "$NAME" >/dev/null 2>&1 || true
docker run -d \
  --name "$NAME" \
  --restart unless-stopped \
  -e EULA=TRUE \
  -e SERVER_NAME="Odin Minecraft" \
  -e GAMEMODE=survival \
  -e DIFFICULTY=normal \
  -e MAX_PLAYERS=10 \
  -p 19132:19132/udp \
  -v "$DATA_DIR":/data \
  -it "$IMAGE"

if command -v ufw >/dev/null 2>&1 && ufw status | grep -q "Status: active"; then
  ufw allow 19132/udp
fi

echo
echo "Servidor Bedrock en marcha. Puerto: 19132/udp"
echo "Logs:      docker logs -f $NAME"
echo "Detener:   docker stop $NAME"
echo "Datos en:  $DATA_DIR"
