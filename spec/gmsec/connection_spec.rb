require 'spec_helper'

describe GMSEC::Connection do

  context 'a Connection instance instantiated with configuration options' do
    subject { described_class.new(foo: :bar) }

    it 'interprets arguments as configuration options' do
      expect(subject.config[:foo]).to eq("bar")
    end
  end
end
