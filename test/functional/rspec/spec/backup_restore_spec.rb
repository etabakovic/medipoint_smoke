describe "Backup and Restore", :broken => false do

  full_path = File.dirname(File.dirname(__FILE__)) + '/lib/data/contact.yaml'
  contacts = YAML::load(File.open(full_path)) #contains all data needed for assertions
  restore_list = []

  date = true #true if date is set in advanced search
  manual_backup = false #true if user wants to trigger backup
  manual_backup_sleep = 100 #custom sleep for backup to be triggered
  manual_contact = "contact2" #defines which contact data corresponds to manual backup

  header = ["full_name","name","email","job title","updated","deleted"] #defines data to be checked in cloudfinder header
  details = ["address","email","phone"] #type of data that can be checked in cloudfinder view file section
  type = ["work","home","mobile"] #variations that each detail in view file can have
  #people is hashmap replica of outlook people section with majority of data it can contain 
  #Some sections that have Other option might not have been included in this hashmap.
  people = {  "Work" => ["Job title","Department","Company","Office","Manager","Assistant","Yomi company"],
              "Send email" => ["Email","Email 2","Email 3"],
              "Phone" => ["Work","Home","Mobile"],
              "Address" => ["Work","Home"],
              "IM" => [],
              "Other" => ["Nickname","Personal web page","Significant other","School","Hobbies","Location","Web page","Birthday","Anniversary"]}

    context "Cloudfinder" do
      it "opens cloudfinder login page" do
        @browser.goto($config['cloudfinder']['host'])
      end

      include_context "Cloudfinder login"
    end


=begin
  contacts.keys.each_with_index do |c,n|
    context "Cloudfinder" do

      it "opens cloudfinder login page" do
        @browser.goto($config['cloudfinder']['host'])
      end

      if n.eql?0
        include_context "Cloudfinder login"
      end
      
      it "checks if correct user is logged" do
        @homepage.wait_present(@homepage.goto_cloudfinder.user($config['cloudfinder']['username']))
        expect(@homepage.goto_cloudfinder.user($config['cloudfinder']['username'])).to be_present
      end

      if manual_backup and c.eql?manual_contact
        it "opens reports page" do
          @homepage.wait_present(@homepage.goto_cloudfinder.reports)
          @homepage.goto_cloudfinder.reports.click
          sleep manual_backup_sleep
        end

        it "waits for backup to complete" do
          @browser.refresh
          @homepage.wait_present(@homepage.goto_cloudfinder.backup_status_check(1))
          @homepage.wait_status(@homepage.goto_cloudfinder.backup_status_check(1),'Completed')
        end
      end

      it "enter and search contact name" do
        @homepage.wait_present(@homepage.goto_cloudfinder.search_header)
        @homepage.goto_cloudfinder.search_header.set contacts[c]['name']
        @homepage.goto_cloudfinder.search_header.send_keys :return
        @homepage.wait_present(@homepage.goto_cloudfinder.contact_name(contacts[c]["name"]))
      end

      if date  
        it "opens advanced search" do
          @homepage.wait_present(@homepage.goto_cloudfinder.advanced_search)
          @homepage.goto_cloudfinder.advanced_search.click
        end

        it "sets date" do
          #this is just made it work
          month = '08-'
          day = '15'
          year = '2016-'
          @homepage.wait_present(@homepage.goto_cloudfinder.date)
          @homepage.goto_cloudfinder.date.set year
          5.times do
            @homepage.goto_cloudfinder.date.send_keys :backspace
          end
          month.each_char do |m|
            @homepage.goto_cloudfinder.date.send_keys m
          end
          3.times do
            @homepage.goto_cloudfinder.date.send_keys :backspace
          end
          day.each_char do |d|
            @homepage.goto_cloudfinder.date.send_keys d
          end
          @homepage.goto_cloudfinder.date.send_keys :return
        end
      end

      it "sorts filtered contacts by backup date" do
        @homepage.wait_present(@homepage.goto_cloudfinder.sort_by)
        @homepage.goto_cloudfinder.sort_by.click
        @homepage.wait_present(@homepage.goto_cloudfinder.relevance('Backup date'))
        @homepage.goto_cloudfinder.relevance('Backup date').click
      end

      it "opens latest backup by filter" do
        @homepage.wait_present(@homepage.goto_cloudfinder.contact_name(contacts[c]['name']))
        @homepage.goto_cloudfinder.contact_name(contacts[c]['name']).click
      end

      if !contacts[c]['backup_date'].to_s.empty?
        it "selects #{contacts[c]['backup_date']} backup date from list" do
          @homepage.wait_present(@homepage.goto_cloudfinder.backup_list)
          @homepage.goto_cloudfinder.backup_list.click
          @homepage.goto_cloudfinder.select_backup(contacts[c]['backup_date']).click
        end
      end

      header.each_with_index do |h,i|
        if !contacts[c][h].to_s.empty?
          it "verifies backup #{h} in header is valid" do
            index = 2*(i+1)
            @homepage.wait_present(@homepage.goto_cloudfinder.contact_header(index))
            expect(@homepage.goto_cloudfinder.contact_header(index).text).to eql(contacts[c][h])
          end
        else
          it "verifies backup #{h} in header is not present" do
            index = 2*(i+1)
            expect(@homepage.goto_cloudfinder.contact_header(index)).not_to be_present
          end
        end
      end

      it "scrolls to center" do
        @browser.scroll.to :center
      end

      it "opens view file for backup contact details" do
        @homepage.wait_present(@homepage.goto_cloudfinder.view_file)
        @homepage.goto_cloudfinder.view_file.click
      end

      it "scrolls to top" do
        @browser.scroll.to :top
      end

      details.each do |d|
        type.each do |t|
          case d
          when "address"
            if !contacts[c]['address'][t].to_s.empty?
              it "verifies backup #{d} #{t} details is valid" do
                address = contacts[c]['address'][t]['street'].to_s + ' ' + contacts[c]['address'][t]['postal'].to_s + ' ' + contacts[c]['address'][t]['city'].to_s + ' ' + contacts[c]['address'][t]['country'].to_s
                full_address = address.gsub(/\s{1,}/,' ')
                @homepage.wait_present(@homepage.goto_cloudfinder.address(t))
                expect(@homepage.goto_cloudfinder.address(t).text).to eql(full_address)
              end
            else
              it "verifies backup #{d} #{t} details do not exist" do
                expect(@homepage.goto_cloudfinder.address(t)).not_to be_present
              end
            end
          when "phone"
            if !contacts[c]['address'][t].to_s.empty?
              it "verifies backup #{d} #{t} details is valid" do
                @homepage.wait_present(@homepage.goto_cloudfinder.phone(t))
                expect(@homepage.goto_cloudfinder.phone(t).text).to eql(contacts[c]['phone'][t])
              end
            else
              it "verifies backup #{d} #{t} details do not exist" do
                expect(@homepage.goto_cloudfinder.phone(t)).not_to be_present
              end
            end
          when "email"
            case t
            when "work"
              if !contacts[c]['email'].to_s.empty?
                it "verifies backup #{d} details is valid" do
                  @homepage.wait_present(@homepage.goto_cloudfinder.email(t))
                  expect(@homepage.goto_cloudfinder.email(t).text).to eql(contacts[c]['email'])
                end
              else
                it "verifies backup #{d} #{t} details do not exist" do
                  expect(@homepage.goto_cloudfinder.email(t)).not_to be_present
                end
              end
            when "home"
              if !contacts[c]['email1'].to_s.empty?
                it "verifies backup #{d} details is valid" do
                  @homepage.wait_present(@homepage.goto_cloudfinder.email(t))
                  expect(@homepage.goto_cloudfinder.email(t).text).to eql(contacts[c]['email1'])
                end
              else
                it "verifies backup #{d} #{t} details does not exist" do
                  expect(@homepage.goto_cloudfinder.email(t)).not_to be_present
                end
              end
            when "mobile"
              if !contacts[c]['email2'].to_s.empty?
                it "verifies backup #{d} details is valid" do
                  @homepage.wait_present(@homepage.goto_cloudfinder.email(t))
                  expect(@homepage.goto_cloudfinder.email(t).text).to eql(contacts[c]['email2'])
                end
              else
                it "verifies backup #{d} #{t} details does not exist" do
                  expect(@homepage.goto_cloudfinder.email(t)).not_to be_present
                end
              end
            end
          end
        end
      end

      it "click on restore" do
        @homepage.goto_cloudfinder.restore.click
      end

      it "specify user" do
        @homepage.wait_present(@homepage.goto_cloudfinder.restore_to_user)
        @homepage.goto_cloudfinder.restore_to_user.click
        @homepage.wait_present(@homepage.goto_cloudfinder.specify_user)
        @homepage.goto_cloudfinder.specify_user.set contacts[c]['user']
        @homepage.wait_present(@homepage.goto_cloudfinder.user_match(contacts[c]['user']))
        @homepage.goto_cloudfinder.user_match(contacts[c]['user']).click
      end

      it "specify location" do
        restore_name = 'Restore' + Time.now.to_i.to_s
        restore_list.push restore_name
        @homepage.wait_present(@homepage.goto_cloudfinder.restore_name)
        @homepage.goto_cloudfinder.restore_name.set restore_name
      end

      it "initiates restore" do
        @homepage.goto_cloudfinder.proceed.click
        @homepage.wait_present(@homepage.goto_cloudfinder.restore_modal)
        @homepage.goto_cloudfinder.restore_modal.click
      end

      it "waits for restore to start" do
        @homepage.wait_present(@homepage.goto_cloudfinder.restoring_modal)
        @homepage.goto_cloudfinder.restoring_modal.click
      end

      it "closes modal" do
        @homepage.wait_present(@homepage.goto_cloudfinder.close_modal)
        @homepage.goto_cloudfinder.close_modal.click
      end

      it "opens reports page" do
        @homepage.wait_present(@homepage.goto_cloudfinder.reports)
        @homepage.goto_cloudfinder.reports.click
      end

      it "opens restore tab" do
        @homepage.wait_present(@homepage.goto_cloudfinder.restore_reports)
        @homepage.goto_cloudfinder.restore_reports.click
        @browser.refresh
      end

      it "waits for restore to complete" do
        @homepage.wait_present(@homepage.goto_cloudfinder.restore_status_check(1))
        @homepage.wait_status(@homepage.goto_cloudfinder.restore_status_check(1),'Completed')
      end
    end

    context "Office 365" do
      it "opens office365 login page" do
        @browser.goto($config['office']['host'])
      end

      if n.eql?0
        include_context "Office login"
      end

      it "checks page title" do
        @homepage.wait_present(@homepage.goto_office.main_title)
        expect(@homepage.goto_office.main_title.text).to eql('Office 365')
      end

      it "opens main menu" do
        @homepage.wait_present(@homepage.goto_office.nav_menu)
        @homepage.goto_office.nav_menu.click
      end

      it "opens people" do
        @homepage.wait_present(@homepage.goto_office.people)
        @homepage.goto_office.people.click
      end

      it "opens your contacts" do
        @homepage.wait_present(@homepage.goto_office.your_contacts)
        @homepage.goto_office.your_contacts.click
      end

      it "opens other contacts" do
        @homepage.wait_present(@homepage.goto_office.other_contacts)
        @homepage.goto_office.other_contacts.click
      end

      it "opens restore contacts" do
        @homepage.wait_present(@homepage.goto_office.restored_contacts(restore_list[n]))
        @homepage.goto_office.restored_contacts(restore_list[n]).click
      end

      it "open contact details" do
        @homepage.wait_present(@homepage.goto_office.select_contact(contacts[c]['name']))
        @homepage.goto_office.select_contact(contacts[c]['name']).click
      end

      it "verifies if #{contacts[c]['full_name']} is present in header" do
        @homepage.wait_present(@homepage.goto_office.contact_name)
        expect(@homepage.goto_office.contact_name.text).to eql(contacts[c]['full_name'])
      end

      people.keys.each do |key|
        case key
        when "Work"
          people[key].each do |value|
            if !contacts[c][value.downcase].to_s.empty?
              it "verifies #{key} #{value} details are valid" do
                expect(@homepage.goto_office.text_details(key,value).text).to eql(contacts[c][value.downcase])
              end
            else
              it "verifies #{key} #{value} details do not exist" do
                expect(@homepage.goto_office.text_details(key,value)).not_to be_present
              end
            end
          end
        when "Phone"
          people[key].each do |value|
            if !contacts[c][key.downcase][value.downcase].to_s.empty?
              it "verifies #{key} #{value} details are valid" do
                if value.eql?"Work"
                  value1 = "Business"
                else
                  value1 = value
                end
                expect(@homepage.goto_office.text_details(key,value1).text).to eql(contacts[c][key.downcase][value.downcase]) 
              end
            else
              it "verifies #{key} #{value} details do not exist" do
                if value.eql?"Work"
                  value1 = "Business"
                else
                  value1 = value
                end
                expect(@homepage.goto_office.text_details(key,value1)).not_to be_present
              end
            end
          end
        when "Send email"
          people[key].each do |value|
            if !contacts[c][value.downcase].to_s.empty?
              it "verifies #{key} #{value} details are valid" do
                expect(@homepage.goto_office.link_details(key,value).text).to eql(contacts[c][value.downcase])
              end
            else
              it "verifies #{key} #{value} details do not exist" do
                expect(@homepage.goto_office.link_details(key,value)).not_to be_present
              end
            end
          end
        when "Address"
          people[key].each do |value|
            if !contacts[c][key.downcase][value.downcase].to_s.empty?
              it "verifies #{key} #{value} details are valid" do
                if value.eql?"Work"
                  value1 = "Business"
                else
                  value1 = value
                end
                address = contacts[c][key.downcase][value.downcase]['street'].to_s + ' ' + contacts[c][key.downcase][value.downcase]['city'].to_s + ' ' + contacts[c][key.downcase][value.downcase]['state'].to_s + ' ' + contacts[c][key.downcase][value.downcase]['postal'].to_s + ' ' + contacts[c][key.downcase][value.downcase]['country'].to_s
                full_address = address.gsub(/\s{1,}/,' ')
                expect(@homepage.goto_office.address_details(value1).text).to eql(full_address)
              end
            else
              it "verifies #{key} #{value} details do not exist" do
                if value.eql?"Work"
                  value1 = "Business"
                else
                  value1 = value
                end
                expect(@homepage.goto_office.address_details(value1)).not_to be_present
              end
            end
          end
        when "IM"
          if !contacts[c][key.downcase].to_s.empty?
            it "verifies #{key} details are valid" do
              expect(@homepage.goto_office.no_label_details(key).text).to eql(contacts[c][key.downcase])
            end
          else
            it "verifies #{key} details do not exist" do
              expect(@homepage.goto_office.no_label_details(key)).not_to be_present
            end
          end
        when "Other"
          people[key].each do |value|
            if !contacts[c][value.downcase].to_s.empty?
              it "verifies #{key} #{value} details are valid" do
                if value.eql?("Web page")
                  expect(@homepage.goto_office.link_details(key,value).text).to eql(contacts[c][value.downcase])
                else
                  expect(@homepage.goto_office.text_details(key,value).text).to eql(contacts[c][value.downcase])
                end
              end
            else
              it "verifies #{key} #{value} details do not exist" do
                expect(@homepage.goto_office.link_details(key,value)).not_to be_present
              end
            end
          end
        end
      end
    end
  end
=end
end