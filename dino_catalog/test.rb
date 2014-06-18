require 'minitest/autorun'
require 'csv'
require_relative 'dinodex'

class DinodexTest < MiniTest::Spec

  before do
    @albertosaurus = {
      :genus => "Albertosaurus",
      :period => "Late Cretaceous",
      :continent => "North America",
      :diet => "Carnivore",
      :weight => 2000,
      :walking => "Biped",
      :description => "Like a T-Rex but smaller."
    }
  end

  describe DinoCSV do
    it "must return properly formatted hashes" do
      DinoCSV.read("dinodex.csv")
      DinoCSV.read("african_dinosaur_export.csv").first.must_equal({
        :genus => "Abrictosaurus",
        :period => "Jurassic",
        :diet => "Herbivore",
        :weight => 100,
        :walking => "Biped"
      })
    end

    it "processes 'name', 'carnivore', 'weight in pounds', 'yes' and 'no'" do
      DinoCSV.process_header(:NAME).must_equal :genus
      DinoCSV.process_header(:Carnivore).must_equal :diet
      DinoCSV.process_header(:WEIGHT_IN_LBS).must_equal :weight
      DinoCSV.process_cell("No").must_equal "Herbivore"
      DinoCSV.process_cell("Yes").must_equal "Carnivore"
    end
  end

  describe Dinodex do
    before do
      @dinodex = Dinodex.new(DinoCSV.read("dinodex.csv"))
      @dinodex.parse_dinos(DinoCSV.read("african_dinosaur_export.csv"))
      @bipeds = [
        "Abrictosaurus",
        "Afrovenator",
        "Carcharodontosaurus",
        "Suchomimus",
        "Albertosaurus",
        "Albertonykus",
        "Baryonyx",
        "Deinonychus",
        "Megalosaurus",
        "Giganotosaurus",
        "Yangchuanosaurus"
      ].sort
      @carnivores = [
        "Afrovenator",
        "Carcharodontosaurus",
        "Suchomimus",
        "Albertosaurus",
        "Albertonykus",
        "Baryonyx",
        "Deinonychus",
        "Diplocaulus",
        "Megalosaurus",
        "Giganotosaurus",
        "Quetzalcoatlus",
        "Yangchuanosaurus"
      ].sort
      @periods = {
        :albian => ["Carcharodontosaurus"],
        :jurassic => ["Abrictosaurus", "Afrovenator", "Giraffatitan", "Megalosaurus"],
        :cretaceous => [
          "Paralititan",
          "Suchomimus",
          "Albertosaurus",
          "Albertonykus",
          "Baryonyx",
          "Deinonychus",
          "Giganotosaurus",
          "Quetzalcoatlus"
        ].sort,
        :triassic => ["Melanorosaurus"],
        :late_permian => ["Diplocaulus"],
        :oxfordian => ["Yangchuanosaurus"]
      }
      @big_dinos = [
       "Giraffatitan",
       "Paralititan",
       "Suchomimus",
       "Baryonyx",
       "Giganotosaurus",
       "Yangchuanosaurus"
      ].sort
      @small_dinos = [
        "Abrictosaurus",
        "Carcharodontosaurus",
        "Melanorosaurus",
        "Albertosaurus",
        "Megalosaurus",
        "Quetzalcoatlus",
        "Deinonychus"
      ].sort
      @albertosaurus = Dinosaur.new(@albertosaurus)
    end

    it "#carnivores returns an array of all carnivores" do
      @dinodex.carnivores.names.must_equal @carnivores
    end

    it "#bipeds returns an array of all bipeds" do
      @dinodex.bipeds.names.must_equal @bipeds
    end

    it "#from_period(period) returns an array of all dinos from that period" do
      @periods.each do |period, dinos|
        @dinodex.from_period(period).names.must_equal dinos
      end
    end

    it "#big_dinos returns all dinos larger than 2 tons" do
      @dinodex.big_dinos.names.must_equal @big_dinos
    end

    it "#small_dinos returns all dinos smaller than 2 tons" do
      @dinodex.small_dinos.names.must_equal @small_dinos
    end

    def call_method_chain(method_chain, receiver)
      method_chain.reduce(receiver) { |r,m| r.send(*m) }
    end

    it "filters can be chained" do
      methods = [:carnivores, :bipeds, [:from_period, :cretaceous], :big_dinos, :small_dinos]
      methods.permutation.each do |method_chain|
        call_method_chain(method_chain, @dinodex)
      end
    end

    it "Dinosaur#show prints all known facts about a dinosaur" do
      @albertosaurus.show.must_equal("Genus: Albertosaurus\nPeriod: Late Cretaceous\nContinent: North America\nDiet: Carnivore\nWeight: 2000\nWalking: Biped\nDescription: Like a T-Rex but smaller.")
    end
  end
end
