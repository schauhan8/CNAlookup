require 'rubygems'
require 'mechanize'
require 'nokogiri'

FieldNames = {
		'First Name' => 'ctl00$ContentPlaceHolderMiddleColumn$txtFirstName',
		'Last Name' => 'ctl00$ContentPlaceHolderMiddleColumn$txtLastName',
		'Cert Type' => 'ctl00$ContentPlaceHolderMiddleColumn$ddlCertType',
		'Cert Number' => 'ctl00$ContentPlaceHolderMiddleColumn$txtCertNumber'
		}

class URLMaker
	def initialize(url)
		@url=url
	end

	def InitURL(cnum, fname, lname)
		agent = Mechanize.new
		agent.get(@url)
		form = agent.page.form_with(:action=>/SearchPage.aspx/)
		form.radiobuttons.each do |var|
			puts var.value
			if var.value == 'rdoTypeNo'
				form.radiobutton_with(:value => var.value).check
			end
		end	

		certNo = form.field_with(:name=>FieldNames['Cert Number'])	
		form.field_with(:name=>FieldNames['Cert Type']).options[2..2].each do |var|
				form[FieldNames['Cert Type']]='CNA'
				form[FieldNames['First Name']]='BENJAMIN P'
				form[FieldNames['Last Name']]='CAACON'
				form[FieldNames['Cert Number']]='00561824'
				
				search_result = form.submit(form.button_with(:value=>'Go'))
				l = agent.submit(form, form.buttons.first)
				form["submit"] = 'submit'
				final = l.body
				#puts final
				re3 = 'No data was found'
				doc = Nokogiri::HTML(final)
				doc.search('//td').each do |cell|
			  		puts cell.content
			  		if(cell.content).include? re3
			  			puts re3
			  			return nil
					end
				end
		end
	end
end


url = 'http://www.apps.cdph.ca.gov/cvl/SearchPage.aspx'
p = URLMaker.new(url)
x = p.InitURL('00561824', 'BENJAMIN P', 'CAACON')
if x==nil
	puts 'value does not exist'
else
	puts 'value exists'
end