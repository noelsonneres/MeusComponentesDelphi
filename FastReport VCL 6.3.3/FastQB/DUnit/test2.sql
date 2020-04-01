SELECT c.CustNo, c.Company, o.SaleDate
FROM
    customer.db c
        INNER JOIN orders.db o ON (c.CustNo=o.OrderNo)
ORDER BY c.Company

/*_FQBMODEL
eAFlTsEKwjAMvRf6J0Wa6IYecnGClyHIvBUPXdfDcFulnQf/3tQhCpKEB3kvL88c7Gz3NvmrFM25JtiuSyw3OwQpzMW2g0/MOHKPNIfRx1XXKihyo9YMWopAIXY+pkwhqrzPAwVz5hj7jg00VWxwCsoxfHycAqXfJQVQFca7nZ5/ikUjBVJjB89xvfr+Cz8Wpu6nW06rKd/AQknxAja1PeM=
_FQBEND*/
