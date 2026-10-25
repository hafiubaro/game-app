import 'package:flutter/material.dart';

import '../model/game.dart';
import '../viewmodel/fetchgame.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Game>> _gameList;
  String _keyword = '';

  @override
  void initState() {
    super.initState();
    _gameList = fetchGames();
  }

  void _reload() {
    setState(() {
      _gameList = fetchGames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Game Store',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amberAccent.shade400,
        actions: [
          IconButton(
            onPressed: _reload,
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
          child: Column(
            children: [
              _searchBar(),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder<List<Game>>(
                  future: _gameList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.wifi_off,
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Gagal memuat game.\n${snapshot.error}',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: _reload,
                                child: const Text('Coba lagi'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final games = snapshot.data ?? <Game>[];

                    if (games.isEmpty) {
                      return const Center(
                        child: Text('Tidak ada data game.'),
                      );
                    }

                    final filteredGames = games.where((game) {
                      return game.title.toLowerCase().contains(_keyword) ||
                          game.genre.toLowerCase().contains(_keyword);
                    }).toList();

                    if (filteredGames.isEmpty) {
                      return const Center(
                        child: Text('Game tidak ditemukan.'),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: filteredGames.length,
                      itemBuilder: (context, index) {
                        return _listItem(filteredGames[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return TextField(
      cursorColor: Colors.blue,
      onChanged: (value) {
        setState(() {
          _keyword = value.trim().toLowerCase();
        });
      },
      decoration: InputDecoration(
        hintText: 'Cari judul atau genre game',
        filled: true,
        fillColor: Colors.blue.shade50,
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.blue,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _listItem(Game game) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/detail',
            arguments: game.id,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                game.thumbnail,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const ColoredBox(
                    color: Color(0xFFE0E0E0),
                    child: Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 48,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${game.genre} • ${game.platform}',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    game.shortDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}