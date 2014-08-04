# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :evento do    
  	association :paciente, factory: :paciente
  	association :doctor, factory: :doctor_user  
    motivo "Dolor de muela"
    start_time "2014-07-10 12:58:01"
    end_time "2014-07-10 13:58:01"
  end
end
