def Dinosaur(item)
  if item.is_a? Dinosaur
    Dinosaur.new(item.attr_hash)
  elsif item.is_a? Hash
    Dinosaur.new(item)
  else
    raise WrongArgumentTypeError
  end
end

class Dinosaur
  TRAITS = [ :name, :period, :continent,
             :diet, :weight, :walking, :description ]

  attr_accessor *TRAITS

  CARNIVOROUS_DIETS = [ "Carnivore", "Insectivore", "Piscivore" ]

  def initialize(dino_hash = {})
    dino_hash.each { |key, val| send("#{key}=", val) }
  end

  def ==(other)
    TRAITS.all? { |attr| other.send(attr) == self.send(attr) }
  end

  def attr_hash
    TRAITS.inject({}){ |hash, attr| hash[attr] = self.send(attr) }
  end

  def to_s
    attr_hash.map do |attr, val|
      "#{attr.to_s.capitalize}: #{val.to_s}" unless val.nil?
    end.compact.join("\n")
  end

  def carnivore?
    CARNIVOROUS_DIETS.include?(diet)
  end

  def biped?
    walking.eql? "Biped"
  end

  #TODO: is there a better way?
  def from?(target_period)
    target_period = target_period.to_s.gsub!('_', '')
    period =~ /#{target_period}/i
  end

  def heavy?
    weight && weight > 4000
  end

  def light?
    weight && weight =< 4000
  end
end

