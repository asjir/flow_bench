# flow_bench

I checked WaterLily against ViscousFlow simulation performance.

The setup is example flow around a circle from WaterLily

WL: 1.352104 seconds (37.65 k allocations: 4.620 MiB)

VF: 6.525013 seconds (6.99 M allocations: 3.154 GiB, 2.18% gc time)

the compilation time happens on every run

comparison of resulting gifs:
### viscous flow:
![viscousflow result](viscousflow.gif)
### waterlily:
![waterlily result](waterlily.gif)

