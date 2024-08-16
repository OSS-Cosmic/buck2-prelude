load("@prelude//apple:apple_toolchain_types.bzl", "AppleToolchainInfo", "AppleToolsInfo")
load("@prelude//cxx:cxx_toolchain_types.bzl", "CxxPlatformInfo", "CxxToolchainInfo")
load("@prelude//apple/swift:swift_toolchain_types.bzl", "SwiftToolchainInfo")

def _find_apple_tools_impl(ctx: AnalysisContext) -> list[Provider]:
  xcod_app_path =  "/Applications/Xcode.app/Contents/Developer/usr/bin"
  sdk_path =  "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
  return [
        DefaultInfo(),
        AppleToolchainInfo(
            actool = RunInfo(args = ["actool"]),
            architecture = ctx.attrs.architecture,
            codesign = RunInfo(args = ["codesign"]),
            codesign_allocate = RunInfo(args = ["codesign_allocate"]),
            codesign_identities_command = None,
            compile_resources_locally = True,
            copy_scene_kit_assets = RunInfo(args = ["{}/copySceneKitAssets".format(xcod_app_path)]),
            dsymutil = RunInfo(args = ["dsymutil"]),
            dwarfdump = RunInfo(args = ["dwarfdump"]),
            extra_linker_outputs = ctx.attrs.extra_linker_outputs,
            ibtool = RunInfo(args = ["ibtool"]),
            libtool = RunInfo(args = ["libtool"]),
            lipo = RunInfo(args = ["lipo"]),
            objdump = RunInfo(args = ["objdump"]),
            installer = ctx.attrs.installer,
            momc = RunInfo(args = ["{}/momc".format(xcod_app_path)]),
            platform_path = "/",
            sdk_name = ctx.attrs.sdk_name,
            sdk_path = sdk_path,
            xctest = RunInfo(args = ["{}/xctest".format(xcod_app_path)]),
            swift_toolchain_info = SwiftToolchainInfo(
              sdk_path = sdk_path,
              compiler_flags = []
            )
        ),
        CxxPlatformInfo(name = "macosx-arm64"),
    ]

find_apple_tools = rule(
    impl = _find_apple_tools_impl,
    attrs = {
        "architecture": attrs.string(),
        "extra_linker_outputs": attrs.list(attrs.string(), default = []),
        "installer": attrs.default_only(attrs.label(default = "buck//src/com/facebook/buck/installer/apple:apple_installer")),
        "sdk_name": attrs.string()
    },
    is_toolchain_rule = True,
)


