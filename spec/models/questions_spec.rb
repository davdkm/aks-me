require 'spec_helper'

describe "Question" do
  before do
    @comment = Question.create(:name => "Fiorello LaGuardia")

    @airport =  Question.create(:name => "LG Airport", :year_completed => 1950)
    @library = Question.create(:name => "Library")

  end


  it "has a name and a year_completed" do
    expect(@airport.name).to eq("LG Airport")
    expect(@airport.year_completed).to eq(1950)
  end

  it "belongs to a comment" do
    @comment.landmarks << @airport
    expect(@airport.comment).to eq(@comment)
  end
end
