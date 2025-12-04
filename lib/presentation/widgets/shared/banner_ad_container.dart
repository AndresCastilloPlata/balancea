import 'package:balancea/config/helpers/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdContainer extends StatefulWidget {
  const BannerAdContainer({super.key});

  @override
  State<BannerAdContainer> createState() => _BannerAdContainerState();
}

class _BannerAdContainerState extends State<BannerAdContainer> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  // Configuracion del banner
  void _loadAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner, // Tamaño estándar (320x50)
      adUnitId: AdHelper.homeBannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Fallo al cargar el banner: ${error.message}');
          ad.dispose(); // Liberar memoria
          setState(() {
            _isLoaded = false;
          });
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // si no ha cargado, no se muestra
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    // Si cargo, mostramos
    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
