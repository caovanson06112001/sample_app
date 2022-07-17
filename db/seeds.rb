99.times do |n|
  name = "cao son-#{n+1}"
  email = "example-#{n+1}@gamil.com"
  password = "123123"
  User.create!(name: name,
              email: email,
              password: password,
              password_confirmation: password)
end
