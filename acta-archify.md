---
title: Acta de sesión – Instalación de Archify
date: 2026-11-08
tags: [acta, archify, claude-code, instalacion]
estado: completada
---

# Acta de sesión – Instalación de la skill Archify

## Resumen
Se instaló la skill **Archify v3.2.0** (Apache-2.0) de forma **global**, solo para el agente **claude-code**, siguiendo estrictamente `https://raw.githubusercontent.com/tt-a1i/archify/main/llms.txt`. No se generaron diagramas ni se escaneó ningún repositorio.

## Qué se instaló
- Skill: `archify` (1 skill, 203 archivos), fuente `https://archify.si`.
- Modo: `--global --copy --yes`, agente `claude-code` únicamente.
- Comando de instalación:
  `NODE_USE_ENV_PROXY=1 npx -y skills@latest add https://archify.si --skill archify --agent claude-code --global --copy --yes`
  (la variable de entorno solo afecta al proceso; el resto es idéntico al `llms.txt`).

## Dónde quedó
- `/root/.claude/skills/archify` (copia real, no enlace simbólico).
- Entorno: VM en la nube de Claude Code (host `vm`, usuario `root`, Node v22.23.4, npm 10.9.9). El "global" es el `~/.claude` de esa VM, que es efímera: se pierde al reciclarse el contenedor.

## Resultado de `doctor`
Comando: `node /root/.claude/skills/archify/bin/archify.mjs doctor` → salida `Archify is ready.`, exit 0.
- Todas las comprobaciones en `[ok]`: Node.js (≥18), plantilla base, renderizadores y runtimes (preview, visual-check, finalize, rutas, escritura atómica), validadores y los 10 tipos de diagrama (architecture, workflow, sequence, dataflow, lifecycle, erd, tree, class, timeline, waterfall), más explainer y sus assets.
- Ningún `[fail]` ni aviso.

## Conflictos y incidencias
1. **Bloqueo de red a `archify.si`** (proxy 403 en `CONNECT`). `npx ... --list` falló con `fetch failed`. Se detuvo el proceso según el `llms.txt`.
   - Resolución: el usuario aprobó añadir el host exacto `archify.si` a la lista de red permitida del entorno personal "Primer Entornos". Esto persiste para futuras sesiones de ese entorno.
2. **`fetch` de Node ignora el proxy** por defecto. Solución: `NODE_USE_ENV_PROXY=1` (documentado en el README del proxy; Node ≥ 22.21) solo en los comandos de `npx`.
3. **Destino sin conflictos**: `~/.claude/skills/archify` no existía; no había archivos no gestionados. No se usó ningún flag de fuerza.
4. **Detalle menor**: el resumen del instalador cita `~/.agents/skills/archify`, pero con `--copy` ese directorio no se creó; la copia efectiva está en `~/.claude/skills/archify`.
5. Aviso del instalador: revisar las skills antes de usarlas, porque corren con permisos completos del agente.
6. Falló la conexión de varios servidores MCP (`ERR_PROXY_TUNNEL`) y el de BigQuery pide autorización. No afectaron a la instalación.

## Cronología
- Lectura de `llms.txt` y presentación de comandos; confirmación del usuario.
- Verificación del entorno (solo lectura).
- Listado del paquete: fallo por red → host permitido → fallo de Node → `NODE_USE_ENV_PROXY=1` → 1 skill `archify` encontrada.
- Instalación y `doctor` correctos.

## Pendiente / siguientes pasos
- Si se necesita en el equipo propio (no solo en esta VM), repetir la instalación allí con los mismos comandos.
- Revisar el contenido de `SKILL.md` antes de usar la skill.

Relacionado: [[Archify]] · [[Claude Code]] · [[Skills]]
