# Unity Prefab Configuration Quick Reference

## Player Prefab Setup

**GameObject Name**: `Player`

### Components:
1. **Transform**
   - Position: (0, 1, 0)
   - Rotation: (0, 0, 0)
   - Scale: (1, 1, 1)

2. **Character Controller**
   - Center: (0, 1, 0)
   - Radius: 0.5
   - Height: 1
   - Skin Width: 0.08
   - Min Move Distance: 0.001
   - Slope Limit: 45
   - Step Offset: 0.3

3. **Player Controller Script**
   - Player Color: Blue
   - Fade Rate: 0.5
   - Push Force: 5.0
   - Speed: 5.0
   - Jump Velocity: 9.0
   - Gravity: 20.0
   - Ball Radius: 0.5
   - Visual Mesh Parent: [Assign PlayerBall model child]

### Hierarchy:
```
Player
├── PlayerBall (Model from PlayerBall.glb)
│   └── ColorIdentifier (Sphere mesh with color material)
```

**Layer**: Player (8)
**Tag**: Player

---

## Box Prefab Setup

**GameObject Name**: `Box`

### Components:
1. **Transform**
   - Scale: (1, 1, 1)

2. **Rigidbody**
   - Mass: 5
   - Drag: 0.5
   - Angular Drag: 0.5
   - Use Gravity: ✓
   - Is Kinematic: ✗

3. **Box Collider**
   - Center: (0, 0.5, 0)
   - Size: (1, 1, 1)

4. **Box Controller Script**
   - Box Color: Blue (change per instance)

### Hierarchy:
```
Box
├── BoxModel (Model from Box.glb)
│   └── ColorIdentifier (Small sphere/cube with color material)
```

**Layer**: Box (10)

---

## Platform Prefabs

### Small Platform

**GameObject Name**: `Platform_Small`

### Components:
1. **Transform**
   - Scale: (1, 1, 1)

2. **Mesh Filter**
   - Mesh: Small.obj

3. **Mesh Renderer**
   - Material: Tech Pattern Material + Color tint

4. **Mesh Collider**
   - Convex: ✗
   - Mesh: Small.obj

5. **Platform Controller Script**
   - Platform Color: Blue (set per instance)
   - Fade Mode: When Standing
   - Fade Rate: 1.0

**Layer**: Platform (9)

**Repeat for**:
- Medium Platform (Medium.obj)
- Large Platform (Large.obj)
- XLarge Platform (XLarge.obj)

---

## ColorSwitcher Prefab Setup

**GameObject Name**: `ColorSwitcher`

### Components:
1. **Transform**
   - Position/Scale as needed

2. **Box Collider**
   - Is Trigger: ✓
   - Size: (2, 2, 2)

3. **Color Switcher Script**
   - Switcher Color: Green (set per instance)
   - Highlight Intensity: 5.0

### Hierarchy:
```
ColorSwitcher
├── ColorChanger (Model from ColorChanger.glb)
├── ColorIdentifier (Sphere with color material)
└── SpotLight (Highlight light)
    - Type: Point or Spot
    - Color: Set by script
    - Intensity: 5
    - Range: 10
```

**Layer**: Trigger (11)

---

## FinishLine Prefab Setup

**GameObject Name**: `FinishLine`

### Components:
1. **Transform**
   - Position as needed

2. **Box Collider**
   - Is Trigger: ✓
   - Size: (3, 4, 2)

3. **Finish Line Script**
   - (No public parameters)

### Hierarchy:
```
FinishLine
└── Portal (Model from Portal.glb)
```

**Layer**: Trigger (11)

---

## UI Prefab Configurations

### Win Panel

```
WinPanel (Panel)
├── Background (Image - semi-transparent black)
├── TitleText (Text: "Level Complete!")
├── ContinueButton (Button: "Continue")
└── QuitButton (Button: "Quit")
```

### Lose Panel

```
LosePanel (Panel)
├── Background (Image - semi-transparent black)
├── TitleText (Text: "Game Over")
├── RetryButton (Button: "Try Again")
└── QuitButton (Button: "Quit")
```

### Pause Panel

```
PausePanel (Panel)
├── Background (Image - semi-transparent black)
├── TitleText (Text: "Paused")
├── ResumeButton (Button: "Resume")
├── RetryButton (Button: "Restart")
└── QuitButton (Button: "Quit")
```

---

## Material Settings

### Color Materials (Transparent)

For each game color create a material with:

**Shader**: Standard
**Rendering Mode**: Transparent

Settings:
- Albedo: Color from table below
- Metallic: 0
- Smoothness: 0.5
- Emission: Same as albedo color
- Emission Intensity: 0 (controlled by script)

| Material Name | Albedo RGB |
|--------------|------------|
| Blue_Mat | (0, 127, 255) |
| Green_Mat | (51, 204, 51) |
| Red_Mat | (255, 51, 51) |
| Purple_Mat | (153, 51, 204) |
| Orange_Mat | (255, 153, 0) |
| Gold_Mat | (255, 214, 0) |

### Tech Pattern Material

**Shader**: Standard
**Albedo**: tech_pattern.jpg
**Tiling**: (0.5, 0.5)
**Albedo Color**: White (tinted by scripts)
**Rendering Mode**: Transparent

---

## Scene Manager Objects

### AudioManager GameObject

**Don't destroy on load**: ✓

Components:
- AudioManager Script
  - Menu Music: theme.mp3
  - Game Music: Background.mp3
  - Jump Sfx: jump.wav
  - Land Sfx: land.wav
  - Win Sfx: win.wav
  - Lose Sfx: lose.wav
  - Push Sfx: push.wav
  - Change Color Sfx: change_color.wav

**Placement**: Add to StartMenu scene (persists across scenes)

---

### SaveManager GameObject

**Don't destroy on load**: ✓

Components:
- SaveManager Script (no inspector settings needed)

**Placement**: Add to StartMenu scene (persists across scenes)

---

## Camera Setup

### Main Camera (for Level scenes)

Position: (0, 5, -10)
Rotation: (30, 0, 0)

This gives a nice isometric-like view of the level.

Adjust as needed for your level layouts.

---

## Lighting Setup

### Directional Light

Rotation: (50, -30, 0)
Intensity: 1
Color: White

### Optional: Add Point Lights

Near color switchers for extra atmosphere
Color: Match the switcher color
Intensity: 2-3
Range: 5-10

---

## Collision Matrix

Go to `Edit > Project Settings > Physics`

Set up collision matrix:

|  | Player | Platform | Box | Trigger |
|--|--------|----------|-----|---------|
| **Player** | ✗ | ✓ | ✓ | ✓ |
| **Platform** | ✓ | ✗ | ✓ | ✗ |
| **Box** | ✓ | ✓ | ✗ | ✗ |
| **Trigger** | ✓ | ✗ | ✗ | ✗ |

This ensures:
- Player collides with platforms, boxes, and triggers
- Boxes collide with platforms
- Triggers only interact with player

---

## Testing Checklist

### Player Testing
- ✓ Can move left/right
- ✓ Can jump
- ✓ Falls with gravity
- ✓ Ball rotates when moving
- ✓ Can't fall through platforms

### Color Mechanics
- ✓ Player fades on wrong-color platform
- ✓ Player visible on matching platform
- ✓ Platform fades after 2 seconds
- ✓ Color switcher changes player color
- ✓ Sound plays on color change

### Box Interaction
- ✓ Can push same-color boxes
- ✓ Cannot push different-color boxes
- ✓ Push sound plays
- ✓ Boxes have physics

### Level Completion
- ✓ Finish line triggers win screen
- ✓ Win sound plays
- ✓ Continue button works
- ✓ Level progression saves

### UI Testing
- ✓ Pause menu works (ESC key)
- ✓ Retry button reloads level
- ✓ Quit button exits
- ✓ Win/Lose panels display correctly

---

**Quick Setup Tip**: Create one complete prefab of each type, then duplicate and modify colors as needed for your levels!
