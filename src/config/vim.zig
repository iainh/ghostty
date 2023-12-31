const std = @import("std");
const Config = @import("Config.zig");

/// This is the associated Vim file as named by the variable.
pub const syntax = comptimeGenSyntax();
pub const ftdetect = "au BufRead,BufNewFile */.config/ghostty/config set ft=ghostty\n";
pub const ftplugin =
    \\" Vim filetype plugin file
    \\" Language: Ghostty config file
    \\" Maintainer: Ghostty <https://github.com/mitchellh/ghostty>
    \\"
    \\" THIS FILE IS AUTO-GENERATED
    \\
    \\if exists('b:did_ftplugin')
    \\  finish
    \\endif
    \\let b:did_ftplugin = 1
    \\
    \\setlocal commentstring=#%s
    \\setlocal iskeyword+=-
    \\
    \\" Use syntax keywords for completion
    \\setlocal omnifunc=syntaxcomplete#Complete
    \\
    \\let b:undo_ftplugin = 'setl cms< isk< ofu<'
    \\
;

/// Generates the syntax file at comptime.
fn comptimeGenSyntax() []const u8 {
    comptime {
        var counting_writer = std.io.countingWriter(std.io.null_writer);
        try writeSyntax(&counting_writer.writer());

        var buf: [counting_writer.bytes_written]u8 = undefined;
        var stream = std.io.fixedBufferStream(&buf);
        try writeSyntax(stream.writer());
        return stream.getWritten();
    }
}

/// Writes the syntax file to the given writer.
fn writeSyntax(writer: anytype) !void {
    try writer.writeAll(
        \\" Vim syntax file
        \\" Language: Ghostty config file
        \\" Maintainer: Ghostty <https://github.com/mitchellh/ghostty>
        \\"
        \\" THIS FILE IS AUTO-GENERATED
        \\
        \\if exists('b:current_syntax')
        \\  finish
        \\endif
        \\
        \\let b:current_syntax = 'ghostty'
        \\
        \\let s:cpo_save = &cpo
        \\set cpo&vim
        \\
        \\syn keyword ghosttyConfigKeyword
    );

    const config_fields = @typeInfo(Config).Struct.fields;
    inline for (config_fields) |field| {
        if (field.name[0] == '_') continue;
        try writer.print("\n\t\\ {s}", .{field.name});
    }

    try writer.writeAll(
        \\
        \\
        \\syn match ghosttyConfigComment /#.*/ contains=@Spell
        \\
        \\hi def link ghosttyConfigComment Comment
        \\hi def link ghosttyConfigKeyword Keyword
        \\
        \\let &cpo = s:cpo_save
        \\unlet s:cpo_save
        \\
    );
}

test {
    _ = syntax;
}