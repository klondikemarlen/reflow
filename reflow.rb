=begin

1. accept file
2. modify it line by line? Or 2-3 lines at a time?
3. check for lines that are longer than 80 chars.
  a. if line is longer than 80 chars split at space.
  b. if next line has no spaces and is longer than 80 chars split first line
    hard at 80 chars.
  This might require a context fork ... do both and see which one looks better
    then discard the other?
4. reflow the text leaving at least 2 words on the next line
(before sentence ends)

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

class TextFlow
  DEFAULT_MARGIN = 80
  LINE_BREAK_FORMAT = %r{
    (?<=[^.:?!])  # break when not proceeded by sentence terminators
    (\r\n|\n)     # match line speparators
    \z            # if at the end of the string, possibly irrelavant
  }x

  def initialize(text, margin=DEFAULT_MARGIN)
    @text = text
    @margin = margin

    # detect current margin?
  end

  def reflowed(margin=@margin)
    reflowed_lines = []
    working_text = ''
    for line in @text.each_line
      line.gsub!(LINE_BREAK_FORMAT, ' ')
      working_text += line
      while working_text.length > margin
        new_line, working_text = break_line(working_text, margin)
        reflowed_lines.push(new_line)
      end
    end
    # push any left over text
    reflowed_lines.push(working_text[0...-1])
    reflowed_lines.join("\n")
  end

  def break_line(line, margin)
    # normal work breaking
    word_break = line[0..margin].rindex(' ') || margin
    new_line = line[0...word_break]
    extra = line[word_break + 1..-1]

    # special break, prevent breaking to early
    space_break = extra[0..margin].rindex(' ')
    if space_break.nil? || space_break > margin
      new_line = line[0...margin]
      extra = line[margin..-1]
    end

    return new_line, extra
  end
end


if __FILE__ == $0
  require 'pathname'

  class String
    def rsplit(pattern=nil, limit=nil)
      array = self.split(pattern)
      left = array[0...-limit].join(pattern)
      right_spits = array[-limit..]
      return [left] + right_spits
    end
  end

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
