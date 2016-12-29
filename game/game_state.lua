local GameState = {}

function GameState.new(rows, columns)
  local pieces = {}
  local piece_count = 0

  if rows >= 6 then
    for column = 1, columns do
      pieces[piece_count + 1] = { owner = 1, row = 1, column = column }
      pieces[piece_count + 2] = { owner = 1, row = 2, column = column }
      pieces[piece_count + 3] = { owner = 2, row = rows - 1, column = column }
      pieces[piece_count + 4] = { owner = 2, row = rows, column = column }
      piece_count = piece_count + 4
    end
  elseif rows >= 2 then
    for column = 1, columns do
      pieces[piece_count + 1] = { owner = 1, row = 1, column = column }
      pieces[piece_count + 2] = { owner = 2, row = rows, column = column }
      piece_count = piece_count + 2
    end
  end

  return {
    rows = rows,
    columns = columns,
    current_player = 1,
    pieces = pieces,
    captured_count = { 0, 0 }
  }
end

function GameState.get_piece_at(state, row, column)
  for i, piece in ipairs(state.pieces) do
    if piece.row == row and piece.column == column then
      return i
    end
  end
  return nil
end

function GameState.get_moves(state)
  local current_player = state.current_player
  local direction = current_player == 1 and 1 or -1
  local rows = state.rows
  local columns = state.columns
  local moves = {}
  local move_count = 0

  for i, piece in ipairs(state.pieces) do
    if piece.owner == current_player then
      local row = piece.row + direction
      if row <= rows and row >= 1 then
        local column = piece.column
        if not GameState.get_piece_at(state, row, column) then
          move_count = move_count + 1
          moves[move_count] = { piece_id = i, row = row, column = column }
        end
        if column > 1 then
          local captured_piece_id = GameState.get_piece_at(state, row, column - 1)
          if not captured_piece_id or state.pieces[captured_piece_id].owner ~= current_player then
            move_count = move_count + 1
            moves[move_count] = { piece_id = i, row = row, column = column - 1, captured_piece_id = captured_piece_id }
          end
        end
        if column < columns then
          local captured_piece_id = GameState.get_piece_at(state, row, column + 1)
          if not captured_piece_id or state.pieces[captured_piece_id].owner ~= current_player then
            move_count = move_count + 1
            moves[move_count] = { piece_id = i, row = row, column = column + 1, captured_piece_id = captured_piece_id }
          end
        end
      end
    end
  end

  return moves
end

local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function GameState.apply_move(state, move)
  local new_state = deepcopy(state)
  local current_player = new_state.current_player
  new_state.current_player = 3 - current_player

  local moved_piece = new_state.pieces[move.piece_id]
  moved_piece.row = move.row
  moved_piece.column = move.column

  if move.captured_piece_id then
    new_state.captured_count[current_player] = new_state.captured_count[current_player] + 1
    table.remove(new_state.pieces, move.captured_piece_id)
  end

  return new_state
end

function GameState.get_winner(state)
  local rows = state.rows
  for i, piece in ipairs(state.pieces) do
    if piece.row == (piece.owner == 1 and rows or 1) then
      return piece.owner
    end
  end
  -- If there are no pieces left, we consider it a draw
  if not state.pieces[1] then
    return 0
  end
  return nil
end

return GameState