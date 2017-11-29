# Heist

[![Build Status](https://travis-ci.org/lyon-fnal/Heist.jl.svg?branch=master)](https://travis-ci.org/lyon-fnal/Heist.jl)

[![Coverage Status](https://coveralls.io/repos/lyon-fnal/Heist.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/lyon-fnal/Heist.jl?branch=master)

[![codecov.io](http://codecov.io/github/lyon-fnal/Heist.jl/coverage.svg?branch=master)](http://codecov.io/github/lyon-fnal/Heist.jl?branch=master)

# Examples

```julia
using Cxx, ROOT, Heist

# Construct file list
const filesDir = "/pnfs/GM2/mc/commission_mdc2_1033/runs_1509575000/1509575784"
files = readlines(`find $filesDir -name 'gm2*.30?*'`)  # Pick a subset of the files
hf = HeistFiles(files);

# Specify some data we'll want
trackRS = HeistRecordSpec(
             namespace     = "gm2truth",
             productType   = "TrackingActionArtRecordCollection",
             header        = "gm2dataproducts/mc/actions/track/TrackingActionArtRecord.hh",
             moduleLabel   = "artg4"
           )

# Function to fill an array with data (track energies)
function pushTrackEnergies!(trackEs::Array{Float64,1}, trackHandle::Cxx.CppValue)
    for i = 0: icxx"$trackHandle->size() - 1;"  # Note the C++ here and below
        push!(trackEs, icxx"(*$trackHandle)[$i].e;")  # Maybe a better way to do this
    end
end

# Event loop function
function loop(hf::HeistFiles, maxEvents::Int)

    # Data will go here
    trackEs = Float64[] ; sizehint!(trackEs, 500_000)

    # Loop over events
    for anEvent ∈ HeistEvents(hf, maxEvents)
        println( @cxx anEvent.galleryEvent->eventEntry() )  # Note use of @cxx macro (-> always)
        tracks = getRecord(anEvent, trackRS)
        pushTrackEnergies!(trackEs, tracks)
    end

    return trackEs

end

energies = loop(hf, 1000) # Process 1000 events
```
