ActiveAdmin.register User, :as => "Applicant" do
  menu :parent => "Event-Management"
  
  scope :event_applicants, :default => true

  filter :firstname
  filter :lastname
  filter :email

  index do
    column :firstname
    column :lastname
    column :email
    column "total Price" do |u|
      number_to_currency(u.total_price, :locale => :de)
    end
    column :newsletter
    default_actions
  end

  show :title => :lastname do
    panel "Applicant" do
      attributes_table_for applicant do
        [:firstname, :lastname, :title, :email, :gender, :function, :phone, :fax, :facebook, :twitter, :linkedin, :xing, :googleplus, :created_at, :updated_at].each do |aa|
          row aa
        end
      end
    end #end panel applicant
    panel "Company" do
      if applicant.company
        attributes_table_for applicant.company do
          [:title, :legal_form, :phone, :fax, :homepage, :sector].each do |aa|
            row aa
          end
        end  
        if applicant.company.location 
          attributes_table_for applicant.company.location do
            [:street, :zip, :city, :region, :country].each do |aa|
              row aa
            end
          end   
        end
      end   
    end
    panel "Registrations" do
      table do
        tr do
          ["Event title", "Pricegroup title", "Price", "Registered at"].each do |sa|
            th sa
          end
        end
        applicant.event_registrations.each do |ereg|
          tr do
            [ereg.event_pricegroup.event.title, ereg.event_pricegroup.title, number_to_currency(ereg.event_pricegroup.price, :locale => :de), ereg.created_at].each do |esa|
              td esa
            end
          end
        end
        tr :class => "total" do
          td ""
          td ""
          td number_to_currency(applicant.total_price, :locale => :de)
          td ""
        end
      end
    end #end panel sponsors
  end
end
