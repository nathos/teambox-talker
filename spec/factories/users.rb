Factory.define :user do |f|
  f.sequence(:name) {|n| "User#{n}"}
  f.sequence(:email) {|n| "email#{n}@talkerapp.com"}
end

Factory.define :talker_user, :class => User do |f|
  f.name "Talker"
  f.email "bot@talkerapp.com"
  f.staff true
  f.time_zone "Atlantic Time (Canada)"

  f.after_create do |user| 
    Factory(:plugin, :name => Plugin::DEFAULTS.first, :author => user)
  end
end
