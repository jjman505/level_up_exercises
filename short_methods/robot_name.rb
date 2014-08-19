class NameFormatError < RuntimeError; end;
class NameCollisionError < RuntimeError; end;

class Robot
  attr_accessor :name

  @@registry

  def initialize(args = {})
    @@registry ||= []
    @name_generator = args[:name_generator]

    generate_name

    if name_valid?
      @@registry << @name
    end
  end

  private

  def name_valid?
    properly_formatted? && unique?
  end

  def properly_formatted?
    unless name =~ /[[:alpha:]]{2}[[:digit:]]{3}/
      raise NameFormatError, 'The robot name was improperly formatted!'
    end
  end

  def unique?
    if @@registry.include?(name)
      raise NameCollisionError, 'The generated robot name was already taken!'
    end
  end

  def generate_name
    @name = @name_generator || "#{Robot.generate_chars(2)}#{Robot.generate_nums(3)}"
  end

  def self.generate_chars(n)
    (1..n).map { generate_char }.join("")
  end

  def self.generate_char
    ('A'..'Z').to_a.sample
  end

  def self.generate_nums(n)
    n.times.map { rand(10) }.join
  end
end

robot = Robot.new
puts "My pet robot's name is #{robot.name}, but we usually call him sparky."

# Errors!
# generator = -> { 'AA111' }
# Robot.new(name_generator: generator)
# Robot.new(name_generator: generator)
#
