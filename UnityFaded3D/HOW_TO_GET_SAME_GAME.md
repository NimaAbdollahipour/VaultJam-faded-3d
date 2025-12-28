# How to Get the Same Game in Unity - Complete Guide

## Overview

Your Godot game "Faded3DFinal" is now ready to be recreated in Unity! This guide explains **exactly how to get the same game working** in Unity with all the features preserved.

---

## What's Been Done For You

✅ **All 11 C# scripts created** (Unity 2021+ compatible, no deprecated warnings)
✅ **All assets copied** (8 audio, 4 textures, 8 models)
✅ **Exact level layouts documented** (every position from your Godot levels)
✅ **UI screens mapped** (StartMenu, WinPanel, LosePanel, PausePanel)

---

## Step-by-Step: Get Your Unity Game Running

### Phase 1: Unity Project Setup (5 minutes)

1. **Open Unity Hub**
2. **Create New Project**:
   - Template: 3D (URP) or 3D Core
   - Name: `Faded3D_Unity`
   - Unity Version: 2021.3 LTS or newer

3. **Import Your Assets**:
   ```
   Copy from: c:\Users\Nima\Documents\faded-3d-final\UnityFaded3D\Assets\
   Paste to: Your Unity project Assets folder
   ```
   - Unity will automatically import everything
   - Wait for scripts to compile
   - Check Console - should be NO ERRORS!

---

### Phase 2: Create Manager Objects (10 minutes)

#### A. Configure Project Settings

1. **Build Settings** (`File > Build Settings`):
   - Click "Add Open Scenes" for each scene you create
   - Order: StartMenu → Level1 → Level2

2. **Physics Layers** (`Edit > Project Settings > Tags and Layers`):
   - Layer 8: `Player`
   - Layer 9: `Platform`
   - Layer 10: `Box`
   - Layer 11: `Trigger`

3. **Input Settings** (`Edit > Project Settings > Input Manager`):
   - Verify "Horizontal" and "Jump" axes exist (they should by default)

#### B. Create StartMenu Scene

1. **Create Scene**: `File > New Scene` → Save as `Assets/Scenes/StartMenu.unity`

2. **Create AudioManager**:
   ```
   Hierarchy > Right-click > Create Empty
   Name: AudioManager
   Add Component > AudioManager.cs
   ```
   
   **Inspector assignments**:
   - Menu Music: Drag `theme.mp3` from Assets/Audio
   - Game Music: Drag `Background.mp3`
   - Jump Sfx: `jump.wav`
   - Land Sfx: `land.wav`
   - Win Sfx: `win.wav`
   - Lose Sfx: `lose.wav`
   - Push Sfx: `push.wav`
   - Change Color Sfx: `change_color.wav`

3. **Create SaveManager**:
   ```
   Hierarchy > Right-click > Create Empty
   Name: SaveManager
   Add Component > SaveManager.cs
   ```
   - No inspector settings needed!

4. **Create UI**:
   ```
   Hierarchy > Right-click > UI > Canvas
   ```
   - Canvas Scaler: Scale With Screen Size (1920x1080)
   
   Add Background:
   ```
   Canvas > Right-click > UI > Image
   Name: Background
   Anchor: Stretch both (full screen)
   Source Image: menu_bg (from Textures folder)
   ```
   
   Add Title & Buttons:
   ```
   Canvas > Right-click > UI > Vertical Layout Group
   Name: MenuButtons
   Position: Center screen
   Spacing: 40
   
   Inside MenuButtons:
   - UI > Text: "FADED 3D" (Font Size: 64)
   - UI > Button: "CONTINUE" (Font Size: 32)
   - UI > Button: "NEW GAME" (Font Size: 32)
   - UI > Button: "QUIT" (Font Size: 32)
   ```

5. **Add StartMenuController**:
   ```
   Hierarchy > Create Empty
   Name: StartMenuController
   Add Component > StartMenuController.cs
   ```
   
   **Inspector**: Drag buttons to their slots:
   - Play Button → "NEW GAME" button
   - Continue Button → "CONTINUE" button
   - Quit Button → "QUIT" button

6. **Save Scene!**

---

### Phase 3: Create Level1 Scene (30 minutes)

This is where the magic happens! Follow `UNITY_SCENE_GUIDE.md` for exact positions.

#### A. Scene Setup

1. **New Scene**: `File > New Scene` → Save as `Assets/Scenes/Level1.unity`

2. **Set Up Camera**:
   - Select Main Camera
   - Position: (32, 10, -20)
   - Rotation: (30, 0, 0)
   - This gives you a nice isometric view!

3. **Add Lighting**:
   ```
   Create > Light > Point Light
   Name: OmniLight
   Position: (0, 3, 0)
   Intensity: 16
   Range: 50
   
   Create > Light > Directional Light (2 of them)
   Positions from UNITY_SCENE_GUIDE.md
   ```

4. **Add Level Controller**:
   ```
   Create Empty > Name: LevelManager
   Add Component > LevelController.cs
   ```

#### B. Create Prefabs First!

Before placing objects, create prefabs from your models:

**Player Prefab**:
```
1. Drag PlayerBall.glb into Hierarchy
2. Add Component > Character Controller
   - Center: (0, 1, 0)
   - Radius: 0.5
   - Height: 1
3. Add Component > PlayerController.cs
4. Create child: Sphere (for ColorIdentifier)
   - Scale: 0.3
   - Material: Blue material
5. In PlayerController: Assign PlayerBall as Visual Mesh Parent
6. Drag to Assets/Prefabs/ to save as prefab
7. Delete from Hierarchy
```

**Platform Prefabs** (Small, Medium, Large):
```
For each platform size:
1. Drag model (Small.obj, Medium.obj, Large.obj) into Hierarchy
2. Add Component > Mesh Collider
3. Add Component > PlatformController.cs
4. Apply material with tech_pattern texture
5. Set Platform Color: Blue
6. Save as prefab
```

**Box Prefab**:
```
1. Drag Box.glb into Hierarchy
2. Add Component > Rigidbody (Mass: 5)
3. Add Component > Box Collider
4. Add Component > BoxController.cs
5. Create child sphere for ColorIdentifier
6. Save as prefab
```

**ColorSwitcher Prefab**:
```
1. Drag ColorChanger.glb into Hierarchy
2. Add Component > Box Collider (Is Trigger: ✓)
3. Add Component > ColorSwitcher.cs
4. Add child: Point Light
5. Add child: Sphere for ColorIdentifier
6. Save as prefab
```

**FinishLine Prefab**:
```
1. Drag Portal.glb into Hierarchy
2. Add Component > Box Collider (Is Trigger: ✓, Size: 3,4,2)
3. Add Component > FinishLine.cs
4. Save as prefab
```

#### C. Place Level Objects

Now use your prefabs and the `UNITY_SCENE_GUIDE.md` positions:

1. **Add Player**:
   - Drag Player prefab into scene
   - Position: (3.49, 0.42, 0)
   - Set Player Color: **Purple** (in inspector!)

2. **Add Platforms**:
   - Drag platform prefabs  
   - Use exact positions from guide
   - All platforms: Blue color
   - **IMPORTANT**: Platform M9 is rotated 90° on Z!

3. **Add Boxes**:
   - 2 boxes at positions from guide
   - Both Blue color

4. **Add Color Switchers**:
   - 2 switchers
   - Switcher 1: Blue (default)
   - Switcher 2: **Red** (set in inspector!)
   - Both rotated 90° on Y-axis

5. **Add Finish Line**:
   - Position from guide
   - Rotated 180° on Y

#### D. Add Game UI

```
Create > UI > Canvas
Name: GameUI
Process Mode: Always (for pause to work)

Add Component > GameUIManager.cs
```

Create 3 panels (all hidden by default):

**Win Panel**:
```
Canvas > UI > Panel
Name: WinPanel
Anchor: Center
Active: OFF (unchecked)

Add inside:
- Text: "Level Complete!"
- Button: "Continue"
- Button: "Retry"
- Button: "Quit"
```

**Lose Panel**:
```
Same as Win Panel but:
Name: LosePanel
Text: "Game Over" (red color!)
```

**Pause Panel**:
```
Canvas > UI > Panel
Name: PausePanel
Background: Black
Full screen anchor
Active: OFF

Inside:
- Text: "PAUSED"
- Button: "Resume"
- Button: "Quit"
```

**Wire Up GameUIManager**:
- Select GameUI object
- In GameUIManager component:
  - Drag WinPanel to Win Panel slot
  - Drag LosePanel to Lose Panel slot
  - Drag PausePanel to Pause Panel slot
  - Drag ALL buttons to their corresponding slots

#### E. Add Background

```
Create > UI > Canvas
Name: GameBackground
Sort Order: -100 (renders behind everything)

Inside canvas:
UI > Image
Name: Background
Anchor: Stretch full screen
Source: Background.png (from Textures)
```

5. **Save Scene!**

---

### Phase 4: Create Level2 Scene (15 minutes)

**Easy Way**: Duplicate Level1 scene!

1. Right-click Level1.unity → Duplicate
2. Rename to Level2.unity
3. Modify according to `UNITY_SCENE_GUIDE.md`:
   - Move Player to (9, -0.51, 0)
   - Set Player Color to **Blue** (not Purple!)
   - Remove most platforms, keep the ones in guide
   - Change Box color to **Orange**!
   - Keep only 1 Color Switcher, set to **Green**
   - Move Finish Line to (67, -1, 0)

4. **Save Scene!**

---

### Phase 5: Final Configuration (5 minutes)

1. **Build Settings**:
   ```
   File > Build Settings
   Add all 3 scenes:
   - StartMenu
   - Level1
   - Level2
   ```

2. **Test StartMenu**:
   - Open StartMenu scene
   - Press Play
   - Music should play!
   - Click NEW GAME → Should load Level1

3. **Test Level1**:
   - Open Level1 scene
   - Press Play
   - Player should be visible (Purple!)
   - Test movement (Arrow keys)
   - Test jumping (Space)
   - Test fading (walk off platform - you should fade!)
   - Test color switching
   - Test pushing boxes
   - Test win condition (reach finish line)

---

## How The Game Works

### Core Gameplay Loop

1. **Player spawns** on matching-color platform (visible)
2. **Player walks** onto wrong-color platform → **starts fading**
3. **Player fades completely** → **Game Over**
4. **Player finds color switcher** → **changes color**
5. **Player now matches different platforms** → stays visible!
6. **Platforms fade** after standing on them for 2 seconds
7. **Push boxes** (only matching-color) to create stepping stones
8. **Reach finish line** → **Level Complete!**

### Visual Feedback

- **Visible Player** = On matching platform ✓
- **Fading Player** = Wrong platform! ⚠️
- **Fully Faded** = Game Over ✗
- **Platforms Disappear** = After 2 seconds of standing

### Controls

- **Arrow Keys / A-D**: Move left/right
- **Space**: Jump
- **Escape**: Pause menu

---

## Game Mechanics Explained

### Color System
```
6 Colors Available:
- Blue
- Green  
- Red
- Purple
- Orange
- Gold

Rule: Player color MUST match platform color to stay visible!
```

### Fading Mechanic
```
Player Alpha:
- On matching platform: Alpha → 1.0 (visible)
- On wrong platform: Alpha → 0.0 (fading)
- Alpha hits 0: Game Over!

Fade Rate: 0.5 (adjustable in inspector)
```

### Platform Behavior
```
When player (matching color) stands on platform:
- Timer starts (2 second delay)
- After 2 seconds: Platform starts fading
- Platform alpha → 0
- Platform is destroyed
```

### Box Pushing
```
if (player.color == box.color):
    physics applied → box moves
else:
    box is immovable
```

### Level Progression
```
Level1 → Level2 → (add more levels!)
Save system tracks current level
Continue button loads saved level
```

---

## Differences from Godot

| Aspect | Godot | Unity |
|--------|-------|-------|
| Script Language | GDScript | C# |
| Physics | CharacterBody3D | CharacterController |
| Scenes | .tscn files | .unity files |
| Prefabs | Inherited scenes | Prefab system |
| Autoload | Global scripts | DontDestroyOnLoad |
| Signals | `signal` keyword | Events/UnityEvents |
| Groups | `add_to_group()` | Tags/FindObjectOfType |

**All game logic is identical!** just different APIs.

---

## Troubleshooting

### "Player falls through platforms"
- Check platform has **Mesh Collider**
- Verify layers are set correctly
- Check CharacterController settings

### "Scripts won't compile"
- Verify Unity version 2021.3+
- Check all scripts are in Assets/Scripts/
- Look at Console for specific errors

### "Audio not playing"
- Check AudioManager has clips assigned
- Verify Audio Listener on Camera
- Check audio import settings

### "Player doesn't fade"
- Check materials are set to Transparent
- Verify PlayerController has meshRenderer references
- Check fade rate isn't 0

### "Color switching doesn't work"
- ColorSwitcher must have **Trigger** collider
- Player needs CharacterController
- Check layers for collision

---

## What Makes This Game Special

✨ **Unique Fading Mechanic**: Most platformers use instant death. This game uses gradual fading for tension!

🎨 **Color-Based Puzzles**: Color matching creates interesting level design possibilities

🎯 **Strategic Gameplay**: Players must plan routes because platforms disappear

🎮 **Physics Interactions**: Pushable boxes add puzzle-solving element

💾 **Save System**: Progress is saved automatically

---

## Next Steps

1. ✅ Complete all 3 scenes (StartMenu, Level1, Level2)
2. ✅ Test all game mechanics
3. ⚡ Create more levels!
4. 🎨 Customize colors/materials
5. 🎵 Add more music/sounds
6. 🏆 Add score system
7. 📱 Build for your target platform

---

## Level Design Tips

### Good Level Design:
- Start with safe matching-color platforms
- Introduce color switchers gradually  
- Use boxes as puzzle elements
- Create challenging jump sequences
- Mix colors for strategy

### Platform Placement:
- Create paths that require color switches
- Use vertical height differences
- Make some platformssafety nets
- Force timing challenges with fading platforms

---

**You now have everything you need to recreate your exact game in Unity!**

Follow this guide step-by-step, and you'll have a fully functional Unity version of your Godot game. All the scripts are modern, compatible, and ready to use.

Good luck! 🚀
