static POWERS_OF_TWO:   [i32; 4] = [6, 2, 4, 8];
static POWERS_OF_THREE: [i32; 4] = [1, 3, 9, 7];
static POWERS_OF_FOUR:  [i32; 2] = [4, 6];
static POWERS_OF_SEVEN: [i32; 4] = [1, 7, 9, 3];
static POWERS_OF_EIGHT: [i32; 4] = [8, 4, 2, 6];
static POWERS_OF_NINE:  [i32; 2] = [1, 9];

fn last_digit(base: &str, exp: &str) -> i32 {
    let digit = base.chars().last().unwrap().to_digit(10).unwrap() as i32;
    let start = if exp.len() > 1 { exp.len() - 2 } else { exp.len() - 1 };
    let power = exp[start..exp.len()].parse::<i32>().unwrap();
    let pair  = (digit, power);
    
    match pair {
      (d, p) if (d == 1) | (p == 0 && exp.len() == 1) => 1,
      (0, _) => 0,
      (d, _) if (d == 5) | (d == 6) => d,
      (2, p) => POWERS_OF_TWO[(p % 4) as usize],
      (3, p) => POWERS_OF_THREE[(p % 4) as usize],
      (4, p) => POWERS_OF_FOUR[((p - 1) % 2) as usize],
      (7, p) => POWERS_OF_SEVEN[(p % 4) as usize],
      (8, p) => POWERS_OF_EIGHT[((p - 1) % 4) as usize],
      (9, p) => POWERS_OF_NINE[(p % 2) as usize],
       _ => 0
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_last_digit() {
        assert_eq!(last_digit("4", "1"), 4);
        assert_eq!(last_digit("4", "2"), 6);
        assert_eq!(last_digit("4", "13"), 4);
        assert_eq!(last_digit("8", "13"), 8);
        assert_eq!(last_digit("9", "7"), 9);
        assert_eq!(last_digit("77", "7"), 3);
        assert_eq!(last_digit("10", "10000000000"), 0);
        assert_eq!(last_digit("1606938044258990275541962092341162602522202993782792835301376", "2037035976334486086268445688409378161051468393665936250636140449354381299763336706183397376"), 6);
        assert_eq!(last_digit("3715290469715693021198967285016729344580685479654510946723", "68819615221552997273737174557165657483427362207517952651"), 7);
        assert_eq!(last_digit("16709895655561134878745562439056049269175", "0"), 1);
        assert_eq!(last_digit("0", "0"), 1);
    }
}
