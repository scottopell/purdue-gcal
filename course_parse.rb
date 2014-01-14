require 'nokogiri'
require 'awesome_print'
require 'date'

# directly from rails
class String
  # A string is blank if it's empty or contains whitespaces only:
  #
  #   ''.blank?                 # => true
  #   '   '.blank?              # => true
  #   '　'.blank?               # => true
  #   ' something here '.blank? # => false
  def blank?
    self !~ /[^[:space:]]/
  end
end

f = File.open "bwskcrse.html"
doc = Nokogiri::HTML(f)

classes = doc.css("table.datadisplaytable").last
headers = classes.css("th").collect { |t| t.text.downcase.gsub(" ", "_") }

rows = []
classes.css("tr").each do |tr|
  row = Hash.new
  tr.css("td").each_with_index do |td, i|
    row[headers[i].to_sym] = td.text
  end
  rows << row
end

# prune out any garbage rows
rows.reject! { |row| row[:crn].nil? || row[:crn].blank? }

ap rows

rows.each do |row|
  # Event Title
  course_elems = row[:course].split(" ")
  # labs have last element as L01, L02... while lectures
  # are LE1 LE2 or just 001 003 004 etc
  if course_elems.last.match(/L\d{2}/)
    suffix = " lab"
  end
  event_title = "#{course_elems.first} #{course_elems[1][0..-3]}#{suffix}"

  # Course Dates
  start_date = DateTime.parse row[:start_date]
  end_date = DateTime.parse row[:end_date]

  # Time Window
  start_time = DateTime.parse row[:time]

  


  ap event_title
  ap start_date
  ap end_date
  ap start_time
end



