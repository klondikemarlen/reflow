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

class Flow
  def initialize(ctx, margin=80)
    @ctx = ctx
    @margin = margin
  end

  def reflowed(margin=@margin)
    extra = ''
    reflowed_lines = []
    @ctx.lines do |line|
      begin
        line, extra = shorten(extra + line, margin)
        reflowed_lines.push line unless line.empty?
        line = ''
      end until extra.length <= margin
    end
    reflowed_lines.push extra.strip unless extra.empty?
    reflowed_lines.join("\n")
  end

  def shorten(line, margin=@margin)
    # puts "Line to shorten: " + line.dump
    if line.length <= margin
      return '', line.strip + ' '
    end
    first_space_before_size = line[0..margin].rindex(' ')
    safe_line = line[0...first_space_before_size]
    extra = line[first_space_before_size..-1].strip + ' '
    [safe_line, extra]
  end
end


long_lines = <<~EOS
  Code abstraction engine. Sort of like "reverse" templating. The abstraction engine analyzes your
  code
  for similarity (sort of like a file/diff tool) and then makes a series of templates that would
EOS

flow = Flow.new(long_lines)
puts flow.reflowed
puts
puts flow.reflowed(40)
puts
puts flow.reflowed(120)

fail unless flow.reflowed(80) == <<~EOS
  Code abstraction engine. Sort of like "reverse" templating. The abstraction
  engine analyzes your code for similarity (sort of like a file/diff tool) and
  then makes a series of templates that would
EOS

fail unless flow.reflowed(40) == <<~EOS
  Code abstraction engine. Sort of like
  "reverse" templating. The abstraction
  engine analyzes your code for similarity
  (sort of like a file/diff tool) and then
  makes a series of templates that would
EOS

fail unless flow.reflowed(120) == <<~EOS
  Code abstraction engine. Sort of like "reverse" templating. The abstraction engine analyzes your code for similarity
  (sort of like a file/diff tool) and then makes a series of templates that would
EOS
