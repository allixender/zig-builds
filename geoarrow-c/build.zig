const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Create a static library
    const lib = b.addStaticLibrary(.{
        .name = "geoarrow",
        .target = target,
        .optimize = optimize,
    });

    // Link with libc and libc++
    // lib.linkLibC();
    // lib.linkLibCpp();

    // Add C source files - you'll need to adjust these paths based on actual repo structure
    const c_sources = [_][]const u8{
        // GeoArrow C sources
        "src/geoarrow/native_writer.c",
        // "src/geoarrow/fast_float.h",
        "src/geoarrow/schema_view.c",
        "src/geoarrow/wkb_reader.c",

        "src/geoarrow/kernel.c",
        "src/geoarrow/array_reader.c",
        "src/geoarrow/util.c",
        "src/geoarrow/wkt_writer.c",
        "src/geoarrow/builder.c",

        "src/geoarrow/ryu/d2s.c",

        "src/geoarrow/array_view.c",
        "src/geoarrow/array_writer.c",
        "src/geoarrow/wkt_reader.c",
        "src/geoarrow/double_parse_std.c",
        "src/geoarrow/double_print.c",
        "src/geoarrow/wkb_writer.c",
        "src/geoarrow/visitor.c",
        "src/geoarrow/metadata.c",
        "src/geoarrow/schema.c",
        "src/geoarrow/nanoarrow/nanoarrow.c",
    };

    lib.addCSourceFiles(.{
        .files = &c_sources,
        .flags = &[_][]const u8{
            "-std=c99",
            "-Wall",
            "-Wextra",
            "-DNANOARROW_NAMESPACE=GeoArrowNanoArrow", // Use namespace to avoid conflicts
            "-DNANOARROW_STATIC", // Build nanoarrow as static library
        },
    });

    // Add include directories
    lib.addIncludePath(b.path("include/"));
    // Add include directories
    lib.addIncludePath(b.path("include/geoarrow/"));
    // Add include directories
    // lib.addIncludePath(b.path("include/geoarrow/hpp"));
    // Add include directories
    // lib.addIncludePath(b.path("include/ryu"));
    // Add include directories
    // lib.addIncludePath(b.path("include/nanoarrow"));

    // Install header files
    lib.installHeadersDirectory(b.path("include/geoarrow"), "geoarrow", .{});
    // lib.installHeadersDirectory(b.path("include/geoarrow/hpp"), "geoarrow/hpp", .{});
    // lib.installHeadersDirectory(b.path("include/geoarrow/ryu"), "geoarrow/ryu", .{});
    lib.installHeadersDirectory(b.path("include/nanoarrow"), "nanoarrow", .{});

    // Install the library
    b.installArtifact(lib);

    const test_case = b.addExecutable(.{
        .name = "test_case",
        .target = target,
        .optimize = optimize,
    });

    const googletest_dep = b.dependency("googletest", .{
        .target = target,
        .optimize = optimize,
    });

    // "src/geoarrow/metadata_test.cc"
    const test_case_sources = [_][]const u8{
        "src/geoarrow/test_main.cc",
        "src/geoarrow/metadata_test.cc",
        "src/geoarrow/array_reader_test.cc",
        "src/geoarrow/array_view_test.cc",
        "src/geoarrow/array_writer_test.cc",
        "src/geoarrow/builder_test.cc",
        // "src/geoarrow/geoarrow_type_inline_test.cc",
        "src/geoarrow/kernel_test.cc",
        // "src/geoarrow/metadata_test.cc",
        "src/geoarrow/native_writer_test.cc",
        // "src/geoarrow/schema_test.cc",
        // "src/geoarrow/schema_view_test.cc",
        "src/geoarrow/util_test.cc",
        "src/geoarrow/visitor_test.cc",
        "src/geoarrow/wkb_reader_test.cc",
        "src/geoarrow/wkb_writer_test.cc",
        "src/geoarrow/wkt_reader_test.cc",
        "src/geoarrow/wkt_writer_test.cc",
        // "src/geoarrow/wkx_files_test.cc",
    };

    test_case.addCSourceFiles(.{
        .files = &test_case_sources,
        .flags = &[_][]const u8{ "-std=c++14", "-Wall" },
    });

    test_case.addIncludePath(b.path("include/"));
    test_case.addIncludePath(b.path("include/geoarrow/"));
    test_case.installHeadersDirectory(b.path("include/geoarrow"), "geoarrow", .{});
    test_case.installHeadersDirectory(b.path("include/nanoarrow"), "nanoarrow", .{});

    test_case.linkLibrary(lib);
    test_case.linkLibrary(googletest_dep.artifact("gtest"));

    const arrow_include_path = std.Build.LazyPath{ .cwd_relative = "/Users/akmoch/micromamba/envs/geopython2025/include/arrow/" };
    test_case.addIncludePath(arrow_include_path);

    const arrow_lib_path = std.Build.LazyPath{ .cwd_relative = "/Users/akmoch/micromamba/envs/geopython2025/lib" };
    test_case.addLibraryPath(arrow_lib_path);
    test_case.linkSystemLibrary("arrow");

    // include /Users/akmoch/micromamba/envs/geopython2025/include/arrow/
    // test_case.addIncludePath(b.path("/Users/akmoch/micromamba/envs/geopython2025/include/arrow/"));
    // test_case.addLibraryPath(b.path("/Users/akmoch/micromamba/envs/geopython2025/lib/"));

    // test_case.linkLibC();
    // test_case.linkLibCpp();
    test_case.linkSystemLibrary("stdc++");

    b.installArtifact(test_case);

    const run_test = b.addRunArtifact(test_case);

    const run_test_step = b.step("test_case", "Run test_case");
    run_test_step.dependOn(&run_test.step);
}
