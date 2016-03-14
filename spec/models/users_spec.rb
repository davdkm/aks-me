require 'spec_helper'

describe "User" do
  before do
    @user = User.create(:username => "Run Simmons", :email => "test@email.com", :password => "test")

    whos_house =  Question.create(:content => "Who's house?", :author => @user)
    walk_which_way = Question.create(:content => "Walk which way?", :author => @user)

  end
  it "can be initialized" do
    expect(@user).to be_an_instance_of(User)
  end

  it "can have a name" do
    expect(@user.username).to eq("Run Simmons")
  end

  it "has many questions" do
    expect(@user.authored_questions.count).to eq(2)
  end

  it "can slugify it's name" do

    expect(@user.slug).to eq("run-simmons")
  end

  describe "Class methods" do
    it "given the slug can find a User" do
      slug = "run-simmons"
      expect((User.find_by_slug(slug)).username).to eq("Run Simmons")
    end
  end

end
