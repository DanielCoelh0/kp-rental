local Translations = {
    info = {
        ['rental_title'] = 'Centro de Aluguer',
    },
    success = {
        ['rented_vehicle'] = 'Veículo arrendado por $',
    },
    error = {
        ['no_money'] = 'Não tens dinheiro para arrendar este veículo',
        ['no_license'] = 'Precisas de licença de condução para alugar este veículo',
        ['parking_lot_full'] = 'Não existem espaços livres no parque',
    },
    blip = {
        ['name'] = 'Centro de Aluguer',
    },
    menu = {
        ['header'] = 'Centro de Aluguer',
        ['price'] = 'Preço: $',
        ['exit'] = 'Sair',

        ['payment_type_header'] = 'Tipo de Pagamento',
        ['payment_type_description'] = 'Escolhe o método de pagamento',
        ['bank_title'] = 'Transferência Bancária',
        ['bank_description'] = 'Pagar com transferência bancária',
        ['money_title'] = 'Monetário',
        ['money_description'] = 'Pagar com dinheiro',

        ['target'] = 'Alugar Veículo',
    }
}

if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
