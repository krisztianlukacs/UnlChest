# UnlChest (Unlimited Chest)

A Factorio mod that provides unlimited chests with an easy-to-use item selector interface.

## Features

### Unlimited Item Source

- **Infinite Supply**: Each UnlChest provides an unlimited supply of a single selected item type
- **Auto-Refill**: Automatically refills to a full stack every 10 ticks (0.16 seconds)
- **Stack-Based**: Always maintains a full stack based on the item's stack size

### Intuitive Item Selection

- **Item Selector GUI**: Features a clean, draggable interface for choosing items
- **Unichest-Style Selection**: Familiar choose-elem-button interface for quick item selection
- **Easy Access**: Simply open the chest to select or change the item type

### Factorio 2.0 Compatible

- **Drag Support**: Fully draggable GUI with titlebar drag functionality
- **ESC Key Support**: Close the interface with the ESC key
- **Modern UI**: Built using `player.gui.screen` for proper Factorio 2.0 integration
- **Stable Performance**: Fixed GUI handling for the latest Factorio version

## Usage

1. **Craft the UnlChest**: Recipe requires just 1 iron plate (enabled by default)
2. **Place the Chest**: Place it like any regular chest
3. **Select an Item**: Open the chest and use the item selector to choose what you want
4. **Extract Items**: The chest will maintain a full stack of the selected item at all times

## Technical Details

- **Version**: 2.3.5
- **Factorio Version**: 2.0+
- **Inventory Size**: 1 slot (always full)
- **Based On**: Steel chest prototype
- **Refresh Rate**: Every 10 ticks

## Recipe

- **Ingredients**: 1x Iron Plate
- **Result**: 1x UnlChest
- **Availability**: Unlocked from the start (no research required)

## Installation

1. Download the mod from the Factorio mod portal or GitHub
2. Place in your Factorio mods folder
3. Enable the mod in the game's mod menu
4. Start or load your game

## Changelog

### v2.3.5

- Fixed drag functionality for Factorio 2.0
- Fixed ESC key closing behavior
- Migrated GUI to `player.gui.screen`
- Improved titlebar with proper drag target

## Author

KrisztainLukacs

## License

See [LICENSE](LICENSE) file for details.

## Compatibility

- **Factorio Version**: 2.0 or higher
- **Dependencies**: base >= 2.0
- **Conflicts**: None known

## Support

If you encounter any issues or have suggestions for improvements, please report them on the mod portal or GitHub repository.
