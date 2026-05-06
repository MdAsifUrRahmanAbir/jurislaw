part of 'home_view.dart';

class HomeTab extends GetView<HomeController> {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    // For now using the same layout as mobile, can be enhanced for tablet later
    return const HomeMobile();
  }
}
