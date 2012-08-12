# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
#  flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  #flunk "Unimplemented"
  index1 = page.body.index e1
  index2 = page.body.index e2
  index1.should < index2
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(",").each do |rating|
    rating = "ratings_".concat(rating.strip)
    step %{I #{uncheck}check "#{rating}"}
  end
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end

When /I check all ratings/ do
  Movie.all_ratings.each do |rating|
    rating = "ratings_".concat(rating.strip)
    step %{I check "#{rating}"}
  end
end

Then /I should see all of the movies/ do
  where_clause = "'".concat(Movie.all_ratings.join("','")).concat("'")
  page.all('table#movies tbody tr').count.should == Movie.where("rating in (#{where_clause})").length
end

Then /I should not see any movie/ do
  assert page.all('table#movies tbody tr').count == 0
end

Then /I should see movies sorted by title/ do
  @movies = Movie.all(:order => "LOWER(title)")
  count = @movies.length
  0.upto(count-2) do |i|
    mv1 = @movies[i]
    mv2 = @movies[i+1]
    step %{I should see "#{mv1.title}" before "#{mv2.title}"}
  end
end


Then /I should see movies sorted by release_date/ do
  @movies = Movie.all(:order => "release_date")
  count = @movies.length
  0.upto(count-2) do |i|
    mv1 = @movies[i]
    mv2 = @movies[i+1]
    step %{I should see "#{mv1.release_date}" before "#{mv2.release_date}"}
  end
end
