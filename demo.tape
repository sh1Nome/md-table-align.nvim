# Where should we write the GIF?
Output demo.gif

# Set up a 960x540 terminal with 24px font.
Set Shell bash
Set FontSize 20
Set Width 960
Set Height 540
Set Padding 0

# Type a command in the terminal.
Sleep 500ms

Type "nvim"
Sleep 500ms
Enter
Sleep 500ms

Type@10ms "i|Product|Price|Status|"
Escape
Type@10ms "o|:--|--:|:-:|"
Escape
Type@10ms "o|Laptop|150,000|Available|"
Escape
Type@10ms "o|Mouse|3,500|Available|"
Escape
Type@10ms "o|Keyboard|12,000|OutofStock|"
Escape
Sleep 500ms

Type ":MdTableAlign"
Sleep 500ms
Enter
Sleep 2000ms

