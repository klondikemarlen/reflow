# reflow
A handy tool to reflow a text file to a different fixed width.

```
long_lines = <<~EOC
  Code abstraction engine. Sort of like "reverse" templating. The abstraction engine analyzes your
  code
  for similarity (sort of like a file/diff tool) and then makes a series of templates that would
EOC

flow = Flow.new(long_lines)
```
`puts flow.reflowed` becomes
```
Code abstraction engine. Sort of like "reverse" templating. The abstraction
engine analyzes your code for similarity (sort of like a file/diff tool) and
then makes a series of templates that would
```
`puts flow.reflowed(40)` becomes
```
Code abstraction engine. Sort of like
"reverse" templating. The abstraction
engine analyzes your code for similarity
(sort of like a file/diff tool) and then
makes a series of templates that would
```
`puts flow.reflowed(120)` becomes
```
Code abstraction engine. Sort of like "reverse" templating. The abstraction engine analyzes your code for similarity
(sort of like a file/diff tool) and then makes a series of templates that would
```
