"""
   getRecord retrieves data out of an event for a given recordSpec. Note that
   the handle that is returned must be treated as a C++ object (e.g. with `icxx`)
"""
function getRecord(he::HeistEvent, rs::HeistRecordSpec)

   # The below builds cxxt"SomeType"
   s = @eval @cxxt_str $(rs.productName)

   return icxx"return $(he.galleryEvent).getValidHandle<$s>($(rs.artInputTag));"
end
