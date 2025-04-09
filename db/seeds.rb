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

# Create 12 users
users = 12.times.map do |i|
  User.create!(
    name: "User #{i + 1}",
    email: "user#{i + 1}@example.com",
    password: "password"
  )
end

# Create rating scale
scale = RatingScale.create!(
  name: "5 point rating scale",
  description: "1 to 5 satisfaction range"
)

rating_values = [
  { label: "Not At All", value: 1 },
  { label: "Slightly", value: 2 },
  { label: "Somewhat", value: 3 },
  { label: "Mostly", value: 4 },
  { label: "Completely", value: 5 }
]

rating_values.each { |opt| scale.rating_options.create!(opt) }

# Categories and questions
categories_with_questions = {
  "Teamwork" => [
    "Collaborates effectively",
    "Supports team members",
    "Accepts feedback",
    "Contributes to team success"
  ],
  "Communication" => [
    "Communicates clearly",
    "Listens actively",
    "Shares information",
    "Gives constructive feedback",
    "Responds in a timely manner"
  ],
  "Problem Solving" => [
    "Identifies problems quickly",
    "Thinks critically",
    "Suggests creative solutions",
    "Implements fixes efficiently"
  ],
  "Leadership" => [
    "Inspires others",
    "Delegates effectively",
    "Leads by example",
    "Takes responsibility"
  ],
  "Time Management" => [
    "Meets deadlines",
    "Prioritizes tasks",
    "Avoids procrastination",
    "Uses time efficiently"
  ],
  "Technical Skills" => [
    "Understands tools and platforms",
    "Writes clean code",
    "Troubleshoots issues",
    "Adapts to new technologies",
    "Follows best practices"
  ]
}

categories = []
questions = []

categories_with_questions.each do |cat_name, question_texts|
  category = Category.create!(name: cat_name)
  categories << category
  question_texts.each do |text|
    questions << Question.create!(content: text, category: category)
  end
end

# Create a survey
survey = Survey.create!(
  name: "Quarterly Review",
  description: "Q1 2025 Performance Survey",
  status: "active",
  rating_scale: scale
)

# Assign questions and users to survey
survey.questions << questions
survey.users << users

# Create responses for each user and question
users.each do |user|
  questions.each do |question|
    Response.create!(
      survey: survey,
      user: user,
      question: question,
      rating_option: scale.rating_options.sample
    )
  end
end

