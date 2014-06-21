class Dinodex
  include Enumerable

  attr_accessor :dinos

  def initialize(dinos = [])
    @dinos = []
    self.parse_dinos(dinos)
  end

  def parse_dinos(dinos)
    dinos.map { |dino| @dinos << Dinosaur(dino) }
    @dinos.sort_by!(&:name)
  end

  def each
    @dinos.each
  end

  def select(&block)
    Dinodex.new(@dinos.select(&block))
  end

  def bipeds
    select { |dino| dino.biped? }
  end

  def carnivores
    select { |dino| dino.carnivore? }
  end

  def from_period(period)
    select { |dino| dino.from?(period) }
  end

  def big_dinos
    select { |dino| dino.heavy? }
  end

  def small_dinos
    select { |dino| dino.light? }
  end

  def names
    @dinos.map { |dino| dino.name }
  end
end
