class CreateGoldencobraEventsRegistrationUsers < ActiveRecord::Migration
  def up
    create_table :goldencobra_events_registration_users do |t|
      t.integer :user_id
      t.boolean :gender
      t.string :email
      t.string :title
      t.string :firstname
      t.string :lastname
      t.string :function
      t.string :phone
      t.boolean :agb
      t.integer :company_id

      t.timestamps
    end
    
    User.event_applicants.each do |u|
      ru = GoldencobraEvents::RegistrationUser.create(:title => u.title, :gender => u.gender, :firstname => u.firstname, :lastname => u.lastname, :email => u.email, :company_id => u.company_id, :function => u.function, :phone => u.phone )
      u.registration_users << ru
    end
    
  end
    
  def down
      drop_table :goldencobra_events_registration_users
  end
  
end
