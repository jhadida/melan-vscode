
<a href="https://marketplace.visualstudio.com/items?itemName=jhadida.melan"><img src="https://img.shields.io/badge/VSCode%20Marketplace-melan-blue" alt="Language extension for VSCode" style="margin:0 20px;"></a>
<img src="https://img.shields.io/visual-studio-marketplace/i/jhadida.melan?color=purple&label=Installs&style=plastic" alt="Unique installs on VSCode Marketplace" style="margin:0 20px;">

# VSCode language extension for MeLan

This is a language extension package for VSCode to support the syntax of [MeLan](https://github.com/jhadida/melan), the meta-language with Python backend.

![Syntax highlighting in action](assets/demo.gif)

## Known Issues

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

## Release Notes

## [0.2.3] – 02-May-2020

- Revert to single rule for body environments (two rules created issues with nested commands).
- Adapt Melan to actually match the syntax highlighting (drop the indentation constraint).
