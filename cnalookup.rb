require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'hpricot'

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
		certNo = form.field_with(:name=>FieldNames['Cert Number'])	
										
		form.field_with(:name=>FieldNames['Cert Type']).options[1..-1].each do |var|
			puts cnum
			if(var.value == 'CNA')
				form[FieldNames['Cert Type']]='CNA'
				form[FieldNames['First Name']]=fname #'BENJAMIN P'
				form[FieldNames['Last Name']]=lname #'CAACON'
				form[FieldNames['Cert Number']]=cnum#'00561824'
				form.radiobuttons[1].checked=true
				#form.radiobuttons[1].checked=true
				search_result = form.submit(form.button_with(:value=>'Go'))
				l = agent.submit(form, form.buttons.first)
				final = l.body
				puts cnum
				puts fname
				re = cnum
				re1 = fname
				re2 = lname
				re3 = /(No data was found that matches your search criteria. Please try again.)/
				if final.match(re3)
					return false
				else
						if(final.match(re1)&&final.match(re2)&&final.match(re))
						puts "Exists"
						end
					puts  FieldNames['Cert Number']
					return true
				end
		end
	end
end

end