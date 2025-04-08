# Clear previous data
Response.delete_all
SurveyUser.delete_all
SurveyQuestion.delete_all
Survey.delete_all
RatingOption.delete_all
RatingScale.delete_all
Question.delete_all
Category.delete_all
User.delete_all


# Users
user1 = User.create(name: "admin", email: "admin@example.com", password: "password")
user2 = User.create(name: "user1", email: "user2@example.com", password: "password")

# Rating Scales
scale = RatingScale.create!(name: "Agreement Scale", description: "1 to 5 Agreement")
scale.rating_options.create!([
  { label: "Strongly Disagree", value: 1 },
  { label: "Disagree", value: 2 },
  { label: "Neutral", value: 3 },
  { label: "Agree", value: 4 },
  { label: "Strongly Agree", value: 5 }
])

# Categories
cat1 = Category.create!(name: "Teamwork")
cat2 = Category.create!(name: "Communication")

# Questions
q1 = Question.create!(content: "Works well in a team", category: cat1)
q2 = Question.create!(content: "Communicates clearly", category: cat2)
q3 = Question.create!(content: "Supports teammates", category: cat1)

# Survey
survey = Survey.create!(
  name: "Quarterly Review",
  description: "Q1 2025 Performance Survey",
  status: "active",
  rating_scale: scale
)

# Assign questions and users to survey
survey.questions << [ q1, q2, q3 ]
survey.users << [ user1, user2 ]

# Create sample responses
Response.create!([
  {
    survey: survey,
    user: user1,
    question: q1,
    rating_option: scale.rating_options.find_by(value: 4) # Agree
  },
  {
    survey: survey,
    user: user1,
    question: q2,
    rating_option: scale.rating_options.find_by(value: 5) # Strongly Agree
  },
  {
    survey: survey,
    user: user2,
    question: q1,
    rating_option: scale.rating_options.find_by(value: 3) # Neutral
  }
])
