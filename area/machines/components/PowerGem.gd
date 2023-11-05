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
	return "A faceted, glowing gemstone. Some of the ancient equipment has slots where these can be " + \
		"inserted, affecting how the equipment functions. Hue: %s, luminance: %s, size: %s, hardness: %s, clarity: %s" % [
		CatalogueMgr.getPropertyDescriptor("hue", props["hue"]),
		CatalogueMgr.getPropertyDescriptor("luminance", props["luminance"]),
		CatalogueMgr.getPropertyDescriptor("size", props["size"]),
		CatalogueMgr.getPropertyDescriptor("hardness", props["hardness"]),
		CatalogueMgr.getPropertyDescriptor("clarity", props["clarity"]),
	]
