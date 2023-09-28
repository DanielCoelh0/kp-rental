# 🚗 _kp-rental_
A vehicle rental system for **FiveM** with support for the **QBCore Framework**.

<br>

## ⭐ _Features_
- 🚗 Add as many rentals as you want
- 🅿️ Several parking slots to prevent collisions between vehicles and players waiting for other players
- ⛽ Support for different fuel scripts such as "LegacyFuel", "Cdn-fuel", etc...
- 🗺️ Display or not display the blips of each rental on the map
- 💰 Allow the player to pay by bank transfer or with cash
- 📇 Check if the player needs a driving license for a certain vehicle or not

<br>

## ⚠️ _Dependencies_
- qb-core: https://github.com/qbcore-framework/qb-core
- qb-target: https://github.com/qbcore-framework/qb-target

<br>

## ❓ How To Install KP-Rental?

Here, is step-by-step guide on installing kp-rental to your server and making it work.

### Step 1 | Download & Start kp-rental script:
First, we need renaming the resource "kp-rental-main" to just "kp-rental". <br> Next, we will drag the "kp-rental" resource into your desired folder in your servers resources directory.

### Step 2 | Create rental papers item:
Afther this, we need to add this new line in **qb-core/shared/itens.lua**.
```lua
['rental_papers']                   = {['name'] = 'rental_papers',                     ['label'] = 'Rental Papers',             ['weight'] = 50,           ['type'] = 'item',         ['image'] = 'rental_papers.png',           ['unique'] = true,          ['useable'] = false,     ['shouldClose'] = false,     ['combinable'] = nil,   ['description'] = 'This car was taken out through car rental.'}
```

> **We now have the rental papers item created, but there are still a few steps to go:**

### Step 3 | Insert new item icon and formated metadata on your inventory:
**3.1:** Find the *app.js* located at *yourinventoryname/html/js/app.js*, and paste de next code, between 500 and 600 line:

```lua
        } else if (itemData.name == "rental_papers") {
            $(".item-info-title").html('<p>' + itemData.label + '</p>')
            $(".item-info-description").html(
               '<p><strong>Temporary Owner: </strong><span>' + itemData.info.temporaryOwner + '</span></p>' + 
               '<p><strong>Citizen ID: </strong><span>' + itemData.info.citizenid + '</span></p>' + 
               '<p><strong>Vehicle Model: </strong><span>' + itemData.info.vehicleModel + '</span></p>' + 
               '<p><strong>Plate: </strong><span>' + itemData.info.plate + '</span></p>');
```

**3.2:** Locate the next image on Images Folder, and put them on *yourinventoryname/html/images/*

![rental_papers](images/rental_papers.png)

### Step 4 | Start script and reload the server
Now that you've followed and finished all the steps, you need to initialize the script in Server.cfg, so that it is loaded when the server starts, just by adding the following line of code:
```lua
ensure kp-rental
```

### 🥳 You are now officially done installing!

<br>

## ❔ Questions / Sugestions
For any questions or suggestions, just go to my [Discord](https://discord.gg//DxXFDqnxYs){:target="_blank"} and talk to me


