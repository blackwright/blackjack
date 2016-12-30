module BlackjackHelper

  def deal(player, deck)
    player.cards << deck.deal_card
  end

  def cardify(card)
    rank = card[0]
    suit = card[1]
    if ["diams", "hearts"].include?(suit)
      (erb :"cards/_#{rank}").gsub("SUIT", "&#{suit};").gsub("front", "front red")
    else
      (erb :"cards/_#{rank}").gsub("SUIT", "&#{suit};")
    end
  end

  def find_outcome(dealer_score, player_score)
    if bust?(player_score)
      :defeat
    elsif bust?(dealer_score)
      :victory
    elsif player_score < dealer_score
      :defeat
    elsif player_score > dealer_score
      :victory
    else
      :push
    end
  end

  def outcome_message(outcome, dealer_score, player_score)
    message = ""
    if outcome == :defeat
      message << "Better luck next time. "
      if bust?(player_score)
        message << "Player busts."
      else
        message << "Player loses #{player_score} to #{dealer_score}."
      end
    elsif outcome == :victory
      message << "Congratulations! "
      if bust?(dealer_score)
        message << "Dealer busts."
      else
        message << "Player wins #{player_score} to #{dealer_score}."
      end
    else
      message << "Push."
    end
    message
  end

  def bust?(score)
    score > 21
  end

  def low_funds_message
    "You don't have enough funds to make that bet."
  end
end
