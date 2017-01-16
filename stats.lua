#!/usr/bin/env lua

local GameState = require "game.game_state"
local random_agent = require "game.random_agent"
local minimax_agent = require "game.minimax_agent"
local montecarlo_agent = require "game.montecarlo_agent"

local agents_by_name = {
  Random = random_agent,
  MiniMax = minimax_agent,
  MonteCarlo = montecarlo_agent
}
local evaluated_agents = { "Random", "MiniMax", "MonteCarlo" }
local budgets = { 50, 200, 1000 }

local function play_game(rows, columns, move_budget, agent_white, agent_black)
  local agents = { agent_white, agent_black }
  local state = GameState.new(rows, columns)

  local winner
  while true do
    winner = GameState.get_winner(state)
    if winner then break end

    local move = agents[state.current_player](state, move_budget)
    if not move then break end

    state = GameState.apply_move(state, move)
  end

  return winner
end

local function compare_agents(move_budget, agent_white_name, agent_black_name)
  local white_wins = 0
  local black_wins = 0

  local agent_white = agents_by_name[agent_white_name]
  local agent_black = agents_by_name[agent_black_name]

  print(agent_white_name .. " vs. " .. agent_black_name .. " on board sizes from 3x3 to 15x15 with " .. move_budget .. " moves:")

  for rows = 3, 15 do
    local s = ""
    for columns = 3, 15 do
      local result = play_game(rows, columns, move_budget, agent_white, agent_black)
      local c
      if result == 1 then
        c = "W"
        white_wins = white_wins + 1
      elseif result == 2 then
        c = "B"
        black_wins = black_wins + 1
      elseif result == 3 then
        c = "D"
      else
        c = "X"
      end
      s = s .. c
    end
    print(s)
  end

  print("White Win Ratio: " .. 100 * white_wins / (white_wins + black_wins) .. "%")
  print("Black Win Ratio: " .. 100 * black_wins / (white_wins + black_wins) .. "%")
  print("")
end

for i, move_budget in ipairs(budgets) do
  for j, agent_white_name in ipairs(evaluated_agents) do
    for k, agent_black_name in ipairs(evaluated_agents) do
      compare_agents(move_budget, agent_white_name, agent_black_name)
    end
  end
end
