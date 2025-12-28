# Unity Scene Setup Guide - Exact Godot Level Recreation

This document provides exact object positions and configurations from your Godot levels to recreate in Unity.

## Scene 1: StartMenu

### Scene Setup
1. Create new scene: `Assets/Scenes/StartMenu.unity`
2. **Canvas Settings**:
   - UI Scale Mode: Scale With Screen Size
   - Reference Resolution: 1920x1080

### GameObjects Hierarchy

```
StartMenu (Scene Root)
├── AudioManager (DontDestroyOnLoad)
│   └── AudioManager.cs script
├── SaveManager (DontDestroyOnLoad)
│   └── SaveManager.cs script
└── Canvas
    ├── Background (Image)
    │   - Texture: menu_bg.png
    │   - Stretch to fill
    ├── VBoxContainer (Vertical Layout Group)
    │   - Position: Center of screen
    │   - Spacing: 40
    │   ├── TitleLabel (Text)
    │   │   - Text: "FADED 3D"
    │   │   - Font Size: 64
    │   │   - Alignment: Center
    │   ├── ContinueButton (Button)
    │   │   - Text: "CONTINUE"
    │   │   - Font Size: 32
    │   │   - Min Width: 300
    │   ├── PlayButton (Button)
    │   │   - Text: "NEW GAME"
    │   │   - Font Size: 32
    │   │   - Min Width: 300
    │   └── QuitButton (Button)
    │       - Text: "QUIT"
    │       - Font Size: 32
    │       - Min Width: 300
    └── StartMenuController (Empty GameObject)
        - StartMenuController.cs script
        - Assign all buttons in inspector
```

---

## Scene 2: Level1

### Scene Overview
- 10 platforms of varying sizes
- 2 boxes
- 2 color switchers  
- Finish line
- Player starts as Purple color
- 3D lighting setup

### Camera Setup
```
Main Camera
- Position: (32, 10, -20)
- Rotation: (30, 0, 0)
- Field of View: 60
- Clear Flags: Skybox
```

### Lighting Setup
```
OmniLight (Point Light)
- Position: (0, 3, 0)
- Intensity: 16
- Range: 50
- Color: White

DirectionalLight1
- Position: (0, 6, 0)
- Rotation: (90, 0, 0)
- Intensity: 1

DirectionalLight2
- Position: (0, 6, 0)
- Rotation: (45, 0, 0)
- Intensity: 0.5
```

### GameObjects - Exact Positions

#### Player
```
Player
- Position: (3.49, 0.42, 0)
- PlayerController.cs
  - Player Color: Purple
  - Speed: 5.0
  - Jump Velocity: 9.0
```

#### Platforms (Small)
```
PlatformS (Blue)
- Position: (-2.30, -2, 0)
- Fade Rate: 0.33

PlatformS4 (Blue)
- Position: (5.86, -2, 0)
- Fade Rate: 0.33

PlatformS5 (Blue)
- Position: (14.03, -2, 0)
- Fade Rate: 0.33
```

#### Platforms (Medium)
```
PlatformM6 (Blue)
- Position: (26.13, -2, 0)
- Fade Rate: 0.33

PlatformM8 (Blue)
- Position: (28, 4.03, 0)
- Fade Rate: 0.33

PlatformM10 (Blue)
- Position: (28, 12.03, 0)
- Fade Rate: 0.33

PlatformM9 (Blue) - ROTATED
- Position: (37.25, 10.91, 0)
- Rotation: (0, 0, 90) ← Standing vertically!
- Fade Rate: 0.33
```

#### Platform (Large)
```
PlatformL7 (Blue)
- Position: (50.45, -2, 0)
- Fade Rate: 0.33
```

#### Boxes
```
Box1 (Blue)
- Position: (17, -0.89, 0)
- Rigidbody: Mass 5

Box2 (Blue)
- Position: (43.68, -1, 0)
- Rigidbody: Mass 5
```

#### Color Switchers
```
ColorSwitcher1 (Blue - default)
- Position: (11, -0.82, 0)
- Rotation: (0, 90, 0)
- Switcher Color: Blue

ColorSwitcher2 (Red)
- Position: (31.41, 5.07, 0)
- Rotation: (0, 90, 0)
- Switcher Color: Red
```

#### Finish Line
```
FinishLine
- Position: (65.77, -1, -0.16)
- Rotation: (0, 180, 0)
```

### UI Canvas (GameUI)
```
GameUI (Canvas Layer)
├── WinPanel (VBoxContainer) - Hidden by default
│   - Anchor: Center
│   - Position: Center screen
│   ├── Label: "Level Complete!" (Size: 32)
│   ├── ContinueButton: "Continue" (Size: 24)
│   ├── RetryButton: "Retry" (Size: 24)
│   └── QuitButton: "Quit" (Size: 24)
│
├── LosePanel (VBoxContainer) - Hidden by default
│   - Anchor: Center
│   ├── Label: "Game Over" (Size: 32, Red color)
│   ├── RetryButton: "Retry" (Size: 24)
│   └── QuitButton: "Quit" (Size: 24)
│
└── PausePanel (ColorRect) - Hidden by default
    - Background: Black
    - Anchor: Full screen
    └── CenterContainer
        └── VBoxContainer
            ├── Label: "PAUSED" (Size: 32)
            ├── ResumeButton: "Resume" (Size: 24)
            └── QuitButton: "Quit" (Size: 24)
```

### Background
```
GameBackground (Canvas Layer -100)
└── TextureRect
    - Texture: Background.png
    - Stretch to fill screen
```

### Scene Root Objects
```
Level1 (Empty GameObject)
- LevelController.cs script

GameUIManager (Empty GameObject)
- GameUIManager.cs script
- Assign all panels and buttons in inspector
```

---

## Scene 3: Level2

### Scene Overview
- Simpler than Level1 (fewer platforms)
- 1 box (Orange color!)
- 1 color switcher (Green)
- Player starts as Blue

### Camera & Lighting
Same as Level1

### GameObjects - Exact Positions

#### Player
```
Player
- Position: (9, -0.51, 0)
- PlayerController.cs
  - Player Color: Blue (default)
```

#### Platforms (Small)
```
PlatformS (Blue)
- Position: (0, -2, 0)

PlatformS2 (Blue)
- Position: (4, -2, 0)

PlatformS3 (Blue)
- Position: (12, -2, 0)

PlatformS4 (Blue)
- Position: (8, -2, 0)

PlatformS5 (Blue)
- Position: (16, -2, 0)
```

#### Platform (Medium)
```
PlatformM6 (Blue)
- Position: (28, -2, 0)
```

#### Platform (Large)
```
PlatformL7 (Blue)
- Position: (52, -2, 0)
```

#### Box
```
Box1 (Orange) ← NOTE: Orange color!
- Position: (6, 0, 0)
- Box Color: Orange
```

#### Color Switcher
```
ColorSwitcher1 (Green)
- Position: (12, -1, 0)
- Rotation: (0, 90, 0)
- Switcher Color: Green
```

#### Finish Line
```
FinishLine
- Position: (67, -1, 0)
- No rotation
```

### UI & Background
Same as Level1

---

## Color Configuration Reference

### Platform Colors (Default: Blue)
All platforms in both levels start as **Blue**.

### Player Starting Colors
- **Level1**: Purple
- **Level2**: Blue

### Box Colors
- **Level1**: Both boxes are Blue
- **Level2**: Box is **Orange**

### Color Switcher Colors
- **Level1**: 
  - Switcher 1: Blue (default)
  - Switcher 2: Red
- **Level2**:
  - Switcher 1: Green

---

## Unity Creation Steps

### For Each Level:

1. **Create Empty Scene Object**
   - Name it "Level1" or "Level2"
   - Add LevelController.cs script

2. **Add Lighting**
   - Create OmniLight (Point Light)
   - Create 2 Directional Lights
   - Set positions and rotations from above

3. **Set Up Camera**
   - Position and rotate Main Camera
   - Adjust for good view of level

4. **Place Platforms**
   - Drag platform prefabs into scene
   - Set exact positions from tables above
   - Configure colors (all Blue for these levels)
   - Set fade rates (0.33 for Level1)

5. **Place Interactive Objects**
   - Add Player at start position
   - Add Boxes
   - Add Color Switchers
   - Add Finish Line
   - **IMPORTANT**: Rotate objects as shown!

6. **Set up UI**
   - Create Canvas
   - Add GameBackground (separate Canvas Layer -100)
   - Create WinPanel, LosePanel, PausePanel
   - Add GameUIManager script
   - Wire up all buttons

7. **Configure Colors**
   - Set Player starting color
   - Set Box colors
   - Set Color Switcher colors
   - Leave platforms as Blue (default)

---

## Important Notes

### Rotations
- **Color Switchers**: Rotated 90° on Y-axis (facing player)
- **Finish Line**: Level1 has 180° Y rotation, Level2 has 0°
- **Platform M9 in Level1**: Rotated 90° on Z-axis (vertical wall!)

### Z-Axis
All objects have Z=0 (2.5D gameplay on XY plane)

### Fade Rates
- Level1: All platforms have fade_rate = 0.33
- Level2: Default fade rate (1.0)

### Color Matching
Remember: Player only stays visible on matching-color platforms!

---

## Testing Checklist

### Level1
- [ ] Player starts at (3.49, 0.42, 0) as Purple
- [ ] Can reach first color switcher
- [ ] Can change to Red at second switcher
- [ ] Vertical platform (M9) is positioned correctly
- [ ] Can push boxes to create path
- [ ] Finish line triggers win

### Level2
- [ ] Player starts at (9, -0.51, 0) as Blue
- [ ] Orange box is visible and pushable
- [ ] Green color switcher works
- [ ] Simpler layout than Level1
- [ ] Finish line works

---

## Quick Position Reference

### Level1 Key Positions
| Object | X | Y | Z | Notes |
|--------|---|---|---|-------|
| Player Start | 3.49 | 0.42 | 0 | Purple |
| First Platform | -2.30 | -2 | 0 | Starting area |
| Color Switch 1 | 11 | -0.82 | 0 | Blue (default) |
| Color Switch 2 | 31.41 | 5.07 | 0 | Red |
| Finish Line | 65.77 | -1 | -0.16 | Goal |

### Level2 Key Positions
| Object | X | Y | Z | Notes |
|--------|---|---|---|-------|
| Player Start | 9 | -0.51 | 0 | Blue |
| Orange Box | 6 | 0 | 0 | Only box |
| Green Switcher | 12 | -1 | 0 | Color change |
| Finish Line | 67 | -1 | 0 | Goal |

---

**Use this guide to recreate your levels EXACTLY as they were in Godot!**
