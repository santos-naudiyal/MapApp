import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapapp/data/services/store_services.dart';
import 'package:provider/provider.dart';
import '../state/store_provider.dart';
import '../../data/models/store_model.dart';

class StoreScreen extends StatefulWidget {
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final MapController _mapController = MapController();
  final StoreService _storeService = StoreService();

  @override
  void initState() {
    super.initState();
    _fetchStores();
  }

  Future<void> _fetchStores() async {
    try {
      final stores = await _storeService.fetchStores();
      Provider.of<StoreProvider>(context, listen: false).setStores(stores);
    } catch (e) {
      print('Error fetching stores: $e');
    }
  }

  void _centerMap(StoreModel store) {
    _mapController.move(LatLng(store.latitude, store.longitude), 15);
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    final selectedStore = storeProvider.selectedStore;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stores',
          style: TextStyle(
              fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // Centers the title
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: const MapOptions(
                      initialCenter: LatLng(16.688653, 74.272591),
                      initialZoom: 13,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        userAgentPackageName: 'com.example.storesapp',
                      ),
                      MarkerLayer(
                        markers: storeProvider.stores.map((store) {
                          return Marker(
                            point: LatLng(store.latitude, store.longitude),
                            width: 40,
                            height: 40,
                            child: GestureDetector(
                              onTap: () {
                                storeProvider.selectStore(store);
                                _centerMap(store);
                              },
                              child: Icon(
                                Icons.location_pin,
                                color: storeProvider.selectedStore == store
                                    ? Colors.purple
                                    : Colors.blue,
                                size: 30,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
        
                  // Selected Store Details Card
                  if (selectedStore != null)
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedStore.storeLocation,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(selectedStore.storeAddress),
                              const SizedBox(height: 4),
                              Text(
                                '${selectedStore.distance.toStringAsFixed(2)} km Away',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Today, ${selectedStore.dayOfWeek} ${selectedStore.startTime} - ${selectedStore.endTime}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        
            // Store List Section
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: storeProvider.stores.length,
                itemBuilder: (context, index) {
                  final store = storeProvider.stores[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 6.0), // Add padding around the list items
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.amber),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          store.storeLocation,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(store.storeAddress),
                            const SizedBox(height: 4),
                            Text(
                              'Today, ${store.dayOfWeek} ${store.startTime} - ${store.endTime}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        trailing: Text(
                          '${store.distance.toStringAsFixed(2)} km',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          storeProvider.selectStore(store);
                          _centerMap(store);
                        },
                        selected: storeProvider.selectedStore == store,
                        selectedTileColor: Colors.orangeAccent.withOpacity(0.2),
                        leading: Icon(
                          Icons.store,
                          color: storeProvider.selectedStore == store
                              ? Colors.orange
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
