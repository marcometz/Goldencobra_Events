ActiveAdmin.register GoldencobraEvents::EmailBlacklist, as: "Email-Blacklist" do
  menu :parent => "Einstellungen", :if => proc{can?(:read, GoldencobraEvents::EmailBlacklist)}

  index do
    selectable_column
      column :email_address, sortable: true
      column :status_code, sortable: true
      column :retryable, sortable: true
      column :count, sortable: true
      column "Stammdaten" do |blacklist_entry|
        if User.where(email: blacklist_entry.email_address).any?
          link_to "Stammdaten anzeigen", edit_admin_user_path(User.where(email: blacklist_entry.email_address).first)
        elsif GoldencobraEvents::RegistrationUser.where(email: blacklist_entry.email_address).any?
          link_to "Event-Anmeldungen anzeigen", "/admin/applicants?q%5Bemail_contains%5D=#{blacklist_entry.email_address}&commit=Filtern&order=id_desc&scope="
        end
      end
      default_actions
  end
end