require 'spec_helper'

describe GMSEC::Config do

  context "a new Config object" do
    it "add persists new configuration options" do
      subject["foo"] = "bar"
      expect(subject["foo"]).to eq("bar")
    end
  end

  context "a Config object with mixed data types" do
    subject do
      described_class.new.tap do |config|
        config["foo"] = "foo"
        config[:bar]  = :bar
        config[42]    = 42
      end
    end

    it "returns nil for config entries that do not exist" do
      expect(subject["nope"]).to be_nil
    end

    it "outputs all values as strings" do
      expect(subject["foo"]).to eq("foo")
      expect(subject[:bar]).to eq("bar")
      expect(subject[42]).to eq("42")
    end

    it "interprets keys as strings" do
      expect(subject["foo"]).to eq("foo")
      expect(subject["bar"]).to eq("bar")
      expect(subject["42"]).to eq("42")
    end

    it "returns all configuration options via #values" do
      expect(subject).to respond_to(:values)
      expect(subject.values).to be_a(Enumerator)
      expect(subject.values.to_a).to eq([["42", "42"], ["bar", "bar"], ["foo", "foo"]])
    end
  end
end
