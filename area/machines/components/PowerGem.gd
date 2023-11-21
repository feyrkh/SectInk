extends MachineComponent
class_name PowerGem

func generateOverrideProps(props:Dictionary):
	resetNextRandomNumber(1250)
	props["hardness"] = getNextRandomNumber()
	props["luminance"] = getNextRandomNumber()
	props["hue"] = getNextRandomNumber()
	props["clarity"] = getNextRandomNumber()
	props["size"] = getNextRandomNumber()
	props["saturation"] = getNextRandomNumber()


func getDescription():
	return "%s %s %s stone of %s %s. It has %s %s glow about it. Some of the ancient equipment has slots where these can be \
		inserted, affecting how the equipment functions. " % [
		PropertyMgr.An(PropertyMgr.getPropertyDescriptor("size", props["size"])),
		PropertyMgr.getPropertyDescriptor("size", props["size"]),
		PropertyMgr.getPropertyDescriptor("hardness", props["hardness"]),
		PropertyMgr.getPropertyDescriptor("clarity", props["clarity"]),
		PropertyMgr.getPropertyDescriptor("hue", props["hue"]),
		PropertyMgr.an(PropertyMgr.getPropertyDescriptor("luminance", props["luminance"])),
		PropertyMgr.getPropertyDescriptor("luminance", props["luminance"]),
	]
