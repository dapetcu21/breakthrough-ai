local GameState = require "game.game_state"

math.randomseed(os.time())

local function alphabeta(state, depth, alpha, beta, get_moves, apply_move)
  local winner = GameState.get_winner(state)
  if depth == 0 or winner then
    if winner then
      if winner == state.current_player then
        return math.huge
      else
        return -math.huge
      end
    end
    return GameState.evaluate_state(state)
  end

  local moves = get_moves(state)
  local best_move
  local value = -math.huge

  for i, move in ipairs(moves) do
    local child = apply_move(state, move)
    if not child then -- We ran out of applications
      return nil
    end

    local child_value = -alphabeta(child, depth - 1, -beta, -alpha, get_moves, apply_move)
    if not child_value then -- The recursive call ran out of applications
      return nil
    end

    if child_value > value then
      value = child_value
      best_move = move
    end

    alpha = math.max(alpha, value)
    if beta <= alpha then
      break
    end
  end

  return value, best_move
end

local function minimax_agent(root_state, move_budget)
  local moves_used = 0
  local application_cache = {}
  local move_cache = {}

  local function get_moves(state)
    local cached_moves = move_cache[state]
    if cached_moves then
      return cached_moves
    end
    local moves = GameState.get_moves(state)
    move_cache[state] = moves
    return moves
  end

  local function apply_move(state, move)
    local cached_moves = application_cache[state]
    local cached_state
    if cached_moves then
      cached_state = cached_moves[move]
    end
    if cached_state then
      return cached_state
    end

    if moves_used >= move_budget then
      return nil
    end

    move_budget = move_budget - 1

    if not cached_moves then
      cached_moves = {}
      application_cache[state] = cached_moves
    end
    cached_state = GameState.apply_move(state, move)
    cached_moves[move] = cached_state

    return cached_state
  end

  local moves = get_moves(root_state)
  local result = moves[math.random(#moves)]

  for depth = 1, 100 do
    local prev_moves_used = moves_used
    local value, best_move = alphabeta(root_state, depth, -math.huge, math.huge, get_moves, apply_move)
    if not best_move then break end
    result = best_move

    if moves_used == prev_moves_used then
      break -- If we haven't used any more moves this means that the last pass of minimax saturated the whole graph, so it's safe to break now
    end
  end

  return result, moves_used
end

return minimax_agent