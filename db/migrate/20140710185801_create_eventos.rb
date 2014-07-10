class CreateEventos < ActiveRecord::Migration
  def change
    create_table :eventos do |t|
      t.integer :paciente_id
      t.integer :doctor_id
      t.string :motivo
      t.datetime :start_time
      t.datetime :end_time
      t.string :registrado_por
      t.boolean :confirmado, default: false

      t.timestamps
    end
    add_index :eventos, [:doctor_id]
  end
end
