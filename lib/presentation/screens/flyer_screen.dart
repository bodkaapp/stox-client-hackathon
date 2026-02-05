import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../config/app_colors.dart';
import '../components/circle_action_button.dart';
import 'my_area_setting_screen.dart';
import 'flyer_viewer_screen.dart';

class FlyerScreen extends StatelessWidget {
  const FlyerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stoxBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context),
            _buildStoreTabs(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100), // Bottom padding for navigation
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNearbyFlyers(context),
                    const SizedBox(height: 24),
                    _buildNewFlyers(context),
                    const SizedBox(height: 24),
                    _buildRecommended(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.stoxPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.feed, color: AppColors.stoxPrimary, size: 22),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.titleFlyer} (${AppLocalizations.of(context)!.labelDraftDesign})', // チラシ (仮デザイン)
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.stoxText,
                        height: 1.0),
                  ),
                  Text(
                    'FLYER',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.stoxAccent,
                        letterSpacing: 1.0),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              CircleActionButton(
                icon: Icons.search,
                backgroundColor: Colors.white,
                contentColor: AppColors.stoxSubText,
                borderColor: AppColors.stoxBorder,
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                offset: const Offset(0, 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onSelected: (value) {
                  if (value == 'my_area') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MyAreaSettingScreen(),
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'my_area',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on_outlined,
                            color: AppColors.stoxSubText, size: 20),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.myAreaSetting, // マイエリア設定
                            style: const TextStyle(color: AppColors.stoxText)),
                      ],
                    ),
                  ),
                ],
                child: CircleActionButton(
                  icon: Icons.menu,
                  backgroundColor: Colors.white,
                  contentColor: AppColors.stoxSubText,
                  borderColor: AppColors.stoxBorder,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoreTabs(BuildContext context) {
    final stores = [
      {
        'name': AppLocalizations.of(context)!.labelRecommended, // おすすめ
        'selected': true,
      },
      {
        'name': 'イオン',
        'logo':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBSUQCtIBxtibZqLOCSB4B6m0nSUT5mQvfCT8zpcftDuHpYzVZsaJbDBv6-UuHf0AydOwEpBDAsG8adImQ7reI5Wp6-nfBYwO0xLYw824ou1ZtoiMmYBcfKBTdUDo-q98dzZkz3qmBypWbzA_hNHybPn8LrvGa7kmFe2MWVwWw5cFdZJxYbMjF8h7fjeTfWsPjVhlmzzSN7OD8OWsEl8MuewQ8ge2lj-C-oGg0HFbH79vfdirN1UyE8WfWKos4rsVE50kYPu96LNHg-'
      },
      {
        'name': 'ほっともっと',
        'logo':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCnTyfHCkZOjA3rHinGZcTDLj0U4UQyABGhTwAu0s3at-fW3PrGJwfE6XXYJERpAoBEQq7CRxXvDaU2tRmQ2tqcqYWUIghjBSF_UJ_cVXKluU3tZhdxaOG6uiw4HmzIYBBL705u4ITo4CgCVxoPmv3z1YlJnP8p3zUkjN6vGCZIxh6uDICr1MtC4c9urRlvBvhUs2ivoeyQj2JFU-jK9yr_I5JX_G7Istads5SPBx10Q3iAsVZyKxTuPd6bXLxvLiK4934ok6XPeuc8'
      },
      {
        'name': 'コーナン',
        'logo':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCcZuCNEz3didPG_eIQj5LaewVJ8MUvCPI-Bm3Nqg8eSHMQE6oDAAuktIRtX3NQkVUFtTJt8_V4qLw-UN-Z7kjYeIQmDNX9oC9dFsTFy-2JN9Ji6pDp4lc3Zem6WhdKR7784HI2ef67NSeQxVL7M2BCQMvkH63xaAOt_jy1_AHKbMENCOT5h2RNA2s8lrmbobbY3mCG7XCBi3DtD-bAp2NkVCIHXlZ_oyBzzYcf2mDRBNioZWVS-PnP8PrnLWV610hdoNOHSA0PeC77'
      },
    ];

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.stoxBorder)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: stores.map((store) {
            final isSelected = store['selected'] == true;
            return InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: isSelected
                      ? const Border(
                          bottom: BorderSide(color: Colors.blue, width: 2))
                      : null,
                ),
                child: Row(
                  children: [
                    if (store['logo'] != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          store['logo'] as String,
                          width: 20,
                          height: 20,
                          errorBuilder: (c, o, s) =>
                              const Icon(Icons.store, size: 20, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      store['name'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.blue : AppColors.stoxSubText,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNearbyFlyers(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 20, color: AppColors.stoxText),
              SizedBox(width: 4),
              Text(
                AppLocalizations.of(context)!.nearbyFlyers, // 近くのお店のチラシ
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.stoxText),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildFlyerCard(
                  context: context,
                  storeName: 'イオンスタイル',
                  storeBranch: '野田阪神店',
                  storeLogo:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuATzu-0iimHwrvkKH9PQPQllLUuoN6k1xZvs2fyVyR-OXexlyj6JVFZl4mjOQ-ZkG-pleAo-GvalYYfjReWPRwhrQK240YNq_SKHixIu3QxIg9qkf9WjFfmuBcVJFNsU-PwsU0QfaMWdvp8-CjidsezaKPMDdUuLPgOFR_XcvU5yn7Xmek9HFBDbd69E0U4oD5b7tRV_Rlmwwe8ZixZw-_fNWoxZNnpOpHuISoqAigq6oqg92WYWMe0OjWplJ_qiV-Je0EunaakM1yd',
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDT0F8dr2T7DjISRE64hgHSMAv-wjuBGnrW5pYp0qUHOxkBWqBDgzAD4lthvPRSI6Oa72wLrIBchafYdF_qYakKjhHBdBLt7ATNNlWibVpRa2LjzaS18V9K7E0iC6HFsUD761fy_oMuikGRBFmnF--K7GZbVz_1nu1VhIIPYjuPSjNw7Cp8G_Hi15vxIHPI2E4bqt-IuO8s2J4UcM8VP7tcBvVrIu7G9-ttck6p-DAJc0_Fdw5x0q5rzJTtvCO2ZzlwAGGV3bPmRXHR',
                  title: '第48週 1/23号 イオン...',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFlyerCard(
                  context: context,
                  storeName: 'EDION',
                  storeBranch: 'みてじま店',
                  storeLogo:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuD4OdqD-ZgLXSXPegS7HEWyEHpqoY8NSuFVhsKGOtICbwNH3WV-ytxZBAcomNRSs9mPh4BFeDICbmcVLGE9K8eUytwpMMWM9r5H5A__xy6I80mEoQfbfoqtrWIwiE1dciMguQ8M1m1hAaUGBWqguL902xuLoPWtLA3mzdjakg1ZGgnYOl3_6_3SO0GM_EvFXyheqPlwx9ccYGcoCrFtXFi-6sNqHus3UNMmwVGPDpmwz9WW4lWthCmGXzsOvI-KGD5DTRR4UFElKGrp',
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBSF3PCO5EX8LhY7FjvwOpX1Y1MMSj8i5b05HZoFIOiT9jkysT3PydPTzIDvp520s2A8rDG0xAKpBJLL1apmUDGpy_2fqZ34wr8cx186NQb7OLtcm7IlpqB7D9c80dKsDmAsBoBxqhNlg0faO10E3iE-Iw4g_w6SzkAH6PUxtEq9Uz_BphwFCGeJWGWJNoaxg_T3Xm5RIlRYZD8DpiKdi_It2vhNDY0lBvZGJphLpMH5wEfoR7zIUafxKHauuMCW4PFWp19f3ODnWKI',
                  title: 'REGZAフェア まとめ買い...',
                  badge: AppLocalizations.of(context)!.newArrivals, // 新着あり
                  badgeColor: Colors.amber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewFlyers(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.newFlyers, // 新着のチラシ
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.stoxText),
          ),
          const SizedBox(height: 12),
          // Grid 1
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildFlyerCard(
                  context: context,
                  storeName: 'ヤマダデンキ',
                  storeBranch: '大阪野田店',
                  storeLogo:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuC4wXo_Y7TvxEDrjP-hcJqRa5OmZ2kxVeP70Vq4M6BYDHsMIJ94_BJKVW7_F03R9YJUAmuwJwD_-pYL_burBwXIOJvZRZwUS5WN37whuW06_Fpn9bUYJTJ83gCmqz3ZiaEbyqFFhyqHM2Ky1Ec-onWSsevy9aP6INHBAHkcep4i87tgTCH4wnrMyEKFRVXNFN7M_fKoO-yo3BdFbOC1JKVu4MsGPZgbzfIv2c-tfetYsvqtUwQlzaDggOgxBet61z1TDkfVc3xPR3EM',
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDkQOYpYRDxlI1VmJMj52x6-ttOxcjqcg8g_997-wdrfGvONQoq0ay1nyiXn17Ob4A4S0RwvP8tx7g8_U9p1V9qC3IrLqGDVm7k7rcLPjiNUuJgh0Fxk9l2ckbbjgA1XqHbdPNqIHjEhWtgFCdw-Uokjmy5OWqX72SPcC-M0Q7_ryJnerTOI-I5uoRr_44Kvkxr1jqMj5aaY2F5Gf444PEbIZ4DmRTOqmbQJ1qkhjUeLtrDEg49Tz-wBff5VEU5RPb_XwTlFs_tOul-',
                  title: '店舗限定 今が買いどき！',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFlyerCard(
                  context: context,
                  storeName: 'コーナン',
                  storeBranch: '福島大開店',
                  storeLogo:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuC4llzMvh-ffDpYJ5OOuvTj-VYBACYKZH28MXR6kIhI1a9mafOkzJt0r1AO5WsAW7vj5l8h_NJOIGaU2MhNHThuTAnpc8jozcRvzIX4zEvDAzXREabyE2TMCHKTS2pKP0VVr7JXrJlH6_BXXx88jo0RshhNXTS5Rk_ePEh4aYIDJONCahufT__nEBzb5ivaTX3jyZHrPQW1atRDsQXCCOQ6zaHXADzKmJO1Km-hfWVhfKK0xus8d49xKqlSKgxeipYGwVdRtMLf37gM',
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAdbH6OABhD7oBntruPR7rmdmDD5mfZazkWAsBPTVFSl2hZe2V2mEOAnEqXOxfDQkhYJXPYOgBcFNM6deZ-mcaDzWBUco9YFTCjZr9uGWoIxXzAqXxRQDYZSGIz9yRNCiqVwPHD973UFTIUhvUQOBIa5tK6l7UAgRq4_GU2nDI-zcco4PoZjlmAC0lpfyHBZ1rb8m7KgTUZOLonmbfuKlRCOODx2_3SipE6k27myBdyoNWgGh7eWGRTNgZEq9la_A-Xj7JdunMG5Cmd',
                  title: '厳選 超特価！チラシ',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Grid 2
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildFlyerCard(
                  context: context,
                  storeName: 'ライフ',
                  storeBranch: '此花伝法店',
                  storeLogo:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBKZ9L-hhoqSKqgNRjR4M089d1hQXi_XhzMvhzULNE2Z6IRfMwyTdrOdXIuCDNahE9ApsXsGYYyGR9UVzjmp19co5l-ZqU0s6lBlBtLO8pUvgf8BQYFkJyOrvC_dsSQpmh7Uoi76M_QAj9t_KvXEqW8UEIIRxolr5QseoBv8om-HVZzd3TdiN6Q5q8Fw9gvsVRYVp-jjJhY1INBHJma7CvHJAAB8GfNfgq17N7ozMc5ssDEHXYeOLix3_Iwv-EEVYweVJGflFw1Ao56',
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuD1wNzYqonRarXUGHJUtQ5ktP1STFb__moKruHqVWdSKq4y5p1nQURi-6KXwrJsvrXRH-3vP9MRq2Cz6OPNIACGH48ioPNO_ERmCNM6AT7YYQxlefWW9F0dCnveUwgsGzCwkxkERbUHuf5MDVUHZYu1PJ6szHHfNtCefdWpy0rfnC2oJVk2dV62NSzgFzt67ya1CWGkR7OFq5doXDcjlujkYJzjJo9SJek1-w7CBbvrB_IbL1U0I-25pQd22zKAhnq8j91i2J_J25e4',
                  title: 'お買い得価格満載！「ライフ」',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFlyerCard(
                  context: context,
                  storeName: 'mandai',
                  storeBranch: '福島吉野店',
                  storeLogo:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuA-Unwd_0khvEutPI0ibbnhZkd3vbYG2b8lC8KBGEfIu-NDk-NYopQFmpCXtCbPMBpKosMu1FUBK4AGPd3tcaNzLa421nPX0m2Ac1XIkQyeQkIhhUmFWIa6965VMBm-vDPGnyk5mcoL4yb49fiOBVMsVh3JeoOdmoujBWLOA2q8wIBkPupgb7Frxq1v4eN_Oc6LCJgPxljvqkz2J9cdDLe4mWMpgEe2lse5EK5aK9SQUKvRWn-ykum1K0K8v9yKK7VHwU0SaK-4jqsF',
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCejkNpdbGc-r47-Dv7rZ9lbTCJ040IqrcdTIrYGqkrWvcipc2s1PcbYlDtGm1-SEnDpURrJI7kRNz3S3LB_Nokbz3lKU4vr5ErPiM-uOQ8Ago-ZFo4JITFtIEbVLqV-lqYLMCR7U9vtK2WDQHExo5YCrXgdMWrbzDOB7wME9Y-fQMGUm4lu85wfQEvnJYnqMioSyji04w27knfPkSmqtDv_PZSNA4MNYfey-LEzKkPjVMkJaAh5QHK8yv200yE90tPms0bjESzph7j',
                  title: '予告!! 1/27(火)のお買...',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlyerCard({
    required BuildContext context,
    required String storeName,
    required String storeBranch,
    required String storeLogo,
    required String imageUrl,
    required String title,
    String? badge,
    Color? badgeColor,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FlyerViewerScreen(
              flyerData: {
                'storeName': storeName,
                'storeBranch': storeBranch,
                'storeLogo': storeLogo,
                'imageUrl': imageUrl,
                'title': title,
              },
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  storeLogo,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) =>
                      Container(width: 32, height: 32, color: Colors.grey[200]),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      storeName,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.stoxText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      storeBranch,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.stoxSubText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.stoxBorder),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (c, o, s) =>
                          Container(color: Colors.grey[100], child: const Icon(Icons.image_not_supported)),
                    ),
                  ),
                ),
              ),
              if (badge != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: badgeColor ?? Colors.red,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        topRight: Radius.circular(8), // Match parent corner
                      ),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.stoxText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommended(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.todaysRecommended, // 今日のおすすめ商品
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.stoxText),
              ),
              Row(
                children: [
                  Text(AppLocalizations.of(context)!.homeViewAll, style: const TextStyle(fontSize: 12, color: AppColors.stoxSubText)), // すべて見る
                  const Icon(Icons.chevron_right, size: 16, color: AppColors.stoxSubText),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6), // gray-100 equivalent
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCOoecH1tEJrs2TFrI1pM3ehxyTWQU2m3vCzpIfxx-YcPT_2Rib3mzEOr4XITGkST0VQikX0lba4Bii8YdUsO9iqOhjggKSZfiFfxTGjLBnJV2IrPa_wEDNewO9h9B98VTvVpq0ELD5jpynWXmhdorFh40YIY5jzCyAjPQC4QZp9g9deaR_SKPr3c-epGT9RJj0bMQbQaIG-5tI7g8T4ozKtGa35NRdjfUF5tcgN8xVAUfTUXCTHdkuUeP-lAeXNAGoX9aBCbPVpCha',
                      fit: BoxFit.cover,
                      errorBuilder: (c, o, s) =>
                          const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.labelNewItem, // NEW ITEM
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'NEW 日産リーフ誕生', // Assuming brand names are not localized for now
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.stoxText),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '日産自動車', // Assuming brand names are not localized for now
                        style: TextStyle(fontSize: 12, color: AppColors.stoxSubText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
