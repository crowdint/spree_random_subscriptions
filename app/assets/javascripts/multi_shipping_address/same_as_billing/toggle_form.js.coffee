window.MultiShippingAddress ||= { SameAsBilling: {} }

class MultiShippingAddress.SameAsBilling.ToggleForm
  constructor: (@$shipAddress) ->
    @bindCheckbox()

  inputs: ->
    @$shipAddress.find('.inner').find('input, select')

  isChecked: ->
    @$shipAddress.find('input[type=checkbox]').is(':checked')

  bindCheckbox: ->
    @$shipAddress.on 'click.checkbox', 'input[type=checkbox]', (check) =>
      @toggleAddressFields ($ check.currentTarget)

  toggleAddressFields: ($checkbox) ->
    @$shipAddress.find('.inner').
      slideToggle !$checkbox.is(':checked')

