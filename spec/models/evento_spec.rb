require 'spec_helper'

describe Evento do
  it 'validates the existence of paciente and docotr in the database: book page 231'
  
  it 'is invalid without paciente_id' do
  	expect(build(:evento, paciente_id: nil)).to_not be_valid
  end
  it 'is invalid without doctor_id' do
  	expect(build(:evento, doctor_id: nil)).to_not be_valid
  end
  it 'is a invalid motivo with > 250 caracters' do
  	expect(build(:evento, motivo: "a"*251)).to have(1).errors_on(:motivo)
  end
  it 'is a invalid registrado_por wiht > 250 caracters' do
  	expect(build(:evento, registrado_por: "a"*251)).to have(1).errors_on(:registrado_por)
  end
  it 'is invalid with start_time > end_time' do
  	expect(build(:evento, start_time: "2014-07-10 14:58:01",
  							end_time: "2014-07-10 13:58:01 -0500")).to_not be_valid
  end
  
  context 'validates the creation of citas with start_time and end_time in the same day' do
    it 'is valid with start_time and end_time in the same day' do
      expect(build(:evento, start_time: "2014-07-10 14:58:01",
                end_time: "2014-07-10 15:58:01")).to be_valid
    end
    it 'is invalid with in a diferent day' do
      expect(build(:evento, start_time: "2014-07-10 14:58:01",
                end_time: "2014-07-11 14:58:0")).to_not be_valid
    end
    it 'is invalid with in a diferent month' do
      expect(build(:evento, start_time: "2014-07-10 14:58:01",
                end_time: "2014-08-10 14:58:01")).to_not be_valid
    end
    it 'is invalid with in a diferent year' do
      expect(build(:evento, start_time: "2014-07-10 14:58:01",
                end_time: "2015-07-10 14:58:01")).to_not be_valid
    end
  end
 
  context	'creation on the same datetime' do
    before(:each) do
      @event = create(:evento, doctor_id: 1, start_time: '2014-07-10 14:00:00',
                               end_time: '2014-07-10 15:00:00')
    end
    context 'for a diferent doctor' do
      it 'allows to create on the same datetime' do
        expect(build(:evento, doctor_id: 2, start_time: '2014-07-10 14:00:00',
                    end_time: '2014-07-10 15:00:00')).to be_valid
      end
    end
    context 'for the same doctor' do
      it 'is invalid with same datetime ' do
        expect(build(:evento, doctor_id: @event.doctor_id, start_time: '2014-07-10 14:00:00',
                               end_time: '2014-07-10 15:00:00')).to_not be_valid 
      end
      it 'is invalid with with inside datetime ' do
        expect(build(:evento, doctor_id: @event.doctor_id, start_time: '2014-07-10 14:15:00',
                               end_time: '2014-07-10 14:45:00')).to_not be_valid
      end
      it 'is invalid with inside botton datetime ' do
        expect(build(:evento, doctor_id: @event.doctor_id, start_time: '2014-07-10 13:00:00',
                               end_time: '2014-07-10 14:30:00')).to_not be_valid
      end
      it 'is invalid with inside top datetime ' do
        expect(build(:evento, doctor_id: @event.doctor_id, start_time: '2014-07-10 14:30:00',
                               end_time: '2014-07-10 15:30:00')).to_not be_valid
      end
      it 'is invalid with same botton datetime ' do
        expect(build(:evento, doctor_id: @event.doctor_id, start_time: '2014-07-10 13:15:00',
                               end_time: '2014-07-10 14:00:00')).to_not be_valid
      end
      it 'is invalid with same top datetime ' do
        expect(build(:evento, doctor_id: @event.doctor_id, start_time: '2014-07-10 15:00:00',
                               end_time: '2014-07-10 15:30:00')).to_not be_valid
      end
      it 'is invalid with ottsider datetime ' do
        expect(build(:evento, doctor_id: @event.doctor_id, start_time: '2014-07-10 13:00:00',
                               end_time: '2014-07-10 16:00:00')).to_not be_valid
      end  
      it 'is valid with a different datetime' do
        expect(build(:evento, doctor_id: @event.doctor_id, start_time: '2014-07-10 13:00:00',
                               end_time: '2014-07-10 13:59:00')).to be_valid
      end    
    end
  end
  describe '#all_in_range' do
    before(:each) do
      @d1_event1 = create(:evento, doctor_id: 1, start_time: '2014-07-10 13:00:00',
                          end_time: '2014-07-10 13:59:00')
      @d1_event2 = create(:evento, doctor_id: 1, start_time: '2014-07-13 13:00:00',
                          end_time: '2014-07-13 13:59:00')
      @d1_event3 = create(:evento, doctor_id: 1, start_time: '2014-12-20 13:00:00',
                          end_time: '2014-12-20 13:59:00')
      @d2_event1 = create(:evento, doctor_id: 2, start_time: '2014-07-15 13:00:00',
                          end_time: '2014-07-15 13:59:00')
    end
    context('with a provided doctor_id') do
      it 'returns not all records for doctor1' do
        expect(Evento.all_in_range(start_date: '2014-07-10',
               end_date: '2014-07-14',
               doctor_id: @d1_event1.doctor_id)).to match_array([@d1_event1,@d1_event2])
      end
      it 'returns all records for doctor1' do
        expect(Evento.all_in_range(start_date: '2014-07-10',
               end_date: '2015-06-13',
               doctor_id: @d1_event1.doctor_id)).to match_array([@d1_event1,@d1_event2,@d1_event3])
      end
      it 'returns and empty array for not matched records' do
        expect(Evento.all_in_range(start_date: '2013-07-10',
               end_date: '2014-06-13',
               doctor_id: @d1_event1.doctor_id)).to match_array([])
      end
      it 'returns all records for doctor2' do  
        expect(Evento.all_in_range(start_date: '2014-07-10',
               end_date: '2015-06-13',
               doctor_id: @d2_event1.doctor_id)).to match_array([@d2_event1])
      end    
    end
    context('without a doctor_id') do
      it 'returns all doctor_events for only one doctor' do
        expect(Evento.all_in_range(start_date: '2014-07-10',
               end_date: '2014-07-14')).to match_array([@d1_event1,@d1_event2])
      end
      it 'returns all doctor_events for all doctor' do
        expect(Evento.all_in_range(start_date: '2014-07-10',
               end_date: '2014-07-16')).to match_array([@d1_event1,@d1_event2,@d2_event1])
      end
    end
  end
end
