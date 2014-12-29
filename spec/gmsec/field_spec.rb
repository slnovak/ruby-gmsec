require 'spec_helper'

describe GMSEC::Field do
  context "when specifying value and type" do

    def self.it_persists_data
      it 'persists the correct field name' do
        expect(subject.name).to eq(name)
      end

      it 'persists the correct value' do
        expect(subject.value).to eq(value)
      end

      it 'persists the correct type' do
        expect(subject.type).to eq(type)
      end
    end

    let(:name){"Test"}

    subject do
      described_class.new(name, value, type: type)
    end

    context 'of type :char' do
      let(:type){:char}
      let(:value){"x"}
      it_persists_data
    end

    context 'of type :str' do
      let(:type){:str}
      let(:value){"Test"}
      it_persists_data
    end

    context 'of type :bool' do
      let(:type){:bool}

      context 'with value of true' do
        let(:value){true}
        it_persists_data
      end

      context 'with value of false' do
        let(:value){false}
        it_persists_data
      end
    end

    context 'of type :i16' do
      let(:type){:i16}
      let(:value){42}
      it_persists_data
    end

    context 'of type :i32' do
      let(:type){:i32}
      let(:value){42}
      it_persists_data
    end

    context 'of type :u32' do
      let(:type){:u32}
      let(:value){42}
      it_persists_data
    end

    context 'of type :f32' do
      let(:type){:f32}
      let(:value){42}
      it_persists_data
    end

    context 'of type :f64' do
      let(:type){:f64}
      let(:value){42}
      it_persists_data
    end
  end
end
