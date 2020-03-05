class Game
  def start
    @word = choose_random_word
    @attempts_left = @word.length
    @hidden_word = ["_"] * (@word.length - 1)
    @previous_guesses = []
    title
  end

  def choose_random_word
    word_collection = []
    words = File.open("dictionary.txt", "r")
    words.each do |word|
      if word.length > 5 && word.length <= 12
        word_collection << word
      end
    end
    random_word = word_collection[rand(1..word_collection.length)].upcase
  end

  def title 
    puts "{"*2 + "@"*76 + "}"*2 
    puts "{"*2 + " "*34 + "HANGMAN!" + " "*34 + "}"*2 
    puts "{"*2 + " "*76 + "}"*2
    puts "{"*2 + " "*30 + "A Game By KGilla" + " "*30 + "}"*2
    puts "{"*2 + "@"*76 + "}"*2 
    title_menu
  end
  
  def title_menu
    puts "\n1) Start a new game"
    puts "\n2) Resume an old game"
    puts "\n3) Quit"
    input = gets.chomp.to_i
    if input == 1
      intro
      loop
    elsif input == 2
      "okay"
    else
      exit
    end
  end

  def intro
    sleep(1)
    puts "Hey there, welcome to Hangman! Let me get you a word to guess..."
    sleep(1)
    puts "Okay, found a great word for you."
    puts "\nThe word is #{@word.length} letters long"
    puts "Goodluck!"
  end

  def get_guess
    guess = ""
    puts "\nGuess a letter!"
    guess = gets.chomp.upcase
    if guess.length != 1
      get_guess
    elsif @previous_guesses.include?(guess)
      puts "You already guessed #{guess}..."
      get_guess
    else
      @previous_guesses << guess if @previous_guesses.include?(guess) == false
    end
    return guess
  end 

  def is_guess_in_word (guess)
    @attempts_left -= 1 if @word.include?(guess) == false
    @word.split("").each_with_index do |letter, index|
      if guess == letter 
        @hidden_word[index] = guess
      end
    end
  end

  def print_round
    puts ""
    @hidden_word.each { |letter| print letter + " "}
    puts "\nYou have #{@attempts_left} attempts left" 
    puts "Your prevous guesses: #{@previous_guesses}" 
  end

  def lose
    puts "\nAww looks like you lost this one"
    puts "The word was: #{@word}"
    puts "Want to play again? (Y/N)"
    answer = gets.chomp.upcase
    if answer == "Y"
      game = Game.new
      game.start
    else
      exit
    end
  end

  def win 
    puts "Congrats! You guessed the word #{@word} successfully!"
    puts "Want to play again? (Y/N)"
    answer = gets.chomp.upcase
    if answer == "Y"
      game = Game.new
      game.start
    else
      exit
    end
  end

  def check_win
    if @hidden_word.include?("_") == false
      win
    end
  end

  def loop
    until @attempts_left == 0
      round
    end
    lose
  end

  def round
    user_guess = get_guess
    is_guess_in_word(user_guess)
    check_win
    print_round
  end
end

game = Game.new
game.start


