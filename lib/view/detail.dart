import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../model/detailgame.dart';
import '../viewmodel/fetchgame.dart';

class Detail extends StatefulWidget {
  final int gameTerpilih;

  const Detail({
    super.key,
    required this.gameTerpilih,
  });

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late Future<DetailGame> _detailGame;

  @override
  void initState() {
    super.initState();
    _detailGame = fetchDetailGame(widget.gameTerpilih);
  }

  @override
  void didUpdateWidget(covariant Detail oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.gameTerpilih != widget.gameTerpilih) {
      _detailGame = fetchDetailGame(widget.gameTerpilih);
    }
  }

  void _reload() {
    setState(() {
      _detailGame = fetchDetailGame(widget.gameTerpilih);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Game'),
        backgroundColor: Colors.amberAccent.shade400,
      ),
      body: SafeArea(
        child: FutureBuilder<DetailGame>(
          future: _detailGame,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        'Gagal memuat detail.\n${snapshot.error}',
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

            final game = snapshot.data;

            if (game == null) {
              return const Center(
                child: Text('Data tidak tersedia.'),
              );
            }

            final requirements = game.minimumSystemRequirements;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(25),
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: _networkImage(game.thumbnail),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            Chip(label: Text(game.genre)),
                            Chip(label: Text(game.platform)),
                            Chip(label: Text(game.status)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _section(
                          title: 'Informasi Game',
                          child: Column(
                            children: [
                              _requirementRow(
                                'Publisher',
                                game.publisher,
                              ),
                              _requirementRow(
                                'Developer',
                                game.developer,
                              ),
                              _requirementRow(
                                'Tanggal rilis',
                                game.releaseDate,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _section(
                          title: 'Minimum System Requirements',
                          child: requirements == null
                              ? const Text(
                            'Spesifikasi minimum tidak disediakan '
                                'untuk game ini.',
                          )
                              : Column(
                            children: [
                              _requirementRow(
                                'OS',
                                requirements.os,
                              ),
                              _requirementRow(
                                'Processor',
                                requirements.processor,
                              ),
                              _requirementRow(
                                'Memory',
                                requirements.memory,
                              ),
                              _requirementRow(
                                'Graphics',
                                requirements.graphics,
                              ),
                              _requirementRow(
                                'Storage',
                                requirements.storage,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Screenshot',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (game.screenshots.isEmpty)
                          const Text('Screenshot tidak tersedia.')
                        else
                          SizedBox(
                            height: 180,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: game.screenshots.length,
                              separatorBuilder: (context, index) {
                                return const SizedBox(width: 12);
                              },
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 280,
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(15),
                                    child: _networkImage(
                                      game.screenshots[index].image,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 20),
                        _section(
                          title: 'Deskripsi',
                          child: game.description.trim().isEmpty
                              ? const Text('Deskripsi tidak tersedia.')
                              : ReadMoreText(
                            game.description,
                            trimLines: 4,
                            trimMode: TrimMode.Line,
                            trimCollapsedText:
                            ' Baca selengkapnya',
                            trimExpandedText: ' Tampilkan sedikit',
                            colorClickableText: Colors.blue,
                            style: const TextStyle(
                              height: 1.5,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Data game: FreeToGame',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _section({
  required String title,
  required Widget child,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    ),
  );
}

Widget _requirementRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(':'),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value.trim().isEmpty ? 'Tidak tersedia' : value,
          ),
        ),
      ],
    ),
  );
}

Widget _networkImage(String url) {
  return Image.network(
    url,
    width: double.infinity,
    height: double.infinity,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return const ColoredBox(
        color: Color(0xFFE0E0E0),
        child: Center(
          child: Icon(
            Icons.broken_image_outlined,
            size: 48,
            color: Colors.grey,
          ),
        ),
      );
    },
  );
}