SELECT 
  a.account_number, 
  t.transaction_id, 
  t.amount, 
  t.timestamp, 
  t.location
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
WHERE t.timestamp >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
  AND (
    t.amount > (
      SELECT AVG(amount) + 3 * STDDEV(amount)
      FROM transactions
      WHERE account_id = t.account_id
      AND timestamp >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
    )
    OR t.location NOT IN (
      SELECT location
      FROM transactions
      WHERE account_id = t.account_id
      AND timestamp >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
      GROUP BY location
      HAVING COUNT(*) > 3
    )
  );
