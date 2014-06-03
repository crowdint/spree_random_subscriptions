window.MultiShippingAddress ||= { SameAsBilling: {} }

class MultiShippingAddress.SameAsBilling.ToggleForm
  constructor: (@$shipAddress) ->
    @bindCheckbox()

  inputs: ->
    @$shipAddress.find('.inner').find('input, select')

  isChecked: ->
    @$shipAddress.find('input[type=checkbox]').is(':checked')

  bindCheckbox: ->
    @$shipAddress.on 'click.checkbox', '.same-as-billing', (check) =>
      @toggleAddressFields ($ check.currentTarget)

    @$shipAddress.on 'click.checkbox', '.is-a-gift', (check) =>
      @toggleGiftFields ($ check.currentTarget)

  toggleAddressFields: ($checkbox) ->
    @$shipAddress.find('.inner').
      slideToggle !$checkbox.is(':checked')

  toggleGiftFields: ($checkbox) ->
    @$shipAddress.find('.gift-fields').
      slideToggle !$checkbox.is(':checked')

