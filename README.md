
# MeLan language extension for VSCode

This is a language extension package for VSCode to support the syntax of [MeLan](https://github.com/jhadida/melan), the meta-language with Python backend.

<img src="assets/demo.gif" alt="Syntax highlighting in action">

## Known Issues

TextMate grammars are not well suited to describing contiguous sequences of scopes spanning multiple lines, each with their own rules (e.g. `Command > Options > Body`).
For this reason, the matching of commands, option groups, and body contents, are currently implemented with separate rules. 

Hence the following minor issues:

- Parentheses directly following a word character (letter, digit or underscore) may be wrongly interpreted as an option group:
```
    a( foo=5 )          # wrongly colored as option group
```
- Body delimiters (`{} [] <[]>`) directly following a word charater, or a closing parenthesis, may be wrongly colored as well:
```
    a{ not a body }     # wrongly colored as body
    )[ not a body ]     # wrongly colored as body
```

The solution for both issues is to use the tilde character `~`, which Melan replaces with an empty string during compilation:
```
    a~( foo=5 )
    a~{ not a body }
    )~[ not a body ]
```

## Release Notes

### [0.1.0] – 27-Apr-2020

- Initial release
- Support commonly expected syntaxes
- Support embedded JSON with the `define` command
