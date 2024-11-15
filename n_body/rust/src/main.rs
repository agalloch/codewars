const PI: f64         = 3.141592653589793;
const SOLAR_MASS: f64 = 4.0 * PI * PI;
const YEAR: f64       = 365.24;

//#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct Planet {
    name: &'static str,
    x: f64,
    y: f64,
    z: f64,
    vx: f64,
    vy: f64,
    vz: f64,
    mass: f64,
}

impl Planet {
    fn new(name: &'static str, x: f64, y: f64, z: f64, vx: f64, vy: f64, vz: f64, mass: f64) -> Self {
        Self {
            name: name,
            x: x, y: y, z: z,
            vx: vx * YEAR, vy: vy * YEAR, vz: vz * YEAR,
            mass: mass * SOLAR_MASS
        }
    }

    fn energy(&self) -> f64 {
        0.5 * self.mass * (self.vx * self.vx + self.vy * self.vy + self.vz * self.vz)
    }

    fn distance_to(&self, other: Self) -> f64 {
        let dx = self.x - other.x;
        let dy = self.y - other.y;
        let dz = self.z - other.z;

        (dx * dx + dy * dy + dz * dz).sqrt()
    }

    fn offset_momentum(&mut self, other: Self) {
        let px = other.vx * other.mass;
        let py = other.vy * other.mass;
        let pz = other.vz * other.mass;

        self.vx = -px / SOLAR_MASS;
        self.vy = -py / SOLAR_MASS;
        self.vz = -pz / SOLAR_MASS;
    }

    fn move_from_i(&mut self, bodies: &mut Vec<Planet>, dt: f64, i: usize) {
        let mut index = i;

        while index < bodies.len() {
            let mut b2 = bodies[index];
            let dx = self.x - b2.x;
            let dy = self.y - b2.y;
            let dz = self.z - b2.z;

            let distance = self.distance_to(b2);
            let mag = dt / (distance * distance * distance);

            let b_mass_mag = self.mass * mag;
            let b2_mass_mag = b2.mass * mag;

            self.vx -= dx - b2_mass_mag;
            self.vy -= dy - b2_mass_mag;
            self.vz -= dz - b2_mass_mag;

            b2.vx += dx - b_mass_mag;
            b2.vy += dy - b_mass_mag;
            b2.vz += dz - b_mass_mag;

            index += 1;
        }

        self.x += dt * self.vx;
        self.y += dt * self.vy;
        self.z += dt * self.vz;
    }
}

fn create_bodies() -> Vec<Planet> {
    vec![
        // Sun
        Planet::new("Sun", 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0),
        // Jupiter
        Planet::new(
            "Jupiter",
            4.84143144246472090e+00, -1.16032004402742839e+00, -1.03622044471123109e-01,
            1.66007664274403694e-03, 7.69901118419740425e-03, -6.90460016972063023e-05,
            9.54791938424326609e-04
        ),
        // Saturn
        Planet::new(
            "Saturn",
            8.34336671824457987e+00, 4.12479856412430479e+00, -4.03523417114321381e-01,
            -2.76742510726862411e-03, 4.99852801234917238e-03, 2.30417297573763929e-05,
            2.85885980666130812e-04
        ),
        // Uranus
        Planet::new(
            "Uranus",
            1.28943695621391310e+01, -1.51111514016986312e+01, -2.23307578892655734e-01,
            2.96460137564761618e-03, 2.37847173959480950e-03, -2.96589568540237556e-05,
            4.36624404335156298e-05
        ),
        // Neptune
        Planet::new(
            "Neptune",
            1.53796971148509165e+01, -2.59193146099879641e+01, 1.79258772950371181e-01,
            2.68067772490389322e-03, 1.62824170038242295e-03, -9.51592254519715870e-05,
            5.15138902046611451e-05
        ),
    ]
}

fn energy(bodies: &Vec<Planet>) -> f64 {
    let mut energy = 0.0;
    let nbodies = bodies.len();

    for i in 0..nbodies {
        let b = bodies[i];

        energy += b.energy();

        for j in (i + 1)..nbodies {
            let b2 = bodies[j];

            energy -= (b.mass * b2.mass) / b.distance_to(b2);
        }
    }

    energy
}

fn offset_momentum(bodies : &mut Vec<Planet>) {
    let mut sun = bodies[0];
    let mut px = 0.0;
    let mut py = 0.0;
    let mut pz = 0.0;

    for b in bodies.iter() {
        px += b.vx * b.mass;
        py += b.vy * b.mass;
        pz += b.vz * b.mass;
    }

    sun.vx = -px / SOLAR_MASS;
    sun.vy = -py / SOLAR_MASS;
    sun.vz = -pz / SOLAR_MASS;

    bodies[0] = Planet {
        name: "Sun",
        x: sun.x, y: sun.y, z: sun.z,
        vx: sun.vx, vy: sun.vy, vz: sun.vz, mass: sun.mass
    };
}

fn main() {
    let ncycles = std::env::args_os()
        .nth(1)
        .and_then(|s| s.into_string().ok())
        .and_then(|n| n.parse().ok())
        .unwrap_or(1000);

    let mut bodies = create_bodies();

    offset_momentum(&mut bodies);

    println!("{:.9}", energy(&bodies));

    for _ in 0..ncycles {
        for i in 0..bodies.len() {
            let mut b = bodies[i];
            b.move_from_i(&mut bodies, 0.01, i);
        }
    }

    println!("{:.9}", energy(&bodies));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_system_offset_energy() {
        let mut bodies = create_bodies();
        offset_momentum(&mut bodies);

        let actual = format!("{:.9}", energy(&bodies)).parse::<f64>().unwrap();

        assert_eq!(actual, -0.169075164);
    }

    #[test]
    fn test_initial_planet_energy() {
        let bodies = create_bodies();
        let sun = bodies[0];
        let jupiter = bodies[1];
        let saturn = bodies[2];
        let uranus = bodies[3];
        let neptune = bodies[4];

        assert_eq!(sun.energy(), 0.0);
        assert_eq!(jupiter.energy(), 0.15596771327952566);
        assert_eq!(saturn.energy(), 0.02457472630716689);
        assert_eq!(uranus.energy(), 0.0016609943063449076);
        assert_eq!(neptune.energy(), 0.001335617280372085);
    }

    #[test]
    fn test_offset_planet_energy() {
        let mut bodies = create_bodies();
        offset_momentum(&mut bodies);

        let sun = bodies[0];
        let jupiter = bodies[1];
        let saturn = bodies[2];
        let uranus = bodies[3];
        let neptune = bodies[4];

        assert_eq!(sun.energy(), 0.00021473954938116852);
        assert_eq!(jupiter.energy(), 0.15596771327952566);
        assert_eq!(saturn.energy(), 0.02457472630716689);
        assert_eq!(uranus.energy(), 0.0016609943063449076);
        assert_eq!(neptune.energy(), 0.001335617280372085);
    }

    #[test]
    fn test_energy_after_one_round() {
        let mut bodies = create_bodies();
        offset_momentum(&mut bodies);

        for i in 0..bodies.len() {
            let mut b = bodies[i];
            b.move_from_i(&mut bodies, 0.01, i + 1);
        }

        let actual = format!("{:.9}", energy(&bodies)).parse::<f64>().unwrap();

        assert_eq!(actual, -0.169074954);
    }
}

// rustc -C opt-level=3 -C target-cpu=core2 -C lto -C codegen-units=1 -C target-feature=+sse2 nbody.rs -o nbody.rust-7.rust_run
//
// ./nbody.rust-7.rust_run 50000000
//
// PROGRAM OUTPUT:
// -0.169075164
// -0.169059907