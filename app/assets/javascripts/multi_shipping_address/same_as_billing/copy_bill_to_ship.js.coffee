window.MultiShippingAddress ||= {}
$.extend(MultiShippingAddress, { SameAsBilling: {} })

class MultiShippingAddress.SameAsBilling.CopyBillToShip
  constructor: (@$form) ->
    @findShippingAddresses()
    @bindForm()
    @bindCountrySelects()

  billAddress: null
  shippingAddresses: []

  getName: ($input) ->
    $input.attr('name').match(/.*\[(.*)\]$/)[1]

  bindForm: ->
    @$form.on 'submit', =>
      @getBillAddress()
      @copyBillAddress()

  bindCountrySelects: ->
    $('.js-shipping-address select.country').on 'change', (e) ->
      id = $(e.currentTarget).parent().attr('id').match(/\d+/);
      Spree.updateState "#{ id }-address"

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
    addressInputs.filter("[name*=#{ name }]").val( $input.val() ).change()

  getBillAddress: ->
    @billAddress =  @$form.find('#billing').find('input, select')

