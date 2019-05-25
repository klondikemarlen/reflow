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
require 'pry'

class String
  def rsplit(pattern=nil, limit=nil)
    array = self.split(pattern)
    left = array[0...-limit].join(pattern)
    right_spits = array[-limit..]
    return [left] + right_spits
  end
end

class TextFlow
  DEFAULT_MARGIN = 80

  def initialize(ctx, margin=DEFAULT_MARGIN)
    @ctx = ctx
    @margin = margin
  end

  def reflowed(margin=@margin)
    extra = ''
    reflowed_lines = []
    @ctx.lines do |line|
      begin
        line, extra = resize(extra + line, margin)
        reflowed_lines.push line unless line.empty?
        line = ''
      end until extra.length <= margin
    end
    reflowed_lines.push extra.strip unless extra.empty?
    reflowed_lines.join("\n")
  end

  def resize(line, margin=@margin)
    if line.length <= margin
      return '', line.strip + ' '
    end
    first_space_before_size = line[0..margin].rindex(' ')  || margin
    safe_line = line[0...first_space_before_size]
    extra = line[first_space_before_size..-1].strip + ' '
    [safe_line, extra]
  end
end

if __FILE__ == $0
  require 'pathname'

  return unless not ARGV[0].nil?
  path = Pathname.new(ARGV[0])
  in_f = File.new(path)
  flow = TextFlow.new(in_f)
  margin = (ARGV[1] || TextFlow::DEFAULT_MARGIN).to_i


  base = path.basename
  base, ending = base.rsplit('.', 1)
  binding.pry
  out_f = File.open("#{base}_reflowed.#{ending}", 'w') do |f|
    f.write(flow.reflowed(margin))
  end
end
