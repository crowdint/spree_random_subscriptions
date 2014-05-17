#= require multi_shipping_address/same_as_billing/toggle_form

describe 'ToggleForm', ->
  window.subject = null

  beforeEach ->
    fixture.load 'form'
    window.subject = new MultiShippingAddress.SameAsBilling.ToggleForm($('#checkout_form_address'))

  describe '#$shipAddress', ->

    it 'is defined', ->
      expect(subject.$shipAddress).toBeDefined()

  describe '#inputs', ->

    it 'returns an array with all inputs and selects', ->
      expect(subject.inputs().length).toEqual(4)

  describe '#isChecked', ->

    it 'returns the value of the checkbox', ->
      expect(subject.isChecked()).toBeTruthy()

  describe '#toggleAddressFields', ->

    it 'changes the slideToggle effect', ->
      subject.toggleAddressFields($('input[type=checkbox]'))
      expect(subject.$shipAddress.find('input[type=checkbox]').is('checked')).
        toBeFalsy()

