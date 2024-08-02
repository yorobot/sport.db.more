# Notes

todos
- [ ] automate slugs / seasons (stages) config
  - [ ] try to auto-get all slugs from all configured leagues (50+)
  - [ ]    use slugs to double check config
           and exit/warn on conflict !!!!!

- [ ]  check fix date - change to use timezone!!!!

---


## How-to update (cached) datasets

Find the (cached) datasets by season in the comma-separated values (.csv) format @ <https://github.com/footballcsv/cache.wfb>



Sample 1 - Austria (at) 2024/25

- Austrian ÖFB Cup  (at.cup)  =>  `$ wfb at.cup 2024/25`







## more 

```
 add more helpers
  move upstream for (re)use - why? why not?

 todo/check: what to do: if league is both included and excluded?
   include forces include? or exclude has the last word? - why? why not?
  Excludes match before includes,
   meaning that something that has been excluded cannot be included again
```

