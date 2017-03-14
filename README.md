# [blackjack](http://blackwright-blackjack.herokuapp.com)

A simple implementation of the card game using Ruby and Sinatra. [Play it here.](http://blackwright-blackjack.herokuapp.com)

### Gameplay Details

- Start a round by entering your bet. Players start with $1000.
- The player must get as close to 21 as possible without going over (bust).

![Placing your bet](https://github.com/blackwright/blackjack/blob/master/screenshots/blackjack1.jpg?raw=true)

- Choose to hit or stand - hit deals the player another card, while stand deals to the dealer and ends the round.

![Hitting](https://github.com/blackwright/blackjack/blob/master/screenshots/blackjack2.jpg?raw=true)

![Standing](https://github.com/blackwright/blackjack/blob/master/screenshots/blackjack3.jpg?raw=true)

- The player who finishes with the greater score, and without busting, wins.
- Winning returns double the bet amount.

![Winning](https://github.com/blackwright/blackjack/blob/master/screenshots/blackjack4.jpg?raw=true)

- A 21 is a blackjack and that player wins unless the opponent also has one.
- A tie (push) returns the bet to the player.
- Busting means that the bet is lost.

![Busting](https://github.com/blackwright/blackjack/blob/master/screenshots/blackjack5.jpg?raw=true)

![Bankrupt](https://github.com/blackwright/blackjack/blob/master/screenshots/blackjack6.jpg?raw=true)

- A new game must be started if the player runs out of money.

### Technical Notes

- A "real" deck of 52 cards is generated and shuffled with each game.
- A new deck is swapped in when the dealer has less than 20 cards.
- Cards are dynamically generated from the back-end and rendered with CSS.
- Card styling source: [http://www.brainjar.com/css/cards](http://www.brainjar.com/css/cards)
- Each card is rendered as a partial. The suit and CSS class are replaced via string substitution.
- Game uses in-browser sessions to track variables and progress.
- Checks in place to prevent changing or repeating the game outcome.
