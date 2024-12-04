{.floatChecks: on}

import std/math
import std/strformat
import std/strutils

const
  solarMass: float64   = 4 * pow(PI, 2)
  daysPerYear: float64 = 365.24

type
  Planet = object
    name: string
    x,y,z: float64 = 0.0
    vx, vy, vz: float64 = 0.0
    mass: float64 = 1.0

  SolarSystem = array[0..4, Planet]

proc newP(name: string, x,y,z,vx,vy,vz: float64 = 0.0'f64, mass = 1.0'f64): Planet =
  Planet(name: name, x: x, y: y, z: z,
    vx: vx * daysPerYear, vy: vy * daysPerYear, vz: vz * daysPerYear,
    mass: mass * solarMass)

proc offsetMomentum(bodies: SolarSystem) =
  var
    px, py, pz: float64 = 0.0

  # for body in bodies:
  let body = bodies[1]
  echo body
  let m = body.mass

  px += body.vx * m
  echo "Product of ", body.vx, " and ", m, " is ", px
  py += body.vy * m
  pz += body.vz * m

  # echo body
  echo &"{body.name} {px}, {py}, {pz}"

  var b = bodies[0]
  echo "Before: ", b
  b.vx = -px / solarMass
  b.vy = -py / solarMass
  b.vz = -pz / solarMass
  echo "After: ", b

proc energy(bodies: SolarSystem): float64 =
  var e = 0.0

  for i, b in bodies:
    e += 0.5 * b.mass * (b.vx * b.vx + b.vy * b.vy + b.vz * b.vz)

    for b2 in bodies[(i + 1) .. ^1]:
      var
        dx = b.x - b2.x
        dy = b.y - b2.y
        dz = b.z - b2.z
        distance = sqrt dx * dx + dy * dy + dz * dz

      e -= (b.mass * b2.mass) / distance

  e

let
  bodies:SolarSystem = [
    newP("Sun", mass = 1.0),
    newP("Jupiter",
      x = 4.84143144246472090e+00, y = -1.16032004402742839e+00, z = -1.03622044471123109e-01,
      vx = 1.66007664274403694e-03, vy = 7.69901118419740425e-03, vz = -6.90460016972063023e-05,
      mass = 9.54791938424326609e-04),
    newP("Saturn",
      x = 8.34336671824457987e+00, y = 4.12479856412430479e+00, z = -4.03523417114321381e-01,
      vx = -2.76742510726862411e-03, vy = 4.99852801234917238e-03, vz = 2.30417297573763929e-05,
      mass = 2.85885980666130812e-04),
    newP("Uranus",
      x = 1.28943695621391310e+01, y = -1.51111514016986312e+01, z = -2.23307578892655734e-01,
      vx = 2.96460137564761618e-03, vy = 2.37847173959480950e-03, vz = -2.96589568540237556e-05,
      mass = 4.36624404335156298e-05),
    newP("Neptune",
      x = 1.53796971148509165e+01, y = -2.59193146099879641e+01, z = 1.79258772950371181e-01,
      vx = 2.68067772490389322e-03, vy = 1.62824170038242295e-03, vz = -9.51592254519715870e-05,
      mass = 5.15138902046611451e-05),
  ]


offset_momentum(bodies)

echo fmt"{energy(bodies)}"


echo "Sun is ", bodies[0]

#[
echo "Please, enter the number of iterations you'd like to make:"
let n:int = parseInt(readLine(stdin))


echo "The magic number is [", n, "] while this year has ",
  daysPerYear, " days and the solar mass is ", solarMass,
  " and if you happen to wonder, Saturn's mass is ", bodies[2]
]#
