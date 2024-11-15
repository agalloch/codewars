SOLAR_MASS    = 4 * Math::PI**2
DAYS_PER_YEAR = 365.24

class Planet
  property x : Float64
  property y : Float64
  property z : Float64
  property vx : Float64
  property vy : Float64
  property vz : Float64
  property mass : Float64

  def initialize(x, y, z, vx, vy, vz, mass)
    @x, @y, @z = x, y, z
    @vx, @vy, @vz = vx * DAYS_PER_YEAR, vy * DAYS_PER_YEAR, vz * DAYS_PER_YEAR
    @mass = mass * SOLAR_MASS
  end

  def move_from_i(bodies, nbodies, dt, i)
    bodies[i..].each do |b2|
      coordinates = distance_to b2
      mag = magnitude coordinates, dt
      b_mass_mag, b2_mass_mag = @mass * mag, b2.mass * mag

      dx, dy, dz = coordinates

      @vx -= dx * b2_mass_mag
      @vy -= dy * b2_mass_mag
      @vz -= dz * b2_mass_mag
      b2.vx += dx * b_mass_mag
      b2.vy += dy * b_mass_mag
      b2.vz += dz * b_mass_mag
    end

    @x += dt * @vx
    @y += dt * @vy
    @z += dt * @vz
  end

  def magnitude(coordinates, dt)
    dx, dy, dz = coordinates
    distance = Math.sqrt dx * dx + dy * dy + dz * dz

    dt / (distance * distance * distance)
  end

  def distance_to(body)
    {@x - body.x, @y - body.y, @z - body.z}
  end
end

def energy(bodies)
  e = 0.0

  bodies.each_with_index do |b, i|
    e += 0.5 * b.mass * (b.vx * b.vx + b.vy * b.vy + b.vz * b.vz)

    bodies[i.succ..].each do |b2|
      dx = b.x - b2.x
      dy = b.y - b2.y
      dz = b.z - b2.z
      distance = Math.sqrt dx * dx + dy * dy + dz * dz
      e -= (b.mass * b2.mass) / distance
    end
  end

  e
end

def offset_momentum(bodies)
  px, py, pz = 0.0, 0.0, 0.0

  bodies.each do |b|
    m = b.mass
    px += b.vx * m
    py += b.vy * m
    pz += b.vz * m
  end

  b = bodies[0]
  b.vx = -px / SOLAR_MASS
  b.vy = -py / SOLAR_MASS
  b.vz = -pz / SOLAR_MASS
end

BODIES = [
  # sun
  Planet.new(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0),

  # jupiter
  Planet.new(
    4.84143144246472090e+00,
    -1.16032004402742839e+00,
    -1.03622044471123109e-01,
    1.66007664274403694e-03,
    7.69901118419740425e-03,
    -6.90460016972063023e-05,
    9.54791938424326609e-04),

  # saturn
  Planet.new(
    8.34336671824457987e+00,
    4.12479856412430479e+00,
    -4.03523417114321381e-01,
    -2.76742510726862411e-03,
    4.99852801234917238e-03,
    2.30417297573763929e-05,
    2.85885980666130812e-04),

  # uranus
  Planet.new(
    1.28943695621391310e+01,
    -1.51111514016986312e+01,
    -2.23307578892655734e-01,
    2.96460137564761618e-03,
    2.37847173959480950e-03,
    -2.96589568540237556e-05,
    4.36624404335156298e-05),

  # neptune
  Planet.new(
    1.53796971148509165e+01,
    -2.59193146099879641e+01,
    1.79258772950371181e-01,
    2.68067772490389322e-03,
    1.62824170038242295e-03,
    -9.51592254519715870e-05,
    5.15138902046611451e-05),
]

n = ARGV[0].to_i

offset_momentum(BODIES)

puts "%.9f" % energy(BODIES)

nbodies = BODIES.size
dt = 0.01

n.times do
  BODIES.each_with_index do |b, i|
    b.move_from_i(BODIES, nbodies, dt, i + 1)
  end
end

puts "%.9f" % energy(BODIES)

# NOTES:
# Crystal 0.34.0 (2020-04-07)

# LLVM: 10.0.0
# Default target: x86_64-apple-macosx

# COMMAND LINE:
# crystal build --release nbodies.cr
# ./nbodies 50000000

# PROGRAM OUTPUT:
# -0.169075164
# -0.169059907

#
# 2024-11-15
# Crystal 1.11.2 (2024-01-18)
#
# LLVM: 17.0.6
# Default target: x86_64-apple-macosx
#
# ./nbodies 50000000  11.11s user 0.04s system 99% cpu 11.150 total
