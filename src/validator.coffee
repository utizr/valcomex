_ = require 'lodash'

module.exports =
	types: require './types'
	defines: {}
	define: (type, obj) ->
		@defines[type] = obj

	addType: (type) ->
		@types = _.assign @types, type

	start: (origData, schema) ->
		# if we have a schema, but the data object is not defined
		if !origData and schema
			return {
				data: undefined
				valid: false
				message: "Data is undefined"
			}

		data = _.cloneDeep(origData)
		dataOut = {}
		valid = true
		message = ""
		if _.isArray(data) and schema.ARR

			arrayValue = []
			for item in data
				result = @start({arrayField:item}, {arrayField:schema.ARR})
				arrayValue.push  result.data.arrayField if result?.data.arrayField
				valid = valid and !!result?.valid
				message += result.message+'\n' if result.message
			dataOut = arrayValue
			return {
				data: dataOut
				valid: valid
				message: message
			}

		for propName, vdtrObject of schema

			if _.isUndefined(data[propName]) and _.isUndefined(dataOut[propName])
				if vdtrObject.DEF
					result = @checkData(data[propName], 'DEF', vdtrObject.DEF)
					dataOut[propName] = result.data
					data[propName] = result.data
					valid = valid and !!result?.valid
					continue
				if vdtrObject.OPT
					continue


			for vdtrName, vdtrValue of vdtrObject
				if vdtrName in ['DEF'] then continue
				# if this is a defined validator object
				if @defines[vdtrName]
					result = @start({arrayField:data[propName]}, {arrayField:@defines[vdtrName]})
					dataOut[propName] = result.data?.arrayField
					valid = valid and !!result?.valid
					message += result.message+'\n' if result.message

				else
					# if this is a validator type
					result = @checkData(data[propName], vdtrName, vdtrValue)
					dataOut[propName] = result.data
					valid = valid and !!result?.valid
					message += result.message+'\n' if result.message

			if _.isUndefined(data[propName]) and _.isUndefined(dataOut[propName])
				if !vdtrObject.OPT
					message += "'#{propName}' does not exist. "
					valid = false

			# recursion on Object
			if _.isPlainObject(vdtrObject.OBJ) and !_.isEmpty(vdtrObject.OBJ) and _.isPlainObject(data[propName]) and !_.isEmpty(data[propName])
				result = @start(data[propName], vdtrObject.OBJ)
				dataOut[propName] = result.data if result?.data
				valid = valid and !!result?.valid
				message += result.message+'\n' if result.message

			# array recursion
			if _.isPlainObject(vdtrObject.ARR) and !_.isEmpty(vdtrObject.ARR) and _.isArray(data[propName]) and !_.isEmpty(data[propName])
				arrayValue = []
				for item in data[propName]
					result = @start({arrayField:item}, {arrayField:vdtrObject.ARR})
					arrayValue.push  result.data.arrayField if result?.data.arrayField
					valid = valid and !!result?.valid
					message += result.message+'\n' if result.message
				dataOut[propName] = arrayValue

		return {
			data: dataOut
			valid: valid
			message: message
		}

	checkData: (data, vdtrName, vdtrValue) ->
		if @types[vdtrName]?.fn and _.isFunction(@types[vdtrName]?.fn)
			result = @types[vdtrName].fn(data, vdtrValue)
			data: if result?.data then result.data else data
			valid: !!result?.valid
			message: result.message or ''
		else
			data: data
			valid: false
			message: "Validator object for #{vdtrName} not defined."

	# synomym for start
	validate: (origData, schema) ->
		@start origData, schema

	quick: (origData, schema) ->
		result = @start origData, schema
		return result.data if result.valid
		return undefined
