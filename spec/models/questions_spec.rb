require 'spec_helper'

describe "Question" do
  before do
    @user = User.create(:username => "Run Simmons")

    @question =  Question.create(:content => "Who's house?", :author => @user)

  end

  it "can initialize a question" do
    expect(Question.new).to be_an_instance_of(Question)
  end

  it "can have a question" do
    expect(@question.content).to eq("Who's house?")
  end

  it "has an author" do
    expect(@question.author).to eq(@user)
  end

end
