extends StatFunction
class_name ExpressionStatFunction

static var STAT_NAME_REGEX:RegEx
static var ZERO_STAT_OBJ:RegeneratingStat

## Either a static float value, or an Expression describing the minimum value required for the stat.
## If the expr passed to the constructor is a float, it is used as a static value.
## If it's a string, any strings that look like variable names will be extracted via regex and
## we'll try to use them as Stat objects inside of the overall expression.
## ex: a value of 53.1 means that the stat referenced by this function must be >= 53.1 to pass 'check'
## ex: a value of "53.1 * (0.5 if $muscleStrength.value > 100 else 1.0)" will halve the min requirement if 
##     user.muscleStrength.value is greater than 100, otherwise it's full cost
var expr
var originalExpr
## Internal use only, this holds the order of the stats in the expression, if any
var requiredVars:Array

func _init(statName:String, expr:Variant):
	if ZERO_STAT_OBJ == null:
		ZERO_STAT_OBJ = RegeneratingStat.new("zero", 0, 0, 0, 0)
	if STAT_NAME_REGEX == null:
		STAT_NAME_REGEX = RegEx.new()
		STAT_NAME_REGEX.compile("\\$([a-zA-Z0-1_]+)")
	super(statName)
	self.originalExpr = expr	
	if expr is String:
		self.expr = parse_min_value_expression(expr)
	else:
		self.expr = expr

func parse_min_value_expression(exprStr:String):
	print("Initial expression: %s" % exprStr)
	var matches:Array[RegExMatch] = STAT_NAME_REGEX.search_all(exprStr)
	requiredVars = matches.map(
		func(item:RegExMatch):
			return item.get_string(1)
	)
	for param in requiredVars:
		exprStr = exprStr.replace("$%s" % param, param)
	print("Final expression: %s" % exprStr)
	expr = Expression.new()
	expr.parse(exprStr, requiredVars)
	return expr

## Returns 'true' if the statHolder has a stat of the correct name with a value > our threshold
func check(statHolder):
	var statObj = statHolder.get(statName)
	if statObj == null: 
		statObj = ExpressionStatFunction.ZERO_STAT_OBJ
	var statValue:float = statObj.value
	var exprValue = getValue(statHolder)
	if exprValue is float || exprValue is int:
		return statValue >= exprValue
	elif exprValue is bool:
		return exprValue
	else:
		push_error("Invalid return value from expression in required min stat function: "+str(exprValue))
		return false

func getValue(statHolder):
	var statObj:Stat = statHolder.get(statName)
	if statObj == null: 
		statObj = ExpressionStatFunction.ZERO_STAT_OBJ
	if expr is float || expr is int:
		return expr
	elif expr is Expression:
		var inputValues = requiredVars.map(func(varName):
			var requiredVarStatObj:Stat = statHolder.get(varName)
			if !requiredVarStatObj: return ZERO_STAT_OBJ
			return requiredVarStatObj
		)
		var calculatedExpr = expr.execute(inputValues, statObj)
		if expr.has_execute_failed() or calculatedExpr == null:
			push_error("Error evaluating stat function `%s`: %s" %  [originalExpr, expr.get_error_text()])
			return 0.0
		return calculatedExpr
	else:
		push_error("Invalid expr in required min stat function: "+str(expr))
		return 0.0
