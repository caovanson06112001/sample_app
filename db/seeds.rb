99.times do |n|
  name = "cao son-#{n+1}"
  email = "abc-#{n+1}@gamil.com"
  password = "123123"
  User.create!(name: name,
              email: email,
              password: password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end
