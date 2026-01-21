<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://i.ibb.co/qLqknnYd/BMScripts-Header.png">
  <source media="(prefers-color-scheme: light)" srcset="https://i.ibb.co/qLqknnYd/BMScripts-Header.png">
  <img alt="Shows the BM Scripts banner" src="https://i.ibb.co/qLqknnYd/BMScripts-Header.png">
</picture>

# 🚗 BM Vehicle Display - QB/QBox Static vehicle spawn with custom colours and rotation

A lightweight, reliable vehicle display system for FiveM.  
Designed for dealerships, showrooms, garages, and static vehicle showcases.

---

## ✨ Features

### **Automatic Vehicle Spawning**
Vehicles spawn when the player enters a configurable radius and despawn when the player leaves.

### **Static Display Vehicles**
Spawned vehicles are:
- Frozen in place  
- Non‑dynamic  
- Invincible  
- Locked  
- Clean (no dirt buildup)

Perfect for showroom environments.

### **Colour Name Support (GTA Colour IDs Only)**
Supports:
- Primary colour  
- Secondary colour  
- Pearlescent  
- Wheel colour  
- Interior colour  
- Dashboard colour  

All colours can be set using **readable names** defined in `client/colours.lua`:

```lua
primary = "matte_red",
secondary = "metallic_black",
wheelColour = "chrome",
pearlescent = "metallic_blue",
```

### **Rotation & Position Control**
Each vehicle supports:
- Custom rotation (pitch, roll, yaw)
- Custom heading
- Optional Z‑offset for perfect placement

### **Automatic Cleanup**
All spawned vehicles are deleted when:
- The player leaves the despawn radius
- The resource stops
- The script reloads
No leftover entities.

# ⚙️ Configuration

All vehicles are defined in `config.lua`.

### **Example Entry**
```lua
{
    vehicle = "adder",
    coords = vector4(-45.2, -1098.4, 26.4, 70.0),

    primary = "metallic_red",
    secondary = "metallic_black",
    pearlescent = "metallic_silver",
    wheelColour = "chrome",

    interior = 5,
    dashboard = 10,

    rotation = { 0.0, 0.0, 90.0 },
    zOffset = 0.0,

    spawnDistance = 150.0,
    despawnDistance = 180.0,
}
```

# 🎨 Colour System

Colour names are defined in `client/colours.lua`.

You can use:
- `metallic_*`
- `matte_*`
- `worn_*`
- `metal_*`
- `chrome`

Example:
```lua
primary = "matte_black",
wheelColour = "chrome",
pearlescent = "metallic_blue",
```

# 🧠 How It Works
- The script checks player distance every 500ms
- When the player enters the spawn radius:
  - The vehicle model loads
  - The vehicle spawns above the ground
  - Physics settle
  - The vehicle is frozen and positioned
  - Colours and plate are applied

- When the player leaves the despawn radius:
  - The vehicle is deleted

- On resource stop:
  - All vehicles are cleaned up

# 🛠 Requirements

- QBCore (for GetCoreObject)
- Basic understanding of GTA colour IDs (already mapped for you)

# 📌 Notes

- RGB colours are not supported
- Paint types (matte/metallic/chrome) are controlled by the colour ID itself
- Some wheel types do not support wheel colour changes

# 🎨 GTA Colour Reference Table

Below is the full list of supported colour names and their corresponding GTA colour IDs.

---

## Metallic Colours

| Name | ID |
|------|----|
| metallic_black | 0 |
| metallic_graphite | 1 |
| metallic_black_steel | 2 |
| metallic_dark_silver | 3 |
| metallic_silver | 4 |
| metallic_blue_silver | 5 |
| metallic_steel_gray | 6 |
| metallic_shadow_silver | 7 |
| metallic_stone_silver | 8 |
| metallic_midnight_silver | 9 |
| metallic_gun_metal | 10 |
| metallic_anthracite_gray | 11 |
| metallic_red | 27 |
| metallic_torino_red | 28 |
| metallic_formula_red | 29 |
| metallic_blaze_red | 30 |
| metallic_grace_red | 31 |
| metallic_garnet_red | 32 |
| metallic_desert_red | 33 |
| metallic_cabernet_red | 34 |
| metallic_candy_red | 35 |
| metallic_sunrise_orange | 36 |
| metallic_gold | 37 |
| metallic_orange | 38 |
| metallic_dark_green | 49 |
| metallic_racing_green | 50 |
| metallic_sea_green | 51 |
| metallic_olive_green | 52 |
| metallic_bright_green | 53 |
| metallic_gasoline_blue | 54 |
| metallic_midnight_blue | 61 |
| metallic_dark_blue | 62 |
| metallic_saxony_blue | 63 |
| metallic_blue | 64 |
| metallic_mariner_blue | 65 |
| metallic_harbor_blue | 66 |
| metallic_diamond_blue | 67 |
| metallic_surf_blue | 68 |
| metallic_nautical_blue | 69 |
| metallic_bright_blue | 70 |
| metallic_purple_blue | 71 |
| metallic_spinnaker_blue | 72 |
| metallic_ultra_blue | 73 |
| metallic_bright_purple | 81 |
| metallic_cream | 107 |

---

## Matte Colours

| Name | ID |
|------|----|
| matte_black | 12 |
| matte_gray | 13 |
| matte_light_gray | 14 |
| matte_ice_white | 131 |
| matte_blue | 83 |
| matte_dark_blue | 82 |
| matte_midnight_blue | 84 |
| matte_midnight_purple | 149 |
| matte_schafter_purple | 148 |
| matte_red | 39 |
| matte_dark_red | 40 |
| matte_orange | 41 |
| matte_yellow | 42 |
| matte_lime_green | 55 |
| matte_green | 128 |
| matte_forest_green | 151 |
| matte_foliage_green | 155 |

---

## Worn Colours

| Name | ID |
|------|----|
| worn_black | 21 |
| worn_graphite | 22 |
| worn_silver_gray | 23 |
| worn_silver | 24 |
| worn_blue_silver | 25 |
| worn_shadow_silver | 26 |
| worn_red | 46 |
| worn_golden_red | 47 |
| worn_dark_red | 48 |
| worn_dark_green | 56 |
| worn_green | 57 |
| worn_sea_wash | 58 |
| worn_dark_blue | 59 |
| worn_blue | 60 |
| worn_light_blue | 74 |
| worn_honey_beige | 99 |
| worn_brown | 95 |
| worn_dark_brown | 96 |
| worn_straw_beige | 97 |
| worn_sandy_brown | 98 |
| worn_off_white | 105 |

---

## Metal Colours

| Name | ID |
|------|----|
| metal_brushed_steel | 117 |
| metal_brushed_black_steel | 118 |
| metal_brushed_aluminum | 119 |
| metal_brushed_gold | 158 |
| metal_brushed_pure_gold | 159 |

---

## Chrome

| Name | ID |
|------|----|
| chrome | 120 |

---
