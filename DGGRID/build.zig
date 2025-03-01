const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // compile projlib as static library
    const proj4lib = b.addStaticLibrary(.{
        .name = "proj4lib",
        .target = target,
        .optimize = optimize,
    });

    const proj_cpp_sources = [_][]const u8{
        "src/lib/proj4lib/lib/pj_mlfn.cpp",
        "src/lib/proj4lib/lib/pj_msfn.cpp",
        "src/lib/proj4lib/lib/adjlon.cpp",
        "src/lib/proj4lib/lib/pj_auth.cpp",
        "src/lib/proj4lib/lib/pj_qsfn.cpp",
        "src/lib/proj4lib/lib/pj_tsfn.cpp",
        "src/lib/proj4lib/lib/pj_phi2.cpp",
    };

    proj4lib.addCSourceFiles(.{
        .files = &proj_cpp_sources,
        .flags = &[_][]const u8{ "-std=c++11", "-Wall", "-Wextra", "-fno-inline", "-fno-eliminate-unused-debug-types", "-pedantic", "-Wimplicit-fallthrough", "-W" },
    });

    proj4lib.addIncludePath(b.path("src/lib/proj4lib/include"));
    proj4lib.linkLibCpp();
    b.installArtifact(proj4lib);

    // compile shapelib as static library
    const shapelib = b.addStaticLibrary(.{
        .name = "shapelib",
        .target = target,
        .optimize = optimize,
    });

    const shapelib_c_sources = [_][]const u8{ "src/lib/shapelib/lib/dbfopen.c", "src/lib/shapelib/lib/safileio.c", "src/lib/shapelib/lib/sbnsearch.c", "src/lib/shapelib/lib/shpopen.c", "src/lib/shapelib/lib/shptree.c", "src/lib/shapelib/lib/shputils.c" };

    shapelib.addCSourceFiles(.{
        .files = &shapelib_c_sources,
        .flags = &[_][]const u8{ "-std=c99", "-Wall", "-Wextra" },
    });

    shapelib.addIncludePath(b.path("src/lib/shapelib/include"));
    shapelib.linkLibC();
    b.installArtifact(shapelib);

    // compile dglib as static library
    const dglib = b.addStaticLibrary(.{
        .name = "dblib",
        .target = target,
        .optimize = optimize,
    });

    const dglib_cpp_sources = [_][]const u8{
        "src/lib/dglib/lib/DgAddressBase.cpp",
        "src/lib/dglib/lib/DgAddressType.cpp",
        "src/lib/dglib/lib/DgApSeq.cpp",
        "src/lib/dglib/lib/DgBase.cpp",
        "src/lib/dglib/lib/DgBoundedHexC2RF2D.cpp",
        "src/lib/dglib/lib/DgBoundedHexC3C2RF2D.cpp",
        "src/lib/dglib/lib/DgBoundedHexC3RF2D.cpp",
        "src/lib/dglib/lib/DgBoundedIDGG.cpp",
        "src/lib/dglib/lib/DgBoundedIDGGS.cpp",
        "src/lib/dglib/lib/DgBoundedRF2D.cpp",
        "src/lib/dglib/lib/DgBoundedRFBase0.cpp",
        // "src/lib/dglib/lib/DgBoundedRF.hpp",
        "src/lib/dglib/lib/DgBoundedRFS2D.cpp",
        "src/lib/dglib/lib/DgCell.cpp",
        "src/lib/dglib/lib/DgColor.cpp",
        "src/lib/dglib/lib/DgConverterBase.cpp",
        "src/lib/dglib/lib/DgDataFieldBase.cpp",
        "src/lib/dglib/lib/DgDataList.cpp",
        // "src/lib/dglib/lib/DgDiscRF.hpp",
        "src/lib/dglib/lib/DgDiscRFS2D.cpp",
        // "src/lib/dglib/lib/DgDiscRFS.hpp",
        "src/lib/dglib/lib/DgDistanceBase.cpp",
        "src/lib/dglib/lib/DgDmdD4Grid2D.cpp",
        "src/lib/dglib/lib/DgDmdD4Grid2DS.cpp",
        "src/lib/dglib/lib/DgDmdD8Grid2D.cpp",
        "src/lib/dglib/lib/DgDmdD8Grid2DS.cpp",
        "src/lib/dglib/lib/DgDmdIDGG.cpp",
        "src/lib/dglib/lib/DgDVec2D.cpp",
        "src/lib/dglib/lib/DgDVec3D.cpp",
        "src/lib/dglib/lib/DgEllipsoidRF.cpp",
        "src/lib/dglib/lib/DgGeoSphRF.cpp",
        "src/lib/dglib/lib/DgGridTopo.cpp",
        "src/lib/dglib/lib/DgHexC1Grid2D.cpp",
        "src/lib/dglib/lib/DgHexC2Grid2D.cpp",
        "src/lib/dglib/lib/DgHexC3Grid2D.cpp",
        "src/lib/dglib/lib/DgHexGrid2DS.cpp",
        "src/lib/dglib/lib/DgHexIDGG.cpp",
        "src/lib/dglib/lib/DgHexIDGGS.cpp",
        "src/lib/dglib/lib/DgIcosaMap.cpp",
        "src/lib/dglib/lib/DgIDGGBase.cpp",
        "src/lib/dglib/lib/DgIDGG.cpp",
        "src/lib/dglib/lib/DgIDGGS3H.cpp",
        "src/lib/dglib/lib/DgIDGGS43H.cpp",
        "src/lib/dglib/lib/DgIDGGS4D.cpp",
        "src/lib/dglib/lib/DgIDGGS4H.cpp",
        "src/lib/dglib/lib/DgIDGGS7H.cpp",
        "src/lib/dglib/lib/DgIDGGS4T.cpp",
        "src/lib/dglib/lib/DgIDGGSBase.cpp",
        "src/lib/dglib/lib/DgIDGGS.cpp",
        "src/lib/dglib/lib/DgIDGGutil.cpp",
        "src/lib/dglib/lib/DgInAIGenFile.cpp",
        "src/lib/dglib/lib/DgInGdalFile.cpp",
        "src/lib/dglib/lib/DgInLocStreamFile.cpp",
        "src/lib/dglib/lib/DgInLocTextFile.cpp",
        "src/lib/dglib/lib/DgInputStream.cpp",
        "src/lib/dglib/lib/DgInShapefileAtt.cpp",
        "src/lib/dglib/lib/DgInShapefile.cpp",
        "src/lib/dglib/lib/DgIVec2D.cpp",
        "src/lib/dglib/lib/DgIVec3D.cpp",
        "src/lib/dglib/lib/DgLocation.cpp",
        "src/lib/dglib/lib/DgLocBase.cpp",
        "src/lib/dglib/lib/DgLocList.cpp",
        "src/lib/dglib/lib/DgLocVector.cpp",
        "src/lib/dglib/lib/DgOutAIGenFile.cpp",
        "src/lib/dglib/lib/DgOutChildrenFile.cpp",
        "src/lib/dglib/lib/DgOutGdalFile.cpp",
        "src/lib/dglib/lib/DgOutGeoJSONFile.cpp",
        "src/lib/dglib/lib/DgOutKMLfile.cpp",
        "src/lib/dglib/lib/DgOutLocFile.cpp",
        "src/lib/dglib/lib/DgOutLocTextFile.cpp",
        "src/lib/dglib/lib/DgOutNeighborsFile.cpp",
        "src/lib/dglib/lib/DgOutPRCellsFile.cpp",
        "src/lib/dglib/lib/DgOutPRPtsFile.cpp",
        "src/lib/dglib/lib/DgOutPtsText.cpp",
        "src/lib/dglib/lib/DgOutputStream.cpp",
        "src/lib/dglib/lib/DgOutRandPtsText.cpp",
        "src/lib/dglib/lib/DgOutShapefile.cpp",
        // "src/lib/dglib/lib/DgPhysicalRF2D.hpp",
        // "src/lib/dglib/lib/DgPhysicalRFBase.hpp",
        // "src/lib/dglib/lib/DgPhysicalRF.hpp",
        // "src/lib/dglib/lib/DgPhysicalRFS2D.hpp",
        "src/lib/dglib/lib/DgPolygon.cpp",
        "src/lib/dglib/lib/DgProjFuller.cpp",
        "src/lib/dglib/lib/DgProjGnomonicRF.cpp",
        "src/lib/dglib/lib/DgProjISEA.cpp",
        "src/lib/dglib/lib/DgProjTriRF.cpp",
        "src/lib/dglib/lib/DgRandom.cpp",
        "src/lib/dglib/lib/DgRFBase.cpp",
        // "src/lib/dglib/lib/DgRF.hpp",
        "src/lib/dglib/lib/DgRFNetwork.cpp",
        "src/lib/dglib/lib/DgSeriesConverter.cpp",
        "src/lib/dglib/lib/DgSqrD4Grid2D.cpp",
        "src/lib/dglib/lib/DgSqrD4Grid2DS.cpp",
        "src/lib/dglib/lib/DgSqrD8Grid2D.cpp",
        "src/lib/dglib/lib/DgSqrD8Grid2DS.cpp",
        "src/lib/dglib/lib/DgSuperfund.cpp",
        "src/lib/dglib/lib/DgTriGrid2D.cpp",
        "src/lib/dglib/lib/DgTriGrid2DS.cpp",
        "src/lib/dglib/lib/DgTriIDGG.cpp",
        "src/lib/dglib/lib/DgUtil.cpp",
        "src/lib/dglib/lib/DgZ3RF.cpp",
        "src/lib/dglib/lib/DgZ3StringRF.cpp",
        "src/lib/dglib/lib/DgZ7RF.cpp",
        "src/lib/dglib/lib/DgZ7StringRF.cpp",
        "src/lib/dglib/lib/DgZOrderRF.cpp",
        "src/lib/dglib/lib/DgZOrderStringRF.cpp",
    };

    dglib.addCSourceFiles(.{
        .files = &dglib_cpp_sources,
        // .flags = &[_][]const u8{ "-std=c++11", "-Wall", "-Wextra", "-fno-inline", "-fno-eliminate-unused-debug-types", "-pedantic", "-Wimplicit-fallthrough", "-W2" },
        // .flags = &[_][]const u8{ "-std=c++11", "-W" },
    });

    dglib.addIncludePath(b.path("src/lib/dglib/include"));
    dglib.addIncludePath(b.path("src/lib/proj4lib/include"));
    dglib.addIncludePath(b.path("src/lib/shapelib/include"));
    // this is because of irregular imports
    dglib.addIncludePath(b.path("src/lib/shapelib/include/shapelib"));
    dglib.linkLibCpp();
    b.installArtifact(dglib);

    // library dgaplib
    const dgaplib = b.addStaticLibrary(.{
        .name = "dgaplib",
        .target = target,
        .optimize = optimize,
    });

    const dgaplib_cpp_sources = [_][]const u8{
        "src/lib/dgaplib/lib/DgApParamList.cpp",
        "src/lib/dgaplib/lib/DgApSubOperation.cpp",
    };

    dgaplib.addCSourceFiles(.{
        .files = &dgaplib_cpp_sources,
        .flags = &[_][]const u8{ "-std=c++11", "-Wall", "-Wextra", "-fno-inline", "-fno-eliminate-unused-debug-types", "-pedantic", "-Wimplicit-fallthrough", "-W2" },
    });

    dgaplib.addIncludePath(b.path("src/lib/dgaplib/include"));
    dgaplib.addIncludePath(b.path("src/lib/dglib/include"));
    dgaplib.addIncludePath(b.path("src/lib/proj4lib/include"));
    dgaplib.addIncludePath(b.path("src/lib/shapelib/include"));
    // this is because of irregular imports
    dgaplib.addIncludePath(b.path("src/lib/shapelib/include/shapelib"));

    dgaplib.linkLibCpp();
    dgaplib.linkLibrary(dglib);
    dgaplib.linkLibrary(proj4lib);
    dgaplib.linkLibrary(shapelib);

    // the apps
    const appex = b.addExecutable(.{
        .name = "appex",
        .target = target,
        .optimize = optimize,
    });

    const appex_cpp_sources = [_][]const u8{"src/apps/appex/appex.cpp"};

    appex.addCSourceFiles(.{
        .files = &appex_cpp_sources,
        .flags = &[_][]const u8{ "-std=c++11", "-Wall", "-Wextra", "-fno-inline", "-fno-eliminate-unused-debug-types", "-pedantic", "-Wimplicit-fallthrough", "-W" },
    });

    appex.addIncludePath(b.path("src/lib/dglib/include"));
    appex.linkLibCpp();
    appex.linkLibrary(dglib);

    b.installArtifact(appex);

    const dggrid = b.addExecutable(.{
        .name = "dggrid",
        .target = target,
        .optimize = optimize,
    });

    const dggrid_cpp_sources = [_][]const u8{ "src/apps/dggrid/DgHexSF.cpp", "src/apps/dggrid/OpBasic.cpp", "src/apps/dggrid/SubOpBasic.cpp", "src/apps/dggrid/SubOpBasicMulti.cpp", "src/apps/dggrid/SubOpBinPts.cpp", "src/apps/dggrid/SubOpDGG.cpp", "src/apps/dggrid/SubOpGen.cpp", "src/apps/dggrid/SubOpGenHelper.cpp", "src/apps/dggrid/SubOpIn.cpp", "src/apps/dggrid/SubOpMain.cpp", "src/apps/dggrid/SubOpOut.cpp", "src/apps/dggrid/SubOpStats.cpp", "src/apps/dggrid/SubOpTransform.cpp", "src/apps/dggrid/clipper.cpp", "src/apps/dggrid/dggrid.cpp" };

    dggrid.addCSourceFiles(.{
        .files = &dggrid_cpp_sources,
        .flags = &[_][]const u8{ "-std=c++11", "-Wall", "-Wextra", "-fno-inline", "-fno-eliminate-unused-debug-types", "-pedantic", "-Wimplicit-fallthrough", "-W" },
    });

    dggrid.addIncludePath(b.path("src/lib/dgaplib/include"));
    dggrid.addIncludePath(b.path("src/lib/dglib/include"));
    dggrid.addIncludePath(b.path("src/lib/proj4lib/include"));
    dggrid.addIncludePath(b.path("src/lib/shapelib/include"));
    // this is because of irregular imports
    dggrid.addIncludePath(b.path("src/lib/shapelib/include/shapelib"));
    // this is because of h/hpp in src together with cpp files
    dggrid.addIncludePath(b.path("src/apps/dggrid"));

    dggrid.linkLibCpp();
    dggrid.linkLibrary(dgaplib);
    dggrid.linkLibrary(dglib);
    dggrid.linkLibrary(proj4lib);
    dggrid.linkLibrary(shapelib);

    b.installArtifact(dggrid);

    const run_appex = b.addRunArtifact(appex);

    const run_appex_step = b.step("run_appex", "Run appex application");
    run_appex_step.dependOn(&run_appex.step);

    // run dggrid
    const run_dggrid = b.addRunArtifact(dggrid);
    run_dggrid.addArg("-v");

    const run_dggrid_step = b.step("run_dggrid", "Run dggrid application");

    run_dggrid_step.dependOn(&run_dggrid.step);
}
