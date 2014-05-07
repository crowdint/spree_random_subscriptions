window.MultiShippingAddress ||= { SameAsBilling: {} }

class MultiShippingAddress.SameAsBilling.ToggleForm
  constructor: (@$shipAddress) ->
    @bindCheckbox()

  isChecked: ->
    @$shipAddress.find('input[type=checkbox]').attr('checked')

  bindCheckbox: ->
    @$shipAddress.on 'click.checkbox', 'input[type=checkbox]', (check) =>
      @toggleAddressFields ($ check.currentTarget)

  toggleAddressFields: ($checkbox) ->
    @$shipAddress.find('.inner').
      toggle $checkbox.attr('checked')

