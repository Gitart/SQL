## Update with relation 

```sql
UPDATE     categories ct
          left JOIN category_group gr
          ON         ct.id     = gr.id
          SET        ct.weight = gr.weight,
                     ct.qty    = gr.qty
```


