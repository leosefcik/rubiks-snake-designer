# rubiks-snake-designer

Find the online version here: https://leosefcik.itch.io/rubiks-snake-designer

# 🧩 Rubik's Snake Designer (Rubik's Twist)

3D virtual Rubik's Snake/Twist simulator with customization and more (made in Godot).

- **Manipulate** a Rubik's Snake/Twist by **twisting pieces** 90 degrees
- **Export and import** designs into a shareable code (with an option to animate the process)
- **Orient** your design with rotation controls (and an upright button in case you mess it up)
- Support for sizes from **2 to 480 prisms** (good luck)
- Various **color, theme** and other **vanity** options
- Toggleable **collision detection** (design with the spatial clunk of a real one)

## ⌨️ Controls:

- **LMB / RMB** on a prism - turn 90 degrees
    
- **MMB / RMB** - Orbit view
    
- **LMB / Shift+MMB / Shift+RMB** - Pan view
    
- **X / C / Scroll** - Zoom
    
- (Option for MMB-only camera in options)
    
- **Z** - Undo changes
    
- **R** - Reset cam to default orientation from the front
    
- **H** - Hide GUI
    

## 🦢 A couple of model codes

### Animals

- Swan: `02000101003210012300101`
- Swan mirrored: `10100321001230010100020|-0,180,-90`
- Dragon upright: `20002001010001300321003030012300332000200202200|0,-0,-135`
- The Snake: `02002000333133022033133|-0,-0,-90`
- Dove: `20130032100303001230031|-0,-180,135`
- Le Coq: `00220101323022032310102|-0,0,90`
- 48 piece dog: `20110220113111022033330220002000220200002022000|-0,180,-0`

### Other models

- Rifle: `02200020000202202000002|-0,0,-90`
- Phone holder: `22001130001230001330022|-0,90,-135`
- Sphere: `11313313113133131131331|-0,0,45`
- Sphere Inverted: `13133131131331311313313|-0,0,45`
- Revolver: `20200220200020202200000|-0,180,-90`
- Octahedron: `30013003100310013001300310031001300130031003100|-0,-0,-135`
- Coffee cup: `10020012300200311022022011300200321002001120020|-0,90,-45`
- Spoon: `00000011100313003130011|0,-0,180`
- Ladle: `02202203000000000002002|-90,45,0`
- Star 72: `22031022013022013022031022031022013022013022031022031022013022013022031|0,-0,-90`
- Thing cool: `023102030102030210203012023102030102030210203012023102030102030210203012023102030102030210203012023102030102030210203012023102030102030210203012023102030102030210203012023102030102030210203012023102030102030210203012023102030102030210203012023102030102030210203012023102030102030210203012023102030102030210203012023102030102030210203012023102030102030210203012023102030102030210203012023102030102030210203012023102030102030210203012023102030102030210203012023102030102030210203012`

## 🚨 Project status

This program was made in the summer of 2024 as a fun little project. I haven't worked on it since, and **currently don't plan on continuing**. Therefore, I've decided to release it now (December 2025), even though it's not in the feature-full state I wanted it to be.

There are lots of features I've planned - examples include a catalogue of preset models, piece-by-piece painting, a puzzle/speed gamemode, mobile support... All things unfit for the current codebase and state of the project. Perhaps I'll make a version 2 with more experience someday. The old to-do document can be found lower in this readme.

## 🪪 Credits

- Inspiration for the program & designs - Rubik's Snake Fansite @ http://thomas-wolter.de/
- Home, Undo, Camera icons - Iconduck @ https://iconduck.com/
- Fira Sans font - Carrois Apostrophe @ https://fonts.google.com/specimen/Fira+Sans

### Software used:

- sfxia by rxi @ https://rxi.itch.io/sfxia
- Blender @ https://www.blender.org/
- Inkscape @ https://inkscape.org/
- Godot @ https://godotengine.org/
- Paint.NET @ https://www.getpaint.net/

# A copy of the design/to-do document for the program

## Basics:

- [x] 3D design program controls
- [x] Highlight when selected
- [x] Home button for reset camera view
- [x] Center camera to bounding box of object
- [x] Zoom out when tesetting
- [x] undo
- [x] Hide GUI
- [x] Reset rotation whole thing
- [x] Default H zoom larger
- [x] Themes
- [ ] Reverse Sequence button (same design but reversed)
- [x] Rotate whole thing buttons
- [x] Rotation check on export
- [x] Collision check and red blink when inside (toggleable)
- [ ] Right side: Catalogue
- [ ] Catalogue search bar
- [ ] Live 1R3 to design thingy
- [ ] WASD cam controls
- [ ] Mobile camera controls
- [x] Fix grid so its not bad
- [ ] Help section with proper formats

## Flavor:

- [x] Smooth spin
- [x] Sticker on start n end
- [x] Building animation when loading
- [x] Random work on startup CANCELED CUZ I DONT HAVE DESIGNS YET
- [x] Random design button
- [x] Stop camera when mouse on gui
- [x] fix ugly mesh
- [ ] Display contornls in app
- [ ] Credits with font credits
- [x] H zoom dynamic to size of thing properly
- [ ] Even better H zoom dynamic
- [ ] Button sounds everywhere applicable
- [ ] PROBLEM: Photo for catalogue items: on runtime or pre-rendered?
- [x] When selected, minor outline on whole prism and main outline on selected side
- [ ] Graphics quality popup on startup
- [ ] Enhance spinning with indicators or smth
- [x] Fix click pan while rotation piece
- [ ] Random rougness map for slight bumps in shiny - with material flag triplanar
- [ ] Blink first piece when uprighting
- [ ] A piece of text that pops up with title and author when u spawn a catalogue deisgn
- [ ] Click off to clear collisions
- [ ] X-RAY mode
- [ ] Outline around snake graphics option
- [ ] Double click to queue 2 spins so u dont have to wait for animation
- [ ] When mouse has some velocity, dont spin a piece - only move camera
- [ ] Smooth spin when collision and undo (make this an option)
- [ ] Highlight prisms which get turned instead of just 1 prism

## Options:

- [x] Sounds for spinning L/R w disable
- [x] FOV change default 75
- [ ] Quality settings mesh, graphics
- [ ] Mouse pan disabled by default
- [ ] MSAA and other graphics toggles
- [x] Spin speed
- [ ] Free-rotate like in thomas wolter
- [ ] Always keep camera centered
- [x] Check Collision
- [ ] GUI sizes
- [ ] Ortho/Persp camera
- [x] Reset default
- [ ] Camera control disable stuff like LMB to pan

## Themes:

- [ ] Themes: Presets + custom dual piece 4-color setup
- [x] Background change
- [x] Darken first piece (default false)
- [ ] Round prism models + full face prism models + smaller face prism models

### Colors (probably outdated):

- White, Black, Gray, Mint Green, Mint Blue
- Blue, Red, Orange, Yellow, Green
- Lavender, Purple, Pink, Cream, Brown
- Wood cream, Wood brown, Steel

### Specific themes:

- Rubik’s Snake Designer (Mint green & blue with belly)
- White and alt belly + blue, green, red, orange, pink, black
- Full color mint green & blue (Thomas Wolter)
- single color full steel texture (Steel Up)
- Alternating full black and white (Piano)
- Alternating full green and blue (Classic Snake)
- Full color purle and mint blue switch (Funky)
- Purple and black belly switch (Missing Textures)
- Cream white and cream brown full (Wooden)
- Black & red alternating belly (Elegant)
- Cream and Pink alternating belly (Ice Cream)
- Cream and brown alternating belly (Coffee)
- Black and yellow alt belly (Bee)
- Mint Blue and Black alt belly (Space)  
    Special:
- Rubik’s Twist
- Toy - Blue&White repeat, pairs: red red, greengree, yellowyellow
- Colorful - Blue, Green, Red, White, Purple, Orange full repeat
- All the rainbows (Each with W/B variants):
- 6 color single
- 12 color double
- 12 color mirror
- 12 colod double

## Big goals:

- [ ] HOTADD/REMOVE pieces from start/end during operation (would need rewrite of the whole thing)
- [ ] Phone & PC compatibility
- [ ] 2R2 and 020 compat formats
- [x] Collision and Non Collision
- [ ] Tags for catalogue?
- [ ] Custom skins
- [ ] Custom hex codes
- [ ] Painting
- [ ] Redo button
- [ ] EMAIL WOLTER for permission to add designs from webstie to program
- [ ] Languages
- [ ] Speedrun mode
- [ ] Puzzle mode (select which categories, show pic, build)
- [ ] Keyboard based controls
- [ ] Generate instructions, like check collision for animation so it does it seamlessly and stuffs
- [ ] Export as model

## Colors

- Classic: 515b58
- Deep Blue: 252e74
- Space Dark: 282C34
- Joplin Dark: 10151A
- White: #F4F5F6

Other inspiration maybe for designs:

https://www.oisteinholen.no/rubik/snake_patterns_for_extra_long_Rubiks_snakes.html

https://ruwix.com/twisty-puzzles/rubiks-snake-twist/
