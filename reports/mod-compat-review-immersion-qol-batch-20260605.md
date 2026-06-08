# Reporte de compatibilidad/idoneidad (batch)

Fecha: 2026-06-05  
Pack objetivo: Minecraft 1.21.1 + NeoForge 21.1.233

Fuente principal de metadata: Modrinth API (consulta por nombre + validacion NeoForge 1.21.1).  
Nota: algunos nombres estaban ambiguos o con typo; cuando fue necesario se normalizo al proyecto mas probable.

## 1) Compatibilidad e idoneidad por candidato

Leyenda compatibilidad:
- Alta: tiene version NeoForge 1.21.1 clara.
- Media: tiene build, pero requiere pruebas por solapamiento o posible impacto.
- Baja: match ambiguo o soporte incierto.
- Nula: sin evidencia de build NeoForge 1.21.1 para el candidato esperado.

| Mod solicitado | Proyecto evaluado | Compatibilidad | Idoneidad | Comentario corto |
|---|---|---|---|---|
| Grappling Hook: Skybound | Grappling Hook Mod: Skybound | Alta | probable | Compatible; requiere test con mods de movimiento/camara. |
| Punchy | Punchy! | Alta | incluido | Cliente-only y sin dependencias graves; requiere ajuste fino con camara/NEA si hubiera overlap visual. |
| Fresh Animations | Fresh Animations (resourcepack) | Alta | incluido | Permitido en modpacks segun sus terminos; activado con pipeline EMF/ETF y fuente oficial Modrinth. |
| Fresh Animations Extensions | Fresh Animations: Extensions (resourcepack) | Alta | incluido | Extension oficial de Fresh Animations; riesgo bajo dentro del mismo stack visual. |
| Fresh Animations Player Extensions | Fresh Animations: Player Extension (resourcepack) | Alta | incluido | Extension oficial para animacion de jugadores; requiere validacion visual con skins/capas. |
| Parcool! | ParCool! | Alta | probable | Mecanicas de movilidad; puede alterar balance de exploracion. |
| Better Combat | Better Combat | Alta | probable | Muy popular y estable; validar balance PVE y compat con armas futuras. |
| Apple Skin | AppleSkin | Alta | incluir | QoL de hambre/saturacion, bajo riesgo y alto valor UX. |
| Better Advancements | Better Advancements | Alta | incluir | QoL puro de interfaz de avances. |
| Mouse Tweaks | Mouse Tweaks | Alta | incluir | QoL inventario muy estable y esperado por jugadores. |
| JEI | Just Enough Items (JEI) | Alta | incluir | Basico de modpacks para recetas/uso de items. |
| Jade | Jade | Alta | incluir | HUD contextual; complementa JEI sin solapamiento fuerte. |
| Real Camera | Real Camera | Alta | probable | Inmersion alta; revisar conflicto con BTP/Punchy/NEA. |
| Not enough animations | Not Enough Animations | Alta | probable | Muy buen acabado visual; revisar stack de animaciones/camara. |
| Better Third Person | Better Third Person | Alta | probable | Camara mejorada; coordinar con Real Camera para evitar redundancia. |
| Entity Model Features | [EMF] Entity Model Features | Alta | incluido | Clave para packs visuales tipo OptiFine; habilitado para compatibilidad con Fresh Animations. |
| Entity Texture Features | [ETF] Entity Texture Features | Alta | incluido | Complemento de EMF; habilitado para compatibilidad con Fresh Animations. |
| Sit | Sit | Alta | probable | Utilidad social simple; solapa parcialmente con Personality. |
| Personality | Personality | Alta | probable | Gamefeel/social interesante; revisar overlap con Sit y animaciones. |
| Soul fire'd | Soul Fire'd | Alta | probable | Efectos/mecanicas de fuego; revisar overlap con Dyed Fire/Burnt. |
| Dyed Fire | Dyed Flames | Alta | probable | Variantes visuales de fuego; potencial solapamiento funcional. |
| Cave dust | Cave Dust | Nula | No Incluir | Sin build NeoForge 1.21.1 detectada para el proyecto esperado. |
| Amendments | Amendments | Alta | incluir | Muy buen mod de mejoras vanilla; estable y de alto valor. |
| Visuality | Visuality: Reforged | Alta | probable | Aporta particulas; vigilar acumulacion de mods visuales. |
| Diagonal fences | Diagonal Fences | Alta | incluir | Mejora estetica/construccion de bajo riesgo tecnico. |
| Bushier flowers | Bushier Flowers | Nula | No Incluir | Sin build NeoForge 1.21.1 clara en consulta. |
| Visual Workbench | Visual Workbench | Alta | incluir | QoL visual de crafteo, multiplayer-friendly. |
| Villager Names | Villager Names | Alta | probable | Inmersion social; impacto tecnico bajo. |
| Ambients sounds 6 | Ambient Sounds 6 | Baja | No Incluir | No aparecio resultado NeoForge 1.21.1 en Modrinth (posible distribucion CF). |
| Presence Footsteps | Presence Footsteps (NeoForge) | Alta | probable | Inmersion sonora fuerte; revisar junto a Sound Physics. |
| Sound Physics remastered | Sound Physics Remastered | Alta | probable | Gran inmersion; posible costo CPU en escenas complejas. |
| Labeling containers | Labelling Containers | Alta | incluir | QoL util en base/almacenaje y multiplayer. |
| Falling Leaves | Falling Leaves (NeoForge/Forge) | Alta | incluir | Efecto visual ligero y popular; bajo riesgo. |
| Burnt | Burnt Basic | Alta | probable | Mejora visual de fuego; potencial solape con otros mods de fuego. |
| Falling Tree Physics | Tree Physics | Alta | probable | Tala inmersiva con fisicas; validar rendimiento y exploits de tala masiva. |
| Immersive Weathering | Immersive Weathering: Renewed | Alta | probable | Port reciente; requiere smoke test de estabilidad. |
| Make bubbles pop | Make Bubbles Pop | Alta | incluir | Client-side, muy bajo riesgo, mejora visual limpia. |
| Eating animations | Eating Animations | Nula | No Incluir | Sin resultado NeoForge 1.21.1 confiable en Modrinth. |
| Immersive enchanting | Immersive Enchanting | Alta | probable | Rework de encantamientos; revisar balance y compat con KubeJS. |
| Subtle effects | Subtle Effects | Alta | probable | Muy buen detalle visual; vigilar acumulacion de particulas. |
| Wakes | Wakes Reforged | Alta | probable | Muy inmersivo en agua; revisar costo visual en zonas con entidades. |
| Particles | Particular Reforged | Alta | probable | Efectos visuales de ambiente bien cuidados; validar costo visual acumulado. |
| Spyglass Improvments | Spyglass Improvements | Alta | incluir | QoL util y de bajo impacto tecnico. |
| Wildex Bestiary | Wildex Bestiary | Alta | probable | Herramienta de descubrimiento de fauna; validar madurez en gameplay largo. |
| Actually Fish | Actual Fishing | Alta | probable | Match confirmado; agrega mecanicas reales de pesca con impacto de gameplay. |
| Keybind Atlas | Keybind Atlas | Alta | incluir | Excelente onboarding para modpacks grandes. |
| Hyper Punchy | Hyper Punchy (resourcepack) | Alta | incluido | Complemento visual de Punchy; sin riesgo grave detectado mas alla de preferencia estetica. |
| Fancy World Animations | Fancy World Animations | Alta | incluido | Cliente-only, sin dependencias y sin conflicto grave detectado con el stack actual. |

## 2) Lista nueva categorizada (nombre, autor, version, descripcion breve, estado)

### Interfaz y calidad de vida (QoL)

| Nombre | Autor | Version (NeoForge 1.21.1) | Descripcion breve | Estado |
|---|---|---|---|---|
| AppleSkin | squeek502 | 3.0.9+mc1.21 | HUD de hambre y saturacion. | incluir |
| Better Advancements | way2muchnoise | 0.4.3.21 | Interfaz de avances mejorada. | incluir |
| Mouse Tweaks | YaLTeR | 1.21-2.26.1-neoforge | Mejoras de arrastre/click en inventario. | incluir |
| JEI | mezz | 19.27.0.340 | Visualizacion de recetas e items. | incluir |
| Jade | Snownee | 15.10.5+neoforge | Informacion contextual en pantalla. | incluir |
| Labeling containers | Infinituum17 | 1.9.2 | Etiquetas e iconos en contenedores. | incluir |
| Spyglass Improvements | juancarloscp52 | 1.5.7+mc1.21+neoforge | Mejora uso y funciones del catalejo. | incluir |
| Keybind Atlas | UmbraLykos | 1.4.0 | Overlay para consultar teclas del pack. | incluir |
| Visual Workbench | Fuzs | v21.1.1-1.21.1-NeoForge | Crafteo visible y persistente en mesa. | incluir |

### Inmersion sonora

| Nombre | Autor | Version (NeoForge 1.21.1) | Descripcion breve | Estado |
|---|---|---|---|---|
| Presence Footsteps | ZCRAFT-NullPointerException | 1.21.1-1.12.0-beta.1 | Sonidos de pasos mas contextuales. | probable |
| Sound Physics Remastered | henkelmax | neoforge-1.21.1-1.5.1 | Reverb/occlusion de sonido realista. | probable |
| Ambient Sounds 6 | N/D | N/D | Capa ambiental sonora por bioma/situacion. | No Incluir |

### Animaciones y camara

| Nombre | Autor | Version (NeoForge 1.21.1) | Descripcion breve | Estado |
|---|---|---|---|---|
| Punchy! | PunchyDevGuy | 2.5.5b | Animaciones de manos/primera persona. | incluido |
| Not Enough Animations | tr7zw | 1.12.3 | Lleva animaciones al modelo en tercera. | probable |
| Better Third Person | Socolio | 1.9.0 | Camara de tercera persona mejorada. | probable |
| Real Camera | xTracr | 0.7.6-beta-1.21.1 | Camara en primera persona mas fisica. | probable |
| Fancy World Animations | maDU59_ | 1.2.24 | Animaciones suaves para bloques interactivos. | incluido |
| Eating Animations | Matyrobbrt | N/D | Animacion al comer. | No Incluir |
| Fresh Animations | FreshLX | N/A (resourcepack) | Animaciones de entidades via resource pack. | incluido |
| Fresh Animations: Extensions | FreshLX | 1.9.1 | Extension oficial combinada para Fresh Animations. | incluido |
| Fresh Animations: Player Extension | FreshLX | 1.0.0 | Animaciones de jugador en estilo Fresh Animations. | incluido |
| Hyper Punchy | HamzTheModMaker | 2.5 | Pack visual complementario para Punchy. | incluido |

### Efectos visuales y particulas

| Nombre | Autor | Version (NeoForge 1.21.1) | Descripcion breve | Estado |
|---|---|---|---|---|
| Visuality: Reforged | RaymondBlaze | 2.1.0 | Particulas y microdetalles visuales. | probable |
| Make Bubbles Pop | Tschipcraft | 0.4.0-beta.1-neoforge | Burbujas mas naturales al subir/romper. | incluir |
| Falling Leaves | cheaterpaul | 1.21.1-2.5.1 | Caida de hojas decorativa. | incluir |
| Subtle Effects | MincraftEinstein | 1.14.3 | Detalles de particulas y pequenos sonidos. | probable |
| Wakes Reforged | Leclowndu93150 | 1.3.6 | Estelas en agua estilo vanilla+. | probable |
| Cave Dust | LizIsTired | N/D | Polvo ambiental en cuevas. | No Incluir |
| Particular Reforged | Leclowndu93150 | 1.5.3 | Efectos visuales y ambiente con particulas trabajadas. | probable |

### Mecanicas y combate

| Nombre | Autor | Version (NeoForge 1.21.1) | Descripcion breve | Estado |
|---|---|---|---|---|
| Better Combat | ZsoltMolnarrr | 2.3.2+1.21.1-neoforge | Combate melee con combos/animaciones. | probable |
| Grappling Hook Mod: Skybound | weaversworkshop | v1.1+1.21.1-neoforge | Gancho fisico para movilidad avanzada. | probable |
| ParCool! | alRex_U | 1.21.1-3.4.3.3 | Parkour y movilidad avanzada. | probable |
| Sit | bl4ckscor3 | v1.4 | Sentarse en escaleras/losas. | probable |
| Personality | TeamAbnormals | 5.0.2 | Crawling/sitting y gamefeel social. | probable |
| Immersive Enchanting | alfino | 6.0.0 | Rework inmersivo del encantamiento. | probable |
| Soul Fire'd | CrystalSpider | 6.1.0 | Expande mecanicas del fuego de almas. | probable |
| Dyed Flames | Fuzs | v21.1.1-1.21.1-NeoForge | Fuego tintado y efectos asociados. | probable |
| Burnt Basic | pxlbnk | 1.10.3.6 | Mejoras de fuego y quemaduras vanilla+. | probable |
| Tree Physics | Farcr | neoforge-2.0 | Tala de arboles con caida fisica realista. | probable |

### Construccion y mundo vivo

| Nombre | Autor | Version (NeoForge 1.21.1) | Descripcion breve | Estado |
|---|---|---|---|---|
| Amendments | MehVahdJukaar | 1.21-2.0.15-neoforge | Ajustes y mejoras de bloques vanilla. | incluir |
| Diagonal Fences | Fuzs | v21.1.1-1.21.1-NeoForge | Conexiones diagonales de vallas. | incluir |
| Villager Names | Serilum | 1.21.1-8.4-fabric+forge+neo | Nombres para aldeanos automaticamente. | probable |
| Immersive Weathering: Renewed | QanoriaPorts | V1.0.4-NeoForge | Meteorizacion/erosion y detalle ambiental. | probable |
| Bushier Flowers | Pandarix | N/D | Flores mas densas y decorativas. | No Incluir |

### Exploracion y coleccion

| Nombre | Autor | Version (NeoForge 1.21.1) | Descripcion breve | Estado |
|---|---|---|---|---|
| Wildex Bestiary | ColdFang | 3.0.0 | Bestiario automatico de criaturas vistas. | probable |
| Actual Fishing | Stereowalker | 1.21.1-1.1-NeoForge | Rework de pesca para capturar peces vivos. | probable |

## 3) Recomendacion de implementacion por fases

1. Fase base (alto valor, bajo riesgo): AppleSkin, Better Advancements, Mouse Tweaks, JEI, Jade, Labeling Containers, Visual Workbench, Diagonal Fences, Make Bubbles Pop, Keybind Atlas.
2. Fase inmersion visual/sonora: Falling Leaves, Subtle Effects, Presence Footsteps, Sound Physics Remastered, Wakes, Visuality.
3. Fase mecanicas: Better Combat, ParCool!, Grappling Hook, Immersive Enchanting, Tree Physics.
4. Fase de validacion manual estricta: stack de camara/animaciones (Punchy, NEA, Better Third Person, Real Camera, Fancy World Animations, Personality, Sit).

---
Si quieres, en el siguiente paso convierto directamente la Fase 1 en entradas .pw.toml y dejo un PR interno con cambios listos para sincronizar.

## 4) Nota de cumplimiento (Fresh Animations)

- El autor permite incluir el resource pack en modpacks/servers.
- Evitar redistribucion standalone o espejada: preferir descarga desde pagina oficial (Modrinth/CurseForge) mediante metadata del pack.
- Si se reutilizan assets en otros packs propios, incluir credito y enlace oficial.
- No publicar versiones editadas del pack como descarga publica sin permiso explicito.
