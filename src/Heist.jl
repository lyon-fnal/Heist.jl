
"""
**Heist.jl** is a Julia package that wraps art's gallery.
The name comes from James Stapleton's similar package for Python.

Note that you must run the Julia executable that is compatable with Root.

You must have the gallery package and dependencies set up in your environment.
You must have your data product packages and dependencies set up in your environment.
"""
module Heist

using Cxx, ROOT  # ROOT is needed for TFile

# Load header paths
addHeaderDir(ENV["GALLERY_INC"], kind=C_System)
addHeaderDir(ENV["CANVAS_INC"], kind=C_System)
addHeaderDir(ENV["CLHEP_INC"], kind=C_System)
addHeaderDir(ENV["BOOST_INC"], kind=C_System)
addHeaderDir(ENV["CETLIB_INC"], kind=C_System)
addHeaderDir(ENV["CETLIB_EXCEPT_INC"], kind=C_System)
addHeaderDir(ENV["FHICLCPP_INC"], kind=C_System)
addHeaderDir(ENV["MESSAGEFACILITY_INC"], kind=C_System)

addHeaderDir(ENV["G4INCLUDE"], kind=C_System)

addHeaderDir(ENV["GM2RINGSIM_INC"], kind=C_System)
addHeaderDir(ENV["GM2DATAPRODUCTS_INC"], kind=C_System)

# Load gallery and dependent libraries
Libdl.dlopen("libgallery", Libdl.RTLD_GLOBAL)
Libdl.dlopen("libcanvas", Libdl.RTLD_GLOBAL)
Libdl.dlopen("libCLHEP", Libdl.RTLD_GLOBAL)

# Load some headers that we'll need
cxx"""
   #include "canvas/Utilities/InputTag.h"
   #include "gallery/Event.h"

   #include <vector>
"""

# files.jl
export
    HeistFiles

# recordSpec.jl
export
    HeistRecordSpec

# event.jl
export
    HeistEvent,
    nextEvent,
    atEnd

# events.jl
export
    HeistEvents

# getRecord.jl
export
    getRecord

include("files.jl")
include("recordSpec.jl")
include("event.jl")
include("events.jl")
include("getRecord.jl")

end # module
