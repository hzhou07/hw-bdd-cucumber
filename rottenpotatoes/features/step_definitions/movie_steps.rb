# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(title: movie[:title], rating: movie[:rating], release_date: movie[:release_date])
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
	regexp = /#{e1}.*#{e2}/m
#	page.body.should =~ regexp
	expect(page).to have_content(regexp)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
	arr = rating_list.split(", ")
	if uncheck.nil?
		arr.each do |r|
			steps %Q{When I check "#{r}"}
		end
	else
		arr.each do |r|
			steps %Q{When I uncheck"#{r}"}
		end
	end

end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
	#puts page.text
	#puts '=='
	#puts page.body
	#puts '=='
	#puts page.html
	#puts '=='
	#puts page.source
	rows = page.text.scan(/More about/).length
	expect(rows).to eq(10)
end
