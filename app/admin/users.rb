ActiveAdmin.register User, :as => "Applicant" do
  menu :parent => "Event-Management"
  
  scope :event_applicants, :default => true

  filter :firstname
  filter :lastname
  filter :email

  index :as => :block do |u|
    table do
      ["Firstname", "Lastname", "Email", "Total price", ""].each do |h|
        th h
      end
      tr :for => u do
        td u.firstname
        td u.lastname
        td u.email
        td number_to_currency(u.total_price)
        td link_to("Details", admin_applicant_path(u))
      end
    end
  end

  show :title => :lastname do
    panel "Applicant" do
      attributes_table_for applicant do
        [:firstname, :lastname, :title, :email, :gender, :function, :phone, :fax, :facebook, :twitter, :linkedin, :xing, :googleplus, :created_at, :updated_at].each do |aa|
          row aa
        end
      end
    end #end panel applicant
    panel "Registrations" do
      table do
        tr do
          ["Event title", "Pricegroup title", "Price", "Registered at"].each do |sa|
            th sa
          end
        end
        applicant.event_registrations.each do |ereg|
          tr do
            [ereg.event_pricegroup.event.title, ereg.event_pricegroup.title, number_to_currency(ereg.event_pricegroup.price), ereg.created_at].each do |esa|
              td esa
            end
          end
        end
        tr :class => "total" do
          td ""
          td ""
          td number_to_currency(applicant.total_price)
          td ""
        end
      end
    end #end panel sponsors
  end
end
