# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:email) { |n| "test#{n}@test.com" }
  sequence(:dni) { |n| 10000000 + n }
  factory :user do
  	email
  	password '1234abcd'
  	password_confirmation '1234abcd'
  	dni
  	apellido_paterno 'Paez'
  	apellido_materno 'Chavez'
  	nombres 'Wenceslao'
  	color '#5cb85c'
    abreviacion 'Ing.'
    sexo 'MASCULINO'
    admin false
    doctor false
    superadmin false
  	factory :admin_user do
    	admin true
    end
    factory :doctor_user do
    	doctor true
    end
    factory :superadmin_user do
      superadmin true
    end    

  end
end
