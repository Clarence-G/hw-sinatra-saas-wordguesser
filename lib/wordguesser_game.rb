class WordGuesserGame

  attr_accessor :word, :guesses, :wrong_guesses, :remain_letters, :word_with_guesses, :count

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
    @remain_letters = word.clone
    @word_with_guesses = "-"*(word.length)
    @count = 0
  end

  def guess(guess_word)
    # valid input
    if (guess_word.nil? || guess_word.empty?)
      raise(ArgumentError)
    elsif (guess_word =~ /[A-Za-z]/)!=0
      raise(ArgumentError)
    end
    # count guesses
  
    guess_word.downcase!
    if @word.include? guess_word
      # already guessed
      if @guesses.include? guess_word
        return false
      end
      # compute display word
      @remain_letters.delete!(guess_word)
      word_cpy = word.clone
      @remain_letters.each_char{|s|
        word_cpy.gsub!(s, '-')
      }
      @word_with_guesses = word_cpy
      @guesses+=guess_word
      # @count+=1
    else
      if @wrong_guesses.include? guess_word
        return false
      end
      @wrong_guesses+=guess_word
      @count+=1
    end
    return true
  
  end

  def check_win_or_lose
    if @count<7 
      if @word==@word_with_guesses
        return :win
      else
        return :play
      end
    elsif @count==7
      if @word==@word_with_guesses
        return :win
      else
        return :lose
      end
    else
      return :lose
    end

  end
  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  # def self.get_random_word
  #   require 'uri'
  #   require 'net/http'
  #   uri = URI('http://randomword.saasbook.info/RandomWord')
  #   Net::HTTP.new('randomword.saasbook.info').start { |http|
  #     return http.post(uri, "").body
  #   }
  # end
  def self.get_random_word
    require "sqlite3"
    db = SQLite3::Database.new "lib/words.sqlite3"
    db.execute "SELECT word from words ORDER BY RANDOM () LIMIT 1" do |s|
        return s[0]
    end
  end

end
