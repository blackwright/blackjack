module SessionsHelper

  def save_sessions(state = {})
    session[:deck] = state[:deck].cards unless state[:deck].nil?
    session[:bank] = state[:bank].funds unless state[:bank].nil?
    session[:player] = state[:player].cards unless state[:player].nil?
    session[:dealer] = state[:dealer].cards unless state[:dealer].nil?
    session[:bet] = state[:bet] unless state[:bet].nil?
    session[:done] = state[:done] unless state[:done].nil?
  end

  def load_deck
    session[:deck]
  end

  def load_bank
    session[:bank]
  end

  def load_player
    session[:player]
  end

  def load_dealer
    session[:dealer]
  end

  def load_bet
    session[:bet]
  end

  def hand_finished
    session[:done]
  end
end
