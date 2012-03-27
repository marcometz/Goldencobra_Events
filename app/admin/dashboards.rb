ActiveAdmin::Dashboards.build do
  
  section "Neueste Anmeldungen" do
    table do
      tr do
        ["Name", "E-mail", "Datum der Regstrierung", "Details"].each do |sa|
          th sa
        end
      end
       
      GoldencobraEvents::RegistrationUser.order("created_at DESC").limit(10).collect do |applicant|
        tr do
          td "#{applicant.lastname}, #{applicant.firstname}"
          td applicant.email
          td l(applicant.created_at, format: :long)
          td link_to("Details", admin_applicant_path(applicant))
        end        
      end
    end
  end

end