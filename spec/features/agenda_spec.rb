require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Admin manage appointments'do
  before do
    user = create(:admin_user)
    login_as(user, :scope => :user)
    @doctor1 = create(:doctor_user, apellido_paterno: 'Messi')
    @doctor2 = create(:doctor_user, apellido_paterno: 'Neymar')
    @paciente1 = create(:paciente)
    @paciente2 = create(:paciente, apellido_paterno: 'Alvarez')
    @evento1 = Evento.create(doctor_id: @doctor1.id, start_time: Date.today+12.hours, motivo: 'Dolor de muela',
                        paciente_id: @paciente1.id, end_time: Date.today+13.hours)
    @evento2 = Evento.create(doctor_id: @doctor2.id, start_time: Date.today+16.hours, motivo: 'Dolor de muelinha',
                        paciente_id: @paciente2.id, end_time: Date.today+17.hours)
  end
 
  scenario 'filters not choosing an specific doctor', js: true  do
    visit agenda_path
    click_button('Filtrar')    
    expect(page).to have_text(@paciente1.full_name)
    expect(page).to have_text(@paciente2.full_name)
  end

  scenario ' filters specific doctor', js: true do
    visit agenda_path
    select(@doctor1.full_name, :from => 'select_doctor')
    click_button('Filtrar')
    expect(page).to have_text(@paciente1.full_name)
    expect(page).to_not have_text(@paciente2.full_name)
  end

  scenario 'show information of appointment', js:true do
    visit agenda_path
    filter_and_click_appointment
    expect(page).to have_text('Fecha programada')
    expect(page).to have_text('Dolor de muela')
    expect(page).to have_text('Eliminar evento')
  end

  scenario 'deletes an appointment', js:true do
    visit agenda_path
    filter_and_click_appointment
    click_button('Eliminar evento')
    expect(page).to_not have_text(@paciente1.full_name)
    expect(page).to_not have_text('Eliminar evento')
  end 

  scenario 'creates new event', js:true do
    visit agenda_path
    filter_and_click_calendar
    fill_appointment_form
    expect(page).to have_text('Eliminar evento')
    expect(page).to have_text(Evento.last.motivo)
    expect(page).to have_text('El evento fue creado correctamente.')
  end
 
  def fill_appointment_form
    fill_in('buscar_paciente', :with => @paciente1.full_name[0..3])  
    find('div.autocomplete-suggestion').click()
    fill_in('motivo', :with => 'Tratamiento de ortodoncia.')
    click_button('Crear evento')  
  end

  def filter_and_click_appointment
    filter_doctor()
    find('div.fc-event.fc-event-vert.fc-event-start.fc-event-end').click()
  end
  def filter_and_click_calendar
    filter_doctor()
    find('tr.fc-slot14 > td.fc-widget-content').click()
  end
  def filter_doctor
    select(@doctor1.full_name, :from => 'select_doctor')
    click_button('Filtrar')    
  end

end