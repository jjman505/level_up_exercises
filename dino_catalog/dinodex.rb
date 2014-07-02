class Dinodex
  attr_accessor :dinos

  def initialize(dinos = [])
    @dinos = []
    parse_dinos(dinos)
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
    select(&:biped?)
  end

  def carnivores
    select(&:carnivore?)
  end

  def from_period(period)
    select { |dino| dino.from?(period) }
  end

  def big_dinos
    select(&:heavy?)
  end

  def small_dinos
    select(&:light?)
  end

  def names
    @dinos.map(&:name)
  end
end

