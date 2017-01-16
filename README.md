# Breakthrough AI Testbench

This project implements a [Breakthrough] game in [Defold] with support for
human and autonomous agents.

This was written as an Uni assignment for my AI class.

The following agents are implemented:
  * A random agent
  * MiniMax with Alpha-Beta pruning
  * Monte Carlo Tree Search with UCB1 selection

All the agents are limited within the same move application budget, for the
sake of comparison.

The board state is modeled in `game/game_state.lua`. Move applications done
with `GameState.apply_move()` return a new state and don't modify the old one,
so you can safely consider board states immutable.

[Breakthrough]: https://en.wikipedia.org/wiki/Breakthrough_(board_game)
[Defold]: https://defold.com

## Analysis

A simple statistics runner is implemented in `stats.lua`. I recommend running it
in [LuaJIT], as it takes a while to run.

[LuaJIT]: http://luajit.org

Looking through the data, we notice a few interesting facts:

* MonteCarlo runs pretty quickly out of moves on larger boards up to the point
  where it can't even run one single playout to the end, effectively being
  comparable with the random agent.

* With the same move budget, MiniMax seems to be more efficient than MonteCarlo.
  I assume this is because multiple playouts are expensive.

* MonteCarlo seems to have an edge over MiniMax on very small board sizes, where
  games end quickly and playouts become more feasible.

The output of `stats.lua` follows:

```
Random vs. Random on board sizes from 3x3 to 15x15 with 50 moves:
WWBBWBBWWWWBW
BWBWWBBBWBWWW
WWWBWWWBWWBBW
WWWBWBBWWBWBB
WBWWWBBBBWBBW
WBWWBBWWWBWWW
WWBBWWWBWBWBW
WWWBWWBBBWWBB
BWWBWBBWWWBBW
WBWBBBBWBWWBW
WBBBWWWWWBBBW
BWBWWBBWBWBWB
WWBWBWWWBBWWW
White Win Ratio: 56.804733727811%
Black Win Ratio: 43.195266272189%

Random vs. MiniMax on board sizes from 3x3 to 15x15 with 50 moves:
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
White Win Ratio: 0%
Black Win Ratio: 100%

Random vs. MonteCarlo on board sizes from 3x3 to 15x15 with 50 moves:
BBBBBBBWBBBBW
WWBBBWBBBBBBW
BBWWBWBBBWBBW
BBBBBBBBBWBBB
BBBBWBBWBBBBB
BBWBBBBWBWBBB
BWWWBBBBBBBBB
BBBWBBWBBBBBB
WBBWBWWBWBWBW
BWWWBBWBWWWBB
BBBWBBBWBWBBB
WWBBWBBBWBBBW
BBBWBBBWBBWBW
White Win Ratio: 28.402366863905%
Black Win Ratio: 71.597633136095%

MiniMax vs. Random on board sizes from 3x3 to 15x15 with 50 moves:
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
White Win Ratio: 100%
Black Win Ratio: 0%

MiniMax vs. MiniMax on board sizes from 3x3 to 15x15 with 50 moves:
WWWWWWWWWWWWW
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BWWWWWWWWWWWW
BBBWBBWBBBBBB
BWWWWWWWWWWWW
BBBBBBBBBBBBB
BWWWWWWWWWWWW
BBBBBBBBBBBBB
BWWWWWWWWWWWW
BBBBBBBBBBBBB
White Win Ratio: 37.278106508876%
Black Win Ratio: 62.721893491124%

MiniMax vs. MonteCarlo on board sizes from 3x3 to 15x15 with 50 moves:
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
BWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
White Win Ratio: 99.408284023669%
Black Win Ratio: 0.59171597633136%

MonteCarlo vs. Random on board sizes from 3x3 to 15x15 with 50 moves:
WWWWWWWWWWWBW
WWWWBWBBWWBBW
BBWBWBWWWWWWB
WWWWWWWBWBWWW
WWBWWWWWWWBWB
WWWWBWWBBBWBW
WWWWWWWWWWWBB
WWWBBWWWWBWBW
WWWBWWWWBWWBB
BWBWWBBWWBWWW
WBWBBWWBBWWBW
WWBWWBBWWBWWB
WWWWBBWWWBWWW
White Win Ratio: 70.414201183432%
Black Win Ratio: 29.585798816568%

MonteCarlo vs. MiniMax on board sizes from 3x3 to 15x15 with 50 moves:
WBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
White Win Ratio: 0.59171597633136%
Black Win Ratio: 99.408284023669%

MonteCarlo vs. MonteCarlo on board sizes from 3x3 to 15x15 with 50 moves:
WWWBWWWBBBBWW
WWWWWWBWWBBWB
BWWWWBWWWBWBW
WBWBBWBBBBWBB
WBWWBBWWBWBWB
WWWBWWBBWBBBW
BWWWBWBBBWBBW
WBBWBWWWBBWBW
WWWBWBWWBWWBW
BWBBWBWWBWBBB
WWWBBWBWBWWWW
BWWBWBWBWBBBB
BBBWBBBBBWWBB
White Win Ratio: 52.07100591716%
Black Win Ratio: 47.92899408284%

Random vs. Random on board sizes from 3x3 to 15x15 with 200 moves:
WWBWWWWBWBWWB
BWWBBWBWWBBWW
WWWBWBWBBWBBW
WWBBWWWBBBWBB
BBWWBBBBBWBWB
WWWBBWBWBWBBB
WWWBBWBWWBWWW
WBBWWBWWBWWBB
BBWWBBWWWWWBW
BWBBWBBWWWBWB
BWWBWWBWWBWBW
BWBWBWWWBWWBW
WBWBWBBWBWBBB
White Win Ratio: 53.254437869822%
Black Win Ratio: 46.745562130178%

Random vs. MiniMax on board sizes from 3x3 to 15x15 with 200 moves:
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
White Win Ratio: 0%
Black Win Ratio: 100%

Random vs. MonteCarlo on board sizes from 3x3 to 15x15 with 200 moves:
BBBBBBBBBBWBB
BBBBWBBBWBBBW
BBWWBBBBWBBBB
BBBBWBBBWBBBB
BBBWBBBBBWBWB
BBBBBWBBBBBWB
BBBBBBBBBBWBB
BBBBBWBBBBBWW
BBBWBBBBBBBBB
BWBBWBBBBWWBW
BBBWBBBBBBWWB
WBBBBBBBBWBBW
BBBBBBWBBBBBW
White Win Ratio: 18.934911242604%
Black Win Ratio: 81.065088757396%

MiniMax vs. Random on board sizes from 3x3 to 15x15 with 200 moves:
WWWWWWWWWWWWW
BWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
White Win Ratio: 99.408284023669%
Black Win Ratio: 0.59171597633136%

MiniMax vs. MiniMax on board sizes from 3x3 to 15x15 with 200 moves:
WWWWWWWWWWWWW
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BWWWWWWWWWWWW
BBBWBBWBBBBBB
BWWWWWWWWWWWW
BBBBBBBBBBBBB
BWWWWWWWWWWWW
BBBBBBBBBBBBB
BWWWWWWWWWWWW
BBBBBBBBBBBBB
White Win Ratio: 37.278106508876%
Black Win Ratio: 62.721893491124%

MiniMax vs. MonteCarlo on board sizes from 3x3 to 15x15 with 200 moves:
WWWWWWWWWWWWW
BBWWWWWWWWWWW
BWWWWWWWWWWWW
WWWWWWWWWWWWW
BWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
BWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
White Win Ratio: 97.041420118343%
Black Win Ratio: 2.9585798816568%

MonteCarlo vs. Random on board sizes from 3x3 to 15x15 with 200 moves:
WWWWWWWWWWWWW
WWWWWWBWWWWWW
WWWWWWWBWWBWW
WWWWBWWWBWWBW
WWWWWWWWBBWWW
WBWWWWWWWWBWW
WWWWWBWBWWWWW
WWWWBWWWWWWBW
BWWWBWWBWWWWB
WWWBWWWWBBWBW
WWWWWWBWWBWWB
WWWWWWBWBBWWB
WBWBWBWWWWBWW
White Win Ratio: 80.473372781065%
Black Win Ratio: 19.526627218935%

MonteCarlo vs. MiniMax on board sizes from 3x3 to 15x15 with 200 moves:
WBBBBBBBBBBBB
BWBBBBBBBBBBB
WBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
White Win Ratio: 1.7751479289941%
Black Win Ratio: 98.224852071006%

MonteCarlo vs. MonteCarlo on board sizes from 3x3 to 15x15 with 200 moves:
WBWWBBWWWBBWW
WBWWWBBWBWBWB
BWBBWBWBBBWBB
BWWWWWWBBBWWB
WWWBWBWBBWBWB
BBBBWBBBBBWWB
BBBWBWBWWWWBB
BWBWWWWBWWBWW
WBBBWWBBBBWBB
BWWBWBBBWWBBB
BBWWBWBWWWBBB
BBBWWWBBBBBWB
WWWBWWBBWBBBB
White Win Ratio: 45.562130177515%
Black Win Ratio: 54.437869822485%

Random vs. Random on board sizes from 3x3 to 15x15 with 1000 moves:
WBWBBWBBWWBWW
WBWWWWBWWBBWW
WBWWWBBWBBWBW
BWWBBBBBWBWBW
WWWWWBBWWBBWB
BWWWBWWWWWBWW
WWWWBBWWWBWWB
WWBBBWBWBWBBB
WWBBWBWBWBBWB
BWBBWWWBWWBWB
BWBBBBWBBWWBB
BBBWWBBWBWBWW
BBBWBWWBBWWBB
White Win Ratio: 52.07100591716%
Black Win Ratio: 47.92899408284%

Random vs. MiniMax on board sizes from 3x3 to 15x15 with 1000 moves:
BBBBBBBBBBBBB
WBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
White Win Ratio: 0.59171597633136%
Black Win Ratio: 99.408284023669%

Random vs. MonteCarlo on board sizes from 3x3 to 15x15 with 1000 moves:
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBW
BBBBBBBBBBBBB
BBBBBBBBBWBBB
BWBBBBWBBBBBB
BBBBWBWBBBBBB
BBBBBBBBBBBBB
BBBBWBBBBBBBW
BBWBBBBBBBBWB
BBBBBWBBWBBBW
BBBBBBBBBWWBB
White Win Ratio: 8.8757396449704%
Black Win Ratio: 91.12426035503%

MiniMax vs. Random on board sizes from 3x3 to 15x15 with 1000 moves:
WWWWWWWWWWWWW
BWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
White Win Ratio: 99.408284023669%
Black Win Ratio: 0.59171597633136%

MiniMax vs. MiniMax on board sizes from 3x3 to 15x15 with 1000 moves:
WWWWWWWWWWWWW
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BWWWWWWWWWWWW
BBBWBBWBBBBBB
BWWWWWWWWWWWW
BBBBBBBBBBBBB
BWWWWWWWWWWWW
BBBBBBBBBBBBB
BWWWWWWWWWWWW
BBBBBBBBBBBBB
White Win Ratio: 37.278106508876%
Black Win Ratio: 62.721893491124%

MiniMax vs. MonteCarlo on board sizes from 3x3 to 15x15 with 1000 moves:
WWWWWWWWWWWWW
BBBWWWWWWWWWW
BWBWWWWWWWWWW
WWWWWWWWWWWWW
WBWWWWWWWWWWW
WWWWWWWWWWWWW
BBWWWWWWWWWWW
BWWWWWWWWWWWW
BWWWWWWWWWWWW
WXWWWWWWWWWWW
WWWWWWWWWWWWW
WBWWWWWWWWWWW
WWWWWWWWWWWWW
White Win Ratio: 93.452380952381%
Black Win Ratio: 6.547619047619%

MonteCarlo vs. Random on board sizes from 3x3 to 15x15 with 1000 moves:
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWBWWBWWB
WWWWWWWWBWBBW
WBWWBBWWWWWWW
WBWWWWWWWWWWW
WWWWWWWWWWWWW
WWWWWWWWWBBWW
WWBWWWWWBWBWW
White Win Ratio: 91.12426035503%
Black Win Ratio: 8.8757396449704%

MonteCarlo vs. MiniMax on board sizes from 3x3 to 15x15 with 1000 moves:
WWBBBBBBBBBBB
BWBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BXBBBBBBBBBBB
WBBBBBBBBBBBB
BBBBBBBBBBBBB
BXBBBBBBBBBBB
BBBBBBBBBBBBB
WBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
BBBBBBBBBBBBB
White Win Ratio: 2.9940119760479%
Black Win Ratio: 97.005988023952%

MonteCarlo vs. MonteCarlo on board sizes from 3x3 to 15x15 with 1000 moves:
WWBWWWWWWWWWW
WWBWWWWBBWWWB
WWWBWWBWWBWBB
WWBBWWWBBBBBW
BWWBBBWWBWBBW
BBBWWBBBWBWWB
BBWWWBWBBBBBW
BWBBWWWBWWBBW
BWWBBBBWBBWWW
BWBWBWWBWWWBB
BWBWWBWWWWWBW
WBBWBWBWBWWWW
WBBWWWWWWBWBW
White Win Ratio: 57.396449704142%
Black Win Ratio: 42.603550295858%
```