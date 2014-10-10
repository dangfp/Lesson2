require 'pry'

class Card
  attr_accessor :suit, :face_value, :actual_value

  def initialize(suit, face_value, actual_value)
    @suit = suit
    @face_value = face_value
    @actual_value = actual_value
  end
  
  def to_s
    "The #{face_value} of #{suit}"
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    ['Hearts', 'Diamonds', 'Spades', 'Clubs'].each do |suit|
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].each do |face_value|
        if face_value == 'A'
          actual_value = 11
        elsif face_value == 'J' || face_value == 'Q' || face_value == 'K'
          actual_value = 10
        else
          actual_value = face_value.to_i
        end

        @cards << Card.new(suit, face_value, actual_value)
      end
    end
    scramble!
  end

  def scramble!
    @cards.shuffle!
  end

  def deal_card
    @cards.pop
  end
end

module Hand
  def show_hand
    puts "---- #{name}'s Hand ----"
    cards.each do |card|
      puts "-> #{card}"
    end
    puts "-> Total: #{total}"
  end

  def total
    total = 0
    cards.each { |card| total += card.actual_value }

    #correct for Aces
    cards.select{ |card| card.face_value == 'A' }.count.times do
      break if total <= 21
      total -= 10
    end
    total
  end

  def add_card(new_card)
    cards << new_card
  end

  def is_blackjack?
    total == 21
  end

  def is_busts?
    total > 21
  end
end

class Player
  include Hand
  attr_reader :name, :type
  attr_accessor :cards

  def initialize(name, type)
    @name = name
    @type = type
    @cards = []
  end
  
end

class Blackjack
  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new("tom", 'player')
    @dealer = Player.new("computer", 'dealer')
  end
  
  def blackjack_or_bust?(player_or_dealer)
    if player_or_dealer.is_blackjack?
      puts "#{player_or_dealer.name} hits blackjack, #{player_or_dealer.name} won!"
      play_again?
    elsif player_or_dealer.is_busts?
      puts "#{player_or_dealer.name} busts, #{player_or_dealer.name} lost!"
      play_again?
    end
  end

  def initial_deal_card
    2.times do
      player.add_card(deck.deal_card)
      dealer.add_card(deck.deal_card)
    end
  end

  def show_hands
    player.show_hand
    dealer.show_hand
  end

  def initail_check_winner
    blackjack_or_bust?(player)
    blackjack_or_bust?(dealer)
  end

  def player_turn
    puts "player turn."
    while player.total < 21
      puts "What would you like to do? 1) hit 2) stay"
      hit_or_stay = gets.chomp

      if !['1', '2'].include?(hit_or_stay)
        puts "Error: you must enter 1 or 2"
        next
      end

      if hit_or_stay == '2'
        break
      end

      new_card = deck.deal_card
      puts "Dealing card to #{player.name}: #{new_card}"
      player.add_card(deck.deal_card)
      puts "#{player.name}'s total is now: #{player.total}"

      blackjack_or_bust?(player)
    end
    puts "#{player.name} stays at #{player.total}."
  end

  def dealer_turn
    puts "Dealer turn."
    while dealer.total < 17
      new_card = deck.deal_card
      puts "Dealing card to #{dealer.name}: #{new_card}"
      dealer.add_card(deck.deal_card)
      puts "#{dealer.name}'s total is now: #{dealer.total}"

      blackjack_or_bust?(dealer)
    end
    puts "#{dealer.name} stays at #{dealer.total}."
  end

  def non_initial_check_winner
    if player.total > dealer.total
      puts "#{player.name} won!"
    elsif player.total < dealer.total
      puts "#{dealer.name} won!"
    else
      puts "It's tie."
    end
  end

  def play_again?
    puts "Would you like to play again? 1) yes 2) no, exit"
    if gets.chomp == '1'
      puts "Starting new game..."
      puts ""
      deck = Deck.new
      player.cards = []
      dealer.cards = []
      run
    else
      puts "Game Over!Goodbye!"
      exit
    end
  end

  def run
    initial_deal_card
    show_hands
    initail_check_winner
    player_turn
    dealer_turn
    non_initial_check_winner
    play_again?
  end
end

Blackjack.new.run


