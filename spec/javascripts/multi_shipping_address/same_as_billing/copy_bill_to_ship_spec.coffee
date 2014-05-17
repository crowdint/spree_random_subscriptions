#= require multi_shipping_address/same_as_billing/copy_bill_to_ship

describe 'CopyBillToShip', ->
  window.subject = null

  beforeEach ->
    fixture.load 'form'
    window.subject = new MultiShippingAddress.SameAsBilling.CopyBillToShip($('#checkout_form_address'))

  it 'expects #$form to be defined', ->
    expect(subject.$form).toBeDefined()

  it 'expects #billAddress to be null', ->
    expect(subject.billAddress).toBeNull()

  it 'expects #shippingAddress to have elements', ->
    expect(subject.shippingAddresses).not.toEqual([])

  describe '#getName', ->

    it 'gets the name of the element', ->
      input = subject.shippingAddresses[0].$shipAddress.find('input').last()
      expect(subject.getName(input)).toEqual('firstname')

  describe '#createToggleForm', ->

    it 'creates a new ToggleForm object', ->
      subject.createToggleForm($('.js-shipping-address').first())
      expect(subject.shippingAddresses.length).toEqual(6)

  describe '#findShippingAddress', ->

    it 'gets all shipping address', ->
      subject.findShippingAddresses()
      expect(subject.shippingAddresses.length).toEqual(8)

  describe '#getBillAddress', ->

    it 'gets all inputs and selects from billing address', ->
      result = subject.getBillAddress()
      expect(result.length).toEqual(2)

