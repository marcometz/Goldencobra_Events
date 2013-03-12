module GoldencobraEvents
  class SentToPrinterMailer < ActionMailer::Base
    default from: Goldencobra::Setting.for_key("goldencobra_events.printer.from")
    default subject: Goldencobra::Setting.for_key("goldencobra_events.printer.subject")
    default :content_type => "text/plain"
    default :reply_to => Goldencobra::Setting.for_key("goldencobra_events.printer.reply_to")

    def send_email(file)
      if file && File.exists?(file) && Goldencobra::Setting.for_key("goldencobra_events.printer.from").present?
        printer_mail_address = Goldencobra::Setting.for_key("goldencobra_events.printer.email")
        path = File.absolute_path(file)
        attachments['attached_file.pdf'] = File.read(path)
        mail to: printer_mail_address
      end
    end
  end
end