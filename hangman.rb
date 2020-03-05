class Game
  attr_accessor :word, :attempts_left, :hidden_word, :previous_guesses

  def title 
    puts 
    puts "{"*2 + "@"*76 + "}"*2 
    puts "{"*2 + "@"*20 + " "*11 + "H A N G M A N" + " "*11 + "@"*21 + "}"*2 
    puts "{"*2 + "@"*76 + "}"*2 
    title_menu
  end
  
  def title_menu
    puts "\n1) Start a new game", "\n2) Resume an old game", "\n3) Quit"
    input = gets.chomp.to_i
    if input == 1
      new_game
    elsif input == 2
      load_screen
    else
      exit
    end
  end

  def new_game
    @word = choose_random_word
    @attempts_left = @word.length
    @hidden_word = ["_"] * (@word.length - 1)
    @previous_guesses = []
    intro
  end

  def choose_random_word
    word_collection = []
    File.open("dictionary.txt", "r").readlines.each do |word|
      if word.length > 5 && word.length <= 12
        word_collection << word
      end
    end
    random_word = word_collection[rand(1..word_collection.length)].upcase
  end

  def intro
    sleep(1)
    puts "Lets find you a word to guess..."
    sleep(1)
    puts "Okay! Found a great word for you."
    puts "\nThe word is #{@word.length} letters long", "\nGood Luck!"
    loop
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

  def get_guess
    guess = ""
    puts "\nGuess a letter! or type save to save your game and exit"
    guess = gets.chomp.upcase
    if guess == "SAVE"
      save_game
    elsif @previous_guesses.include?(guess) || guess.length != 1
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

  def check_win
    if @hidden_word.include?("_") == false
      win
    end
  end

  def print_round
    @previous_guesses.sort!
    puts ""
    @hidden_word.each { |letter| print letter + " "}
    puts " ", "\nYou have #{@attempts_left} attempts left" 
    puts "Your prevous guesses: #{@previous_guesses}" 
  end

  def win 
    puts "Congrats! You guessed the word #{@word}successfully!"
    puts "Want to play again? (Y/N)"
    answer = gets.chomp.upcase
    if answer == "Y"
      new_game
    else
      title
    end
  end

  def lose
    puts "\nAww looks like you lost this one", "The word was: #{@word}"
    puts "Want to play again? (Y/N)"
    answer = gets.chomp.upcase
    if answer == "Y"
      new_game
    else
      title
    end
  end

  def save_game
    puts "Go ahead and name your save"
    save_name = gets.chomp
    File.open("saves/#{save_name}", 'w+') do |s| 
      Marshal.dump(self, s)  
    end 
    puts"\nCurrent session has been saved"
    title
  end

  def load_screen
    puts "\n Here are your saves:"
    saves = Dir.children('saves')
    saves.each_with_index do |save, index|
      puts "#{index + 1}) #{save}"
    end
    puts "\n To load a file, please enter its number"
    file_index = gets.chomp.to_i
    file_to_load = "saves/" + saves[file_index - 1]
    load_game(file_to_load)
  end

  def load_game (file_to_load)
    game = File.new(file_to_load,'r')
    old_game = Marshal.load(game)
    @word = old_game.word
    @attempts_left = old_game.attempts_left
    @hidden_word = old_game.hidden_word
    @previous_guesses = old_game.previous_guesses
    print_round
    loop
  end
end

game = Game.new
game.title