# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :paciente do
    apellido_paterno "MyString"
    apellido_materno "MyString"
    nombres "MyString"
    full_name "MyString"
    fecha_nacimiento "2014-07-24"
    sexo "MyString"
    domicilio "MyString"
    lugar_nacimiento "MyString"
    telefono_fijo "MyString"
    telefono_celular "MyString"
    estado_civil "MyString"
    ocupacion "MyString"
    recomendado_por "MyString"
  end
end
