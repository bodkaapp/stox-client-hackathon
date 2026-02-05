import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../config/app_colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/repositories/drift_user_settings_repository.dart';

class MyAreaSettingScreen extends ConsumerStatefulWidget {
  const MyAreaSettingScreen({super.key});

  @override
  ConsumerState<MyAreaSettingScreen> createState() => _MyAreaSettingScreenState();
}

class _MyAreaSettingScreenState extends ConsumerState<MyAreaSettingScreen> {
  // GoogleMapController? _controller;
  
  // Default to Tokyo Station for initial position
  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(35.681236, 139.767125),
    zoom: 14.4746,
  );

  CameraPosition _currentPosition = _kInitialPosition;
  final Color _mapBlue = const Color(0xFF3B82F6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            // 1. Google Map
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kInitialPosition,
              myLocationEnabled: false, // Requires permission, implement later if needed
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                // _controller = controller;
              },
              onCameraMove: (CameraPosition position) {
                _currentPosition = position;
              },
            ),

            // 2. Center Pin
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _mapBlue,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.location_on, color: Colors.white, size: 28),
                  ),
                  Container(
                    width: 4,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _mapBlue,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 2),
                      ],
                    ),
                  ),
                  // Offset to center the pin visually
                  const SizedBox(height: 44), 
                ],
              ),
            ),

            // 3. Header & Search
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     Container(
                      color: Colors.white.withValues(alpha: 0.9),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => context.pop(),
                            icon: const Icon(Icons.arrow_back_ios_new, size: 24),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.titleChangeMyArea, // マイエリアの変更
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.stoxText,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 48), // Balance for back button
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                          ],
                        ),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.searchByZipCode, // 郵便番号で探す
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 4. Near Me Button
            Positioned(
              bottom: 100,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  // Implement current location logic
                },
               backgroundColor: Colors.white,
               foregroundColor: _mapBlue,
               elevation: 4,
               shape: const CircleBorder(),
               child: const Icon(Icons.near_me),
              ),
            ),

            // 5. Example Pins (Decorations from HTML) omitted

            // 6. Floating Action Button "My Area Here"
            Positioned(
              bottom: 32,
              left: 24,
              right: 24,
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    final repo = await ref.read(userSettingsRepositoryProvider.future);
                    final current = await repo.get();
                    await repo.save(current.copyWith(
                      myAreaLat: _currentPosition.target.latitude,
                      myAreaLng: _currentPosition.target.longitude,
                    ));
                    if (context.mounted) {
                       context.pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _mapBlue,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.setMyAreaHere, // マイエリアをここにする
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
