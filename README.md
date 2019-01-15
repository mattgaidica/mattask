# Readme
Using MATLAB comments to track tasks seemed like the most agile solution to all my problems. The **mattasks** project recursively scans a directory for any comment with the format `[ ] This is a task!` and exports a pretty markdown file with every task, from every file.

## How to
You can use mattasks two ways based on the `useWorkingDir` configuration variable:
1. Place *mattasks.m* in your working directory and set `useWorkingDir = true`.
2. Keep the mattasks repository anywhere and select a directory at runtime with `useWorkingDir = false`.

All tasks are identified with the regex pattern: `\[(x| )\].*` The following are valid task formats (see the [tests directory](/tests) for inline examples) which can appear on their own line or next to uncommented code:
* `a = 3; % [ ] Reset a to positive number`
* `% [x] Exclude the following line after Joey fixes his code`

## Configuration
All of the configuration variables can be found at the top of the *mattasks.m* file.

Variable | Type | Description
---------|------|------------
`useWorkingDir` | boolean | `true` uses working directory and `false` opens the folder selection dialog at runtime
`tasksFilename` | string | sets the output filename (recommended: *README.md* or *TASKS.md*)
`fileExtensions` | cell | list of file extensions to search through
`skipString` | string | all tasks appearing in a file after this string is encountered are skipped
`openTaskFile` | boolean | `true` opens the task file when done and `false` does not

--- 
### Sample Task File
Also see the [tests directory](/tests).

# Tasks   
*Last Updated Jan.14, 2019 at 15:45*  
  
  
/**DefinitionsofInequality.m**  
- [ ] Add a condition to handle undefined numbers `(ln005)`  
  
/**EquivalencePropertiesofEquality.m**  
- [x] add exclamation point! `(ln012)`  
- [ ] add entry for Transitive Property -Matt `(ln015)`  
  
/**TestSkipString.m**  
- [x] Setup addition and subtraction `(ln001)`  
- [x] Use a and b to demonstrate addition `(ln004)`  
  
/testsub/**TestString.m**  
- [ ] Display each character of a one new line `(ln003)`  
  
EOF20190114154555