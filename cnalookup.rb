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
		puts cnum
		puts fname
		puts lname
		agent = Mechanize.new
		agent.get(@url)
		form = agent.page.form_with(:action=>/SearchPage.aspx/)
		certNo = form.field_with(:name=>FieldNames['Cert Number'])	
										
		form.field_with(:name=>FieldNames['Cert Type']).options[1..-1].each do |var|
			if(var.value == 'CNA')
				form[FieldNames['Cert Type']]='CNA'
				form[FieldNames['First Name']]=fname #'BENJAMIN P'
				form[FieldNames['Last Name']]=lname #'CAACON'
				form[FieldNames['Cert Number']]=cnum#'00561824'
				form.radiobuttons[1].checked=true
				#form.radiobuttons[1].checked=true
				#search_result = form.submit(form.button_with(:value=>'Go'))
				l = agent.submit(form, form.buttons.first)
				final = l.body
				#puts final
				x = cnum
				if final.include? cnum
					puts "??!!"
				end
				puts final
				 
				doc = Nokogiri::HTML(final)
				doc.search('//td').each do |cell|
			  		puts cell.content
			  		if(cell.content).include? 'No data was found that matches your search criteria. Please try again'
			  			puts 'Not found!'
			  			return nil
					end
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