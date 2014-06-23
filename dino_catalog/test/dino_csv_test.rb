require 'minitest/autorun'
require 'csv'
require_relative '../dino_csv'

describe DinoCSV do
  it "must return properly formatted hashes" do
    DinoCSV.read("test/dino_test.csv").first.must_equal({
      :name => "Albertosaurus",
      :period => "Late Cretaceous",
      :continent => "North America",
      :diet => "Carnivore",
      :weight => 2000,
      :walking => "Biped",
      :description => "Like a T-Rex but smaller."
    })
    DinoCSV.read("test/african_test.csv").first.must_equal({
      :name => "Abrictosaurus",
      :period => "Jurassic",
      :diet => "Herbivore",
      :weight => 100,
      :walking => "Biped"
    })
  end
end
