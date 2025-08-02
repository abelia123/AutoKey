# AutoKey - 8-Way Direction UI

A mouse gesture control application that provides quick access to common keyboard shortcuts through an intuitive radial menu interface.

## Features

- **8-way directional control** - Access 8 different actions with simple mouse gestures
- **Visual feedback** - Beautiful radial UI with animations and visual cues
- **Customizable actions** - Each direction triggers a specific keyboard shortcut
- **Mouse button 4 (X2) activation** - Hold the side mouse button to activate

## Default Actions

- **↑ Up**: Select All (Ctrl+A)
- **↗ Up-Right**: Copy (Ctrl+C)
- **→ Right**: Save (Ctrl+S)
- **↘ Down-Right**: Paste (Ctrl+V)
- **↓ Down**: Enter
- **↙ Down-Left**: Screenshot (Win+Shift+S)
- **← Left**: Undo (Ctrl+Z)
- **↖ Up-Left**: Backspace

## Installation

### Option 1: Download Pre-built Release
1. Go to the [Releases](https://github.com/abelia123/AutoKey/releases) page
2. Download the latest `DirectionUI_8way.exe`
3. Run the executable (no installation required)

### Option 2: Build from Source
1. Clone the repository:
   ```bash
   git clone https://github.com/abelia123/AutoKey.git
   cd AutoKey
   ```

2. Install dependencies:
   ```bash
   pip install PyQt6 pynput pyautogui
   ```

3. Run the Python script:
   ```bash
   python direction_ui_8way.py
   ```

4. Or build the executable:
   ```bash
   build.bat
   ```

## Usage

1. Launch the application
2. Hold down Mouse Button 4 (usually the side button on gaming mice)
3. Move the mouse in any of the 8 directions
4. Release the button to execute the selected action

## Requirements

- Windows OS
- Python 3.8+ (if running from source)
- Mouse with extra buttons (Mouse Button 4/X2)

## Dependencies

- PyQt6 - GUI framework
- pynput - Mouse input handling
- pyautogui - Keyboard automation

## Building

To build the executable from source:

```bash
build.bat
```

This will create a standalone executable in the `dist` folder.

## License

This project is open source and available under the [MIT License](LICENSE).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Known Issues

- The application requires a mouse with extra buttons (specifically Mouse Button 4)
- Some antivirus software may flag the executable due to keyboard automation features

## Future Enhancements

- Configurable shortcuts
- Custom themes
- Multiple gesture sets
- Settings UI