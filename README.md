
<a href="https://marketplace.visualstudio.com/items?itemName=jhadida.melan"><img src="https://img.shields.io/badge/VSCode%20Marketplace-melan-blue" alt="Language extension for VSCode" style="margin:0 20px;"></a>
<img src="https://img.shields.io/visual-studio-marketplace/i/jhadida.melan?color=purple&label=Installs&style=plastic" alt="Unique installs on VSCode Marketplace" style="margin:0 20px;">

# VSCode language extension for MeLan

This is a language extension package for VSCode to support the syntax of [MeLan](https://github.com/jhadida/melan), the meta-language with Python backend.

![Syntax highlighting in action](assets/demo.gif)

## Known Issues

### False positives

TextMate grammars are not well suited to describing contiguous sequences of scopes spanning multiple lines, each with their own rules (e.g. `Command > Options > Body`).
For this reason, the matching of commands, option groups, and body contents, are currently implemented with separate rules. 

Hence the following issues:

1. Parentheses directly following a word character (letter, digit or underscore) may be wrongly interpreted as an option group:
```
    a( foo=5 )          # wrongly colored as option group
```
2. Body delimiters (`{} [] <[]>`) directly following a word charater, or a closing parenthesis, may be wrongly colored as well:
```
    a{ not a body }     # wrongly colored as body
    )[ not a body ]     # wrongly colored as body
```

The solution for these issues is to use the tilde character `~`, which Melan replaces with an empty string during compilation:
```
    a~( foo=5 )
    a~{ not a body }
    )~[ not a body ]
```

### Differences with Melan

Unfortunately at this point, syntax highlighting does not cover all valid cases within the Melan language. 

In order to ensure that multiline commands are colored correctly, but also that they are valid Melan code, you should adhere to the following rules:
- body contents should be indented with respect to the line in which the command was issued;
- the closing delimiter MUST be on its own line, **without** trailing whitespace (e.g. `]>⎵` will cause syntax highlighting to fail).

It is unclear whether or not the actual Melan syntax can ever be implemented as a TextMate grammar for syntax highlighting.
Nevertheless, the two previous rules are not overly restrictive, and in any case should not prevent the use of the language.

There is only one case in which syntax highlighting might fail, even with the previous rules. 
When using angular body delimiters `<[ ]>`, if a line in the contents matches `\s*]>`, it will be colored as a closing delimiter, even if it is indented correctly.
In that case, the solution is simply to add a trailing space to this line (i.e. `\s*]>⎵`).

## Release Notes

## [0.2.2] – 30-Apr-2020

Implement two separate rules (inline/multiline) per body scope type (curly, square, angle), in order to make the grammar a little closer to the actual language.
Melan still supports more cases than can be highlighted at the moment, but this is a good improvement on the previous version.
