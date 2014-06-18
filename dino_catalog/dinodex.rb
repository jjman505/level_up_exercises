require 'csv'

class DinoCSV
  def self.read(filename)
    dinos = []
    table = CSV.table(filename)
    table.headers.map! { |h| process_header(h) }
    table.each do |row|
      dino_hash = {}
      row.each { |k, v| dino_hash[process_header(k)] = process_cell(v) }
      dinos << dino_hash
    end
    dinos.sort { |a,b| a[:genus] <=> b[:genus] }
  end

  def self.process_header(item)
    process(item, {
      :name => :genus,
      :carnivore => :diet,
      :weight_in_lbs => :weight
    })
  end

  def self.process_cell(item)
    process(item, {
      "yes" => "Carnivore",
      "no" => "Herbivore"
    })
  end

  def self.process(item, conversions)
    (item.respond_to?(:downcase) && conversions[item.downcase]) || item
  end
end

class Dinodex
  attr_accessor :dinos

  def initialize(dinos = [])
    @dinos = []
    self.parse_dinos(dinos)
  end

  def parse_dinos(dinos)
    dinos.each { |dino| @dinos << Dinosaur.new(dino) }
    @dinos.sort! { |a, b| a.name <=> b.name }
  end

  def each
    @dinos.each
  end

  def get(genus)
    show(@dinos.select{ |dino| dino.genus == genus }.first)
  end

  def show
    each { |dino| dino.show }
  end

  def show(dino)
    get(dino).show
  end

  def find_where(&block)
    Dinodex.new(@dinos.select(&block))
  end

  def bipeds
    find_where { |dino| dino.biped? }
  end

  def carnivores
    find_where { |dino| dino.carnivore? }
  end

  def from_period(period)
    find_where { |dino| dino.from?(period) }
  end

  def big_dinos
    find_where { |dino| dino.heavy? }
  end

  def small_dinos
    find_where { |dino| dino.light? }
  end

  def names
    @dinos.map { |dino| dino.genus }
  end
end

class Dinosaur
  TRAITS = [ :genus, :period, :continent,
             :diet, :weight, :walking, :description ]

  attr_accessor *TRAITS

  alias :name :genus
  alias :name= :genus=

  def initialize(dino_hash = {})
    dino_hash = dino_hash.attr_hash if dino_hash.is_a?(Dinosaur)
    dino_hash.each do |key, value|
      send("#{key}=", value)
    end
  end

  def ==(other_dino)
    TRAITS.each do |key|
      return false if other_dino.send(key) != self.send(key)
    end
  end

  def attr_hash
    TRAITS.map { |attr| [attr, self.send(attr)] }.to_h
  end

  def show
    defined_attributes = attr_hash.select { |_, val| val != nil }
    attribute_string = ""
    defined_attributes.each do |attr, val|
      attribute_string << "#{attr.to_s.capitalize}: #{val.to_s}\n"
    end
    attribute_string.chomp
  end

  def carnivore?
    ["Carnivore", "Piscivore", "Insectivore"].include?(@diet)
  end

  def biped?
    @walking == "Biped"
  end

  def from?(period)
    @period.downcase.include?(period.to_s.downcase.tr('_',' '))
  end

  def heavy?
    @weight && @weight > 4000
  end

  def light?
    @weight && @weight < 4000
  end
end


