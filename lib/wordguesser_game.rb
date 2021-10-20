class WordGuesserGame

  attr_accessor :word, :guesses, :wrong_guesses, :several_letters

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
    @several_letters = ""
  end

  def guess(guess_word)
    if (guess_word.nil? || guess_word.empty?)
      raise(ArgumentError)
    else
      guess_word.each_char{|s|
        if((s =~ /[A-Za-z]/)!=0)
          raise(ArgumentError)
        end
      }
    end
    guess_word.downcase!
    if @word.include? guess_word
      if @guesses.include? guess_word
        return false
      end
      
      @guesses+=guess_word
      # return true
    else
      if @wrong_guesses.include? guess_word
        return false
      end
      @wrong_guesses+=guess_word
    end
    return true
  
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
