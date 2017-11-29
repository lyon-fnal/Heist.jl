"""
   HiestFiles is an object that represents a list of file (with paths) that are
   to be processed.
"""
struct HeistFiles
    files::Array{String,1}
    theVector::Cxx.CppValue
end

"""
    HeistFiles(filesArray)

    Creates a `HiestFiles` object representing the list of files to process.

       filesArray is a list of strings that are paths to files. It can also
       contain XrootD URI's.
"""
function HeistFiles(files::Array{String,1})
    fv = icxx"""std::vector<std::string> fv; return fv;"""
    for s ∈ files
        icxx"$fv.push_back($s);"
    end

    HeistFiles(files, fv)
end
