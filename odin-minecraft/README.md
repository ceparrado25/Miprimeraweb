# Minecraft Bedrock en Odin

En Odin (Linux con acceso a internet):

```bash
git clone https://github.com/ceparrado25/miprimeraweb.git
cd miprimeraweb && git checkout claude/minecraft-odin-install-stcuha
sudo ./odin-minecraft/install-bedrock.sh
```

El script instala Docker si falta, levanta el servidor (`itzg/minecraft-bedrock-server`)
en el puerto `19132/udp` y lo configura para arrancar con el sistema.
Los datos del mundo quedan en `/opt/minecraft-bedrock`.

Para jugar desde fuera de tu red, abre/redirige el puerto `19132/udp` en el router hacia Odin.
