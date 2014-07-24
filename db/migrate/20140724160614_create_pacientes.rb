class CreatePacientes < ActiveRecord::Migration
  def change
    create_table :pacientes do |t|
      t.string :apellido_paterno
      t.string :apellido_materno
      t.string :nombres
      t.string :full_name
      t.date :fecha_nacimiento
      t.string :sexo
      t.string :domicilio
      t.string :lugar_nacimiento
      t.string :telefono_fijo
      t.string :telefono_celular
      t.string :estado_civil
      t.string :ocupacion
      t.string :recomendado_por

      t.timestamps
    end
  end
end
