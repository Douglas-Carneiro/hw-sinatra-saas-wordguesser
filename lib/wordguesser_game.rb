class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  # Creates the getter and setter methods
  attr_accessor(:word, :guesses, :wrong_guesses)

  def guess(letter)
    if !letter || !letter.match?(/[[:alpha:]]/) || letter.empty?
      raise ArgumentError.new("Guess should be a valid letter")
    end
    
    # case insensitive
    letter.downcase!

    if @word.include? letter
      unless @guesses.include?(letter)
        @guesses.concat(letter)
        
        # subtract the number of available guesses
        return true
      else
        return false
      end
    else
      unless @wrong_guesses.include?(letter)
        @wrong_guesses.concat(letter)
        return true
      else
        return false
      end
    end
  end

  def word_with_guesses
    @word.chars.map { |letter| @guesses.include?(letter) ? letter : '-' }.join()
  end

  def check_win_or_lose
    attempts = @guesses.length + @wrong_guesses.length
    
    if attempts <= 7 && @word == self.word_with_guesses
      return :win
    elsif attempts < 7 && @word != self.word_with_guesses
      return :play
    else
      return :lose
    end
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end
