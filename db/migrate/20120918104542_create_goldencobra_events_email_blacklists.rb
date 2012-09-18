class CreateGoldencobraEventsEmailBlacklists < ActiveRecord::Migration
  def change
    create_table :goldencobra_events_email_blacklists do |t|
      t.string :email_address
      t.string :status_code
      t.boolean :retryable
      t.integer :count

      t.timestamps
    end
  end
end
