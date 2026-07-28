const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_filters = b.option([]const []const u8, "test-filter", "Skip tests that do not match any filter") orelse &[0][]const u8{};

    const mod = b.addModule("wav", .{
        .root_source_file = b.path("src/Wav.zig"),
        .target = target,
        .optimize = optimize,
    });

    const mod_tests = b.addTest(.{
        .root_module = mod,
        .filters = test_filters,
    });
    const run_mod_tests = b.addRunArtifact(mod_tests);

    mod_tests.root_module.addAnonymousImport("wav_32", .{
        .root_source_file = b.path("test/test_32bit.wav"),
    });
    mod_tests.root_module.addAnonymousImport("wav_16", .{
        .root_source_file = b.path("test/test_16bit.wav"),
    });
    mod_tests.root_module.addAnonymousImport("wav_32_stereo", .{
        .root_source_file = b.path("test/test_32bit_stereo.wav"),
    });
    mod_tests.root_module.addAnonymousImport("wav_fade_edges", .{
        .root_source_file = b.path("test/test_wav_fade_edges.wav"),
    });
    mod_tests.root_module.addAnonymousImport("wav_quiet", .{
        .root_source_file = b.path("test/quiet.wav"),
    });

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
}
