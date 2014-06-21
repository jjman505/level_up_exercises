require 'minitest/autorun'
require 'csv'
require_relative '../dinosaur'

describe Dinosaur, "Dinosaur" do
  before do
    @albertosaurus = Dinosaur.new({:name => "Albertosaurus"})
  end

  describe "#to_s" do
    it "must print all known facts" do
      @albertosaurus.to_s.must_match /Name/
      @albertosaurus.to_s.must_match /Albertosaurus/
      @albertosaurus.to_s.wont_match /Period/
    end
  end
end
