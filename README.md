# Scout Corn Cub for Popcorn Fundraising

Corn Cub is a multi-Scout Unit or single Unit application for managing and for promoting involvement in a Scout popcorn fundraiser. 

For **Scouts**, they can track their progress, prizes they might have earned, and manage orders and deliveries.

For **Leaders**, Corn Cub provides a financial accounting and inventory management system. With Corncub, you will always know how much inventory you have, where it is, and how much your unit has earned.

Through their own accounts, Scouts can view their sales progress in door-to-door (Take Order) sales and hours they have contributed towards Site Sales.

Corn Cub also provides comprehensive management tools, including an Income Statement, Balance Sheet, Take Order Purchase Order and Final BSA Settlement Form. It also notifies your Unit Treasurer every time a bank deposit is made from Popcorn sales.

## Features

- Manage Site Sales, where Scouts will get a pro-rata sales credit based on time spent, out of all Site Sales.

- Manage Take Orders, where individual customer orders can be entered, tracked, receipts generated and used for ordering inventory to satify deliveries.

- Manage finances, where you can see sales, expenses, income, and track inventory.

- Manage prizes, so Scouts can see available prizes and order them, based on their own sales and eligibility.

- Can be used for one or more Scout units. If only for one unit, set `config.allow_for_multiple_units` to `true`.

- Bank deposits will result in notification emails being sent out to the Treasurer email address on a Unit.

## Installation

This is a Ruby on Rails application. Simply `bundle install` will install dependencies and then `Rails server` will launch the application.

### Dependencies

Rails 5.0, Ruby 2.3

### Database

This application uses Sqlite. Under heavier concurrant requests, it may be advisable to use a more robust database.

### Config

In application.rb, you can set the following:

```ruby
config.application_name = 'Corn Cub'
config.allow_for_multiple_units = false
```

If you want to run the application for just one Scout unit, change `config.allow_for_multiple_unit` to `false`.

For email notification, update settings in **environment.rb**.

### Seed Data

There is seed data that can be optionally loaded to view an already-entered Unit, Scouts, event, and administrators. To see how the application works based on the user, you can login with any of the pre-defined users below.

```ruby
rails db:seed
```

There are multiple administrators and Scout users with different roles, all of which have a password of 'password'.

- Admin (full rights): admin@example.com
- Unit admin: unit_admin@example.com
- Site Sales: site_sales_admin@example.com
- Take Orders: take_orders_admin@example.com
- Financial: financial_admin@example.com
- Warehouse: warehouse_admin@example.com
- Prizes: prizes_admin@example.com
- Scouts: scout1@example.com, scout2@example.com, scout3@example.com

## Administrative Roles

Roles are broken down into the following, which each administrative user can be assigned one or more:

- **Unit:** All unit info, including users and assignment of roles, event, product and prize information. This role is effectively a super-admin role, but for rights to any of the below roles, it must be specifically assigned.

- **Take Orders:** All Take Orders info.

- **Site Sales:** All Site Sales info.

- **Warehouse:** All inventory info, including transfers of product to the person(s) handling Site Sales and Take Orders.

- **Online:** All online orders info.

- **Financial:** All financial info.

- **Prizes:** All prize info.


## Author / License

Corn Cub was developed by Carson Cole. It is free to use and be modified as you see fit. It uses the GNU GENERAL PUBLIC LICENSE.