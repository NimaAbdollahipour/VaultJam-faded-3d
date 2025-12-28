# Unity Faded3D - Setup Guide

This is a Unity conversion of the Godot "Faded3DFinal" game - a 3D color-matching platformer with unique fading mechanics.

## 📋 Project Overview

**Game Concept**: A 3D platformer where the player ball must navigate levels using color-matching mechanics. The player fades away when NOT standing on platforms that match their current color. Color switchers change the player's color to access different areas.

**Core Mechanics**:
- Color-based gameplay (Blue, Green, Red, Purple, Orange, Gold)
- Player fades when not on matching-color platforms
- Push boxes (only when colors match)
- Color switcher pickups
- Platform fading after standing on them
- Level progression with save/load system

## 🎮 Game Controls

- **Arrow Keys / WASD**: Move left/right
- **Space / Jump Button**: Jump
- **Escape**: Pause menu

## 📁 Project Structure

```
UnityFaded3D/
├── Assets/
│   ├── Scripts/          # All C# game scripts
│   ├── Models/           # 3D models (.glb and .obj files)
│   ├── Textures/         # Images and patterns
│   ├── Audio/            # Music and sound effects
│   ├── Prefabs/          # (To be created) Reusable game objects
│   ├── Scenes/           # (To be created) Game scenes
│   └── Materials/        # (To be created) Unity materials
```

## 🚀 Setup Instructions

### Step 1: Create New Unity Project

1. Open Unity Hub
2. Click "New Project"
3. Select **3D (URP)** or **3D** template (Universal Render Pipeline recommended)
4. Choose Unity **2021.3 LTS** or later
5. Name it `UnityFaded3D`
6. Click "Create"

### Step 2: Import Project Files

1. **Copy Assets Folder**:
   - Locate the generated `UnityFaded3D/Assets` folder
   - Copy the entire `Assets` folder contents into your Unity project's `Assets` folder
   - Unity will automatically import all scripts, models, textures, and audio

2. **Wait for Import**:
   - Unity will compile C# scripts
   - Import 3D models
   - Process audio files
   - Check Console for any errors

### Step 3: Configure Project Settings

1. **Scene Build Settings**:
   - Go to `File > Build Settings`
   - Add scenes in this order (after creating them):
     - StartMenu
     - Level1
     - Level2

2. **Input Settings**:
   - Go to `Edit > Project Settings > Input Manager`
   - Verify these axes exist:
     - Horizontal (Arrow Keys/A-D)
     - Vertical (Arrow Keys/W-S)  
     - Jump (Spacebar)

3. **Physics Layers** (Important!):
   - Go to `Edit > Project Settings > Tags and Layers`
   - Create these layers:
     - Layer 8: `Player`
     - Layer 9: `Platform`
     - Layer 10: `Box`
     - Layer 11: `Trigger`

### Step 4: Create Manager Objects

1. **Create AudioManager**:
   - In Hierarchy, right-click > Create Empty
   - Name it `AudioManager`
   - Add Component > `AudioManager` script
   - In Inspector, assign audio clips:
     - Menu Music: `theme.mp3`
     - Game Music: `Background.mp3`
     - All SFX files (jump, land, win, lose, push, change_color)

2. **Create SaveManager**:
   - In Hierarchy, right-click > Create Empty
   - Name it `SaveManager`
   - Add Component > `SaveManager` script

### Step 5: Create Materials

Create materials for each color in `Assets/Materials/`:

1. **Blue Material**: Albedo (0, 127, 255)
2. **Green Material**: Albedo (51, 204, 51)
3. **Red Material**: Albedo (255, 51, 51)
4. **Purple Material**: Albedo (153, 51, 204)
5. **Orange Material**: Albedo (255, 153, 0)
6. **Gold Material**: Albedo (255, 214, 0)

For each material:
- Set Rendering Mode to `Transparent`
- Enable Emission (optional for glow effect)

**Tech Pattern Material**:
- Create Standard Material
- Assign `tech_pattern.jpg` as Albedo texture
- Set tiling to 0.5, 0.5

### Step 6: Create Prefabs

#### Player Prefab

1. Create Empty GameObject named `Player`
2. Add Component > `Character Controller`
   - Center: (0, 1, 0)
   - Radius: 0.5
   - Height: 1
3. Add Component > `PlayerController` script
4. Import `PlayerBall.glb` model
5. Drag model as child of Player
6. Create child empty object named `ColorIdentifier`
   - Add sphere mesh
   - Apply color material
7. Set Layer to `Player`
8. Save as Prefab in `Assets/Prefabs/`

#### Box Prefab

1. Import `Box.glb` model
2. Add Component > `Rigidbody`
   - Mass: 5
   - Drag: 0.5
3. Add Component > `Box Collider`
4. Add Component > `BoxController` script
5. Create child object `ColorIdentifier` with color mesh
6. Set Layer to `Box`
7. Save as Prefab

#### Platform Prefabs (Small, Medium, Large)

1. Import platform models (Small.obj, Medium.obj, Large.obj)
2. Add Component > `Mesh Collider`
3. Add Component > `PlatformController` script
4. Apply tech pattern material
5. Set Layer to `Platform`
6. Save as Prefab for each size

#### ColorSwitcher Prefab

1. Import `ColorChanger.glb` model
2. Add Component > `Box Collider`
   - Set as Trigger: ✓
3. Add Component > `ColorSwitcher` script
4. Add child `Point Light` or `Spot Light`
5. Create child `ColorIdentifier` mesh
6. Set Layer to `Trigger`
7. Save as Prefab

#### FinishLine Prefab

1. Import `Portal.glb` model
2. Add Component > `Box Collider`
   - Set as Trigger: ✓
3. Add Component > `FinishLine` script
4. Set Layer to `Trigger`
5. Save as Prefab

### Step 7: Create StartMenu Scene

1. Create new scene: `File > New Scene`
2. Save as `Assets/Scenes/StartMenu.unity`

**Setup**:
- Add `AudioManager` and `SaveManager` objects
- Create Canvas (UI > Canvas)
- Add background image (menu_bg.png)
- Create 3 buttons:
  - **Play Button**: "New Game"
  - **Continue Button**: "Continue"
  - **Quit Button**: "Quit"
- Add Empty GameObject with `StartMenuController` script
- Link buttons in inspector
- Add `EventSystem` if missing

### Step 8: Create Level1 Scene

1. Create new scene
2. Save as `Assets/Scenes/Level1.unity`

**Setup**:
- Add Directional Light
- Add Main Camera (position: 0, 5, -10, rotation: 30, 0, 0)
- Create Empty GameObject named `LevelManager`
  - Add `LevelController` script
- Add Player prefab (starting position)
- Add platforms with different colors
- Add boxes
- Add color switchers
- Add finish line
- Create Canvas for UI
  - Add `GameUIManager` script
  - Create Win Panel (hidden by default)
  - Create Lose Panel (hidden by default)  
  - Create Pause Panel (hidden by default)

**Example Level Layout**:
```
Starting Platform (Blue) → Player starts here
Color Switcher (Green) → Changes player to green
Green Platforms → Player can walk on
Box (Green) → Player can push
Finish Line → Complete level
```

### Step 9: Create Level2 Scene

- Duplicate Level1 scene
- Save as `Assets/Scenes/Level2.unity`
- Modify layout for increased difficulty
- Add more color switches and platforms

### Step 10: Configure Inspector References

#### AudioManager
- Drag all audio clips to respective slots

#### PlayerController (on Player prefab)
- Set `Visual Mesh Parent` to the PlayerBall model child

#### GameUIManager (in Level scenes)
- Link Win Panel, Lose Panel, Pause Panel
- Link all buttons (Resume, Retry, Quit, Continue)

#### StartMenuController (in StartMenu scene)
- Link Play, Continue, and Quit buttons

### Step 11: Set Up Build Settings

1. Go to `File > Build Settings`
2. Add scenes:
   - Scene 0: StartMenu
   - Scene 1: Level1
   - Scene 2: Level2
3. Set Platform (PC, Mac, Linux Standalone)

## 🎨 Color System Reference

The game uses 6 colors with specific RGB values:

| Color | RGB Values | Hex |
|-------|------------|-----|
| Blue | (0, 127, 255) | #007FFF |
| Green | (51, 204, 51) | #33CC33 |
| Red | (255, 51, 51) | #FF3333 |
| Purple | (153, 51, 204) | #9933CC |
| Orange | (255, 153, 0) | #FF9900 |
| Gold | (255, 214, 0) | #FFD600 |

## 🎵 Audio Files

- **Music**:
  - `theme.mp3` - Menu background music
  - `Background.mp3` - In-game music

- **Sound Effects**:
  - `jump.wav` - Player jump
  - `land.wav` - Player landing
  - `push.wav` - Pushing boxes
  - `change_color.wav` - Color switcher pickup
  - `win.wav` - Level complete
  - `lose.wav` - Game over

## 🛠️ Troubleshooting

### Scripts Won't Compile
- Check Unity version (2021.3 LTS+)
- Verify all script files are in `Assets/Scripts/`
- Check Console for specific errors

### Player Falls Through Platforms
- Verify platform has Collider
- Check Physics layers are set correctly
- Ensure Player has CharacterController

### Audio Not Playing
- Check AudioManager has clips assigned
- Verify audio files imported correctly
- Check Audio Source components

### Color Switching Doesn't Work
- Verify ColorSwitcher has trigger collider
- Check Player has PlayerController script
- Ensure layers are configured for collision

### Player Fades Immediately
- Check if player is standing on matching-color platform
- Verify platform color matches player starting color
- Check fade rate isn't too high

## 📝 Game Design Notes

### Fading Mechanic
- Player is **VISIBLE** when on matching-color platform
- Player **FADES** when:
  - On mismatched-color platform
  - In the air
  - On ground with no color
- Complete fade = Game Over

### Platform Behavior
- Platforms fade after player stands on them for 2 seconds
- Only same-color platforms fade
- Mismatched platforms stay solid

### Box Interaction
- Player can only push boxes of matching color
- Mismatched boxes are immovable
- Boxes have physics (can fall, be pushed off edges)

## 🎯 Next Steps

1. Complete all manual setup steps above
2. Test StartMenu scene
3. Test Level1 gameplay
4. Adjust values in Inspector as needed:
   - Player speed, jump height
   - Fade rates
   - Platform timers
   - Push forces
5. Create additional levels
6. Polish visuals and lighting
7. Build and test executable

## 📚 Additional Resources

### Unity Documentation
- [CharacterController](https://docs.unity3d.com/ScriptReference/CharacterController.html)
- [Physics](https://docs.unity3d.com/Manual/PhysicsSection.html)
- [UI System](https://docs.unity3d.com/Packages/com.unity.ugui@1.0/manual/index.html)

### Script Architecture
- **Singleton Pattern**: AudioManager, SaveManager persist across scenes
- **Component-Based**: Each game object has specific controller scripts
- **Event-Driven**: UI triggers game state changes

## 🤝 Credits

Original Godot game: Faded3DFinal
Converted to Unity: [Your Name]
Game Design: Color-matching platformer with fading mechanics

---

**Good luck with your Unity project! 🎮**

If you encounter any issues, refer to the troubleshooting section or check the Unity Console for specific error messages.
