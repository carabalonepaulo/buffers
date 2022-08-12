`nim c -r -d:release --verbosity:0 --hints:off .\src\bench.nim`

```
min time    avg time  std dv   runs name
1.320 ms    1.400 ms  ±0.076  x1000 write using string stream
0.884 ms    0.937 ms  ±0.049  x1000 write using binary writer
1.013 ms    1.044 ms  ±0.038  x1000 read using string stream
1.062 ms    1.088 ms  ±0.030  x1000 read using binary reader
```

`nim c -r -d:danger --verbosity:0 --hints:off .\src\bench.nim`

```
min time    avg time  std dv   runs name
1.299 ms    1.360 ms  ±0.069  x1000 write using string stream
0.800 ms    0.820 ms  ±0.023  x1000 write using binary writer
0.873 ms    0.890 ms  ±0.023  x1000 read using string stream
0.986 ms    1.009 ms  ±0.024  x1000 read using binary reader
```

`nim c -r --verbosity:0 --hints:off .\src\bench.nim`

```
min time    avg time  std dv   runs name
15.966 ms   16.737 ms  ±0.663   x299 write using string stream
8.866 ms     9.616 ms  ±0.549   x519 write using binary writer
9.923 ms    10.288 ms  ±0.426   x486 read using string stream
13.232 ms   14.318 ms  ±0.762   x349 read using binary reader
```

`nim c -r --gc:orc -d:release --verbosity:0 --hints:off .\src\bench.nim`

```
min time    avg time  std dv   runs name
2.819 ms    3.270 ms  ±0.158  x1000 write using string stream
1.090 ms    1.379 ms  ±0.095  x1000 write using binary writer
1.597 ms    1.817 ms  ±0.087  x1000 read using string stream
0.985 ms    1.054 ms  ±0.056  x1000 read using binary reader
```

`nim c -r --gc:arc -d:release --verbosity:0 --hints:off .\src\bench.nim`

```
min time    avg time  std dv   runs name
2.694 ms    3.222 ms  ±0.261  x1000 write using string stream
0.628 ms    0.889 ms  ±0.122  x1000 write using binary writer
1.448 ms    1.563 ms  ±0.128  x1000 read using string stream
0.993 ms    1.076 ms  ±0.062  x1000 read using binary reader
```
