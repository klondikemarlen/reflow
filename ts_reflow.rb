require 'test/unit'
require 'pry'

require_relative 'reflow'


class TestReflow < Test::Unit::TestCase
  def setup
    original_text = <<~EOS
      Code abstraction engine. Sort of like "reverse" templating. The abstraction engine analyzes your code
      for similarity (sort of like a file/diff tool) and then makes a series of templates that would
    EOS

    @flow = TextFlow.new(original_text)
  end

  def test_reflow_default_80
    margin_80_flow = <<~EOS.strip
      Code abstraction engine. Sort of like "reverse" templating. The abstraction
      engine analyzes your code for similarity (sort of like a file/diff tool) and
      then makes a series of templates that would
    EOS
    assert_equal(margin_80_flow, @flow.reflowed)
  end

  def test_reflow_40
    margin_40_flow = <<~EOS.strip
      Code abstraction engine. Sort of like
      "reverse" templating. The abstraction
      engine analyzes your code for similarity
      (sort of like a file/diff tool) and then
      makes a series of templates that would
    EOS
    assert_equal(margin_40_flow, @flow.reflowed(40))
  end

  def test_reflow_120
    # my code currently can't expand a hardbroken margin.
    margin_120_flow = <<~EOS.strip
      Code abstraction engine. Sort of like "reverse" templating. The abstraction engine analyzes your code for similarity
      (sort of like a file/diff tool) and then makes a series of templates that would
    EOS
    # binding.pry
    assert_equal(margin_120_flow, @flow.reflowed(120))
  end

  def test_avoid_overstriping
    original_text = <<~EOS
      (or heating) coil connecting, a filter, a battery and a liquid mix. You could even caffinate the fluid so as the get your daily caffiene hit.

      A non-profit bank. The Peoples Bank of Canada. Open source distributed conversation
    EOS

    overstriping_avoided = <<~EOS
      (or heating) coil connecting, a filter, a battery and a liquid mix. You could
      even caffinate the fluid so as the get your daily caffiene hit.

      A non-profit bank. The Peoples Bank of Canada. Open source distributed
      conversation
    EOS

    flow = TextFlow.new(original_text)
    # binding.pry
    assert_equal(overstriping_avoided, flow.reflowed)
  end

  def test_nospace_line
    original_text = <<~EOS
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
    flow = TextFlow.new(original_text)
    # binding.pry
    assert_equal(smart_hard_break, flow.reflowed)
  end
end
