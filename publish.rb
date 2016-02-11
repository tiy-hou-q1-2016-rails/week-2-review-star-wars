require 'csv'
require 'erb'
# reads from the template (or ERB file)

html = File.read("template.erb")

# replaces with values

page_title = "Who likes (if any) Jar Jar"

responses = []

CSV.foreach("StarWars.csv", headers: true) do |row|
  responses << row.to_hash
end

eighteen = []
thirty = []
fifty = []
sixty = []

responses.each do |response|
  if response["Jar Jar Binks"] == "Very favorably"
    value = 5
  elsif response["Jar Jar Binks"] == "Somewhat favorably"
    value = 4
  elsif response["Jar Jar Binks"] == "Neither favorably nor unfavorably (neutral)"
    value = 3
  elsif response["Jar Jar Binks"] == "Somewhat unfavorably"
    value = 2
  elsif response["Jar Jar Binks"] == "Very unfavorably"
    value = 1
  end

  if value

    if response["Age"] == "18-29"
      eighteen << value
    elsif response["Age"] == "30-44"
      thirty << value
    elsif response["Age"] == "45-60"
      fifty << value
    elsif response["Age"] == "> 60"
      sixty << value
    end

  end


end

age_groups = responses.map do |response|
  response["Age"]
end
age_groups = age_groups.uniq

favorable = responses.map do |response|
  response["Jar Jar Binks"]
end
favorable = favorable.uniq

avg_eighteen = eighteen.reduce(:+) / eighteen.count
avg_thirty = thirty.reduce(:+) / thirty.count
avg_fifty = fifty.reduce(:+) / fifty.count
avg_sixty = sixty.reduce(:+) / sixty.count


new_html = ERB.new(html).result(binding)

# writes the HTML file
File.open("report.html", "wb") do |file|
  file.write(new_html)
  file.close
end
