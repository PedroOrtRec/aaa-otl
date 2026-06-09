# Handoff - Flicker persistente Photon + Dynamic Lights (2026-06-09)

## Estado

El parpadeo/flashing del modelo del jugador al sostener fuentes de luz (antorcha/candil) persiste.

## Contexto

- Pack: An Awesome Adventure - Ode to Leonor
- MC: 1.21.1 + NeoForge
- Shader activo: Photon (`photon_v1.3b.zip`)
- Datapack: Dynamic Lights (`dynamiclights-v1.9.2-mc1.17-26.1.1-datapack.zip`)

## Cambios ya implementados

1. YOSBR Neo agregado para defaults de cliente.
2. Override de Photon en `config/yosbr/shaderpacks/photon_v1.3b.zip.txt`:
   - `HANDHELD_LIGHTING=false`
   - `HANDHELD_LIGHTING_INTENSITY=0.00`
3. Parche runtime de Photon para Prism:
   - Script `scripts/patch-photon-shader.ps1`
   - Fuerza `dynamicHandLight=false` dentro de `shaderpacks/photon_v1.3b.zip`.
4. Integracion del parche en bootstrap de Prism:
   - `scripts/prism-packwiz-bootstrap.ps1`
5. Validacion en preflight:
   - `scripts/prepare-prism-check.ps1`
   - Verifica `dynamicHandLight=false` en ZIP runtime.
6. Mitigacion cliente KubeJS:
   - `kubejs/client_scripts/main.js`
   - Auto-toggle de Dynamic Lights por jugador segun shaders activos.

## Evidencia verificada

- Logs muestran Iris + YOSBR cargando correctamente.
- Instancia Prism contiene `shaderpacks/photon_v1.3b.zip.txt`.
- Verificado en ZIP runtime: `dynamicHandLight    = false`.
- Preflight reporta `OK Photon runtime patch: dynamicHandLight=false`.

## Problema abierto

A pesar de lo anterior, el flicker sigue ocurriendo en juego.

## Hipotesis pendientes

1. El artefacto no proviene solo de handheld lighting, sino de interaccion con render del modelo del jugador (animaciones/entidades/translucencias) bajo shaders.
2. Existe otra ruta de iluminacion en Photon independiente de `HANDHELD_LIGHTING` y `dynamicHandLight`.
3. El datapack Dynamic Lights en modo tick/marker sigue generando transiciones de luz percibidas como flicker en primera/tercera persona.

## Proximo plan recomendado

1. Reproducir con matriz A/B minima:
   - A: Photon ON + Dynamic Lights ON + stack visual completo.
   - B: Photon ON + Dynamic Lights OFF (toggle solo jugador).
   - C: Photon OFF + Dynamic Lights ON.
   - D: Photon ON + Dynamic Lights ON + desactivar temporalmente Punchy/FWA/EMF/ETF.
2. Capturar evidencia en video corto con debug HUD y timestamps.
3. Revisar shaders de Photon para rutas adicionales en `gbuffers_hand`, `diffuse_lighting`, y cualquier include de hand/item light no controlado por los toggles ya parchados.
4. Si se confirma conflicto estructural sin fix limpio, introducir fallback oficial en pack:
   - politica por defecto: con shaders activos, Dynamic Lights del jugador desactivado de forma fija;
   - sin shaders, Dynamic Lights normal.

## Notas operativas

- No revertir scripts nuevos: forman parte del diagnostico y facilitan futuras pruebas.
- La instancia Prism ya quedo sincronizada con el estado de este repo en esta fecha.
