window.MultiShippingAddress ||= { SameAsBilling: {} }

class MultiShippingAddress.SameAsBilling.CopyBillToShip
  constructor: (@$form) ->
    @findShippingAddresses()
    @bindForm()

  shippingAddresses: []

  bindForm: ->
    @$form.on 'submit', =>
      @copyBillAddress()
      false

  findShippingAddresses: ->
    shippingAddresses = @$form.find('.js-shipping-address')
    @createToggleForm(address) for address in shippingAddresses

  createToggleForm: (address) ->
    @shippingAddresses.push(new MultiShippingAddress.SameAsBilling.ToggleForm ($ address))

  copyBillAddress: ->
    console.log @shippingAddresses
    console.log 'waka'


