Factory.define :user do |user|
  user.sequence :login do |n| "username #{n}" end
  user.password 'password'
  user.password_confirmation 'password'
end