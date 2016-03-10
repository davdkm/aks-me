require 'spec_helper'

describe QuestionsController do
  before do
    queenb = Question.create(:name => "Beyonce")
    kanye = Question.create(:name => "Kanye")
    bqe = Landmark.create(name: 'BQE', year_completed: 1961)
    mr_president = Title.create(name: "Mr. President")
    bqe.question = queenb
    bqe.save
  end

  after do
    Question.destroy_all
    Title.destroy_all
    Landmark.destroy_all
  end

  it "allows you to view form to create a new question" do
    visit '/questions/new'
    expect(page.body).to include('<form')
    expect(page.body).to include('question[name]')
    expect(page.body).to include('question[title_ids][]')
    expect(page.body).to include('question[landmark_ids][]')
    expect(page.body).to include('landmark[name]')
    expect(page.body).to include('title[name]')
  end

  it "allows you to create a new question with a title" do
    visit '/questions/new'
    fill_in :question_name, :with => "Doctor Who"
    check "title_#{Title.first.id}"
    click_button "Create New Question"
    question = Question.last
    expect(Question.all.count).to eq(3)
    expect(question.name).to eq("Doctor Who")
    expect(question.titles).to include(Title.first)
  end

  it "allows you to create a new question with a landmark" do
    visit '/questions/new'
    fill_in :question_name, :with => "Doctor Who"
    check "landmark_#{Landmark.first.id}"
    click_button "Create New Question"
    question = Question.last
    expect(Question.all.count).to eq(3)
    expect(question.name).to eq("Doctor Who")
    expect(question.landmarks).to include(Landmark.first)
  end

   it "allows you to create a new question with a new title" do
    visit '/questions/new'
    fill_in :question_name, :with => "Doctor Who"
    fill_in :new_title, :with => "Time Lord"
    click_button "Create New Question"
    question = Question.last
    title = Title.last
    expect(Question.all.count).to eq(3)
    expect(Title.all.count).to eq(2)
    expect(question.name).to eq("Doctor Who")
    expect(question.titles).to include(title)
  end

  it "allows you to create a new question with a new landmark" do
    visit '/questions/new'
    fill_in :question_name, :with => "Doctor Who"
    fill_in :new_landmark, :with => "The Tardis"
    click_button "Create New Question"
    question = Question.last
    landmark = Landmark.last
    expect(Question.all.count).to eq(3)
    expect(Landmark.all.count).to eq(2)
    expect(question.name).to eq("Doctor Who")
    expect(question.landmarks).to include(landmark)
  end

  it "allows you to list all questions" do
    visit '/questions'

    expect(page.status_code).to eq(200)

    expect(page.body).to include("Beyonce")
    expect(page.body).to include('Kanye')
  end

  it "allows you to see a single Question" do
    @question = Question.first
    get "/questions/#{@question.id}"
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include("#{@question.name}")
  end

  it "allows you to view form to edit a single question" do
    @question = Question.first
    get "/questions/#{@question.id}/edit"

    expect(last_response.status).to eq(
