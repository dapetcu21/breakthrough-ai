local GameState = require "game.game_state"

math.randomseed(os.time())

local function random_agent(state)
  local moves = GameState.get_moves(state)
  local nmoves = #moves
  if nmoves > 0 then
    return moves[math.random(nmoves)], 0
  end
  return nil
end

return random_agent