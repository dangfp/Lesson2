class Player
  attr_accessor :pick_result
  attr_reader :name

  def initialize(n)
    @name = n
  end
  
  # def to_s
  #   "#{name} pick_result is #{pick_result}"
  # end
end

class Person < Player
  def pick
    begin
      puts "Choose one: (P/R/S)"
      self.pick_result = gets.chomp.downcase
    end until Game::CHOICES.keys.include?(pick_result)
  end
end

class Computer < Player
  def pick
    self.pick_result = Game::CHOICES.keys.sample
  end
end

class Game
  CHOICES = {'p' => 'Paper', 'r' => 'Rock', 's' => 'Scissors'}
  attr_reader :player, :computer

  def initialize
    @player = Person.new("Tom")
    @computer = Computer.new("computer")
  end

  def display_winner_message(winner)
    case winner.pick_result
    when 'p'
      puts "Paper wraps Rock."
    when 'r'
      puts "Rock smashes Scissors."
    when 's'
      puts "Scissors cuts Paper."
    end

    puts "#{winner.name} won!"
  end

  def compare_picks
    if player.pick_result == computer.pick_result
      puts "It's a tie."
    elsif (player.pick_result == 'p' && computer.pick_result == 'r') || 
      (player.pick_result == 'r' && computer.pick_result == 's') || 
      (player.pick_result == 's' && computer.pick_result == 'p')
      display_winner_message(player)
    else
      display_winner_message(computer)
    end
  end

  def run
    player.pick
    computer.pick
    compare_picks
  end

end

game = Game.new.run
