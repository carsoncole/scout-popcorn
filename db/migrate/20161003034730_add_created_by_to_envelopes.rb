class AddCreatedByToEnvelopes < ActiveRecord::Migration[5.0]
  def change
    add_column :envelopes, :created_by, :integer
  end
end
