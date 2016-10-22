expect = require('chai').expect

validator = require '../src/'

describe 'Validator', () ->


	it 'validate simple object', (done) ->
		vDefinition =
			name: STR: 1

		vData =
			name: "John"

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true
		expect(result.data).to.be.an('object')
		expect(result.data.name).to.equal(vData.name)
		done()
		
		
	it 'array of numbers with a string-numer should be converted to number', (done) ->
		vDefinition = ARR: NUM: 1

		vData = [1,2,3,"4"]

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true
		expect(result.data).to.be.an('array')
		for num in result.data
			expect(num).to.be.a('number')
		done()
		
	it 'array of numbers with a string should fail', (done) ->
		vDefinition = ARR: NUM: 1

		vData = [1,2,3,"foo"]

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false
		done()

	it 'find not number', (done) ->
		vDefinition =
			number: NUM: 1

		vData =
			number: "John"

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false
		done()
		
	it 'find not integer (string)', (done) ->
		vDefinition =
			number: INT: 1

		vData =
			number: "erer"

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false
		done()

	it 'find not integer (float)', (done) ->
		vDefinition =
			number: INT: 1

		vData =
			number: 31.32

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false
		done()


	it 'use the app with validate (synonym for start)', (done) ->
		vDefinition =
			name: STR: 1

		vData =
			name: "John"

		result = validator.validate(vData, vDefinition)

		expect(result.valid).to.be.true
		expect(result.data).to.be.an('object')
		expect(result.data.name).to.equal(vData.name)
		done()


	it 'validate fail without validator type', (done) ->
		vDefinition =
			name: XXX: 1

		vData =
			name: "John"

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false
		done()

	it 'validate fail with empty data object', (done) ->
		vDefinition =
			name: STR: 1

		vData = {}

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false
		done()

	it 'validate fail with undefined data object', (done) ->
		vDefinition =
			name: STR: 1

		vData = undefined

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false
		done()

	it 'validate simple array', (done) ->
		vDefinition = ARR: STR: 1

		vData = ["John", "Jane"]

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true
		expect(result.data).to.be.an('array')
		expect(JSON.stringify result.data).to.equal(JSON.stringify  vData)
		done()

	it 'validate date', (done) ->
		vDefinition =
			date: DT: 1

		vData =
			date: '2016-06-16 08:37:37'

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true
		done()
		
	it 'fail on invalid date', (done) ->
		vDefinition =
			date: DT: 1

		vData =
			date: '2016-06-16 today'

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false
		done()
		
	it 'validate complex object', (done) ->
		vDefinition =
			id: NUM: 1
			integer: INT: 1
			title: STR: 1
			deleted: BOOL: 1
			tags: ARR: STR: 1
			today: DT: 1
			address: OBJ:
				street: STR: 1
				houseNumber: NUM: 1
				city: STR: 1
				country: STR: 1
			contacts: ARR: OBJ:
				name: STR: 1
				phone: STR: 1

		vData =
			id: 232
			integer: 9001
			title: "This is a title"
			deleted: false
			tags: ["foo","bar","zig"]
			today: '2016-06-16 08:37:37'
			address:
				street: "Fifth Street"
				houseNumber: 12
				city: "New York"
				country: "USA"
			contacts: Array
				name: "John"
				phone: "+ 32 4245366"
			,
				name: "Sophie"
				phone: "+ 32 2425453"

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true
		expect(result.data).to.be.an('object')
		expect(result.data.id).to.equal(vData.id)
		expect(result.data.integer).to.equal(vData.integer)
		expect(result.data.title).to.equal(vData.title)
		expect(result.data.today).to.equal(vData.today)
		expect(JSON.stringify result.data.tags).to.equal(JSON.stringify vData.tags)
		expect(JSON.stringify result.data.address).to.equal(JSON.stringify vData.address)
		expect(JSON.stringify result.data.contacts).to.equal(JSON.stringify vData.contacts)

		done()

	it 'find not boolean', (done) ->
		vDefinition =
			deleted: BOOL: 1

		vData =
			deleted: null

		result = validator.start(vData, vDefinition)
		expect(result.valid).to.be.false
		done()

	it 'find not string', (done) ->
		vDefinition =
			title: STR: 1

		vData =
			title: 23

		result = validator.start(vData, vDefinition)
		expect(result.valid).to.be.false
		done()

	it 'find not number', (done) ->
		vDefinition =
			age: NUM: 1

		vData =
			age: '33et'

		result = validator.start(vData, vDefinition)
		expect(result.valid).to.be.false
		done()

	it 'find not array', (done) ->
		vDefinition =
			age: ARR: 1

		vData =
			age: 'text'

		result = validator.start(vData, vDefinition)
		expect(result.valid).to.be.false
		done()

	it 'find not array 2', (done) ->
		vDefinition =
			age: ARR: 1

		vData =
			age: {}

		result = validator.start(vData, vDefinition)
		expect(result.valid).to.be.false
		done()

	it 'validate array', (done) ->
		vDefinition =
			age: ARR: 1

		vData =
			age: []

		result = validator.start(vData, vDefinition)
		expect(result.valid).to.be.true
		done()

	it 'validate object', (done) ->
		vDefinition =
			age: OBJ: 1

		vData =
			age: {}

		result = validator.start(vData, vDefinition)
		expect(result.valid).to.be.true
		done()

	it 'find not object 2', (done) ->
		vDefinition =
			age: OBJ: 1

		vData =
			age: []

		result = validator.start(vData, vDefinition)
		expect(result.valid).to.be.false
		done()

	it 'convert string numbers to numbers', (done) ->
		vDefinition =
			id: NUM: 1
			houseNumber: NUM: 1

		vData =
			id: 232
			houseNumber: "23"

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true
		expect(result.data).to.be.an('object')
		expect(result.data.id).to.equal(vData.id)
		expect(result.data.houseNumber).to.equal(23)
		done()

	it 'empty object maps to null validator', (done) ->

		vDefinition = null

		vData = undefined

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true
		done()

	it 'define new simple validator definition', (done) ->

		validator.define 'EMAIL', REG: /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/

		vDefinition =
			email: EMAIL: 1

		vData =
			email: "john@doe.com"


		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true
		expect(result.data.email).to.equal vData.email

		vDefinition =
			email: EMAIL: 1

		vData =
			email: "johndoe.com"


		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false
		done()

	it 'define new simple validator definition 2', (done) ->

		validator.addType
			is_car:
				desc: "check if variable is 'car'."
				fn: (data, options) ->
					if data is "car"
						data: data
						valid: true
						message: ''
					else
						valid: false
						message: 'data is not "car"'

		vDefinition =
			title: is_car: 1

		vData =
			title: "car"


		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true
		expect(result.data.title).to.equal "car"

		vData =
			title: "truck"

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false
		done()

	it 'define new complex (object) validator definition', (done) ->

		validator.define 'ADDRESS',
			OBJ:
				street: STR: 1
				houseNumber: NUM: 1
				postcode: NUM: 1
				city: STR: 1

		vDefinition =
			address: ADDRESS: 1

		vData =
			address:
				street: 'Jozef Straat'
				houseNumber: '23'
				postcode: 2421
				city: 'Antwerpen'


		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true
		expect(result.data.address.houseNumber).to.equal 23

		vData =
			address:
				street: 'Jozef Straat'
				houseNumber: '23'
				postcode: 2421

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false
		done()

	it 'use quick validation', (done) ->

		vDefinition =
			name: STR: 1

		vData =
			name: "John"

		vDataNew = validator.quick(vData, vDefinition)

		expect(vDataNew).to.be.defined
		expect(vDataNew.name).to.equal "John"

		vData =
			title: "John"

		vDataNew = validator.quick(vData, vDefinition)

		expect(vDataNew).to.be.undefined

		done()

	it 'define new validator type that acts as default value', (done) ->

		validator.addType
			UUID:
				desc: "UUID generation."
				fn: (data, options) ->
					# here we could add eg :
					# data: require("uuid-js").create().toString()
					data: "f12ee86d-77a9-4e2f-9d37-55f4194677bf"
					valid: true
					message: ''

		vDefinition =
			uuid: UUID: 1
			name: STR: 1

		vData =
			name: "John"


		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true
		expect(result.data.uuid).to.equal "f12ee86d-77a9-4e2f-9d37-55f4194677bf"
		done()

	it 'default value', (done) ->

		vDefinition =
			uuid: STR: 1, DEF: "f12ee86d-77a9-4e2f-9d37-55f4194677bf"
			name: STR: 1

		vData =
			name: "John"


		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true
		expect(result.data.uuid).to.equal "f12ee86d-77a9-4e2f-9d37-55f4194677bf"
		done()

	it 'default value should not overwrite existing data', (done) ->

		vDefinition =
			uuid: DEF: "f12ee86d-77a9-4e2f-9d37-55f4194677bf", STR: 1

		vData =
			uuid: "xxx"

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true
		expect(result.data.uuid).to.equal "xxx"
		done()

	it 'default value from function', (done) ->

		createUUID = (data) ->
			# here we could add eg :
			# data: require("uuid-js").create().toString()
			"f12ee86d-77a9-4e2f-9d37-55f4194677bf"

		vDefinition =
			uuid: DEF: createUUID

		vData =
			name: "122"


		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true
		expect(result.data.uuid).to.equal "f12ee86d-77a9-4e2f-9d37-55f4194677bf"
		done()


	it 'filter out properties not in the validator definition', (done) ->

		vDefinition =
			name: STR: 1

		vData =
			name: "John"
			title: "Mr"


		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true
		expect(result.data.name).to.equal vData.name
		expect(result.data.title).to.be.undefined
		done()

	it 'handle optional properties', (done) ->

		vDefinition =
			name: STR: 1
			test: OBJ:
				lastName: OPT: 1, STR: 1
				gender: OPT: 1, STR: 1

		vData =
			name: "John"
			test:
				lastName: 'Doe'

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true
		expect(result.data.name).to.equal vData.name
		expect(result.data.test.lastName).to.equal 'Doe'
		expect(result.data.test.gender).to.be.undefined
		done()

	it 'EQ string', (done) ->
		vDefinition =
			name: STR: 1, EQ: 'John Doe'

		vData =
			name: "John Doe"

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true

		done()
		
	it 'EQ number', (done) ->
		vDefinition =
			count: NUM: 1, EQ: 3

		vData =
			count: 3

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true

		done()
		
	it 'EQ string fail if not equal', (done) ->
		vDefinition =
			name: STR: 1, EQ: 'John Doe'

		vData =
			name: "Jane Doe"

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false

		done()

	it 'GT string', (done) ->
		vDefinition =
			name: STR: 1, GT: 4

		vData =
			name: "My String"

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true

		vDefinition =
			name: STR: 1, GT: 4

		vData =
			name: "My"

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false

		done()

	it 'LT string', (done) ->
		vDefinition =
			name: STR: 1, LT: 4

		vData =
			name: "My"

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true

		vDefinition =
			name: STR: 1, LT: 4

		vData =
			name: "My String"

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false

		done()

	it 'GT number', (done) ->
		vDefinition =
			year: NUM: 1, GT: 2004

		vData =
			year: 2015

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true

		vDefinition =
			year: NUM: 1, GT: 2020

		vData =
			year: 2015

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false

		done()

	it 'LT number', (done) ->
		vDefinition =
			year: NUM: 1, LT: 2020

		vData =
			year: 2015

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true

		vDefinition =
			year: NUM: 1, LT: 2004

		vData =
			year: 2015

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false

		done()

	it 'GT array', (done) ->
		vDefinition =
			tags: GT: 2, ARR: STR: 1

		vData =
			tags: ["foo", "bar", "zig"]

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true

		vDefinition =
			tags: GT: 5, ARR: STR: 1

		vData =
			tags: ["foo", "bar", "zig"]

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false

		done()

	it 'GT should fail on object', (done) ->
		vDefinition =
			tags: OBJ: 1, GT: 2

		vData =
			tags: {foo: 'bar'}

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false

		done()

	it 'LT array', (done) ->
		vDefinition =
			tags: ARR: STR: 1, LT: 4

		vData =
			tags: ["foo", "bar", "zig"]

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true

		vDefinition =
			tags: ARR: STR: 1, LT: 2

		vData =
			tags: ["foo", "bar", "zig"]

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false

		done()

	it 'LT should fail on object', (done) ->
		vDefinition =
			tags: OBJ: 1, LT: 2

		vData =
			tags: {foo: 'bar'}

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false

		done()

	it 'IN array', (done) ->
		vDefinition =
			title: STR: 1, IN: ["foo", "bar", "zig"]

		vData =
			title: "foo"

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true

		vData =
			title: "xxx"

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false

		done()
		

	it 'IN should fail if input is not an array', (done) ->
		vDefinition =
			title: STR: 1, IN: "not an array"

		vData =
			title: "xxx"

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false

		done()

	it 'NIN should', (done) ->
		vDefinition =
			title: STR: 1, NIN: ["foo", "bar", "zig"]

		vData =
			title: "buzz"

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.true

		done()
		
	it 'NIN array fail', (done) ->
		vDefinition =
			title: STR: 1, NIN: ["foo", "bar", "zig"]

		vData =
			title: "foo"

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false

		done()
		
	it 'NIN fail on not array', (done) ->
		vDefinition =
			title: STR: 1, NIN: "things"

		vData =
			title: "foo"

		result = validator.start(vData, vDefinition)

		expect(result.valid).to.be.false

		done()


