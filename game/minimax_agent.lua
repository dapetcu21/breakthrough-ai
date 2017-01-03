local GameState = require "game.game_state"

math.randomseed(os.time())

local function minimax_agent(state)
  local moves = GameState.get_moves(state)
  return moves[math.random(#moves)]
end

return minimax_agent