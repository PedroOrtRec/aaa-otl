# Natural Temperature - Variables configurables (NeoForge 1.21.1)

Fecha: 2026-06-09
Mod: Natural Temperature
Versión instalada: 1.1.6 (Modrinth version id: 55RGZNUQ)

## Ubicación esperada del archivo de configuración

- `config/naturaltemperature-common.toml`

Nota: el mod registra config de tipo `COMMON` con `modid = naturaltemperature`, por lo que NeoForge normalmente crea el archivo con ese patrón.

## Escala de modos de generación

- `0`: DEFAULT
- `1`: SIMPLIFIED
- `2`: LINEAR
- `3`: CUSTOM CIRCULAR
- `4`: CIRCULAR
- `5` y `6`: modos adicionales soportados por el código actual (aparecen en el rango permitido del parámetro)

## Variables configurables

### Núcleo de distribución térmica

1. `equatorial_distance`
- Tipo: `double`
- Default: `50000.0`
- Rango: `0.0` a `6.0E12`
- Explicación: distancia base (en bloques) usada para definir la separación entre polos y ecuador. A mayor valor, bandas climáticas más grandes.

2. `looping_world`
- Tipo: `boolean`
- Default: `false`
- Explicación: si está en `true`, el patrón climático se repite tras las zonas muy frías hasta el borde del mundo.

3. `generation_mode`
- Tipo: `int`
- Default: `0`
- Rango: `0` a `6`
- Explicación: selecciona el algoritmo de distribución de temperaturas/biomas por bandas.

4. `equator_offset`
- Tipo: `double`
- Default: `0.0`
- Rango: `-6.0E12` a `6.0E12`
- Explicación: desplaza el ecuador hacia norte/sur. Valores positivos mueven el ecuador al norte.

5. `randomize_underground`
- Tipo: `boolean`
- Default: `false`
- Explicación: ignora el patrón de superficie en biomas subterráneos, útil con mods que generan underground biomes.

6. `randomize_underground_below_y`
- Tipo: `double`
- Default: `45.0`
- Rango: `-6.0E12` a `6.0E12`
- Explicación: cota Y a partir de la cual se aplica la aleatorización subterránea.

7. `underground_randomization_type`
- Tipo: `int`
- Default: `1`
- Rango: `0` a `2`
- Explicación:
  - `0`: random total (excepto bajo junglas)
  - `1`: half_random (mezcla aleatorio + similitud con superficie)
  - `2`: random_plus_jungle (aleatorio total incluyendo junglas)

8. `multidimensional_bands`
- Tipo: `boolean`
- Default: `false`
- Explicación: activa la lógica de bandas también en otras dimensiones.

9. `global_temperature_modifier_percentage`
- Tipo: `double`
- Default: `0.0`
- Rango: `-100.0` a `100.0`
- Explicación: calienta o enfría globalmente el planeta en porcentaje.

10. `global_temperature_mitigation_percentage`
- Tipo: `double`
- Default: `0.0`
- Rango: `0.0` a `100.0`
- Explicación: reduce extremos climáticos (mitiga contrastes entre zonas muy calientes/frías).

11. `extra_bands`
- Tipo: `boolean`
- Default: `false`
- Explicación: agrega una transición más amplia entre desierto y jungla en modo default, útil para mejorar spawn de algunos biomas modded.

12. `wave_magnification`
- Tipo: `double`
- Default: `2.0`
- Rango: `-6.0E12` a `6.0E12`
- Explicación: escala la amplitud espacial del ondulado de bandas (magnifica la forma de onda climática).

### Temperatura por zonas (modos personalizados)

13. `temperature_zone_1`
- Tipo: `double`
- Default: `0.0`
- Rango: `-1.0` a `8.0`
- Explicación: valor térmico de la zona 1. `1.0` muy caliente, `-1.0` muy fría, `8.0` randomiza la zona.

14. `temperature_zone_2`
- Tipo: `double`
- Default: `8.0`
- Rango: `-1.0` a `8.0`
- Explicación: valor térmico de la zona 2.

15. `temperature_zone_3`
- Tipo: `double`
- Default: `1.0`
- Rango: `-1.0` a `8.0`
- Explicación: valor térmico de la zona 3.

16. `temperature_zone_4`
- Tipo: `double`
- Default: `-1.0`
- Rango: `-1.0` a `8.0`
- Explicación: valor térmico de la zona 4.

17. `temperature_zone_5`
- Tipo: `double`
- Default: `8.0`
- Rango: `-1.0` a `8.0`
- Explicación: valor térmico de la zona 5.

18. `temperature_zone_6`
- Tipo: `double`
- Default: `-1.0`
- Rango: `-1.0` a `8.0`
- Explicación: valor térmico de la zona 6.

### Humedad por zonas

19. `humidity_zone_1`
- Tipo: `double`
- Default: `8.0`
- Rango: `-1.0` a `8.0`
- Explicación: humedad de zona 1. `1.0` muy húmeda, `-1.0` muy seca, `8.0` randomiza la zona.

20. `humidity_zone_2`
- Tipo: `double`
- Default: `8.0`
- Rango: `-1.0` a `8.0`
- Explicación: humedad de zona 2.

21. `humidity_zone_3`
- Tipo: `double`
- Default: `8.0`
- Rango: `-1.0` a `8.0`
- Explicación: humedad de zona 3.

22. `humidity_zone_4`
- Tipo: `double`
- Default: `8.0`
- Rango: `-1.0` a `8.0`
- Explicación: humedad de zona 4.

23. `humidity_zone_5`
- Tipo: `double`
- Default: `8.0`
- Rango: `-1.0` a `8.0`
- Explicación: humedad de zona 5.

24. `humidity_zone_6`
- Tipo: `double`
- Default: `8.0`
- Rango: `-1.0` a `8.0`
- Explicación: humedad de zona 6.

25. `info_humidity_offset`
- Tipo: `double`
- Default: `0.0`
- Rango: `-6.0E12` a `6.0E12`
- Explicación: desplaza longitudinalmente (este/oeste) las bandas de humedad. Positivo mueve al oeste, negativo al este.

### Cobertura porcentual por zona (modos banded)

26. `percentage_coverage_zone_1`
- Tipo: `double`
- Default: `17.0`
- Rango: `1.0` a `100.0`
- Explicación: porcentaje relativo de cobertura para zona 1.

27. `percentage_coverage_zone_2`
- Tipo: `double`
- Default: `24.0`
- Rango: `1.0` a `100.0`
- Explicación: porcentaje relativo de cobertura para zona 2.

28. `percentage_coverage_zone_3`
- Tipo: `double`
- Default: `13.0`
- Rango: `1.0` a `100.0`
- Explicación: porcentaje relativo de cobertura para zona 3.

29. `percentage_coverage_zone_4`
- Tipo: `double`
- Default: `10.0`
- Rango: `1.0` a `100.0`
- Explicación: porcentaje relativo de cobertura para zona 4.

30. `percentage_coverage_zone_5`
- Tipo: `double`
- Default: `22.0`
- Rango: `1.0` a `100.0`
- Explicación: porcentaje relativo de cobertura para zona 5.

31. `percentage_coverage_zone_6`
- Tipo: `double`
- Default: `14.0`
- Rango: `1.0` a `100.0`
- Explicación: porcentaje relativo de cobertura para zona 6.

### Bandas de humedad adicionales

32. `enable_humidity_bands`
- Tipo: `boolean`
- Default: `false`
- Explicación: activa bandas de humedad/vegetación perpendiculares a las de temperatura (en modos simplified y linear).

33. `humidity_bands_width`
- Tipo: `double`
- Default: `1000.0`
- Rango: `-6.0E12` a `6.0E12`
- Explicación: ancho base de bandas de humedad; internamente representa un cuarto de la distancia entre picos de humedad.

### Modos personalizados por ID

34. `custom_mode_id_1`
- Tipo: `string`
- Default: `default`
- Explicación: ID del modo custom para usar cuando el modo seleccionado corresponde al slot 1 custom.

35. `custom_mode_id_2`
- Tipo: `string`
- Default: `default`
- Explicación: ID del modo custom para slot 2.

36. `custom_mode_id_3`
- Tipo: `string`
- Default: `default`
- Explicación: ID del modo custom para slot 3.

37. `custom_mode_id_4`
- Tipo: `string`
- Default: `default`
- Explicación: ID del modo custom para slot 4.

38. `custom_mode_id_5`
- Tipo: `string`
- Default: `default`
- Explicación: ID del modo custom para slot 5.

### Interfaz y mezcla final

39. `show_gui_button`
- Tipo: `boolean`
- Default: `true`
- Explicación: muestra/oculta el botón de configuración del mod en el menú principal.

40. `natural_temperature_influence`
- Tipo: `double`
- Default: `100.0`
- Rango: `0.0` a `100.0`
- Explicación: cuánto influye el cálculo de temperatura natural en la generación final. El autor sugiere no bajarlo mucho (referencia: >80% para resultados estables).

## Observaciones importantes

- En el código, `generation_mode` está limitado a `0..6`, pero los comentarios de `custom_mode_id_*` mencionan modos `101..105`. Esto parece inconsistente en esta versión y conviene validar en juego antes de usar esos IDs.
- El mod está marcado como `side = "server"` en metadata de packwiz, por lo que impacta principalmente worldgen y debe sincronizarse también en entorno server.

## Fuente técnica usada

- Variables y defaults extraídos de la clase `com.naturaltemperature.Config` de `naturaltemperature-1.1.6-NEOFORGE-MC-1.21.1.jar` mediante inspección de bytecode (`javap -c -verbose`).