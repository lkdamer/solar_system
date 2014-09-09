class Planet
  attr_accessor :name, :diameter, :moons, :habitable, :type, :sol_rot_rate, :sun_dist

  def initialize(hash)
    @name = hash[:name]
    @diameter = hash[:diameter]

    @moons = []
    hash[:moons].each do |moon|
      @moons << Moon.new(moon)
    end

    @habitable = hash[:habitable]
    @type = hash[:type]
    @sol_rot_rate = hash[:sol_rot_rate]
    @sun_dist = hash[:sun_dist]
  end

  def local_age(s_system_age)
    s_system_age/@sol_rot_rate
  end


  class Moon
    attr_accessor :name, :diameter, :habitable, :type

    def initialize(hash)
      @name = hash[:name]
      @diameter = hash[:diameter]
      @habitable = hash[:habitable]
      @type = hash[:type]
    end
  end

end

class SolarSystem
  attr_accessor :planets, :age

  def initialize(array)
    @age = (325 * 365) #age of solar system in Dirt days
    @planets = []
    array.each do |p_hash|
      @planets << Planet.new(p_hash)
    end
    @planets
  end

  def planet_info
    while true
      puts "Would you like to learn about interplanetary distances?"
      input = gets.chomp.downcase
      quit_check(input)
      if input == "yes"
        int_plan_dist
      end
      puts "Would you like to learn more about a specific planet?"
      p = pick_a_planet
      puts "You would like to know more about #{p.name}."
      puts "What would you like to know more about?"
      puts "#{p.name}'s diameter, moons, habitability, type,\nrotation rate, or distance from the sun?"
      topic = pick_a_topic
      disp_topic_info(p, topic)
    end
  end

  def int_plan_dist
    puts "For which two planets do you want to calculate interplanetary distance?"
    planet1 = nil
    planet2 = nil
    while planet1 == planet2
      planet1 = pick_a_planet
      planet2 = pick_a_planet
    end
    dist = (planet1.sun_dist - planet2.sun_dist).abs
    puts "The distance between #{planet1.name} and #{planet2.name} is #{dist}."
  end

  def quit_check(input)
    if ["quit", "end", "no", "exit"].include?(input.downcase)
      puts "Okay, bye!"
      abort
    end
  end

  def pick_a_planet
    planet_finder = {}
    puts "Please type a planet name."
    planets.each do |planet|
      planet_finder[planet.name] = planet
    end
    input = gets.chomp
    while !planet_finder.keys.include?(input)
      quit_check(input)
      puts "That's not a planet name I recognize. Try again"
      input = gets.chomp
    end
    planet_finder[input]
  end

  def pick_a_topic
    input = gets.chomp.downcase
    while !["diameter", "moons", "habitability", "type", "rotation rate"].include?(input)
      quit_check(input)
      puts "That's not something I know about.\nPlease pick one of the options I offered."
      input = gets.chomp.downcase
    end
    input
  end

  def disp_topic_info(planet, topic)
    case topic
    when "diameter"
      puts "#{planet.name}'s diameter is #{planet.diameter}."
    when "moons"
      if planet.moons.length == 0
        puts "This planet has no moons."
      elsif planet.moons.length == 1
        puts "This planet has one moon"
        puts "It is named:"
        z = moon_name(planet)
        y = moon_finder(z, planet)
        moon_info(y)
      else
        puts "This planet has #{planet.moons.length.to_s} moons.\nThey are named:"
        z = moon_name(planet)
        y = moon_finder(z, planet)
        moon_info(y)
      end
    when "habitability"
      puts "It is #{planet.habitable} that #{planet.name}is habitable."
    when "type"
      puts "#{planet.name} is a #{planet.type.to_s} planet."
    when "rotation rate"
      puts "#{planet.name} has a rotation rate of #{planet.sol_rot_rate.to_s} Dirt days"
    end
  end

  def moon_finder(name, planet)
    planet.moons.each do |moon|
      if moon.name == name
        print moon
        return moon
      end
    end
  end

  def moon_info(moon)
    puts "#{moon.name}'s diameter is #{moon.diameter}."
    puts "It is #{moon.habitable} that #{moon.name} is habitable."
    puts "#{moon.name} is made of #{moon.type}."

  end

  def moon_name(planet)
    moons = planet.moons
    moons.each do |moon|
      puts moon.name
    end
    puts "Would you like to learn more?"
    input = gets.chomp.downcase
    quit_check(input)
    if input =="yes"
      puts "Enter the name of the moon you would like to know more about."
      input = gets.chomp.downcase
      quit_check(input)
      return input.capitalize
    end
  end
end

planets = [
  {name: "Hermes",
    diameter: "small",
    moons: [
      {name: "Moonywoony",
        diameter: "tiny",
        habitable: "not the case",
        type: :gas}],
    habitable: "highly unlikely",
    type: :rocky,
    sol_rot_rate: 59,
    sun_dist: 100},
  {name: "Aphrodite",
    diameter: "smallish",
    moons: [
      {name: "Wooooo!",
        diameter: "teeny",
        habitable: "not the case",
        type: :rock}],
    habitable: "highly unlikely",
    type: :rocky,
    sol_rot_rate: 243,
    sun_dist: 150},
  {name: "Dirt",
    diameter: "pretty standard",
    moons: [
      {name: "Luna",
      diameter: "small",
      habitable: "possible",
      type: :rock}],
    habitable: "true",
    type: :rocky,
    sol_rot_rate: 365,
    sun_dist: 225},
  {name: "Ares",
    diameter: "same-ish as Dirt",
    moons: [
      {name: "McMoon",
        diameter: "small",
        habitable: "true",
        type: :rock},
      {name: "Duck",
        diameter: "sizeable",
        habitable: "not the case",
        type: :rock}],
    habitable: "possible",
    type: :rocky,
    sol_rot_rate: 687,
    sun_dist: 347}]

z = SolarSystem.new(planets)
puts "Here are the planets in this solar system."
z.planets.each do |planet|
  puts "#{planet.name}"
end
z.planet_info
