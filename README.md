# Heist

[![Build Status](https://travis-ci.org/lyon-fnal/Heist.jl.svg?branch=master)](https://travis-ci.org/lyon-fnal/Heist.jl)

[![Coverage Status](https://coveralls.io/repos/lyon-fnal/Heist.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/lyon-fnal/Heist.jl?branch=master)

[![codecov.io](http://codecov.io/github/lyon-fnal/Heist.jl/coverage.svg?branch=master)](http://codecov.io/github/lyon-fnal/Heist.jl?branch=master)

# Examples

```julia
using Cxx, ROOT, Heist

const filesDir = "/pnfs/GM2/mc/commission_mdc2_1033/runs_1509575000/1509575784"
files = readlines(`find $filesDir -name 'gm2*.30?*'`)
hf = HeistFiles(files);

trackRS = HeistRecordSpec(
             namespace     = "gm2truth",
             productType   = "TrackingActionArtRecordCollection",
             header        = "gm2dataproducts/mc/actions/track/TrackingActionArtRecord.hh",
             moduleLabel   = "artg4"
           )

trackEs = Float64[]

function pushTrackEnergies!(trackEs, trackHandle)
    for i = 0: icxx"$trackHandle->size() - 1;"
        push!(trackEs, icxx"(*$trackHandle)[$i].e;")
    end
end

for anEvent ∈ HeistEvents(hf, 200)
    println( @cxx anEvent.galleryEvent->eventEntry() )
    tracks = getRecord(anEvent, trackRS)
    pushTrackEnergies!(trackEs, tracks)
end
```
