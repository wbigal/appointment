require 'spec_helper'

describe User do
	it 'is invalid without abreviacion' do
  	expect(build(:user, abreviacion: nil)).to_not be_valid
  end
  it 'is invalid without apellido_paterno' do
  	expect(build(:user, apellido_paterno: nil)).to_not be_valid
  end
  it 'is invalid without apellido_materno' do
  	expect(build(:user, apellido_materno: nil)).to_not be_valid
  end
  it 'is invalid without nombres' do
  	expect(build(:user, nombres: nil)).to_not be_valid
  end
  it 'is invalid without dni' do
  	expect(build(:user, dni: nil)).to_not be_valid
  end
  it "does not allow a empty dni" do
    expect(build(:user, dni: "")).to_not be_valid
  end  
  it "does not allow a abreviacion with more of 6 characters" do
    expect(build(:user, abreviacion: "a"*7)).to_not be_valid
  end
  it "does not allow a apellido_paterno with more of 250 characters" do
    expect(build(:user, apellido_paterno: "a"*251)).to_not be_valid
  end
  it "does not allow a apellido_materno with more of 250 characters" do
    expect(build(:user, apellido_materno: "a"*251)).to_not be_valid
  end
  it "does not allow a nombres with more of 250 characters" do
    expect(build(:user, nombres: "a"*251)).to_not be_valid
  end
  it "does not allow a user with a same DNI" do
    create(:user, dni: '22345672')
    expect(build(:user, dni: '22345672')).to_not be_valid
  end
  it 'has a correct DNI lenght' do
  	expect(build(:user, dni: '4639908')).to_not be_valid
  	expect(build(:user, dni: '463990822')).to_not be_valid
  end
  it "validates sexo valid" do
    expect(build(:user, sexo: 'MASCULINO')).to be_valid
  end
  it "validates sexo valid" do
    expect(build(:user, sexo: 'FEMENINO')).to be_valid
  end
  it "validates invalid sexo"  do
    expect(build(:user, sexo: 'M')).to_not be_valid
  end
  it 'validates lenght of valid color' do
  	expect(build(:user, color: '#ff4fc')).to_not be_valid
  	expect(build(:user, color: '#ff4fc55')).to_not be_valid
  end
  it 'validates color' do
  	expect(build(:user, color: '#ffz4fc')).to_not be_valid
  end
end 