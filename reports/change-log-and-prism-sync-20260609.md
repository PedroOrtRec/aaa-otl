# Cambios acumulados y sync de Prism (2026-06-09)

## Objetivo

Documentar el estado completo de cambios del workspace y dejar constancia de la sincronizacion de mods hacia la instancia de Prism para validacion manual en juego.

## Verificacion tecnica (Photon + Dynamic Lights)

La hipotesis es valida: Photon aplica iluminacion en mano por shader y el datapack Dynamic Lights aporta iluminacion dinamica por su cuenta. Si ambas quedan activas, puede aparecer doble aporte de luz y artefactos visuales (flicker/flashes) en el jugador al sostener fuentes de luz.

Diagnostico posterior: el flicker persistia porque la causa principal era `dynamicHandLight=true` dentro de `shaders/shaders.properties` de Photon (dentro del ZIP), valor que Iris no aplica desde `shaderpacks/photon_v1.3b.zip.txt`.

## Mejoras implementadas

1. Se agrego YOSBR Neo para sembrar defaults de opciones:
   - `mods/yosbr-neo.pw.toml`
2. Se agrego preset default para Photon via YOSBR:
   - `config/yosbr/shaderpacks/photon_v1.3b.zip.txt`
   - Valores forzados por defecto:
     - `HANDHELD_LIGHTING=false`
     - `HANDHELD_LIGHTING_INTENSITY=0.00`
3. Se agrego parche runtime de Photon para Prism:
   - `scripts/patch-photon-shader.ps1`
   - Fuerza `dynamicHandLight=false` dentro de `shaderpacks/photon_v1.3b.zip`.
4. Se integro el parche al flujo bootstrap de Prism:
   - `scripts/prism-packwiz-bootstrap.ps1`
5. Se agrego validacion en preflight:
   - `scripts/prepare-prism-check.ps1`
   - Verifica que `dynamicHandLight=false` este aplicado dentro del ZIP.
6. Se agrego automatizacion en KubeJS (cliente):
   - `kubejs/client_scripts/main.js`
   - Si Iris detecta shaders activos, ejecuta `trigger ts.dl.toggle` para desactivar Dynamic Lights solo para ese jugador.
   - Si shaders estan desactivados, vuelve a activar Dynamic Lights para ese jugador.
7. Se actualizo metadata packwiz:
   - `index.toml`
   - `pack.toml`
8. Se registro cambio funcional en changelog:
   - `CHANGELOG.md`

## Nota operativa corta (soporte)

YOSBR solo copia defaults cuando el archivo destino no existe.

Para instalaciones ya existentes que sigan con flicker:
1. Cerrar Minecraft/Prism.
2. Ejecutar `scripts/prism-packwiz-bootstrap.ps1` (ahora aplica tambien el parche del ZIP de Photon).
3. Abrir la instancia.
4. Verificar en Shader Pack Settings de Photon que Handheld Lighting este en OFF.
5. Esperar unos segundos tras entrar al mundo para que el script cliente sincronice `ts.dl.ignore` segun estado de shaders.

## Inventario de cambios actuales del workspace

Snapshot tomado con `git status --short`:

### Modificados
- `.github/.context/mod-list.md`
- `CHANGELOG.md`
- `config/bettercombat/client.json5`
- `config/bettercombat/fallback_compatibility.json`
- `config/bettercombat/server.json5`
- `config/bettercombat/weapon_trails.json`
- `config/entity_model_features.json`
- `config/entity_texture_features.json`
- `config/etf_warnings.json`
- `config/iris.properties`
- `config/parcool-client.toml`
- `config/punchy/merged_animation_selection.json`
- `config/sodium-options.json`
- `index.toml`
- `mods/keybind-atlas.pw.toml`
- `pack.toml`

### No rastreados
- `config/grapplemod-client.json`
- `config/grapplemod-common.json`
- `config/grapplemod-properties.json`
- `config/keybindatlas-client.toml`
- `config/resourcepackoverrides.json`
- `config/yosbr/`
- `mods/fa-player-extension-compat.pw.toml`
- `mods/parcool+-compatibility-addon-neoforge-edition.pw.toml`
- `mods/resource-pack-overrides.pw.toml`
- `mods/yosbr-neo.pw.toml`
- `resourcepacks/fa-player-extension-x-better-combat.pw.toml`

## Compilacion/sync de mods a Prism (ejecutado)

Scripts ejecutados:
1. `scripts/setup-prism-runtime.ps1`
2. `scripts/prism-packwiz-bootstrap.ps1`
3. `scripts/prepare-prism-check.ps1`

Resultado:
- Bootstrap completado con exito.
- Parche runtime de Photon aplicado: `dynamicHandLight=false` dentro del ZIP.
- Preflight de workflow y enlaces completado con estado OK.
- Conteo actual en mods de la instancia Prism: `35` archivos `.jar`.

## Checklist de comprobacion manual en juego

1. Abrir instancia `aaa-otl Desarrollo` en Prism.
2. Entrar a un mundo y equipar antorcha/candil en mano principal y secundaria.
3. Repetir prueba con shaders Photon ON y OFF.
4. Confirmar ausencia de parpadeo/flash del modelo del jugador con Photon ON.
5. Confirmar que con shaders OFF el datapack Dynamic Lights mantiene iluminacion dinamica.
