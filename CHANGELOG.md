# Change Log

All notable changes to the "melan" extension will be documented in this file.

<!-- See: http://keepachangelog.com/ -->

## [0.2.3] – 02-May-2020

- Revert to single rule for body environments (two rules created issues with nested commands).
- Adapt Melan to actually match the syntax highlighting (drop the indentation constraint).

## [0.2.2] – 30-Apr-2020

Implement two separate rules (inline/multiline) per body scope type (curly, square, angle), in order to make the grammar a little closer to the actual language.
Melan still supports more cases than can be highlighted at the moment, but this is a good improvement on the previous version.

## [0.1.0] – 27-Apr-2020

- Initial release
- Support commonly expected syntaxes
- Support embedded JSON with the `define` command
