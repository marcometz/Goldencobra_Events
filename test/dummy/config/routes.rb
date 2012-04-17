Rails.application.routes.draw do
  
  ActiveAdmin.routes(self)
  devise_for :users, ActiveAdmin::Devise.config
  mount GoldencobraEvents::Engine => "/goldencobra_events"
  mount GoldencobraEmailTemplates::Engine => "/goldencobra_email_templates"
  mount Goldencobra::Engine => "/"
end
#== Route Map
# Generated on 17 Apr 2012 18:27
#
#    mark_as_startpage_admin_article GET        /admin/articles/:id/mark_as_startpage(.:format) admin/articles#mark_as_startpage
#       update_widgets_admin_article POST       /admin/articles/:id/update_widgets(.:format)    admin/articles#update_widgets
#        batch_action_admin_articles POST       /admin/articles/batch_action(.:format)          admin/articles#batch_action
#                     admin_articles GET        /admin/articles(.:format)                       admin/articles#index
#                                    POST       /admin/articles(.:format)                       admin/articles#create
#                  new_admin_article GET        /admin/articles/new(.:format)                   admin/articles#new
#                 edit_admin_article GET        /admin/articles/:id/edit(.:format)              admin/articles#edit
#                      admin_article GET        /admin/articles/:id(.:format)                   admin/articles#show
#                                    PUT        /admin/articles/:id(.:format)                   admin/articles#update
#                                    DELETE     /admin/articles/:id(.:format)                   admin/articles#destroy
#            admin_goldencobra_infos            /admin/goldencobra_infos(.:format)              admin/goldencobra_infos#index
#          batch_action_admin_menues POST       /admin/menues/batch_action(.:format)            admin/menues#batch_action
#                       admin_menues GET        /admin/menues(.:format)                         admin/menues#index
#                                    POST       /admin/menues(.:format)                         admin/menues#create
#                    new_admin_menue GET        /admin/menues/new(.:format)                     admin/menues#new
#                   edit_admin_menue GET        /admin/menues/:id/edit(.:format)                admin/menues#edit
#                        admin_menue GET        /admin/menues/:id(.:format)                     admin/menues#show
#                                    PUT        /admin/menues/:id(.:format)                     admin/menues#update
#                                    DELETE     /admin/menues/:id(.:format)                     admin/menues#destroy
#     batch_action_admin_permissions POST       /admin/permissions/batch_action(.:format)       admin/permissions#batch_action
#                  admin_permissions GET        /admin/permissions(.:format)                    admin/permissions#index
#                                    POST       /admin/permissions(.:format)                    admin/permissions#create
#               new_admin_permission GET        /admin/permissions/new(.:format)                admin/permissions#new
#              edit_admin_permission GET        /admin/permissions/:id/edit(.:format)           admin/permissions#edit
#                   admin_permission GET        /admin/permissions/:id(.:format)                admin/permissions#show
#                                    PUT        /admin/permissions/:id(.:format)                admin/permissions#update
#                                    DELETE     /admin/permissions/:id(.:format)                admin/permissions#destroy
#           batch_action_admin_roles POST       /admin/roles/batch_action(.:format)             admin/roles#batch_action
#                        admin_roles GET        /admin/roles(.:format)                          admin/roles#index
#                                    POST       /admin/roles(.:format)                          admin/roles#create
#                     new_admin_role GET        /admin/roles/new(.:format)                      admin/roles#new
#                    edit_admin_role GET        /admin/roles/:id/edit(.:format)                 admin/roles#edit
#                         admin_role GET        /admin/roles/:id(.:format)                      admin/roles#show
#                                    PUT        /admin/roles/:id(.:format)                      admin/roles#update
#                                    DELETE     /admin/roles/:id(.:format)                      admin/roles#destroy
#        batch_action_admin_settings POST       /admin/settings/batch_action(.:format)          admin/settings#batch_action
#                     admin_settings GET        /admin/settings(.:format)                       admin/settings#index
#                                    POST       /admin/settings(.:format)                       admin/settings#create
#                  new_admin_setting GET        /admin/settings/new(.:format)                   admin/settings#new
#                 edit_admin_setting GET        /admin/settings/:id/edit(.:format)              admin/settings#edit
#                      admin_setting GET        /admin/settings/:id(.:format)                   admin/settings#show
#                                    PUT        /admin/settings/:id(.:format)                   admin/settings#update
#                                    DELETE     /admin/settings/:id(.:format)                   admin/settings#destroy
#         batch_action_admin_uploads POST       /admin/uploads/batch_action(.:format)           admin/uploads#batch_action
#                      admin_uploads GET        /admin/uploads(.:format)                        admin/uploads#index
#                                    POST       /admin/uploads(.:format)                        admin/uploads#create
#                   new_admin_upload GET        /admin/uploads/new(.:format)                    admin/uploads#new
#                  edit_admin_upload GET        /admin/uploads/:id/edit(.:format)               admin/uploads#edit
#                       admin_upload GET        /admin/uploads/:id(.:format)                    admin/uploads#show
#                                    PUT        /admin/uploads/:id(.:format)                    admin/uploads#update
#                                    DELETE     /admin/uploads/:id(.:format)                    admin/uploads#destroy
#           batch_action_admin_users POST       /admin/users/batch_action(.:format)             admin/users#batch_action
#                        admin_users GET        /admin/users(.:format)                          admin/users#index
#                                    POST       /admin/users(.:format)                          admin/users#create
#                     new_admin_user GET        /admin/users/new(.:format)                      admin/users#new
#                    edit_admin_user GET        /admin/users/:id/edit(.:format)                 admin/users#edit
#                         admin_user GET        /admin/users/:id(.:format)                      admin/users#show
#                                    PUT        /admin/users/:id(.:format)                      admin/users#update
#                                    DELETE     /admin/users/:id(.:format)                      admin/users#destroy
#         batch_action_admin_widgets POST       /admin/widgets/batch_action(.:format)           admin/widgets#batch_action
#                      admin_widgets GET        /admin/widgets(.:format)                        admin/widgets#index
#                                    POST       /admin/widgets(.:format)                        admin/widgets#create
#                   new_admin_widget GET        /admin/widgets/new(.:format)                    admin/widgets#new
#                  edit_admin_widget GET        /admin/widgets/:id/edit(.:format)               admin/widgets#edit
#                       admin_widget GET        /admin/widgets/:id(.:format)                    admin/widgets#show
#                                    PUT        /admin/widgets/:id(.:format)                    admin/widgets#update
#                                    DELETE     /admin/widgets/:id(.:format)                    admin/widgets#destroy
#     send_conf_mail_admin_applicant GET        /admin/applicants/:id/send_conf_mail(.:format)  admin/applicants#send_conf_mail
#      batch_action_admin_applicants POST       /admin/applicants/batch_action(.:format)        admin/applicants#batch_action
#                   admin_applicants GET        /admin/applicants(.:format)                     admin/applicants#index
#                                    POST       /admin/applicants(.:format)                     admin/applicants#create
#                new_admin_applicant GET        /admin/applicants/new(.:format)                 admin/applicants#new
#               edit_admin_applicant GET        /admin/applicants/:id/edit(.:format)            admin/applicants#edit
#                    admin_applicant GET        /admin/applicants/:id(.:format)                 admin/applicants#show
#                                    PUT        /admin/applicants/:id(.:format)                 admin/applicants#update
#                                    DELETE     /admin/applicants/:id(.:format)                 admin/applicants#destroy
#         batch_action_admin_artists POST       /admin/artists/batch_action(.:format)           admin/artists#batch_action
#                      admin_artists GET        /admin/artists(.:format)                        admin/artists#index
#                                    POST       /admin/artists(.:format)                        admin/artists#create
#                   new_admin_artist GET        /admin/artists/new(.:format)                    admin/artists#new
#                  edit_admin_artist GET        /admin/artists/:id/edit(.:format)               admin/artists#edit
#                       admin_artist GET        /admin/artists/:id(.:format)                    admin/artists#show
#                                    PUT        /admin/artists/:id(.:format)                    admin/artists#update
#                                    DELETE     /admin/artists/:id(.:format)                    admin/artists#destroy
#          batch_action_admin_events POST       /admin/events/batch_action(.:format)            admin/events#batch_action
#                       admin_events GET        /admin/events(.:format)                         admin/events#index
#                                    POST       /admin/events(.:format)                         admin/events#create
#                    new_admin_event GET        /admin/events/new(.:format)                     admin/events#new
#                   edit_admin_event GET        /admin/events/:id/edit(.:format)                admin/events#edit
#                        admin_event GET        /admin/events/:id(.:format)                     admin/events#show
#                                    PUT        /admin/events/:id(.:format)                     admin/events#update
#                                    DELETE     /admin/events/:id(.:format)                     admin/events#destroy
#    batch_action_admin_event_panels POST       /admin/event_panels/batch_action(.:format)      admin/event_panels#batch_action
#                 admin_event_panels GET        /admin/event_panels(.:format)                   admin/event_panels#index
#                                    POST       /admin/event_panels(.:format)                   admin/event_panels#create
#              new_admin_event_panel GET        /admin/event_panels/new(.:format)               admin/event_panels#new
#             edit_admin_event_panel GET        /admin/event_panels/:id/edit(.:format)          admin/event_panels#edit
#                  admin_event_panel GET        /admin/event_panels/:id(.:format)               admin/event_panels#show
#                                    PUT        /admin/event_panels/:id(.:format)               admin/event_panels#update
#                                    DELETE     /admin/event_panels/:id(.:format)               admin/event_panels#destroy
#     batch_action_admin_pricegroups POST       /admin/pricegroups/batch_action(.:format)       admin/pricegroups#batch_action
#                  admin_pricegroups GET        /admin/pricegroups(.:format)                    admin/pricegroups#index
#                                    POST       /admin/pricegroups(.:format)                    admin/pricegroups#create
#               new_admin_pricegroup GET        /admin/pricegroups/new(.:format)                admin/pricegroups#new
#              edit_admin_pricegroup GET        /admin/pricegroups/:id/edit(.:format)           admin/pricegroups#edit
#                   admin_pricegroup GET        /admin/pricegroups/:id(.:format)                admin/pricegroups#show
#                                    PUT        /admin/pricegroups/:id(.:format)                admin/pricegroups#update
#                                    DELETE     /admin/pricegroups/:id(.:format)                admin/pricegroups#destroy
#        batch_action_admin_sponsors POST       /admin/sponsors/batch_action(.:format)          admin/sponsors#batch_action
#                     admin_sponsors GET        /admin/sponsors(.:format)                       admin/sponsors#index
#                                    POST       /admin/sponsors(.:format)                       admin/sponsors#create
#                  new_admin_sponsor GET        /admin/sponsors/new(.:format)                   admin/sponsors#new
#                 edit_admin_sponsor GET        /admin/sponsors/:id/edit(.:format)              admin/sponsors#edit
#                      admin_sponsor GET        /admin/sponsors/:id(.:format)                   admin/sponsors#show
#                                    PUT        /admin/sponsors/:id(.:format)                   admin/sponsors#update
#                                    DELETE     /admin/sponsors/:id(.:format)                   admin/sponsors#destroy
#          batch_action_admin_venues POST       /admin/venues/batch_action(.:format)            admin/venues#batch_action
#                       admin_venues GET        /admin/venues(.:format)                         admin/venues#index
#                                    POST       /admin/venues(.:format)                         admin/venues#create
#                    new_admin_venue GET        /admin/venues/new(.:format)                     admin/venues#new
#                   edit_admin_venue GET        /admin/venues/:id/edit(.:format)                admin/venues#edit
#                        admin_venue GET        /admin/venues/:id(.:format)                     admin/venues#show
#                                    PUT        /admin/venues/:id(.:format)                     admin/venues#update
#                                    DELETE     /admin/venues/:id(.:format)                     admin/venues#destroy
# batch_action_admin_email_templates POST       /admin/email_templates/batch_action(.:format)   admin/email_templates#batch_action
#              admin_email_templates GET        /admin/email_templates(.:format)                admin/email_templates#index
#                                    POST       /admin/email_templates(.:format)                admin/email_templates#create
#           new_admin_email_template GET        /admin/email_templates/new(.:format)            admin/email_templates#new
#          edit_admin_email_template GET        /admin/email_templates/:id/edit(.:format)       admin/email_templates#edit
#               admin_email_template GET        /admin/email_templates/:id(.:format)            admin/email_templates#show
#                                    PUT        /admin/email_templates/:id(.:format)            admin/email_templates#update
#                                    DELETE     /admin/email_templates/:id(.:format)            admin/email_templates#destroy
#        batch_action_admin_comments POST       /admin/comments/batch_action(.:format)          admin/comments#batch_action
#                     admin_comments GET        /admin/comments(.:format)                       admin/comments#index
#                                    POST       /admin/comments(.:format)                       admin/comments#create
#                  new_admin_comment GET        /admin/comments/new(.:format)                   admin/comments#new
#                 edit_admin_comment GET        /admin/comments/:id/edit(.:format)              admin/comments#edit
#                      admin_comment GET        /admin/comments/:id(.:format)                   admin/comments#show
#                                    PUT        /admin/comments/:id(.:format)                   admin/comments#update
#                                    DELETE     /admin/comments/:id(.:format)                   admin/comments#destroy
#                   new_user_session GET        /admin/login(.:format)                          active_admin/devise/sessions#new
#                       user_session POST       /admin/login(.:format)                          active_admin/devise/sessions#create
#               destroy_user_session DELETE|GET /admin/logout(.:format)                         active_admin/devise/sessions#destroy
#             user_omniauth_callback            /admin/auth/:action/callback(.:format)          devise/omniauth_callbacks#(?-mix:(?!))
#                      user_password POST       /admin/password(.:format)                       active_admin/devise/passwords#create
#                  new_user_password GET        /admin/password/new(.:format)                   active_admin/devise/passwords#new
#                 edit_user_password GET        /admin/password/edit(.:format)                  active_admin/devise/passwords#edit
#                                    PUT        /admin/password(.:format)                       active_admin/devise/passwords#update
#           cancel_user_registration GET        /admin/cancel(.:format)                         devise/registrations#cancel
#                  user_registration POST       /admin(.:format)                                devise/registrations#create
#              new_user_registration GET        /admin/sign_up(.:format)                        devise/registrations#new
#             edit_user_registration GET        /admin/edit(.:format)                           devise/registrations#edit
#                                    PUT        /admin(.:format)                                devise/registrations#update
#                                    DELETE     /admin(.:format)                                devise/registrations#destroy
#                        user_unlock POST       /admin/unlock(.:format)                         devise/unlocks#create
#                    new_user_unlock GET        /admin/unlock/new(.:format)                     devise/unlocks#new
#                                    GET        /admin/unlock(.:format)                         devise/unlocks#show
#                 goldencobra_events            /goldencobra_events                             GoldencobraEvents::Engine
#        goldencobra_email_templates            /goldencobra_email_templates                    GoldencobraEmailTemplates::Engine
#                        goldencobra            /                                               Goldencobra::Engine
# 
# Routes for GoldencobraEvents::Engine:
#                  events_register GET /events/register(.:format)                  events#register
#                   register_event     /event/:id/register(.:format)               goldencobra_events/events#register
#                   events_summary     /events/summary(.:format)                   goldencobra_events/events#summary
#                     cancel_event     /event/:id/cancel(.:format)                 goldencobra_events/events#cancel
#      perform_events_registration     /events/registration(.:format)              goldencobra_events/events#perform_registration
#                 validate_webcode     /events/webcode(.:format)                   goldencobra_events/events#validate_webcode
# events_confirmation_registration     /events/confirmation_registration(.:format) goldencobra_events/events#confirm_registration
#                      display_agb     /display_agb(.:format)                      goldencobra_events/events#display_agb
# 
# Routes for GoldencobraEmailTemplates::Engine:
# 
# Routes for Goldencobra::Engine:
# sitemap GET /sitemap(.:format)     goldencobra/articles#sitemap {:format=>"xml"}
#             /*article_id(.:format) goldencobra/articles#show
#    root     /                      goldencobra/articles#show {:startpage=>true}
