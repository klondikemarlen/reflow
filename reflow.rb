# accept file
# modify it line by line? Or 2-3 lines at a time?
# check for lines that are longer than 80 chars.
# reflow the text leaving at least 2 words on the next line
# (before sentence ends)

# example
=begin

e.g.
Code abstraction engine. Sort of like "reverse" templating. The abstraction engine analyzes your
code
for similarity (sort of like a file/diff tool) and then makes a series of templates that would

Would become:
Code abstraction engine. Sort of like "reverse" templating. The abstraction
engine analyzes your code for similarity (sort of like a file/diff tool) and
then makes a series of templates that would

=end

long_lines = <<~EOC
  Code abstraction engine. Sort of like "reverse" templating. The abstraction engine analyzes your
  code
  for similarity (sort of like a file/diff tool) and then makes a series of templates that would
EOC

class Flow
  def initialize(ctx, size=80)
    @ctx = ctx
    @size = size
  end

  def reflow
    extra = ''
    reflowed_lines = []
    @ctx.lines do |line|
      line, extra = shorten(extra + line)
      begin
        reflowed_lines.push line unless line.empty?
        line, extra = shorten(extra)
      end until extra.length <= @size
      reflowed_lines.push line unless line.empty?
    end
    reflowed_lines.push extra unless extra.empty?
    reflowed_lines.join("\n")
  end

  def shorten(line)
    # puts "Line to shorten: " + line.dump
    if line.length <= @size
      return '', line.strip() + ' '
    end
    first_space_before_size = line[0..@size].rindex(' ')
    safe_line = line[0..first_space_before_size]
    extra = line[first_space_before_size..-1].strip() + ' '
    [safe_line, extra]
  end
end

flow = Flow.new(long_lines)
puts flow.reflow
