"""
   HeistEvent is an object that represents a gallery event along with a counter that
   advances when an event is seen.

   You can make a HeistEvent by passing in a `HeistFiles` object that represents the
   files to process.

   If you are looping over events, you should create a `HiestEvents` object (plural) instead
   of this one.
"""
mutable struct HeistEvent
   galleryEvent::Cxx.CppValue
   nSeen::Int

   HeistEvent(hf::HeistFiles) = new( icxx"gallery::Event ev($(hf.theVector)); return ev;", 1)
end

"""
   nextEvent advances to the next event in the file or to the next file to process.
"""
nextEvent(he::HeistEvent) = ( @cxx he.galleryEvent->next() ; he.nSeen += 1; he )

"""
   atEnd returns true if there are no more events to process
"""
atEnd(he::HeistEvent) = @cxx he.galleryEvent->atEnd()
