window.MultiShippingAddress ||= { SameAsBilling: {} }

class MultiShippingAddress.SameAsBilling.CopyBillToShip
  constructor: (@$form) ->
    @findShippingAddresses()
    @bindForm()

  billAddress: null
  shippingAddresses: []

  getName: ($input) ->
    $input.attr('name').match(/.*\[(.*)\]$/)[1]

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
    @copyFormValues(address.inputs()) for address in @shippingAddresses when address.isChecked()

  copyFormValues: (addressInputs) ->
    @copyInputValue(($ input), addressInputs) for input in @billAddress

  copyInputValue: ($input, addressInputs) ->
    name = @getName $input
    addressInputs.filter("[name*=#{ name }]").val $input.val()

  getBillAddress: ->
    @billAddress =  @$form.find('#billing').find('input, select')

