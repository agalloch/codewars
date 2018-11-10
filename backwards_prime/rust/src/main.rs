use std::iter::Iterator;

fn main() {
    println!("{:?}", (3..20).last());
    println!("{:?}", (9409 as f64).sqrt());
    println!("{:?}", (9409 as f64).sqrt() as usize);
    println!("{:?}", backwards_prime(8940, 10000));
}

fn backwards_prime(start: usize, stop: usize) -> Vec<usize> {
    (start..stop + 1).filter(|x| is_reverse_prime(*x)).collect()
}

fn reverse(n: usize) -> usize {
    n.to_string().chars().rev().collect::<String>().parse::<usize>().unwrap()
}

fn is_prime(n: usize) -> bool {
    if n < 2 { return false; }
    if n <= 3 { return true; }
    if div_by(n, 2) { return false; }

    let limit = (n as f64).sqrt() as usize + 1;
    (3..limit).step_by(2).all(|x| !div_by(n, x))
}

fn is_reverse_prime(n: usize) -> bool {
    let rev = reverse(n);

    n > 12 && n != rev && is_prime(n) && is_prime(rev)
}

fn div_by(n: usize, d: usize) -> bool {
    n % d == 0
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_backwards_prime() {
        assert_eq!(backwards_prime(1, 31), vec![13, 17, 31]);
        assert_eq!(backwards_prime(1, 100), vec![13, 17, 31, 37, 71, 73, 79, 97]);
        assert_eq!(backwards_prime(7000, 7100), vec![7027, 7043, 7057]);
        assert_eq!(backwards_prime(8940, 10000), vec![9001, 9011, 9013, 9029, 9041, 9103, 9127, 9133, 9161, 9173,
                                                      9209, 9221, 9227, 9241, 9257, 9293, 9341, 9349, 9403, 9421,
                                                      9437, 9439, 9467, 9479, 9491, 9497, 9521, 9533, 9547, 9551,
                                                      9601, 9613, 9643, 9661, 9679, 9721, 9749, 9769, 9781, 9787,
                                                      9791, 9803, 9833, 9857, 9871, 9883, 9923, 9931, 9941, 9967]);
        assert_eq!(50, backwards_prime(8940, 10000).len())
    }

    #[test]
    fn test_reverse() {
        assert_eq!(reverse(8), 8);
        assert_eq!(reverse(321), 123);
        assert_eq!(reverse(24531), 13542);
    }

    #[test]
    fn test_is_prime() {
        assert_eq!(is_prime(1), false);
        assert_eq!(is_prime(3), true);
        assert_eq!(is_prime(68), false);
        assert_eq!(is_prime(151), true);
        assert_eq!(is_prime(115), false);
        assert_eq!(is_prime(9409), false);
        assert_eq!(is_prime(79997), true);
    }

    #[test]
    fn test_is_reverse_prime() {
        assert_eq!(is_reverse_prime(1), false);
        assert_eq!(is_reverse_prime(11), false);
        assert_eq!(is_reverse_prime(131), false);
        assert_eq!(is_reverse_prime(149), true);
        assert_eq!(is_reverse_prime(1753), true);
    }
}
