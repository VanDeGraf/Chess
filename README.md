# Chess

## Command line Chess game. 
Game rules: [Wikipedia](https://en.wikipedia.org/wiki/Chess)  
This project is part of [The Odin Project Curriculum](https://www.theodinproject.com/paths/full-stack-ruby-on-rails/courses/ruby-programming/lessons/ruby-final-project)

### Implemented features:
* Figures movement, include special: 
  [castling](https://en.wikipedia.org/wiki/Castling), 
  [en passant](https://en.wikipedia.org/wiki/En_passant), 
  [promotion](https://en.wikipedia.org/wiki/Promotion_(chess))
* Game states:
    * Win\Lose: 
      [Checkmate](https://en.wikipedia.org/wiki/Checkmate),
      [Resignation](https://en.wikipedia.org/wiki/Rules_of_chess#Resigning)
    * Draw:
      [Draw by agreement](https://en.wikipedia.org/wiki/Draw_by_agreement),
      [Stalemate](https://en.wikipedia.org/wiki/Stalemate),
      incomplete [Dead position](https://en.wikipedia.org/wiki/Rules_of_chess#Dead_position),
      [Seventy-five move](https://en.wikipedia.org/wiki/Fifty-move_rule#Seventy-five-move_rule),
      [Fivefold repetition](https://en.wikipedia.org/wiki/Threefold_repetition)
    * [Check](https://en.wikipedia.org/wiki/Check_(chess))
* Save\Load game to file
* Turns history shown
* Simple Computer AI
* Export\Import [PGN](https://ru.wikipedia.org/wiki/Portable_Game_Notation) game saves
### Not implemented features yet:
* Game states:      
    * Draw:
      Ask about [Threefold repetition](https://en.wikipedia.org/wiki/Threefold_repetition),
      Ask about [Fifty-move rule](https://en.wikipedia.org/wiki/Fifty-move_rule),      
      
* Game with time control