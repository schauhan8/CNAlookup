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

	def InitURL()
		agent = Mechanize.new
		agent.get(@url)
		form = agent.page.form_with(:action=>/SearchPage.aspx/)
		certNo = form.field_with(:name=>FieldNames['Cert Number'])	
										
		form.field_with(:name=>FieldNames['Cert Type']).options[1..-1].each do |var|
			if(var.value == 'CNA')
				form[FieldNames['Cert Type']]='CNA'
				form[FieldNames['First Name']]='BENJAMIN P'
				form[FieldNames['Last Name']]='CAACON'
				form[FieldNames['Cert Number']]='00561824'
				form.radiobuttons[1].checked=true
				#form.radiobuttons[1].checked=true
				search_result = form.submit(form.button_with(:value=>'Go'))
				l = agent.submit(form, form.buttons.first)
				#puts l.body
				doc=l.body
				doc.search("div")
				if l.body.include? /No results/
					print "Nope"
					return false
				else
					puts "Exists"
					puts  FieldNames['Cert Number']
					return true
				end
			end
		end
	end
end

url = 'http://www.apps.cdph.ca.gov/cvl/SearchPage.aspx'
p = URLMaker.new(url)
p.InitURL()


