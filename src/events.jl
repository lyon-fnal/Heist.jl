"""
   HeistEvents is a object that creates a `HiestEvent` and loops over the events.
   It can be used as an event loop. You create it by passing in a `HeistFiles`
   object that represents the files to run over and an integer `nMax` that is the maximum
   number of events to process. Set to zero if you want to process everything.

# Examples

```julia
for anEvent ∈ HeistEvents(hf, 200)
   println( @cxx anEvent.galleryEvent->eventEntry() )
   tracks = getRecord(anEvent, tas)
   ghosts = getRecord(anEvent, gds)
   # ... do something with the objects ...
end
```
"""
struct HeistEvents
   hf::HeistFiles
   nDesired::Int
end

# See https://docs.julialang.org/en/stable/stdlib/collections/#lib-collections-iteration-1 and
# see https://docs.julialang.org/en/stable/manual/interfaces/#man-interface-iteration-1
# for how this works as a for loop. That is,
#   for i = I   # or  "for i in I"
#     ...
#   end
#
#   is translated into
#
#  state = start(I)
#  while !done(I, state)
#      (i, state) = next(I, state)
#      ...
#  end
#
#  So need to define start, next and done. eltype improves efficiency
#
Base.start(::HeistEvents) = nothing  # Don't do anything at the start --
                                     # next will make the HeistEvent -- this allows us to see the first event

Base.next(hes::HeistEvents, state::Void)       = (he = HeistEvent(hes.hf) ; (he, he) )  # Multiple dispatch in action!
Base.next(hes::HeistEvents, state::HeistEvent) = (nextEvent(state), state)

Base.done(hes::HeistEvents, state::Void)       = false
Base.done(hes::HeistEvents, state::HeistEvent) = atEnd(state) ||
                                                 (hes.nDesired > 0 && state.nSeen ≥ hes.nDesired)

Base.eltype(::Type{HeistEvents}) = HeistEvent
