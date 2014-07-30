# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140724160614) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "eventos", force: true do |t|
    t.integer  "paciente_id"
    t.integer  "doctor_id"
    t.string   "motivo"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "registrado_por"
    t.boolean  "confirmado",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "eventos", ["doctor_id"], name: "index_eventos_on_doctor_id", using: :btree

  create_table "pacientes", force: true do |t|
    t.string   "apellido_paterno"
    t.string   "apellido_materno"
    t.string   "nombres"
    t.string   "full_name"
    t.date     "fecha_nacimiento"
    t.string   "sexo"
    t.string   "domicilio"
    t.string   "lugar_nacimiento"
    t.string   "telefono_fijo"
    t.string   "telefono_celular"
    t.string   "estado_civil"
    t.string   "ocupacion"
    t.string   "recomendado_por"
    t.string   "dni"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
