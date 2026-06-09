# Tectonic 3.0.22 - Referencia completa de configuracion

Este documento describe todas las caracteristicas configurables de Tectonic (version mod para NeoForge/Fabric), con enfoque en:

- Clave JSON real
- Que modifica en el mundo
- Rango del slider in-game (cuando aplica)
- Valor por defecto de Tectonic

Fuente de verdad usada:

- Config screen builder (lista de opciones y rangos)
- Modelo de estado y codecs (claves JSON y defaults)
- Wiki oficial de configuracion de Tectonic

## Archivo de configuracion

Tectonic carga su config en:

- config/tectonic.json

Estructura general esperada:

- general
- global_terrain
- continents
- islands
- oceans
- biomes
- caves
- experimental

Tambien existen metadatos en raiz:

- __notice
- minor_version

## Notas globales importantes

- La mayoria de campos usan fallback a default si no aparecen en JSON.
- Algunas opciones solo existen en la version mod (no datapack puro) y se marcan como MOD_ONLY en la UI.
- Cambios de worldgen solo se ven en chunks nuevos (no regeneran terreno ya generado).
- Claves de ruido usan patron comun: *_scale, *_multiplier, *_offset.

## 1) General

### mod_enabled

- Seccion/clave: general.mod_enabled
- Tipo: boolean
- Default: true
- Efecto: activa/desactiva Tectonic completo.
- UI: MOD_ONLY

### snow_start_offset

- Seccion/clave: general.snow_start_offset
- Tipo: int
- Rango UI: 0..256 (step 1)
- Default: 128
- Efecto: desplaza la altura a la que empieza la nieve en biomas frios.
- UI: MOD_ONLY

## 2) Global Terrain

### vertical_scale

- Seccion/clave: global_terrain.vertical_scale
- Tipo: double
- Rango UI: 0.75..15 (step 0.005)
- Default: 1.125
- Efecto: estira/comprime verticalmente el relieve sobre nivel del mar.
- Lectura rapida: mas alto = montanas mas altas y pendientes mas dramaticas.

### elevation_boost

- Seccion/clave: global_terrain.elevation_boost
- Tipo: double
- Rango UI: 0..1 (step 0.01)
- Default: 0
- Efecto: eleva el terreno de forma general (sesgo de elevacion).

### min_y

- Seccion/clave: global_terrain.min_y
- Tipo: int
- Rango UI: -2032..-64 (step 16)
- Default: -64
- Restricciones: multiplo de 16; no puede ser > 0.
- Efecto: cota minima del mundo.

### max_y

- Seccion/clave: global_terrain.max_y
- Tipo: int
- Rango UI: 256..2032 (step 16)
- Default: 320
- Restricciones: multiplo de 16; no puede ser < 256.
- Efecto: cota maxima de generacion/construccion.
- Nota: max_y > 320 equivale al antiguo "increased_height".

### ultrasmooth

- Seccion/clave: global_terrain.ultrasmooth
- Tipo: boolean
- Default: false
- Efecto: suaviza mucho el terrain para reducir escalonado (look v2), con posible generacion rara/rota en oceanos profundos y windswept.
- UI: ALL (overlay)

### lava_tunnels

- Seccion/clave: global_terrain.lava_tunnels
- Tipo: boolean
- Default: true
- Efecto: habilita tuneles de lava profundos.
- Nota: en la UI aparece en categoria Caves, pero el dato vive en global_terrain.

## 3) Continents

### ocean_offset

- Seccion/clave: continents.ocean_offset
- Tipo: double
- Rango UI: -2..0 (step 0.01)
- Default: -0.8
- Efecto: sesga el terreno hacia oceano o tierra.
- Lectura rapida: valor mas bajo = mas oceano.
- Umbrales documentados:
  - > -0.45: deep oceans dejan de spawnear
  - > -0.2: oceanos dejan de spawnear

### continents_scale

- Seccion/clave: continents.continents_scale
- Tipo: double
- Rango UI: 0.01..1 (step 0.01)
- Default: 0.13
- Efecto: escala horizontal de continentes.
- Lectura rapida: valor mas bajo = continentes/oceanos mas grandes (menos frecuencia).

### erosion_scale

- Seccion/clave: continents.erosion_scale
- Tipo: double
- Rango UI: 0.01..1 (step 0.01)
- Default: 0.25
- Efecto: escala horizontal de erosion (afecta grosor de cordilleras y transiciones).
- Lectura rapida: valor mas bajo = formas mas anchas.

### ridge_scale

- Seccion/clave: continents.ridge_scale
- Tipo: double
- Rango UI: 0.01..2 (step 0.01)
- Default: 0.25
- Efecto: escala horizontal del ruido ridge (rios y relieve alrededor).
- Lectura rapida: valor mas bajo = rios/estructuras mas anchas y espaciadas.

### underground_rivers

- Seccion/clave: continents.underground_rivers
- Tipo: boolean
- Default: true
- Efecto: rios continúan bajo montanas para navegacion continua.

### river_lanterns

- Seccion/clave: continents.river_lanterns
- Tipo: boolean
- Default: true
- Efecto: variantes raras de rios subterraneos con faroles colgantes.
- UI: MOD_ONLY

### river_ice

- Seccion/clave: continents.river_ice
- Tipo: boolean
- Default: false
- Efecto: comportamiento de hielo en rios subterraneos frios.
- UI: MOD_ONLY

### flat_terrain_skew

- Seccion/clave: continents.flat_terrain_skew
- Tipo: double
- Rango UI: -1..1 (step 0.01)
- Default: 0.1
- Efecto: umbral entre zonas de plateau y zonas planas.
- Lectura rapida: positivo favorece plano; negativo favorece plateau.

### rolling_hills

- Seccion/clave: continents.rolling_hills
- Tipo: boolean
- Default: true
- Efecto: habilita colinas suaves (especialmente en Plains).

### jungle_pillars

- Seccion/clave: continents.jungle_pillars
- Tipo: boolean
- Default: true
- Efecto: habilita pilares gigantes en algunas junglas.

## 4) Islands

### enabled

- Seccion/clave: islands.enabled
- Tipo: boolean
- Default: true
- Efecto: habilita islas oceanicas de estilo vanilla montanoso.
- Nota UI: el control aparece como islands_enabled.

### noise_scale

- Seccion/clave: islands.noise_scale
- Tipo: double
- Rango UI: 0..1 (step 0.01)
- Default: 0.11
- Efecto: escala horizontal del patron de islas.
- Lectura rapida: valor mas bajo = islas/oceanos mas grandes.

### noise_multiplier

- Seccion/clave: islands.noise_multiplier
- Tipo: double
- Rango UI: 0..5 (step 0.1)
- Default: 1.0
- Efecto: multiplica intensidad del patron de islas.
- Lectura rapida: mas alto = mas presencia de islas.

### noise_offset

- Seccion/clave: islands.noise_offset
- Tipo: double
- Rango UI: -1..1 (step 0.01)
- Default: 0.0
- Efecto: sesgo del ruido de islas.
- Lectura rapida: desplaza balance entre tipos/frecuencia de isla.

## 5) Oceans

### ocean_depth

- Seccion/clave: oceans.ocean_depth
- Tipo: double
- Rango UI: -10..-0.05 (step 0.01)
- Default: -0.22
- Efecto: profundidad base de oceano (0 = nivel del mar, -0.5 ~ 64 bloques bajo mar).

### deep_ocean_depth

- Seccion/clave: oceans.deep_ocean_depth
- Tipo: double
- Rango UI: -10..-0.05 (step 0.01)
- Default: -0.45
- Efecto: profundidad de deep oceans.

### monument_offset

- Seccion/clave: oceans.monument_offset
- Tipo: int
- Rango UI: -60..0 (step 1)
- Default: -30
- Efecto: desplaza Ocean Monuments para alinearlos con oceanos mas profundos.
- UI: MOD_ONLY

### remove_frozen_ocean_ice

- Seccion/clave: oceans.remove_frozen_ocean_ice
- Tipo: boolean
- Default: false
- Efecto: quita hielo superficial en Frozen Ocean para navegacion.
- UI: MOD_ONLY

## 6) Biomes (ruido climatico)

Defaults de ruido (NoiseState.DEFAULT):

- scale: 0.25
- multiplier: 1.0
- offset: 0.0

### temperature_scale

- Seccion/clave: biomes.temperature_scale
- Tipo: double
- Rango UI: 0..1 (step 0.01)
- Default: 0.25
- Efecto: escala horizontal del ruido termico.
- Lectura rapida: valor mas bajo = distancias mas grandes entre biomas frios/calidos.

### temperature_multiplier

- Seccion/clave: biomes.temperature_multiplier
- Tipo: double
- Rango UI: 0..5 (step 0.1)
- Default: 1.0
- Efecto: aumenta/disminuye extremos termicos (mas nieve/desierto en extremos altos).

### temperature_offset

- Seccion/clave: biomes.temperature_offset
- Tipo: double
- Rango UI: -1..1 (step 0.01)
- Default: 0.0
- Efecto: sesgo global de temperatura.
- Lectura rapida: positivo favorece calido; negativo favorece frio.

### vegetation_scale

- Seccion/clave: biomes.vegetation_scale
- Tipo: double
- Rango UI: 0..1 (step 0.01)
- Default: 0.25
- Efecto: escala horizontal del ruido de humedad/vegetacion.
- Lectura rapida: valor mas bajo = transiciones seco-humedo mas espaciadas.

### vegetation_multiplier

- Seccion/clave: biomes.vegetation_multiplier
- Tipo: double
- Rango UI: 0..5 (step 0.1)
- Default: 1.0
- Efecto: intensifica extremos de humedad (mas biomas muy secos o muy humedos).

### vegetation_offset

- Seccion/clave: biomes.vegetation_offset
- Tipo: double
- Rango UI: -1..1 (step 0.01)
- Default: 0.0
- Efecto: sesgo global de humedad.
- Lectura rapida: positivo favorece vegetacion densa; negativo favorece vegetacion escasa.

## 7) Caves

### depth_cutoff_start

- Seccion/clave: caves.depth_cutoff_start
- Tipo: double
- Rango UI: -0.1..1 (step 0.1)
- Default: 0.1
- Efecto: valor de profundidad a partir del cual las cuevas empiezan a cerrarse.

### depth_cutoff_size

- Seccion/clave: caves.depth_cutoff_size
- Tipo: double
- Rango UI: 0..1 (step 0.1)
- Default: 0.1
- Efecto: grosor de la transicion entre cuevas abiertas y cerradas.

### cheese_enabled

- Seccion/clave: caves.cheese_enabled
- Tipo: boolean
- Default: true
- Efecto: habilita cuevas tipo cheese (grandes cavidades).

### cheese_additive

- Seccion/clave: caves.cheese_additive
- Tipo: double
- Rango UI: -0.5..0.5 (step 0.01)
- Default: 0.27
- Efecto: densidad aditiva de cheese caves.
- Lectura rapida: menor valor = cavidades mas grandes.

### noodle_enabled

- Seccion/clave: caves.noodle_enabled
- Tipo: boolean
- Default: true
- Efecto: habilita cuevas tipo noodle (estrechas y largas).

### noodle_additive

- Seccion/clave: caves.noodle_additive
- Tipo: double
- Rango UI: -0.25..0.25 (step 0.025)
- Default: -0.075
- Efecto: densidad aditiva de noodle caves.
- Lectura rapida: menor valor = noodle caves mas grandes.

### spaghetti_enabled

- Seccion/clave: caves.spaghetti_enabled
- Tipo: boolean
- Default: true
- Efecto: habilita cuevas tipo spaghetti (tuneles medianos).

### carvers_enabled

- Seccion/clave: caves.carvers_enabled
- Tipo: boolean
- Default: true
- Efecto: habilita carvers "clasicos" (caves/ravines vanilla).

### ore_fix

- Seccion/clave: caves.ore_fix
- Tipo: boolean
- Default: false
- Efecto: toggle tecnico para ajuste de ores en ciertos escenarios.
- UI: MOD_ONLY

## 8) Experimental

### alternate_erosion_scaling

- Seccion/clave: experimental.alternate_erosion_scaling
- Tipo: boolean
- Default: false
- Efecto: activa formula alternativa de escalado para erosion.
- UI: MOD_ONLY

### alternate_continents_scaling

- Seccion/clave: experimental.alternate_continents_scaling
- Tipo: boolean
- Default: false
- Efecto: activa formula alternativa de escalado para continentes.
- UI: MOD_ONLY

## Recomendaciones operativas para tuning

- Ajusta 1-3 parametros por iteracion y prueba en chunks nuevos.
- Si el objetivo es macrogeografia (continentes/oceanos), prioriza:
  - continents_scale
  - ocean_offset
  - ridge_scale
  - erosion_scale
- Si el objetivo es biomas mas "mezclados" o mas "continentales", prioriza:
  - temperature_scale y vegetation_scale
  - luego multiplier/offset para sesgos climaticos
- Si usas ultrasmooth, valida oceanos profundos y biomas windswept porque pueden aparecer artefactos.

## Lista rapida de todas las claves jugables

general:

- mod_enabled
- snow_start_offset

global_terrain:

- vertical_scale
- elevation_boost
- min_y
- max_y
- ultrasmooth
- lava_tunnels

continents:

- ocean_offset
- continents_scale
- erosion_scale
- ridge_scale
- underground_rivers
- river_lanterns
- river_ice
- flat_terrain_skew
- rolling_hills
- jungle_pillars

islands:

- enabled
- noise_scale
- noise_multiplier
- noise_offset

oceans:

- ocean_depth
- deep_ocean_depth
- monument_offset
- remove_frozen_ocean_ice

biomes:

- temperature_scale
- temperature_multiplier
- temperature_offset
- vegetation_scale
- vegetation_multiplier
- vegetation_offset

caves:

- depth_cutoff_start
- depth_cutoff_size
- cheese_enabled
- cheese_additive
- noodle_enabled
- noodle_additive
- spaghetti_enabled
- carvers_enabled
- ore_fix

experimental:

- alternate_erosion_scaling
- alternate_continents_scaling
