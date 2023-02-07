The roles table has many boolean fields, each costing 1 byte of memory.
This query compresses those fields into a single `SMALLINT`, saving several bytes per role.
In most examples, this is a nifty-yet-unnecessary optimization that is completely dominated by the size of the query itself.
