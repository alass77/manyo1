FactoryBot.define do
  factory :user do
    name { "didi" }
    email { "didi@gmail.com" }
    password { "123456" }
    password_confirmation { "123456" }
    admin { false }
  end

  factory :second_user, class: User do
    name { "dada" }
    email { "dada2@gmail.com" }
    password { "123456" }
    password_confirmation { "123456" }
    admin { true }
  end
end
