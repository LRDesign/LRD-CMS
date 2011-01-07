Factory.define :user do |user|
  user.login 'john'
  user.password 'foobar'
  user.password_confirmation 'foobar'
end