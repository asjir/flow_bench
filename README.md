# flow_bench

I checked WaterLily against ViscousFlow simulation performance.

The setup is example flow around a circle from WaterLily

WL: 1.352104 seconds (37.65 k allocations: 4.620 MiB)

VF: 21.691545 seconds (70.61 M allocations: 6.663 GiB, 4.82% gc time, 66.32% compilation time)

the compilation time happens on every run
