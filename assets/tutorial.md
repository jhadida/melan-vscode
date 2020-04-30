
> The following contents is based on these resources:
>
> - Official documentation for VSCode extension [link](https://code.visualstudio.com/api/language-extensions/syntax-highlight-guide)
> - TextMate documentation: [regex](https://macromates.com/manual/en/regular_expressions), [grammars](https://macromates.com/manual/en/language_grammars)
> - Great blog post about writing a TextMate grammar [link](https://www.apeth.com/nonblog/stories/textmatebundle.html)
> - WebApp to test Oniguruma regex [link](https://rubular.com/), see also files `RE-<version>.txt` in this folder
> - SublimeText docs about scope naming [link](https://www.sublimetext.com/docs/3/scope_naming.html), see also `standard-scopes.txt` in this folder
> - Existing grammars in VSCode [link](https://github.com/microsoft/vscode-textmate/blob/master/test-cases/themes/grammars.json)

# TextMate grammars for syntax highighting

## High-level structure

TextMate grammars in VSCode are JSON files with the extension `.tmLanguage.json`:
```
{
    "$schema": "https://raw.githubusercontent.com/martinring/tmlanguage/master/tmlanguage.json" <special key>
    "name": <human friendly name>
    "scopeName": <the type of document this grammar is for>
    "patterns": [
        <rules to be matched, order matters>
    ],
    "repository": {
        <rules associated with names, to facilitate re-use>
    }
}
```

Note that:
- the `scopeName` should correspond to the key defined in your [manifest](https://code.visualstudio.com/api/references/extension-manifest) `package.json`, under `contributes > grammars > scopeName`;
- the keys of the `repository` object are not TextMate scopes, they can be any string that suitably describes the rule.

## Rules

There are three types of rules:
- `include`: using keys from the repository, or calling to external scopes;
- `match`: single-line only;
- `begin/end`: potentially multi-line, but not necessarily.

All rules are JSON objects `{ }`, which may contain the following keys:
- `name`: required field defining the TextMate scope;
- `comment`: use this to add comments to your rules;
- `disabled`: set to `1` to disable this rule (useful for testing).

The `name` field is a TextMate scope that will be used for coloring. 
They are dot-separated strings, which **always end with the languages name**, for example:
```
keyword.control.function.melan      // notice the .melan at the end
```

The dot-separated syntax indicates a hierarchy: `keyword` is more general than `keyword.control`, which is in turn more general than `keyword.control.function`, etc.
Color themes "target" some of these scopes and define different colors for each of them. 
If a color theme targets a given scope, but not specific subscopes, then the colors are applied to the corresponding scope, and _all_ of its subscopes.

### Include

Include rules are simply:
```json
{ "include": "#key" }           // refer to a key in repository
{ "include": "scope.json" }     // refer to external scope
```

### Match

Match rules are formatted as follows:
```
{
    "name": <TextMate target scope to be used for coloring>
    "match": <regex to be matched>
    "captures": { // optional
        "1": <refer to first captured group in regex>
        "2": <second group>
        ...
    }
}
```

- More info about TextMate scopes [here](https://macromates.com/manual/en/language_grammars#naming_conventions)
- More info about Oniguruma regex [here](https://macromates.com/manual/en/regular_expressions)
- See details below.


### Begin/end

Begin/end rules are formatted as follows:
```
{
    "name": <TextMate target scope to be used for coloring>
    "begin": <regex to be matched>
    "end": <regex to be matched>
    "beginCaptures": { // optional
        "1": <refer to first captured group in begin regex>
        "2": <second group>
        ...
    }
    "endCaptures": { // optional
        "1": <refer to first captured group in end regex>
        "2": <second group>
        ...
    }
    "contentName": <TextMate target scope to be used for coloring BETWEEN begin/end>
}
```

Both `begin` and `end` and single-line patterns, but they can match on different lines. 
The text between them is the "content", which can span multiple lines.

## Details

### Captures

Captures can be used to define _nested patterns_ within a group captured by the regex.
They can be one of:
```
{ "name": ... }       // specified scope will be assigned to captured group
{ "include": ... }    // match named rule or scope within captured group
{ 
   "patterns": [
      // match multiple rules or scopes within the captured group
   ] 
}
```

### Oniguruma regex

Make sure you read about [Oniguruma regex](https://macromates.com/manual/en/regular_expressions) and understand them, in particular:

- greedy `*`, reluctant `*?` and possessive `*+` matches;
- lookbehind and lookahead (note that lookbehind only support **fixed length** patterns);
- shy groups, named groups and "variables" (Tanaka Akira Special).

### Common TextMate scopes

Most color themes cover the following TextMate scopes:
```
comment
constant
constant.character.escape
constant.language
constant.numeric
declaration.section 
declaration.tag
deco.folding
entity.name.function
entity.name.section
entity.name.tag
entity.name.type
entity.other.attribute-name
entity.other.inherited-class
invalid
keyword
keyword.control.import
keyword.operator.js
markup.heading
markup.list
markup.quote
meta.embedded
meta.preprocessor
meta.section
meta.tag
storage
storage.type.method
string
string.unquoted
support.class
support.constant
support.function
support.type
support.variable
variable
variable.language
variable.other
variable.parameter
```

### Deferred end patterns

In a begin/match rule, the optional patterns defined in the `endCaptures` may overflow an otherwise valid `end` pattern. 
For example (taken from [here](https://www.apeth.com/nonblog/stories/textmatebundle.html)) with:
```json
"bold": {
    "name": "markup.bold.toy",
    "begin": "\\*",
    "end": "\\+",
    "patterns": [
        {
            "name": "markup.italic.toy",
            "match": "_.*?_';}",
        }
    ]
};
```

With the following text, things behave as expected:
```
This is *a
bold+ stretch of text.
```
The words “a bold” are in bold, and that’s the end of that. But now:
```
This is *a
_bold+ stretch_ of text.
```
Here "bold stretch" will be in italic, and _eat_ past the end of the bold scope.