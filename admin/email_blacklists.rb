ActiveAdmin.register GoldencobraEvents::EmailBlacklist, as: "Email-Blacklist" do
  menu :parent => "Einstellungen", :if => proc{can?(:read, GoldencobraEvents::EmailBlacklist)}
end