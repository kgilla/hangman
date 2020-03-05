class HangmanGame
  # attr_accessor :word, :guess, :guesses, :temp_string, :guess_collection

  # def initialize
  #   @@word = choose_random_word()
  #   @@guess = get_guess()
  #   @@guess_collection = []
  # end



  def choose_random_word
    word_collection = []
    words = File.open("dictionary.txt", "r")
    words.each do |word|
      if word.length > 5 && word.length <= 12
        word_collection.push(word)
      end
    end
    words.close
    random_word = word_collection[rand(1..word_collection.length)].upcase
    return random_word
  end

  def intro
    puts "|"*2 + "*"*76 + "|"*2 
    puts "|"*2 + "-"*76 + "|"*2 
    puts "|"*2 + " "*76 + "|"*2 
    puts "|"*2 + " "*34 + "HANGMAN!" + " "*34 + "|"*2 
    puts "|"*2 + " "*76 + "|"*2 
    puts "|"*2 + "-"*76 + "|"*2 
    puts "|"*2 + "*"*76 + "|"*2 
    
  end

  def get_guess
    guess = ""
    puts "Guess a letter!"
    guess = gets.chomp.upcase
    if guess.length != 1
      puts "One letter only please"
      get_guess()
    end
    return guess
  end 

  def thingy ()
    @@word.split("").each_with_index do |letter, index|
      if guess == letter 
        temp_string[index] = guess
      end
    end
    return temp_string
  end

  def print_round ()
    @@temp_string.split("").each do |letter|
      print letter + " "
    end
  end

  @@word = choose_random_word()
  @@guess = get_guess()
  @@guess_collection = []
end

puts HangmanGame.word


# guess = get_guess()
# word = choose_random_word()
# temp_string = "?"*word.length
# temp_string = thingy(word, guess, temp_string)

# puts word.include? guess
# print_round(temp_string, guess)

