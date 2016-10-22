_ = require 'lodash'

### Types:
	STR - "String type, does not modify content."
	NUM - "Number type. If number is string if will be converted to number when possible."
	INT - "Integer type."
	BOOL - "Check boolean type."
	DT - "Check iso date"
	OBJ - "Check if type is object. Recursion is automatic in the app in case of object, and array."
	ARR - "Check if type is array. Recursion is automatic in the app in case of object, and array."

	OPT - "Optional"
	REG - "Regular expression."
	DEF - "Fefined value, only checks if value exists or not, and returns defined value, or result of provided function."
	LT - Lower than. This can be used for numbers and arrays.
	GT - Greater than. This can be used for numbers and arrays.
	IN - In an array. Array has to be supplied in the options
###

regexISO8601 = /^(\d{4}-[01]\d-[0-3]\d)[ T]([0-2]\d:[0-5]\d:[0-5]\d)(\.\d+)?([+-][0-2]\d:?[0-5]\d|Z)?$/

isNumberString = (value) ->
	return true if _.isNumber value
	return true if _.isString(value) and value == +value + ''
	return false

module.exports =
	STR:
		desc: "String type, does not modify content."
		fn: (data, options) ->
			if _.isString(data)
				data: data
				valid: true
				message: ''
			else
				data: data
				valid: false
				message: 'Data is not a String!'

	NUM:
		desc: "Number type. If number is string, it will be converted to number when possible."
		fn: (data, options) ->
			if isNumberString(data)
				data: +data
				valid: true
				message: ''
			else
				data: data
				valid: false
				message: 'Data is not a Number!'

	INT:
		desc: "Integer type. If number is string it will be converted to number when possible."
		fn: (data, options) ->
			if _.isInteger(+data)
				data: +data
				valid: true
				message: ''
			else
				data: data
				valid: false
				message: 'Data is not a Integer!'

	BOOL:
		desc: "Check boolean type."
		fn: (data, options) ->
			if _.isBoolean(data)
				data: data
				valid: true
				message: ''
			else
				data: data
				valid: false
				message: 'Data is not a Boolean!'

	DT:
		desc: 'ISO8601 date.'
		fn: (data, options) ->
			if typeof data == 'string' && data.match(regexISO8601)
				data: data
				valid: true
				message: ''
			else
				data: data
				valid: false
				message: 'Data does not match ISO 8601 date-time format'

	OBJ:
		desc: "Check if type is object. Recursion is automatic in the app in case of object, and array."
		fn: (data, options) ->
			if _.isPlainObject(data)
				data: data
				valid: true
				message: ''
			else
				data: data
				valid: false
				message: 'Data is not an Object!'

	ARR:
		desc: "Check if type is array. Recursion is automatic in the app in case of object, and array."
		fn: (data, options) ->
			if _.isArray(data)
				data: data
				valid: true
				message: ''
			else
				data: data
				valid: false
				message: 'Data is not an Array!'
	OPT:
		desc: "Optional property." # no fn needed, it will be handled in app
		fn: (data, options) ->
			data: data
			valid: true
			message: ''

	REG:
		desc: "Match regular expression."
		fn: (data, options) ->
			if options.test(data)
				data: data
				valid: true
				message: ''
			else
				data: data
				valid: false
				message: 'Regex failed!'

	DEF:
		desc: "Defined value, only checks if value exists or not, and returns defined value, or result of provided function"
		fn: (data, options) ->
			if _.isFunction(options)
				newData = options(data)
			else if options
				newData = options
			return {
				data: newData
				valid: true
				message: ''
			}
			
	EQ:
		desc: "Check if value is equal to the supplied one."
		fn: (data, options) ->
			if data isnt options
				return Object
					data: undefined
					valid: false
					message: 'Data does not equal option.'
			else
				return Object
					data: data
					valid: true
					message: ''
				
	LT:
		desc: "Lower than."
		fn: (data, options) ->
			if isNumberString(data)
				if +data < options
					data: +data
					valid: true
					message: ''
				else
					data: data
					valid: false
					message: 'LT failed!'
			else if _.isString(data) or _.isArray(data)
				if data.length < options
					data: data
					valid: true
					message: ''
				else
					data: data
					valid: false
					message: 'LT failed!'
			else
				data: data
				valid: false
				message: 'LT failed!'
				
	GT:
		desc: "Greater than."
		fn: (data, options) ->

			if isNumberString(data)
				if +data > options
					data: +data
					valid: true
					message: ''
				else
					data: data
					valid: false
					message: 'GT failed for isNumberString! ' + data + ' >? ' + options
			else if _.isString(data) or _.isArray(data)
				if data.length > options
					data: data
					valid: true
					message: ''
				else
					data: data
					valid: false
					message: 'GT failed for string/array!'
			else
				data: data
				valid: false
				message: 'GT failed!'

	IN:
		desc: "Value is in the specified array"
		fn: (data, options) ->
			if _.isArray(options)
				if data in options
					data: data
					valid: true
					message: ''
				else
					data: data
					valid: false
					message: 'IN failed!'
			else
				data: data
				valid: false
				message: 'IN failed!'
				
				
	NIN:
		desc: "Value is not in the specified array"
		fn: (data, options) ->
			if _.isArray(options)
				if data not in options
					data: data
					valid: true
					message: ''
				else
					data: data
					valid: false
					message: 'NIN failed!'
			else
				data: data
				valid: false
				message: 'NIN failed!'
