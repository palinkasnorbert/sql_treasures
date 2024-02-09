/* 
Solution for Hackerrank Print Prime Numbers problem.
Dialect: T-SQL
*/

-- generate a number sequence with recursive CTE from 2 to 1000
WITH num_seq AS (
  SELECT 2 AS num
  UNION ALL
  SELECT num + 1
  FROM num_seq
  WHERE num + 1 <= 1000
)

SELECT num_seq (num, '&') AS prime_numbers_str -- print the numbers with '&' as separator in one row (STRING_AGG)
FROM num_seq
-- Here comes the magic:
WHERE NOT EXISTS (
  SELECT 1
  FROM num_seq AS ns2
  WHERE ns2.num <= SQRT(num_seq.num) AND (num_seq.num % ns2.num) = 0
)
  
OPTION(MAXRECURSION 1000);  -- override SQL Server default recursion limit (100)

/* Explanation of the NOT EXISTS check:

To understand how the `NOT EXISTS` check works for identifying prime numbers, let's manually go through the first 10 iterations of the `num_range` CTE (although we'll have numbers up to 11 since we're starting from 2) and apply the prime checking logic. 

For simplicity, we'll consider the numbers 2 through 11.

For each number `n` in this range, we'll examine potential divisors `n2` from 2 up to the square root of `n`. The `NOT EXISTS` clause ensures that a number is considered prime if there is no `n2` that divides `n` evenly (i.e., `n % n2 = 0`).

### Iteration 1: Checking 2

- **Number:** 2
- **Square root:** ~1.41
- **Potential divisors (`n2`):** None (since we only consider numbers greater than 1 and up to the square root)
- **Result:** Prime (no divisors)

### Iteration 2: Checking 3

- **Number:** 3
- **Square root:** ~1.73
- **Potential divisors (`n2`):** None (no integers from 2 up to ~1.73)
- **Result:** Prime

### Iteration 3: Checking 4

- **Number:** 4
- **Square root:** 2
- **Potential divisors (`n2`):** 2
- **Check:** \( 4 \% 2 = 0 \)
- **Result:** Not Prime (divisible by 2)

### Iteration 4: Checking 5

- **Number:** 5
- **Square root:** ~2.24
- **Potential divisors (`n2`):** 2
- **Check:** \( 5 \% 2 \neq 0 \)
- **Result:** Prime (2 does not divide 5)

### Iteration 5: Checking 6

- **Number:** 6
- **Square root:** ~2.45
- **Potential divisors (`n2`):** 2
- **Check:** \( 6 \% 2 = 0 \)
- **Result:** Not Prime (divisible by 2)

### Iteration 6: Checking 7

- **Number:** 7
- **Square root:** ~2.65
- **Potential divisors (`n2`):** 2
- **Check:** \( 7 \% 2 \neq 0 \)
- **Result:** Prime (2 does not divide 7)

### Iteration 7: Checking 8

- **Number:** 8
- **Square root:** ~2.83
- **Potential divisors (`n2`):** 2
- **Check:** \( 8 \% 2 = 0 \)
- **Result:** Not Prime (divisible by 2)

### Iteration 8: Checking 9

- **Number:** 9
- **Square root:** 3
- **Potential divisors (`n2`):** 2, 3
- **Check for 2:** \( 9 \% 2 \neq 0 \)
- **Check for 3:** \( 9 \% 3 = 0 \)
- **Result:** Not Prime (divisible by 3)

### Iteration 9: Checking 10

- **Number:** 10
- **Square root:** ~3.16
- **Potential divisors (`n2`):** 2, 3
- **Check for 2:** \( 10 \% 2 = 0 \)
- **Result:** Not Prime (divisible by 2)

### Iteration 10: Checking 11

- **Number:** 11
- **Square root:** ~3.32
- **Potential divisors (`n2`):** 2, 3
- **Check for 2:** \( 11 \% 2 \neq 0 \)
- **Check for 3:** \( 11 \% 3 \neq 0 \)
- **Result:** Prime (neither 2 nor 3 divides 11)

Through these iterations, the `NOT EXISTS` clause in the SQL query effectively filters out non-prime numbers by finding at least one divisor within the range from 2 up to the square root of the number. If such a divisor is found, the number is not prime. If no such divisor exists, the number is considered prime.
