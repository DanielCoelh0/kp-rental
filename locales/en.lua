local Translations = {
    info = {
        ['rental_title'] = 'Rental center',
    },
    success = {
        ['rented_vehicle'] = 'Vehicle rented for: $',
    },
    error = {
        ['no_money'] = 'You dont have sufficient money to rent this vehicle',
        ['no_license'] = 'You need a driver license to rent this vehicle',
        ['parking_lot_full'] = 'There are no free spaces in the parking lot',
    },
    blip = {
        ['name'] = 'Rental center',
    },
    menu = {
        ['header'] = 'Rental center',
        ['price'] = 'Price: $',
        ['exit'] = 'Exit',

        ['payment_type_header'] = 'Payment Type',
        ['payment_type_description'] = 'Choose payment method',
        ['bank_title'] = 'Bank Payment',
        ['bank_description'] = 'Pay with bank transfer',
        ['money_title'] = 'Money Payment',
        ['money_description'] = 'Pay with cash',

        ['target'] = 'Rent Vehicle',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
