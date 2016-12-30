require "sinatra"
require "sinatra/reloader" if development?
require "./helpers/sessions_helper"
require "./helpers/blackjack_helper"
require "./deck"
require "./bank"
require "./hand"

helpers SessionsHelper, BlackjackHelper
enable :sessions

get '/' do
  deck = Deck.new(load_deck)
  bank = Bank.new(load_bank)
  player = Hand.new(deck.initial_deal)
  dealer = Hand.new(deck.initial_deal)
  save_sessions({ deck: deck, bank: bank, player: player, dealer: dealer })
  redirect to('/bet')
end

get '/new' do
  session.clear
  redirect to('/')
end

get '/bet' do
  @message = low_funds_message if params[:funds] == "low"
  @bank = Bank.new(load_bank)
  erb :bet
end

post '/bet' do
  bet = params[:bet].to_i
  bank = Bank.new(load_bank)
  if bet <= bank.funds
    bank.transfer(-bet)
    save_sessions({ bank: bank, bet: bet })
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
  deal(@dealer, deck) until @dealer.has_seventeen?

  dealer_score = @dealer.score
  player_score = @player.score

  outcome = find_outcome(dealer_score, player_score)
  if outcome == :victory
    @bank.transfer(bet * 2)
  elsif outcome == :push
    @bank.transfer(bet)
  end

  @message = outcome_message(outcome, dealer_score, player_score)

  save_sessions({ deck: deck, bank: @bank, dealer: @dealer })
  erb :stand
end
