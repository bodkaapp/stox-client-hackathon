import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../config/app_colors.dart';

class FlyerViewerScreen extends StatelessWidget {
  final Map<String, dynamic> flyerData;

  const FlyerViewerScreen({
    super.key,
    required this.flyerData,
  });

  @override
  Widget build(BuildContext context) {
    // Determine colors based on design preference (Dark/Black background for viewer)
    const bgColor = Color(0xFF000000); // background-dark
    // const cardColor = Color(0xFF1C1C1E); // card-dark (unused currently but good for ref)
    const textColor = Colors.white;

    final storeName = flyerData['storeName'] ?? 'イオンスタイル';
    final storeBranch = flyerData['storeBranch'] ?? '野田阪神店';
    final storeLogo = flyerData['storeLogo'] ?? '';

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: bgColor,
                border: Border(bottom: BorderSide(color: Color(0xFF1F2937))), // gray-800
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_ios_new, color: textColor),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF1F2937), // gray-800
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.titleFlyer, // チラシ
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.share, color: textColor),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF1F2937),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
            ),

            // Store Info Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: bgColor,
              child: Column(
                children: [
                   Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFF374151)), // gray-700
                        ),
                        child: ClipOval(
                          child: Image.network(
                            storeLogo,
                            errorBuilder: (c, o, s) => const Icon(Icons.store, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              storeName,
                              style: const TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              storeBranch,
                              style: const TextStyle(
                                color: Color(0xFF9CA3AF), // gray-400
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.stoxPrimary),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.statusFollowing, // フォロー中
                          style: const TextStyle(
                            color: AppColors.stoxPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 32,
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColors.stoxPrimary,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content (Viewer)
            Expanded(
              child: Container(
                color: const Color(0xFF09090B), // zinc-950
                child: Center(
                  child: InteractiveViewer(
                     maxScale: 4.0,
                     child: Image.network(
                       'https://lh3.googleusercontent.com/aida-public/AB6AXuDt8QM6dABX8AxHUtGjEZwe1lQZ1qrP7eYdVv2Jr7yyEE-QHTiEwveldzZnAtgyCW3vOpNa3_PDFpNSEGo-m8zlRgPulqkOrsRuauMw5LNZAsFioYaCXc_G-C0EJsGyAX0zabMaqq9bQl4_9Crm-Vbtt-iD4NPTLkgOHVpKhT3XkwO49fZPfrVQ0gSCxnUouJ5T1T63_nUTSt_guC8ExJX-RdUu8FV4UbmdS7_rJRRpu8fooPrElQavYn-AngWIxRd3VFB9uspD_g-1',
                       fit: BoxFit.contain,
                       loadingBuilder: (context, child, loadingProgress) {
                         if (loadingProgress == null) return child;
                         return const Center(child: CircularProgressIndicator());
                       },
                       errorBuilder: (context, error, stackTrace) =>
                           const Icon(Icons.broken_image, color: Colors.white, size: 48),
                     ),
                  ),
                ),
              ),
            ),

            // Footer Info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFF18181B), // zinc-900 (footer bg)
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        const Text(
                          '第48週 1/23号', // Dates and numbers generally stay as is unless they have specific words
                          style: TextStyle(color: Color(0xFFA1A1AA), fontSize: 12), // zinc-400
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'イオンのガチ推し', // Store specific catchphrase, might not need strict localization if it's dynamic
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(AppLocalizations.of(context)!.shopDetails, style: const TextStyle(fontSize: 12)), // 店舗詳細
                        const Icon(Icons.chevron_right, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Thumbnails
            Container(
              height: 88,
              color: const Color(0xFF18181B), // zinc-900
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                children: [
                  _buildThumbnail('https://lh3.googleusercontent.com/aida-public/AB6AXuC1w4g2zlF3RSBC0Fb22doIUlxPl6N73LvogvK11YkaG2Taxh_4KdB2x9Ia_eoqyzI_TjsFpehAAWIjZKSUASd45J-ZqtzdFxU5UnDG43HSuFhckkZ9luUoKTwmRc5DPg0nkHV142JiAcSVCF_zsXzyAaSGWLmykHEHbYc2ve-DwHY7J5PdwO_b91kyDYDXAZ0aoPVh1M-wkK5reiguhA4RRjAK_wxQ8FKrnp1mGEo-tJlfo33DBRUeX4IhiUEQz2fLGKY5vxsIxFsq', selected: true),
                  _buildThumbnail('https://lh3.googleusercontent.com/aida-public/AB6AXuBUTvBOsYBB7Nui3TgyEqZLMurT7N9PtVTbGVOuylGRkO20CnUHxaHaDF72gKP3q1ACnajnoo5uM9cRh5C3a62zHiYzeaCd1tkgInJqtHPXlD_avhzrsgdW6g0A1c3nK_a0yzeunCS0p0QTdLIDPkwaISAaaa1DOiQOzVs-0_NG3OvemDIcSI2B7HOt7SB317Kd8P7jWn93MMFFKHdi-F6c9V1FVADRZ3flu1P7oijZGERNvJMyydw799odCQbmWrt_LUzTOKUNYx5X'),
                  _buildThumbnail('https://lh3.googleusercontent.com/aida-public/AB6AXuCV_M4n1b6-3gGenWXQG4OLzNAbtZ5cR-gTlV5uEKGNn30JVuCheozg0GJW5Y9VS0i7jjb71tAX_gJDrfnk669vKwteaS3E1z7zDV2are_WPUmsDxGUPQbhS7htF5oyJZZn8c_xZh15YnGjFaJpgaY8_lbCPJ7ITZW_cRW-nH4HUAGZBj3llPyMZadnGO4kibTmH0nRZEDObv1gVq66oba0UXnD_hqNdKus8smEwyMrPy57ogsiT0utSTZpnOu1UaARPVg479OhSZPF'),
                  _buildThumbnail('https://lh3.googleusercontent.com/aida-public/AB6AXuAaWHuoiRNuAM63sZvjGeAzNb_vhLPqV93UJ-y9sPoPd1zjPyJgmlgBOTXn1ms8TG81YalSFKFuDdWlthxBMe4ywvXE38u9O5uEPfb4a6HmSjQUu0Y9CKlkQxam8CLdRdmRmMiVM0DvBMCh5tjEx459VkpAY7YWQ46fs1_GZwtJ2pDrq1zEC_vaM7MsaU0h6OxUjjfYkrtLMl5rqGBUuP-jTWe1TUkoKqBsznlxCGYiZCiicEAuNGg3mQYtRtu0lZIWqCP9iLSWKTMQ'),
                  _buildThumbnail('https://lh3.googleusercontent.com/aida-public/AB6AXuAJSOlqm4t0jNlXTIOQD-PpPejUv09jyrLoYYrN95B7_QF1ETru2M-t3OwmOgUA-I3OaxQoGnpLpXILV9Gh6bUVwtA1XuxJlTmvpxrKwdVELf-LHxmedtZ_hFSmE7Jvzw5P1xoJp7TaOopOA_CPuo3w4b8By0VbtJZhOrnvzqX1S-XQ5-6tUB_b_igfNaA0R6sgaBxSeG9DqGjIDcPITquZ9cCkcnhuE9_KWU8dDJvtaRa9rqQR8EcaadLdIx_w1zDXkhryrdom-4AI'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(String url, {bool selected = false}) {
    return Container(
      width: 96,
      height: 64,
      margin: const EdgeInsets.only(right: 8, bottom: 16),
      decoration: BoxDecoration(
        border: selected ? Border.all(color: AppColors.stoxPrimary, width: 2) : null,
        borderRadius: BorderRadius.circular(4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              url,
              fit: BoxFit.cover,
            ),
            if (selected)
              Container(color: AppColors.stoxPrimary.withValues(alpha: 0.2)),
          ],
        ),
      ),
    );
  }
}
