import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/player_service.dart';
import '../services/game_service.dart';
import '../models/player.dart';
import '../models/game.dart';
import '../utils/snackbar_helper.dart';

/// Screen for adding players to a game
class AddPlayersToGameScreen extends StatefulWidget {
  final Game game;

  const AddPlayersToGameScreen({super.key, required this.game});

  @override
  State<AddPlayersToGameScreen> createState() => _AddPlayersToGameScreenState();
}

class _AddPlayersToGameScreenState extends State<AddPlayersToGameScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _togglePlayer(Player player) {
    final gameService = Provider.of<GameService>(context, listen: false);
    final isInGame = widget.game.playerIds.contains(player.id);

    if (isInGame) {
      final success = gameService.removePlayerFromGame(
        widget.game.id,
        player.id,
      );
      if (mounted) {
        if (success) {
          SnackBarHelper.showSuccess(context, '${player.nickname} removed');
        } else {
          SnackBarHelper.showError(context, 'Failed to remove player');
        }
      }
    } else {
      final success = gameService.addPlayerToGame(widget.game.id, player.id);
      if (mounted) {
        if (success) {
          SnackBarHelper.showSuccess(context, '${player.nickname} added');
        } else {
          SnackBarHelper.showError(context, 'Failed to add player');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Players')),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search players...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
          ),

          // Players List
          Expanded(
            child: Consumer2<PlayerService, GameService>(
              builder: (context, playerService, gameService, child) {
                final players = playerService.searchPlayers(_searchQuery);

                // Get updated game data
                final currentGame = gameService.games.firstWhere(
                  (g) => g.id == widget.game.id,
                  orElse: () => widget.game,
                );

                if (players.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No players available'
                              : 'No players found',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.5),
                              ),
                        ),
                        if (_searchQuery.isEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Add players from the Players tab first',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.4),
                                ),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final player = players[index];
                    final isInGame = currentGame.playerIds.contains(player.id);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isInGame
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                          child: Text(
                            player.nickname.substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              color: isInGame
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          player.nickname,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              player.fullName,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              player.skillLevelRange,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.6),
                                  ),
                            ),
                          ],
                        ),
                        trailing: isInGame
                            ? IconButton(
                                icon: Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () => _togglePlayer(player),
                              )
                            : IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => _togglePlayer(player),
                              ),
                        onTap: () => _togglePlayer(player),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Bottom info
          Consumer<GameService>(
            builder: (context, gameService, child) {
              final currentGame = gameService.games.firstWhere(
                (g) => g.id == widget.game.id,
                orElse: () => widget.game,
              );

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${currentGame.playerIds.length} players in game',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (currentGame.divideCourtEqually &&
                        currentGame.playerIds.isNotEmpty)
                      Text(
                        '₱${currentGame.courtCostPerPlayer.toStringAsFixed(2)} / player',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
