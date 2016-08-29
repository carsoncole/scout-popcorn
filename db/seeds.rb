# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Product.create([
  {name: 'Classic Caramel Popcorn', retail_price: 10, quantity: 1, url: 'classic-caramel-corn.png'},
  {name: 'Popping Corn', retail_price: 10, quantity: 1, url: 'popping-corn.png'},
  {name: 'White Cheddar Cheese', retail_price: 25, quantity: 1, url: 'white-cheddar-cheese.png'},
  {name: 'White Chocolatey Pretzels', retail_price: 25, quantity: 1, url: 'white-chocolatey-pretzels.png'},
  {name: 'Seattle Seahawks Tin', retail_price: 25, quantity: 1, url: 'seattle-seahawks-tin.jpg'},
  {name: 'Kettle Corn Microwave', retail_price: 20, quantity: 1, url: 'kettle-corn-microwave.jpg'},
  {name: 'Butter Light Microwave', retail_price: 20, quantity: 1, url: 'butter-light-microwave.jpg'},
  {name: 'Unbelievable Butter Microwave', retail_price: 20, quantity: 1, url: 'unbelievable-butter-microwave.jpg'},
  {name: 'White Cheddar Cheese', retail_price: 15, quantity: 1, url: 'white-cheddar-cheese.png'},
  {name: 'Chocolatey Caramel Crunch', retail_price: 25, quantity: 1, url: 'chocolatey-caramel-crunch.png'},
  {name: 'Premium Caramel Corn', retail_price: 25, quantity: 1, url: 'premium-caramel-corn.png'},
  {name: 'Jalapeno Cheddar Cheese', retail_price: 15, quantity: 1, url: 'jalapeno-cheddar-cheese.jpg'}
  ])

Prize.create([
  {name: 'Patch', amount: 25},
  {name: 'Watergun', amount: 150},
  {name: 'X-Box One', amount: 2000},
  {name: 'Slingshot', amount: 300}
  ])

Unit.create([
  {name: 'Pack 4496', street_address_1: '425 Rolling Bay Road', city: 'Bainbridge Island', state_postal_code: 'WA', zip_code: '98110'},
  {name: 'Pack 440', street_address_1: '425 Rolling Bay Road', city: 'Tacoma', state_postal_code: 'WA', zip_code: '98110'},
  {name: 'Pack 545', street_address_1: '425 Rolling Bay Road', city: 'Seattle', state_postal_code: 'WA', zip_code: '98110'}
  ])

Event.create([
  { unit_id: 1, name: 'Popcorn Sales 2016'},
  { unit_id: 2, name: 'Tacoma Popcorn Sales 2016'},
  { unit_id: 3, name: 'Seattle Popcorn Sales 2016'},
  { unit_id: 1, name: 'Popcorn Sales 2017', is_active: false}
  ])

Scout.create([
  {first_name: 'Aidan', last_name: 'Cole', email: 'aidan@gmail.com', password: 'robert', password_confirmation: 'robert', unit_id: 1},
  {first_name: 'Teo', last_name: 'Pinzon', email: 'keripinzon+Teo@gmail.com', password: 'robert', password_confirmation: 'robert', unit_id: 1},
  {first_name: 'Porter', last_name: 'Daniels', email: 'kevindaniels@gmail.com', password: 'robert', password_confirmation: 'robert', unit_id: 1},
  {first_name: 'John', last_name: 'Wills', email: 'john@gmail.com', password: 'robert', password_confirmation: 'robert', unit_id: 2},
  {first_name: 'Luke', last_name: 'Ball', email: 'jack@gmail.com', password: 'robert', password_confirmation: 'robert', unit_id: 3},
  {first_name: 'Admin', last_name: 'Cole', email: 'admin@gmail.com', password: 'robert', password_confirmation: 'robert', unit_id: 1, is_admin: true},
  {first_name: 'Carson', last_name: 'Cole', email: 'carson@gmail.com', password: 'robert', password_confirmation: 'robert', unit_id: 1, is_admin: true},
  {first_name: 'Super', last_name: 'Cole', email: 'carson@gmail.com', password: 'robert', password_confirmation: 'robert', unit_id: 1, is_admin: true, is_super_admin: true}
  ])

TakeOrder.create([
  {scout_id: 1, event_id: 1, customer_name: 'Mary Jones', customer_address: '123 Main Street', customer_email: 'maryjones@example.com'},
  {scout_id: 1, event_id: 1, customer_name: 'Bob White', customer_address: '12 Acme Avenue', customer_email: 'bobwhite@example.com'},
  {scout_id: 2, event_id: 1, customer_name: 'Bob White', customer_address: '12 Acme Avenue', customer_email: 'bobwhite@example.com'},
  {scout_id: 2, event_id: 1, customer_name: 'Bob White', customer_address: '12 Acme Avenue', customer_email: 'bobwhite@example.com'},
  {scout_id: 3, event_id: 1, customer_name: 'Bob White', customer_address: '12 Acme Avenue', customer_email: 'bobwhite@example.com'},
  {scout_id: 4, event_id: 1, customer_name: 'Bob White', customer_address: '12 Acme Avenue', customer_email: 'bobwhite@example.com'}
  ])

LineItem.create([
  {take_order_id: 1, product_id: Event.first.products.first.id, quantity: 2},
  {take_order_id: 1, product_id: Event.first.products[1].id, quantity: 3},
  {take_order_id: 2, product_id: Event.first.products[3].id, quantity: 5},
  {take_order_id: 3, product_id: Event.first.products[2].id, quantity: 5},
  {take_order_id: 3, product_id: Event.first.products[3].id, quantity: 5},
  {take_order_id: 4, product_id: Event.first.products[4].id, quantity: 5},
  {take_order_id: 4, product_id: Event.first.products[1].id, quantity: 5},
  {take_order_id: 5, product_id: Event.first.products[0].id, quantity: 5},
  {take_order_id: 5, product_id: Event.first.products[3].id, quantity: 5}
])

SiteSale.create ([
  {event_id: 1, name: 'Rite Aid Sep 9-10', total_sales: 1500.50},
  {event_id: 1, name: 'Ace Hardward Sep 16-17'}
  ])

ScoutSiteSale.create ([
  {scout_id: 1, site_sale_id: 1, hours_worked: 6},
  {scout_id: 2, site_sale_id:1, hours_worked: 4}
  ])
