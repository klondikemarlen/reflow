require_relative 'reflow'
require 'test/unit'

class TestReflow < Test::Unit::TestCase
  def setup
    long_lines = <<~EOS
      Code abstraction engine. Sort of like "reverse" templating. The abstraction engine analyzes your
      code
      for similarity (sort of like a file/diff tool) and then makes a series of templates that would
    EOS

    @flow = TextFlow.new(long_lines)
  end

  def test_reflow_default_80
    margin_80_flow = <<~EOS.strip
      Code abstraction engine. Sort of like "reverse" templating. The abstraction
      engine analyzes your code for similarity (sort of like a file/diff tool) and
      then makes a series of templates that would
    EOS
    assert_equal(@flow.reflowed, margin_80_flow)
  end

  def test_reflow_40
    margin_40_flow = <<~EOS.strip
      Code abstraction engine. Sort of like
      "reverse" templating. The abstraction
      engine analyzes your code for similarity
      (sort of like a file/diff tool) and then
      makes a series of templates that would
    EOS
    assert_equal(@flow.reflowed(40), margin_40_flow)
  end

  def test_reflow_120
    margin_120_flow = <<~EOS.strip
      Code abstraction engine. Sort of like "reverse" templating. The abstraction engine analyzes your code for similarity
      (sort of like a file/diff tool) and then makes a series of templates that would
    EOS
    assert_equal(@flow.reflowed(120), margin_120_flow)
  end

  def test_nospace_line
    long_lines = <<~EOS
      Number of Phones of Most Languages to be 37 Phonemes, 25 Consonants, 6 Diphthongs, 9 Vowels see
      https://www.eupedia.com/linguistics/number_of_phonemes_in_european_languages.shtml
      analysed in LibreCalc :) I guess I would like my code to be pronounceable? :P
      I would like to think that this
    EOS

    smart_hard_break = <<~EOS
      Number of Phones of Most Languages to be 37 Phonemes, 25 Consonants, 6
      Diphthongs, 9 Vowels see https://www.eupedia.com/linguistics/number_of_phonemes_
      in_european_languages.shtml analysed in LibreCalc :) I guess I would like my
      code to be pronounceable? :P I would like to think that this
    EOS
    flow = TextFlow.new(long_lines)
    assert_equal(flow.reflowed, smart_hard_break)
  end
end
