window.MultiShippingAddress ||= {}
$.extend(MultiShippingAddress, { Helpers: {} })

class MultiShippingAddress.Helpers.ToggleAddress
  constructor: ->
    ($ ".display-address").on 'click', (event) => @toggleAddress(event)

  toggleAddress: (event) ->
    event.preventDefault()
    @$link = ($ event.target)
    @$address =  ($ @$link.attr 'href')
    @$address.slideToggle => @updateText()

  updateText: ->
    text = @$address.is(':visible') and '(hide)' or '(show)'
    @$link.text text

