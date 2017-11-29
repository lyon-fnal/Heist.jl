"""
   HeistRecordSpec is an object that holds information about how to access a
   data product from gallery.

# Arguments

   You construct it by passing in the following *String* arguments
   with keywords (! are required):

         namespace is the namespace of the product, e.g. "gm2truth"

       ! productType is the C++ type of the product. It can be a typedef to a vector like
            CalorimeterArtRecordCollection

       ! header is the path to the header for the product. It can be a relative path if you have issued
         `addHeaderDir` (that's been done for `gm2dataproducts`).

       ! moduleLabel is the module label name associated with the product

         instanceLabel is the instance label name associated with the product

# Examples

```julia
trackRS = HeistRecordSpec(
             namespace     = "gm2truth",
             productType   = "TrackingActionArtRecordCollection",
             header        = "gm2dataproducts/mc/actions/track/TrackingActionArtRecord.hh",
             moduleLabel   = "artg4"
           )
```
"""

struct HeistRecordSpec
   productName::String
   artInputTag::Cxx.CppValue

   function HeistRecordSpec(; namespace="", productType="", header="", moduleLabel="", instanceLabel="")
     @assert productType != ""
     @assert moduleLabel != ""
     @assert header != ""

     cxxparse("#include \"" * header * "\"")
     productName = namespace == "" ? productType : namespace * "::" * productType
     inputTagString = instanceLabel == "" ? moduleLabel : moduleLabel * ":" * instanceLabel
     new(productName, icxx"""art::InputTag it($inputTagString); return it;""")
   end

end
