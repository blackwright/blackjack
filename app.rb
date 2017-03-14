require "sinatra"
require "sinatra/reloader" if development?
require "./helpers/sessions_helper"
require "./helpers/blackjack_helper"
require "./lib/deck"
require "./lib/bank"
require "./lib/hand"

helpers SessionsHelper, BlackjackHelper
enable :sessions

get '/' do
  deck = Deck.new(load_deck)
  bank = Bank.new(load_bank)
  player = Hand.new(deck.initial_deal)
  dealer = Hand.new(deck.initial_deal)
  save_sessions({ deck: deck, bank: bank,
                  player: player, dealer: dealer,
                  done: false })
  redirect to('/bet')
end

get '/new' do
  session.clear
  redirect to('/')
end

get '/bet' do
  @bank = Bank.new(load_bank)
  if @bank.funds.zero?
    @bankrupt = true
  else
    @message = low_funds_message if params[:funds] == "low"
  end
  @deck = Deck.new(load_deck)
  if @deck.cards.count < 20
    @deck = Deck.new
    save_sessions({ deck: @deck })
  end
  erb :bet
end

post '/bet' do
  bet = params[:bet].to_i
  bank = Bank.new(load_bank)
  if bet <= bank.funds
    bank.transfer(-bet)
    save_sessions({ bank: bank, bet: bet, done: false })
    redirect to('/blackjack')
  else
    redirect to('/bet?funds=low')
  end
end

get '/blackjack' do
  deck = Deck.new(load_deck)
  @dealer = Hand.new(load_dealer)
  @player = Hand.new(load_player)
  erb :blackjack
end

post '/hit' do
  redirect to('/stand') if hand_finished
  deck = Deck.new(load_deck)
  bank = Bank.new(load_bank)
  dealer = Hand.new(load_dealer)
  player = Hand.new(load_player)
  deal(player, deck)
  save_sessions({ deck: deck, bank: bank, player: player })
  redirect to(player.bust? ? '/stand' : '/blackjack')
end

get '/stand' do
  deck = Deck.new(load_deck)
  @bank = Bank.new(load_bank)
  bet = load_bet
  @dealer = Hand.new(load_dealer)
  @player = Hand.new(load_player)

  unless hand_finished
    deal(@dealer, deck) until @dealer.has_seventeen?
  end

  dealer_score = @dealer.score
  player_score = @player.score

  outcome = find_outcome(dealer_score, player_score)
  unless hand_finished
    if outcome == :victory
      @bank.transfer(bet * 2)
    elsif outcome == :push
      @bank.transfer(bet)
    end
  end

  @message = outcome_message(outcome, dealer_score, player_score)

  save_sessions({ deck: deck, bank: @bank, dealer: @dealer, done: true })
  erb :stand
end
