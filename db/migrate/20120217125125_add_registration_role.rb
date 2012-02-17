class AddRegistrationRole < ActiveRecord::Migration
  def up
    Goldencobra::Role.find_or_create_by_name("EventRegistrations")
  end

  def down
  end
end
