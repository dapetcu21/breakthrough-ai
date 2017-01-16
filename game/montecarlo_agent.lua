local GameState = require "game.game_state"
local random_agent = require "game.random_agent"

local function shuffle(t)
  local n = #t
  while n > 2 do
    local k = math.random(n)
    t[n], t[k] = t[k], t[n]
    n = n - 1
  end
  return t
end

local function montecarlo_discover(node)
  if node.discovered then return end
  node.discovered = true
  local state = node.state
  local winner = GameState.get_winner(state)
  if winner then
    node.winner = winner
    return
  end
  local moves = shuffle(GameState.get_moves(state))
  node.moves = moves
  node.move_count = #moves
end

local function montecarlo_select(node)
  while true do
    montecarlo_discover(node)

    if node.winner then
      return node
    end

    if node.move_count ~= node.child_count then
      return node
    end

    local best_child
    local best_confidence_bound = -1
    for i, child in ipairs(node.children) do
      local confidence_bound = child.score / child.playouts + math.sqrt(2 * math.log(node.playouts) / child.playouts)
      if confidence_bound > best_confidence_bound then
        best_child, best_confidence_bound = child, confidence_bound
      end
    end

    if not best_child then
      return node
    end

    node = best_child
  end
end

local function montecarlo_expand(node)
  if node.winner or node.move_count == 0 then
    return node, 0
  end

  local child_count = node.child_count + 1
  node.child_count = child_count
  local move = node.moves[child_count]
  local state = GameState.apply_move(node.state, move)

  local child = {
    state = state,
    parent = node,
    children = {},
    child_count = 0,
    score = 0,
    playouts = 0
  }

  node.children[child_count] = child
  return child, 1
end

local function montecarlo_playout(node, move_budget, current_player)
  local moves_used = 0
  local winner = node.winner
  local state = node.state

  while moves_used < move_budget and not winner do
    local next_move, moves_used_agent = random_agent(state, move_budget)

    -- No moves available means draw
    if not next_move then
      return 0.5, moves_used
    end

    state = GameState.apply_move(state, next_move)
    winner = GameState.get_winner(state)
    moves_used = moves_used + moves_used_agent + 1
  end

  -- Playout interrupted by move budget
  if not winner then
    return 0.5, moves_used, true
  end

  local score = winner == 0 and 0.5 or (winner == current_player and 1 or 0)
  return score, moves_used
end

local function montecarlo_agent(state, move_budget)
  local moves_used = 0

  local root = {
    state = state,
    children = {},
    child_count = 0,
    score = 0,
    playouts = 0
  }

  montecarlo_discover(root)

  while move_budget > moves_used do
    local node, moves_used_expand = montecarlo_expand(montecarlo_select(root))
    local playout_budget = move_budget - moves_used - moves_used_expand
    local score, moves_used_playout, interrupted = montecarlo_playout(node, playout_budget, state.current_player)

    -- We ignore the last playout if it was interrupted by the move budget
    if interrupted then
      break
    end

    -- We use up a minimum of one move even for zero-cost playouts to avoid
    -- a self-enforcing loop where we only select terminal nodes
    moves_used = moves_used + math.max(1, moves_used_expand + moves_used_playout)
    while node do
      node.playouts = node.playouts + 1
      node.score = node.score + score
      node = node.parent
    end
  end

  local best_move
  local best_win_rate = -1
  for i, child in ipairs(root.children) do
    local win_rate = child.score / child.playouts
    if win_rate > best_win_rate then
      best_move, best_win_rate = root.moves[i], win_rate
    end
  end

  -- If move budget wasn't even enough for one playout, we just return something random
  if not best_move then
    return random_agent(state)
  end

  return best_move, moves_used
end

return montecarlo_agent