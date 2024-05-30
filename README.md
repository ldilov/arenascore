<img src="doc/arenascore.png" alt="WoW Arena Score Logo" width="400" height="400">

# WoW PvP Power Scoring Addon

Welcome to the **WoW PvP Power Scoring Addon** repository! This addon provides a universal numerical metric to evaluate the PvP power of target characters in World of Warcraft (WoW). The metric is derived from a combination of the character's rating, achievements, and PvP item level, offering a comprehensive assessment of their PvP capabilities.

## Key Features

- **Unified PvP Score**: Combines rating, achievements, and PvP item level into a single numerical value for easy comparison.
- **Real-Time Calculations**: Instantly calculates the PvP score of any target character, providing up-to-date information during gameplay.
- **Customizable Weights**: Allows users to adjust the weight of each component (rating, achievements, item level) to tailor the scoring to their preferences.
- **User-Friendly Interface**: Intuitive and easy-to-use interface integrated seamlessly with the WoW UI.
- **Comprehensive Data**: Leverages a wide range of PvP-related data points to ensure an accurate and fair assessment of PvP power.

## Installation

1. **Download** the latest release from the [Releases](link_to_releases) section.
2. **Extract** the downloaded file to your WoW Addons folder (typically located at `World of Warcraft/_retail_/Interface/AddOns`).
3. **Restart WoW** to enable the addon.

## Important Note

Currently, the addon does not use online or public web APIs and databases to get data about characters. Instead, it uses the InspectAPI from WoWAPI. On rare occasions, this could interfere with manual inspecting, but it is very unlikely. Additionally, there could be very small delays in obtaining PvP data from WoW servers for a particular character, so keep hovering on its unit frame for a second or two to ensure the data is fetched.

## Usage

- **Target a Character**: Simply target a player and hover on their unitframe to see their PvP power score displayed.
- **Customization**: Access the addon's settings through the WoW interface options menu to adjust the weights and preferences.

## PvP Power Calculation

The PvP power score (\$S\$) is calculated using the following formula:

\$\$
S = W\_R \cdot R + W\_WL \cdot A + W\_I \cdot I
\$\$

Where:

- \$R\$ is the PvP rating
- \$WL\$ is the win/loss ratio
- \$I\$ is the PvP item level
- \$W\_R\$, \$W\_WL\$, and \$W\_I\$ are the weights assigned to each component

Conditions:

- If \$R \geq 3000\$, then you get the max ArenaScore value

### Example Calculation (as of Retail v.10.2.7)

If the weights are set to \$W\_R = 0.5\$, \$W\_WL = 0.3\$, and \$W\_I = 0.2\$, and the target character has a PvP rating of 2000, an win/loss ratio of 1.5, and a PvP item level of 500, the PvP power score would be:

\$\$
S = 0.5 \cdot 2000 + 0.3 \cdot 1.5 + 0.2 \cdot 500 = 1000 + 0.45 + 80 = 1080.45 (~ 1080)
\$\$

The numbers used in the example are totally random!

### Why This Method?

PvP rating is by far the most important factor. Even with low item level, if your PvP rating is high, your skills should be respected. That's why rating has the highest percentage weight.

If your PvP rating is low but you have a very high item level, even though your lack of skills is evident, item level should be respected because critical strikes and total DPS output are a significant factors in PvP and they depend not only on rotation but also on the character's gear.

If a particular item is not a PvP item, we get its effective item level in the average PvP item level calculation.

## License

This project is licensed under the MIT License. See the [LICENSE](https://raw.githubusercontent.com/ldilov/arenascore/main/LICENSE) file for details.

## Acknowledgements

Special thanks to the creators of the [ACE3](https://github.com/WoWUIDev/Ace3) library.