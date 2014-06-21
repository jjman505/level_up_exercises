require 'minitest/autorun'
require 'csv'
require_relative '../dinodex'

describe Dinodex, "Dinodex" do
  before do
    #TODO: don't use DinoCSV to test Dinodex
    @dinodex = Dinodex.new(DinoCSV.read("test/dino_test.csv"))
    @dinodex.parse_dinos(DinoCSV.read("test/african_test.csv"))
    @periods = {
      :jurassic => ["Abrictosaurus", "Megalosaurus"],
      :cretaceous => ["Albertosaurus", "Albertonykus", "Paralititan"],
      "late_permian" => ["Diplocaulus"],
    }
  end

  it "#carnivores returns an array of all carnivores" do
    @dinodex.carnivores.names.must_include "Albertosaurus"
    @dinodex.carnivores.names.must_include "Albertonykus"
    @dinodex.carnivores.names.wont_include "Abrictosaurus"
  end

  it "#bipeds returns an array of all bipeds" do
    @dinodex.bipeds.names.must_include "Albertosaurus"
    @dinodex.bipeds.names.wont_include "Diplocaulus"
  end

  it "#from_period(period) returns an array of all dinos from that period" do
    @periods.each do |period, dinos|
      @dinodex.from_period(period).names.must_equal dinos.sort
    end
  end

  it "#big_dinos returns all dinos larger than 2 tons" do
    @dinodex.big_dinos.names.must_include "Paralititan"
    @dinodex.big_dinos.names.wont_include "Megalosaurus"
    @dinodex.small_dinos.names.wont_include "Albertonykus"
  end

  it "#small_dinos returns all dinos smaller than 2 tons" do
    @dinodex.small_dinos.names.must_include "Megalosaurus"
    @dinodex.small_dinos.names.wont_include "Paralititan"
    @dinodex.small_dinos.names.wont_include "Albertonykus"
  end

  it "filters can be chained" do
    methods = [:carnivores, :bipeds, [:from_period, :cretaceous],
               :big_dinos, :small_dinos]
    methods.each { |method| @dinodex.send(*method).is_a? Dinodex }
  end
end

