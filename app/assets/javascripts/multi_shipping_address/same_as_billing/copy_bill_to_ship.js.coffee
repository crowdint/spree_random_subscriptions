window.MultiShippingAddress ||= { SameAsBilling: {} }

class MultiShippingAddress.SameAsBilling.CopyBillToShip
  constructor: (@$form) ->
    @findShippingAddresses()
    @bindForm()

  formValues: [
    'firstname', 'lastname', 'address1',
    'address2', 'city', 'country_id', 'state_id',
    'zipcode', 'phone'
  ]

  shippingAddresses: []
  billAddress: null

  bindForm: ->
    @$form.on 'submit', =>
      @getBillAddress()
      @copyBillAddress()

  findShippingAddresses: ->
    shippingAddresses = @$form.find('.js-shipping-address')
    @createToggleForm(address) for address in shippingAddresses

  createToggleForm: (address) ->
    @shippingAddresses.push(new MultiShippingAddress.SameAsBilling.ToggleForm ($ address))

  copyBillAddress: ->
    @copyValues(address.inputs()) for address in @shippingAddresses when address.isChecked()

  copyValues: (addressInputs) ->
    for value in @formValues
      do (value) =>
        query = "[name*=#{ value }]"
        billValue = @billAddress.filter(query).val()
        addressInputs.filter(query).val billValue

  getBillAddress: ->
    @billAddress =  @$form.find('#billing').find('input, select')

