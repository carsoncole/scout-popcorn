# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Product.create([
  {name: 'Chocolatey Caramel Crunch', retail_price: 25, quantity: 1, url: 'chocolatey-caramel-crunch.png'},
  {name: 'White Chocolatey Pretzels', retail_price: 25, quantity: 1, url: 'white-chocolatey-pretzels.png'},
  {name: 'Seattle Seahawks Tin', retail_price: 25, quantity: 1, url: 'seattle-seahawks-tin.jpg'},
  {name: 'Premium Caramel Corn', retail_price: 20, quantity: 1, url: 'premium-caramel-corn.png'},
  {name: 'Jalapeno Cheddar Cheese', retail_price: 15, quantity: 1, url: 'jalapeno-cheddar-cheese.jpg'},
  {name: 'White Cheddar Cheese Corn', retail_price: 15, quantity: 1, url: 'white-cheddar-cheese.png'},
  {name: 'Classic Caramel Corn', retail_price: 10, quantity: 1, url: 'classic-caramel-corn.png'},
  {name: 'Popping Corn', retail_price: 10, quantity: 1, url: 'popping-corn.png'},
  {name: 'Kettle Corn Microwave', retail_price: 20, quantity: 1, url: 'kettle-corn-microwave.jpg'},
  {name: 'Unbelievable Butter Microwave', retail_price: 20, quantity: 1, url: 'unbelievable-butter-microwave.jpg'},
  {name: 'Butter Light Microwave', retail_price: 20, quantity: 1, url: 'butter-light-microwave.jpg'},
  {name: 'Sweet & Savory Collection', retail_price: 40, quantity: 1},
  {name: "Cheese Lover's Collection", retail_price: 30, quantity: 1, url: 'jalapeno-cheddar-cheese.jpg'},
  {name: "Chocolate Lover's Collection", retail_price: 60, quantity: 1},
  {name: "Popcorn for our Troops Gold Donation", retail_price: 50, quantity: 1},
  {name: "Popcorn for our Troops Silver Donation", retail_price: 30, quantity: 1},
  {name: "Pack Donation", retail_price: 1, quantity: 1}
  ])

Prize.create([
  {name: 'Participation Patch', amount: 25, source: 'bsa', source_id: '633893', source_description: 'Prize Level 1'},
  {name: 'Marshmallow Straight Shooter', amount: 350, source: 'bsa', source_id: '634181', source_description: 'Prize Level 2'},
  {name: 'Luci Solar Lantern', amount: 350, source: 'bsa', source_id: '633896', source_description: 'Prize Level 2'},
  {name: 'Slime Lab Science Kit', amount: 350, source: 'bsa', source_id: '7406', source_description: 'Prize Level 2'},
  {name: 'Cub Scout Utility Knife', amount: 350, source: 'bsa', source_id: '615777', source_description: 'Prize Level 2'},

  {name: 'HEXBUG Aquabot Jellyfish', amount: 450, source: 'bsa', source_id: '634191', source_description: 'Prize Level 3'},
  {name: 'Spy Science Kit', amount: 450, source: 'bsa', source_id: '627343', source_description: 'Prize Level 3'},
  {name: 'Nite Ize Flashlight', amount: 450, source: 'bsa', source_id: '624334', source_description: 'Prize Level 3'},
  {name: 'Green Rubber Lock Back Knife', amount: 450, source: 'bsa', source_id: '615774', source_description: 'Prize Level 3'},

  {name: 'Voice Changer', amount: 650, source: 'bsa', source_id: '633898', source_description: 'Prize Level 4'},
  {name: 'Binoculars 8 x 22', amount: 650, source: 'bsa', source_id: '611050', source_description: 'Prize Level 4'},
  {name: 'Landsailer Kit', amount: 650, source: 'bsa', source_id: '621406', source_description: 'Prize Level 4'},
  {name: 'Lego Onuna Unifier Kit', amount: 650, source: 'bsa', source_id: '634414', source_description: 'Prize Level 4'},

  {name: 'Marshmallow Blaster', amount: 850, source: 'bsa', source_id: '634182', source_description: 'Prize Level 5'},
  {name: 'Smithsonian 30x Telescope', amount: 850, source: 'bsa', source_id: '621346', source_description: 'Prize Level 5'},
  {name: '4" BSA Multi Tool', amount: 850, source: 'bsa', source_id: '615781', source_description: 'Prize Level 5'},
  {name: 'RC Helicopter', amount: 850, source: 'bsa', source_id: '618984', source_description: 'Prize Level 5'},

  {name: '$600 Bonus Level', amount: 600, source: 'bsa-bonus', source_id: '988100313', description: 'Two Tickets to the Mariners Scout Day Experience', is_by_level: true},
  {name: '$1,500 Bonus Level', amount: 1500, source: 'bsa-bonus', source_id: '', description: 'Invitation to party (to be announced)', is_by_level: true}
  ])

Unit.create([
  {name: 'Pack 4496', street_address_1: '425 Rolling Bay Road', city: 'Bainbridge Island', state_postal_code: 'WA', zip_code: '98110'},
  {name: 'Pack 9999', street_address_1: '425 Rolling Bay Road', city: 'Tacoma', state_postal_code: 'WA', zip_code: '98110'}
  ])

Event.create([
  { unit_id: 1, name: 'Popcorn Sales 2016'},
  { unit_id: 2, name: 'Popcorn Sales 2016'}
  ])

Scout.create([
  {first_name: 'Aidan', last_name: 'Cole', email: 'aidan@gmail.com', password: 'robert', password_confirmation: 'robert', unit_id: 2},
  {first_name: 'Teo', last_name: 'Pinzon', email: 'keripinzon+Teo@gmail.com', password: 'robert', password_confirmation: 'robert', unit_id: 2},
  {first_name: 'Porter', last_name: 'Daniels', email: 'kevindaniels@gmail.com', password: 'robert', password_confirmation: 'robert', unit_id: 2},
  {first_name: 'John', last_name: 'Wills', email: 'john@gmail.com', password: 'robert', password_confirmation: 'robert', unit_id: 2},
  {first_name: 'Luke', last_name: 'Ball', email: 'jack@gmail.com', password: 'robert', password_confirmation: 'robert', unit_id: 2},
  {first_name: 'Admin', last_name: 'Cole', email: 'admin@gmail.com', password: 'robert', password_confirmation: 'robert', unit_id: 2, is_admin: true},
  {first_name: 'Carson', last_name: 'Cole', email: 'carson@gmail.com', password: 'robert', password_confirmation: 'robert', unit_id: 2, is_admin: true},
  {first_name: 'Super', last_name: 'Cole', email: 'carson@gmail.com', password: 'robert', password_confirmation: 'robert', unit_id: 2, is_admin: true, is_super_admin: true}
  ])

TakeOrder.create([
  {scout_id: 1, event_id: 2, customer_name: 'Mary Jones', customer_address: '123 Main Street', customer_email: 'maryjones@example.com'},
  {scout_id: 1, event_id: 2, customer_name: 'Bob White', customer_address: '12 Acme Avenue', customer_email: 'bobwhite@example.com'},
  {scout_id: 2, event_id: 2, customer_name: 'Bob White', customer_address: '12 Acme Avenue', customer_email: 'bobwhite@example.com'},
  {scout_id: 2, event_id: 2, customer_name: 'Bob White', customer_address: '12 Acme Avenue', customer_email: 'bobwhite@example.com'},
  {scout_id: 3, event_id: 2, customer_name: 'Bob White', customer_address: '12 Acme Avenue', customer_email: 'bobwhite@example.com'},
  {scout_id: 4, event_id: 2, customer_name: 'Bob White', customer_address: '12 Acme Avenue', customer_email: 'bobwhite@example.com'}
  ])

TakeOrderLineItem.create([
  {take_order_id: 1, product_id: Unit.find(2).events.first.products.first.id, quantity: 2},
  {take_order_id: 1, product_id: Unit.find(2).events.first.products[1].id, quantity: 3},
  {take_order_id: 2, product_id: Unit.find(2).events.first.products[3].id, quantity: 5},
  {take_order_id: 3, product_id: Unit.find(2).events.first.products[2].id, quantity: 5},
  {take_order_id: 3, product_id: Unit.find(2).events.first.products[3].id, quantity: 5},
  {take_order_id: 4, product_id: Unit.find(2).events.first.products[4].id, quantity: 5},
  {take_order_id: 4, product_id: Unit.find(2).events.first.products[1].id, quantity: 5},
  {take_order_id: 5, product_id: Unit.find(2).events.first.products[0].id, quantity: 5},
  {take_order_id: 5, product_id: Unit.find(2).events.first.products[3].id, quantity: 5}
])

SiteSale.create ([
  {event_id: 2, name: 'Ace Hardware', date: '2016-09-10'},
  {event_id: 2, name: 'Rite Aid', date: '2016-09-11'},
  {event_id: 2, name: 'Rite Aid', date: '2016-09-17'},
  {event_id: 2, name: 'Ace Hardware', date: '2016-09-18'},
  {event_id: 2, name: 'Town & Country', date: '2016-10-01'},
  {event_id: 2, name: 'Town & Country', date: '2016-10-02'}
  ])

ScoutSiteSale.create ([
  {scout_id: 1, site_sale_id: 1, hours_worked: 6},
  {scout_id: 2, site_sale_id:1, hours_worked: 4}
  ])

