require 'spec_helper'

describe "Comment" do
  before do
    @user = User.create(:username => "Run Simmons")
    @commenter = User.create(:username => "DMC")

    @whos_house =  Question.create(:content => "Who's house?", :author => @user)
    @comment = Comment.create(:content => "Run's House!", :commenter => @commenter)

  end
  it "can be initialized" do
    expect(@comment).to be_an_instance_of(Comment)
  end

  it "can have a commenter name" do
    expect(@comment.commenter.username).to eq("DMC")
  end

  it "belongs to a question" do
    @whos_house.comments << @comment
    expect(@comment.question).to eq(@whos_house)
  end

end
