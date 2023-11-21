extends Node

var propertyDescriptors = {
	"luminance": [["matte","dark","pale"],["faint","subdued","gentle"],["dim","dull","gloomy"],["murky","obscure","shadowy"],["muted","soft","pale"],["moderate","average","medium"],["gleaming","shining","vivid"],["iridescent","shimmering"],["bright","brilliant"],["luminous","glowing","vibrant"],["dazzling","intense"],["blinding","radiant"]],
	"hardness": [["gelatinous", "semi-solid", "viscous"],
		["yielding", "flexible"],
		["malleable", "pliable"],
		["chalky", "powdery", "crumbly"],
		["flexible", "yielding"],
		["springy", "resilient"],
		["firm", "stiff"],
		["rigid", "inflexible", "hard"],
		["solid", "dense"],
		["tough", "durable", "robust"],
		["unyielding", "rigid", "inflexible"],
		["adamantine", "indestructible", "unbreakable"]],
	"hue": ["red", "orange", "yellow", "chartreuse", "green", "spring green", "cyan", "azure", "blue", "violet", "magenta", "rose"],
	"clarity": ["opaque", "cloudy", "occluded", "milky", "hazy", "frosted", "misted", "translucent", "semitransparent", "slightly included", "transparent", "crisp", "flawless", "pristine"],
	"size": ["miniscule", "petite", "compact", "small", "modest", "average", "sizeable", "large", "massive", "enormous", "gigantic"],
	"saturation": ["pale", "muted", "soft", "vivid", "bold", "intense"]
}

func _init():
	choosePropertyDescriptors()

func choosePropertyDescriptors():
	var i = 0
	for propertyName in propertyDescriptors:
		propertyDescriptors[propertyName] = propertyDescriptors[propertyName].map(func(opts):
			if opts is String:
				return opts
			i += 1
			return opts[Rand.stableInt(i) % opts.size()]
		)

func getPropertyDescriptor(property:String, value:float):
	value = clampf(value, 0, 0.9999999)
	var arr = propertyDescriptors.get(property, ["unknown"])
	return arr[floor(value * arr.size())]

const anLetters = {"a":"an", "e":"an", "i": "an", "o": "an", "u": "an"}
## Returns either 'a' or 'an' based on the first letter of the string passed
func an(str:String) -> String:
	return anLetters.get(str[0].to_lower(), "a")
	
## Returns either 'a' or 'an' based on the first letter of the string passed
func An(str:String) -> String:
	return anLetters.get(str[0].to_lower(), "A").capitalize()
	
