# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :evento do
    paciente_id 1
    doctor_id 1
    motivo "Dolor de muela"
    start_time "2014-07-10 13:58:01"
    end_time "2014-07-10 13:58:01"
    registrado_por "Administrador"
    confirmado false
  end
end
