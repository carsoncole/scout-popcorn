class CreateUnits < ActiveRecord::Migration[5.0]
  def change
    create_table :units do |t|
      t.string :name
      t.string :street_address_1
      t.string :street_address_2
      t.string :city
      t.string :zip_code
      t.string :state_postal_code
      t.string :treasurer_first_name
      t.string :treasurer_last_name
      t.string :treasurer_email
      t.boolean :send_email_on_registration, default: false
      t.boolean :send_emails, default: true
      t.timestamps
    end
  end
end