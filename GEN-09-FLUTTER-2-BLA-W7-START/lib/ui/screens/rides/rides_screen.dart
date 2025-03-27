import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/rides_preferences_provider.dart';
import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../model/ride/ride_filter.dart';
import '../../../service/rides_service.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_bar.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///
class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  void onPreferencePressed(BuildContext context) async {
    final provider =
        Provider.of<RidesPreferencesProvider>(context, listen: false);
    final currentPreference = provider.currentPreference;

    // Open a modal to edit the ride preferences
    RidePreference? newPreference =
        await Navigator.of(context).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(initialPreference: currentPreference),
      ),
    );

    if (newPreference != null) {
      provider.setCurrentPreference(newPreference);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RidesPreferencesProvider>(context);
    final currentPreference = provider.currentPreference;
    final matchingRides =
        RidesService.instance.getRidesFor(currentPreference!, RideFilter());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search Search bar
            RidePrefBar(
              ridePreference: currentPreference,
              onBackPressed: () => Navigator.of(context).pop(),
              onPreferencePressed: () => onPreferencePressed(context),
              onFilterPressed: () {},
            ),

            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) =>
                    RideTile(ride: matchingRides[index], onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
