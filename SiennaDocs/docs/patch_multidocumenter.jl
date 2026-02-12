# Apply upstream fix for MultiDocumenter bug: get_meta_redirect_url(html::Gumbo.HTMLDocument)
# references indexhtml_path which is not in scope (UndefVarError). This script patches the
# installed MultiDocumenter so canonical URL fixing and sitemap work without "Canonical URL
# missing" warnings. Run once per environment (e.g. before docs/make.jl or in CI):
#   julia --project=docs docs/patch_multidocumenter.jl
# Re-apply after Pkg.update("MultiDocumenter") if the upstream package hasn't fixed it yet.

using Pkg
Pkg.activate(@__DIR__)
# Ensure MultiDocumenter is loaded so we can find its path
using MultiDocumenter

path = joinpath(dirname(dirname(Base.find_package("MultiDocumenter"))), "src", "documentertools", "canonical_urls.jl")
@assert isfile(path) "MultiDocumenter canonical_urls.jl not found at $path"

content = read(path, String)

# Check if already patched
if occursin("get_meta_redirect_url(Gumbo.parsehtml(read(indexhtml_path, String)), indexhtml_path)", content)
    @info "MultiDocumenter already patched" path
    exit(0)
end

# Fix: pass indexhtml_path into the HTML method so @warn has it in scope
old1 = "get_meta_redirect_url(indexhtml_path::AbstractString) =\n    get_meta_redirect_url(Gumbo.parsehtml(read(indexhtml_path, String)))"
new1 = "get_meta_redirect_url(indexhtml_path::AbstractString) =\n    get_meta_redirect_url(Gumbo.parsehtml(read(indexhtml_path, String)), indexhtml_path)"
@assert occursin(old1, content) "Unexpected canonical_urls.jl content (string method)"
content = replace(content, old1 => new1)

old2 = "function get_meta_redirect_url(html::Gumbo.HTMLDocument)"
new2 = "function get_meta_redirect_url(html::Gumbo.HTMLDocument, indexhtml_path::Union{AbstractString,Nothing}=nothing)"
@assert occursin(old2, content) "Unexpected canonical_urls.jl content (HTML method)"
content = replace(content, old2 => new2)

try
    write(path, content)
    @info "Patched MultiDocumenter" path
catch e
    if e isa SystemError && e.errnum == 13  # EACCES
        @error "Cannot write to MultiDocumenter package (permission denied). Run this script with write access to your Julia package directory, or apply the fix manually: add a second parameter (indexhtml_path::Union{AbstractString,Nothing}=nothing) to get_meta_redirect_url(html::Gumbo.HTMLDocument) and pass indexhtml_path when calling it from the string method." path
    else
        rethrow(e)
    end
end
