require 'spec_helper'

describe "User" do
  before do
    @user = User.create(:username => "Run Simmons")

    whos_house =  Question.create(:content => "Who's house?", :author => @user)

    run_dmc = Group.create(:name => "Run-D.M.C")

    whos_house.genre_ids = run_dmc.id

  end
  it "can be initialized" do
    expect(@user).to be_an_instance_of(User)
  end

  it "can have a name" do
    expect(@user.username).to eq("Run Simmons")
  end

  it "has many questions" do
    expect(@user.questions.count).to eq(1)
  end

  it "can have many groups" do
    expect(@user.groups.count).to eq(1)
  end

  it "can slugify it's name" do

    expect(@user.slug).to eq("run-dmc")
  end

  describe "Class methods" do
    it "given the slug can find a User" do
      slug = "run-dmc"
      expect((User.find_by_slug(slug)).name).to eq("Run-D.M.C")
    end
  end

end
