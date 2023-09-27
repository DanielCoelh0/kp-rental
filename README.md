    ['rental_papers']                   = {['name'] = 'rental_papers',                     ['label'] = 'Rental Papers',             ['weight'] = 50,           ['type'] = 'item',         ['image'] = 'rental_papers.png',           ['unique'] = true,          ['useable'] = false,     ['shouldClose'] = false,     ['combinable'] = nil,   ['description'] = 'This car was taken out through car rental.'}



qb-inventory - html - js- app.js - 500 600
        } else if (itemData.name == "rental_papers") {
            $(".item-info-title").html('<p>' + itemData.label + '</p>')
            $(".item-info-description").html(
               '<p><strong>Temporary Owner: </strong><span>' + itemData.info.temporaryOwner + '</span></p>' + 
               '<p><strong>Citizen ID: </strong><span>' + itemData.info.citizenid + '</span></p>' + 
               '<p><strong>Vehicle Model: </strong><span>' + itemData.info.vehicleModel + '</span></p>' + 
               '<p><strong>Plate: </strong><span>' + itemData.info.plate + '</span></p>');

