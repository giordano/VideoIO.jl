using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    LibraryProduct(prefix, String["libfdk-aac"], :libfdk),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/SimonDanisch/FDKBuilder/releases/download/0.1.6"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64, :glibc) => ("$bin_prefix/libfdk.v0.1.6.aarch64-linux-gnu.tar.gz", "5a827004cc0eaba23dc5f366010336efbe1e678d90b9bd68a7ef20917e3c516d"),
    Linux(:aarch64, :musl) => ("$bin_prefix/libfdk.v0.1.6.aarch64-linux-musl.tar.gz", "55a4fbcc41139987e83016feea62498aec6adf2b2957ea0633c5935af48427a3"),
    Linux(:armv7l, :glibc, :eabihf) => ("$bin_prefix/libfdk.v0.1.6.arm-linux-gnueabihf.tar.gz", "426007534aaf9b5859c7a62b57acfd2dd431d8a0d2483061692327f9f60abebd"),
    Linux(:armv7l, :musl, :eabihf) => ("$bin_prefix/libfdk.v0.1.6.arm-linux-musleabihf.tar.gz", "4c487b54626fc6817981727b35cf08ecfb44c61bc46d948c08d23d9b8ff19643"),
    Linux(:i686, :glibc) => ("$bin_prefix/libfdk.v0.1.6.i686-linux-gnu.tar.gz", "2414699166aace3887b9a9aa725e7cdf7c5f3d415de46eb2af064830a9296f52"),
    Linux(:i686, :musl) => ("$bin_prefix/libfdk.v0.1.6.i686-linux-musl.tar.gz", "cd84bccc86222c7a18fecc27eb69ba583bff4411825dd605075f55d7b98c4c99"),
    Windows(:i686) => ("$bin_prefix/libfdk.v0.1.6.i686-w64-mingw32.tar.gz", "d931d9b162c06a0a580db0679de11162a09fd9d73ab1b3549170b81559b39a1c"),
    Linux(:powerpc64le, :glibc) => ("$bin_prefix/libfdk.v0.1.6.powerpc64le-linux-gnu.tar.gz", "e2cf851625e236b026d9427e91adc9892b5cc543b4665a98ca48676df963cce3"),
    MacOS(:x86_64) => ("$bin_prefix/libfdk.v0.1.6.x86_64-apple-darwin14.tar.gz", "984949ded2588a8efde357185fe9e9ed1fc53890107728ba0567f37d3870f0e7"),
    Linux(:x86_64, :glibc) => ("$bin_prefix/libfdk.v0.1.6.x86_64-linux-gnu.tar.gz", "bf80ed02b20af6be1e21c56c687b2c8e2f92d363e67c1ea6dbb22cf47deed507"),
    Linux(:x86_64, :musl) => ("$bin_prefix/libfdk.v0.1.6.x86_64-linux-musl.tar.gz", "c4334260c48fb002b95c8c54fe536e70181a7ce4a2f20a467eb4ffd6dfea0082"),
    FreeBSD(:x86_64) => ("$bin_prefix/libfdk.v0.1.6.x86_64-unknown-freebsd11.1.tar.gz", "b7cde97fbd3c476be3de75a2c24615dc27c31ca63e666e2fa79c298c7a319cb2"),
    Windows(:x86_64) => ("$bin_prefix/libfdk.v0.1.6.x86_64-w64-mingw32.tar.gz", "2df1d88b2241012825a6d34fa29e6a8410e4de25f3fc20535ad166e9ec59b035"),
)

# Install unsatisfied or updated dependencies:
unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)
if haskey(download_info, platform_key())
    url, tarball_hash = download_info[platform_key()]
    if unsatisfied || !isinstalled(url, tarball_hash; prefix=prefix)
        # Download and install binaries
        install(url, tarball_hash; prefix=prefix, force=true, verbose=verbose)
    end
elseif unsatisfied
    # If we don't have a BinaryProvider-compatible .tar.gz to download, complain.
    # Alternatively, you could attempt to install from a separate provider,
    # build from source or something even more ambitious here.
    error("Your platform $(triplet(platform_key())) is not supported by this package!")
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps_codec.jl"), products)
