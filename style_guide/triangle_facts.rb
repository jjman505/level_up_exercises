class Triangle
  attr_accessor :side1, :side2, :side3

  def initialize(side1, side2, side3)
    @side1 = side1
    @side2 = side2
    @side3 = side3
  end

  def equalateral?
    side1 == side2 && side2 == side3
  end

  def isosceles?
    [side1, side2, side3].uniq.length == 2
  end

  def scalene?
    !(equalateral? || isosceles?)
  end

  def recite_facts
    if equalateral?
      puts "This triangle is equalateral!"
    elsif isosceles?
      puts "This triangle is isosceles! Also, that word is hard to type."
    elsif scalene?
      puts "This triangle is scalene and mathematically boring."
    end

    angles = calculate_angles
    puts "The angles of this triangle are #{angles.join(", ")}"

    if angles.include? 90
      puts "This triangle is also a right triangle!"
    end
    puts ""
  end

  def calculate_angles
    a, b, c = sides
    angle_a = complementary_angle((b**2 + c**2 - a**2) / (2.0 * b * c))
    angle_b = complementary_angle((a**2 + c**2 - b**2) / (2.0 * a * c))
    angle_c = complementary_angle((a**2 + b**2 - c**2) / (2.0 * a * b))

    [angle_a, angle_b, angle_c]
  end

  def complementary_angle(law_of_cosines_operand)
    radians_to_degrees(Math.acos(law_of_cosines_operand))
  end

  def sides
    [side1, side2, side3]
  end

  def radians_to_degrees(rads)
    (rads * 180 / Math::PI).round
  end
end


triangles = [
  [5, 5, 5],
  [5, 12, 13],
]

triangles.each do |sides|
  tri = Triangle.new(*sides)
  tri.recite_facts
end
