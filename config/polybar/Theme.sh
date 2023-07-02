#!/bin/env bash
#  ╔═════════════╗ drop 󰚌 Redd's ═════════ *
#  ║   ▄█████▄   ║ ╔╦═╗╔═╗╔╦╗╔╦═╗╔═╗╔╦╗╔╗╔ ║    
#  ║  ▄███████▄  ║  ║ ║║ ║ ║  ║ ║║ ║║║║║║║ ║    
#  ║  ██  █  ██  ║  ║ ║║ ║ ║  ║ ║╠═╣║║║║║║ ║    
#  ║   ███████   ║  ║ ║║ ║ ║  ║ ║║ ║║║║║║║ ║    
#  ║    █ █ █    ║ ═╩═╝╚═╝ ╩ ═╩═╝╩ ╩╩ ╩╝╚╝ ║     
#  ╚═════════════╝ ══════════════ DOTFILES *    
#  https://github.com/dropdeadredd/.dotdamn    
#
#  DropDead Theme config settings & polybar
#


# Set Terminal Colors
set_term_config() {
    sed -i "$HOME"/.config/alacritty/fonts.yml \
		-e "s/family: .*/family: sfmono Nerd Font mono/g" \
		-e "s/size: .*/size: 10/g"

    cat > "$HOME"/.config/alacritty/colors.yml <<- _EOF_
				# Colors (vintage-dropdead) dropdead
				colors:
				   	primary:
      					background: "#0C0C0C"
      					foreground: "#C9C9C9"
    				cursor:
      					text: "#0C0C0C"
      					cursor: "#EE9B00"
    				selection:
      					text: "#0C0C0C"
      					background: "#94D2BD"
    				normal:
      					black: "#4B4B4B"
      					red: "#EE9B00"
      					green: "#90BE6D"
     					yellow: "#AE2012"
     					blue: "#94D2BD"
    					magenta: "#005F73"
      					cyan: "#E9D8A6"
      					white: "#C9C9C9"
    				bright:
      					black: "#6B6B6B"
    					red: "#EDAB2F"
      					green: "#A2C786"
      					yellow: "#BA483D"
      					blue: "#A5D7C6"
      					magenta: "#2F7B8B"
      					cyan: "#E9DBB3"
      					white: "#E9E9E9"
    				dim:
      					black: "#2C2C2C"
      					red: "#C17E02"
    					green: "#769A5A"
      					yellow: "#8E1C11"
     					blue: "#79AA9A"
      					magenta: "#024E5E"
      					cyan: "#BDAF87"
      					white: "#AAAAAA"
_EOF_
}

# Set compositor configuration
set_picom_config() {
			sed -i "$HOME"/.config/bspwm/picom.conf \
			-e "s/normal = .*/normal =  { fade = true; shadow = true; };/g" \
			-e "s/shadow-color = .*/shadow-color = \"#000000\"/g" \
			-e "s/corner-radius = .*/corner-radius = 6/g" \
			-e "s/\".*:class_g = 'alacritty'\"/\"85:class_g = 'Alacritty'\"/g" \
			-e "s/\".*:class_g = 'FloaTerm'\"/\"100:class_g = 'FloaTerm'\"/g"
}

# Set dunst notification daemon config
set_dunst_config() {
		sed -i "$HOME"/.config/bspwm/dunstrc \
			-e "s/transparency = .*/transparency = 0/g" \
			-e "s/frame_color = .*/frame_color = \"#252525\"/g" \
			-e "s/separator_color = .*/separator_color = \"#EA6F6F\"/g" \
			-e "s/font = .*/font = JetBrainsMono Nerd Font Medium 9/g" \
			-e "s/foreground='.*'/foreground='#9bced7'/g"
		sed -i '/urgency_low/Q' "$HOME"/.config/bspwm/dunstrc
		cat >> "$HOME"/.config/bspwm/dunstrc <<- _EOF_
				
				[urgency_low]o
				timeout = 3
				background = "#1f1d29"
				foreground = "#eaeaea"

				[urgency_normal]
				timeout = 6
				background = "#1f1d29"
				foreground = "#eaeaea"

				[urgency_critical]
				timeout = 0
				background = "#1f1d29"
				foreground = "#eaeaea"
_EOF_
}

# Launch the bar and or eww widgets
launch_bars() {
	polybar -q bspwm -c /home/ddrx/.config/bspwm/polybar/config.ini &
	polybar -q stats -c /home/ddrx/.config/bspwm/polybar/config.ini & 
	
}

# run Functions
set_term_config
set_dunst_config
launch_bars

if [ ! -f "$HOME"/.config/bspwm/picom.conf.old ]; then
	set_picom_config
fi


