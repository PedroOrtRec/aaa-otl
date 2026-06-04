# Performance Baseline Testing Spec

## Objetivo
Establecer configuraciones óptimas para cada mod de rendimiento mediante pruebas estructuradas en Prism Launcher, usando spark como herramienta de medición primaria.

## Stack de rendimiento instalado

| Mod | Rol | Config |
|-----|-----|--------|
| Sodium | Render engine | `config/sodium-options.json`, `sodium-mixins.properties` |
| Iris | Shader loader | `config/iris.properties` |
| Lithium | Game logic | `config/lithium.properties` |
| ModernFix | All-in-one perf+memory | `config/modernfix-common.toml`, `modernfix-mixins.properties` |
| FerriteCore | Reducción de memoria | `config/ferritecore-mixin.toml` |
| ImmediatelyFast | Batching UI/render | `config/immediatelyfast.json` |
| Entity Culling | Oclusión de entidades | `config/entityculling.json` |
| Distant Horizons | LOD lejano | `config/DistantHorizons.toml` |
| Krypton FNP | Optimización red | `config/krypton_fnp.yaml` |
| Noisium | Generación de mundo | _(sin config manual)_ |
| Clumps | Agrupación de XP | _(sin config manual)_ |
| spark | Profiler | `config/spark/` |

---

## Herramienta de medición: spark

Todos los perfiles se toman con spark. Comandos clave en chat/consola:

```
/spark profiler start        # inicia profiling CPU
/spark profiler stop         # detiene y genera URL del reporte
/spark health                # snapshot rápido de TPS, MSPT, memoria
/spark heapdump              # volcado de heap para análisis de memoria
/spark gc                    # estadísticas de garbage collection
```

Referencia de métricas objetivo:
- **TPS**: 20 (cliente no tiene TPS, pero integrado server sí)
- **MSPT** (servidor): < 50 ms en condiciones normales
- **Frame time** (cliente): < 16.7 ms → 60 fps mínimo sin shader; < 33 ms con shader
- **RAM** usada: < 4 GB en JVM con los mods actuales (sin DH cargado); < 5.5 GB con DH activo

---

## Entorno de prueba estándar

Antes de cada sesión de medición:
1. Ejecutar `scripts/prepare-prism-check.ps1` para verificar symlinks y bootstrap.
2. Usar un mundo de prueba dedicado (no el mundo del pack) con seed conocida.
3. Spawn point en zona plana o bioma simple (evitar zonas con muchas entidades para baseline limpio).
4. Render distance fija de **12 chunks** como valor de referencia base.
5. Cerrar aplicaciones que consuman GPU/CPU en segundo plano.
6. JVM args recomendados para Prism (en instance.cfg o lanzador):
   ```
   -Xms2G -Xmx6G -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions
   -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20
   -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M
   ```

---

## Escenarios de prueba

### Escenario A — Baseline sin shaders

**Objetivo**: FPS máximo puro con Sodium, sin Iris activo.

1. En `config/iris.properties` → `enableShaders=false`
2. Lanzar Prism, cargar mundo.
3. `F3` para ver FPS en esquina superior izquierda.
4. Girar 360° en zona abierta y anotar FPS mínimo/máximo.
5. `/spark profiler start` → caminar 2 minutos explorando → `/spark profiler stop`.
6. Registrar en tabla de resultados (ver sección final).

**Configs a validar (Sodium)**:
- `chunk_builder_threads`: 0 = automático (recomendado). Probar con 2 si hay micro-stutters.
- `always_defer_chunk_updates_v2`: true (mantener).
- `animate_only_visible_textures`: true (mantener).
- `use_entity_culling`: true — verificar que Entity Culling no haga doble trabajo.
- `cpu_render_ahead_limit`: 3 → probar reducir a 2 si hay input lag.

---

### Escenario B — Con shader Photon

**Objetivo**: Frame time estable con Photon v1.3b activo.

1. `config/iris.properties` → `enableShaders=true`, `shaderPack=photon_v1.3b.zip`.
2. `maxShadowRenderDistance`: actualmente 32. Probar 16 y 24 para comparar.
3. Mismo recorrido que Escenario A.
4. Anotar impacto de shadow distance en FPS.

**Configs a validar (Iris)**:
- `allowUnknownShaders=false` → mantener (seguridad).
- `colorSpace=SRGB` → mantener.
- Shadow render distance: **testear 16 / 24 / 32** y elegir el que mantenga > 45 fps.

---

### Escenario C — Distant Horizons (DH)

**Objetivo**: LOD distance óptima sin degradar FPS base.

1. Activar DH desde su menú in-game (tecla `Z` por defecto o menú de opciones).
2. Probar con LOD render distance: **64 / 128 / 256 chunks** (ajustar en menú DH).
3. DH CPU Load setting: probar **Low** para baseline, luego **Medium**.
4. Medir con `/spark health` tras 3 minutos de carga.

**Configs clave en `DistantHorizons.toml`**:
- `realTimeUpdateDistanceRadiusInChunks = 256` — puede reducirse a 128 si hay lag de red/servidor.
- `enableServerGeneration = true` — mantener (usa pregeneración del servidor).
- `playerBandwidthLimit = 500` KB/s — aumentar a 2000 en LAN/local, mantener para online.
- `enableAdaptiveTransferSpeed = false` → activar (`true`) para mayor estabilidad en variaciones de carga.

---

### Escenario D — Presión de entidades (Entity Culling)

**Objetivo**: verificar ganancia de Entity Culling en zonas densas.

1. Invocar ~50 mobs en un área pequeña (vanilla: `/summon` × 50).
2. Mirar directamente la zona vs de espaldas → comparar FPS.
3. En `config/entityculling.json`:
   - `tracingDistance`: 128 → probar 64 en hardware modesto.
   - `sleepDelay`: 10 ms → aumentar a 20 si hay CPU overhead visible en spark.
   - `captureRate`: 5 → no tocar sin razón.
   - `hitboxLimit`: 50 → suficiente para zonas densas típicas.

> Nota: `use_entity_culling` en Sodium debe mantenerse en `true` — trabaja en paralelo con Entity Culling mod, no en conflicto.

---

### Escenario E — Memoria y GC (FerriteCore + ModernFix)

**Objetivo**: confirmar reducción de memoria y ausencia de GC pauses.

1. `/spark gc` antes y después de cargar un chunk denso.
2. Abrir F3 y revisar `Used Memory` vs `Allocated Memory`.
3. Si GC pause > 200 ms, revisar JVM args (G1GC config).

**ModernFix** (`modernfix-mixins.properties`):
- Todos los mixins están en default. Si hay crash con un mod específico, deshabilitar el mixin afectado añadiendo línea: `mixin.perf.<nombre>=false`.
- `mixin.perf.dynamic_resources` — clave para carga diferida de texturas. Mantener activo.

**FerriteCore** (`ferritecore-mixin.toml`):
- Pocas opciones configurables. Si un mod presenta crash en startup, consultar si es conocido en el issue tracker de FerriteCore.

---

### Escenario F — ImmediatelyFast (batching UI)

**Objetivo**: verificar que el batching de UI no produce glitches.

1. Abrir inventario, mapa de Xaero, pantalla de crafting — revisar artefactos visuales.
2. Si hay glitches en texto o iconos → `fast_text_lookup: false`.
3. Si hay glitches en HUD → `hud_batching: false`.
4. `experimental_screen_batching` y `experimental_sign_text_buffering` → mantener `false` salvo prueba explícita.

---

## ImmediatelyFast + Sodium — interacción conocida

Estos dos mods comparten capas de render. Si aparecen artefactos:
1. Primero deshabilitar opciones experimentales de ImmediatelyFast.
2. Si persiste, deshabilitar `debug_only_and_not_recommended_disable_universal_batching: false` → cambiar a `true` como diagnóstico.
3. Reportar combinación problemática.

---

## Tabla de resultados baseline

Copiar y rellenar tras cada sesión:

```
| Escenario              | FPS min | FPS avg | RAM usada | spark MSPT | Notas            |
|------------------------|---------|---------|-----------|------------|------------------|
| A — Sin shader         |         |         |           |     N/A    |                  |
| B — Photon shadow=16   |         |         |           |     N/A    |                  |
| B — Photon shadow=24   |         |         |           |     N/A    |                  |
| B — Photon shadow=32   |         |         |           |     N/A    |                  |
| C — DH 64 chunks       |         |         |           |            |                  |
| C — DH 128 chunks      |         |         |           |            |                  |
| C — DH 256 chunks      |         |         |           |            |                  |
| D — Entity Culling ON  |         |         |           |            |                  |
| D — Entity Culling OFF |         |         |           |            |                  |
| E — GC baseline        |   N/A   |   N/A   |           |            | GC pauses: X ms  |
```

Los resultados numéricos se guardan en `reports/performance-baseline-<fecha>.md`.

---

## Post-testing — Aplicar configuración ganadora

Una vez identificados los valores óptimos:
1. Editar los archivos de config correspondientes en `config/`.
2. Ejecutar `scripts/prepare-prism-check.ps1` para verificar integridad.
3. Ejecutar `scripts/monitor-performance.ps1` para generar reporte de referencia.
4. Hacer commit con mensaje: `perf: apply performance baseline config <fecha>`.

---

## Orden de ejecución recomendado

```
A (sin shader, limpio)
  → B (añadir shader, comparar)
    → C (añadir DH, comparar)
      → D (stress entidades)
        → E (verificar memoria)
          → F (verificar UI glitches)
```

Cada escenario parte del anterior como base acumulativa.
