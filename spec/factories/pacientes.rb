# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do 
  factory :paciente do
    apellido_paterno "Paez"
    apellido_materno "Chavez"
    nombres "Wenceslao"
    fecha_nacimiento "2014-07-24"
    sexo "Masculino"
    domicilio "Jr. Avellaneda 1122"
    lugar_nacimiento "Hyo"
    telefono_fijo "222222"
    telefono_celular "222222"
    estado_civil "Soltero"
    ocupacion "Profesional"
    recomendado_por "Juan Chavez"
  end
end
