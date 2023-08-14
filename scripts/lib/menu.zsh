# vim: fdm=marker fmr=〈,〉

menu=()
tint='terminal'

item() {
	menu+=("#[fg=$tint]$1" "$2" "$3")
}

popup() {
	item "$1" "$2" "display-popup -E -w70% -h80% \"$3\""
}

shell() {
	item "$1" "$2" "run-shell '$3'"
}

script() { 
	shell "$1" "$2" "${scripts_dir}/$3"
}

nl() { 
	menu+=('- ' '-' '-')
}

# $1: title
# $2: title alignment
# $3: left bar length
# $4: right bar length
sep() { 
	local left=$(printf '―%.0s' {1..${3:-8}})
	local right=$(printf '―%.0s' {1..${4:-8}})
	local align="${2:-centre}"
	menu+=("-#[align=$align]$left $1 $right" '-' '-')
}

# $1: title
sep1() { 
	local left=$(printf ' %.0s' {1..$(( 22 - $#1 ))})
	menu+=("-$left#[fg=$tint,bg=default,nodim]#[fg=black,bg=$tint,nodim] $1 " '-' '-')
}

