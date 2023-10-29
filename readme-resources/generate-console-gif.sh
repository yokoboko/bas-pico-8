
#!/usr/bin/env bash
#brew install imagemagick

cd "$(dirname "$0")"
convert ./console.gif -coalesce null: bas.gif -gravity center -layers composite console_game_composition.gif
