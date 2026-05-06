import 'package:get/get.dart';
import 'package:my_structure/app/core/services/local_storage_service.dart';
import 'package:my_structure/app/data/models/lawyer_model.dart';

class HomeController extends GetxController {
  final userName = ''.obs;
  
  final lawyers = <Lawyer>[].obs;
  final categories = ['পারিবারিক', 'ফৌজদারি', 'ব্যক্তিগত', 'ডিভোর্স', 'ভূমি', 'ট্যাক্স'].obs;
  final selectedCategory = 'পারিবারিক'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
    _loadDummyLawyers();
  }

  void _loadUser() {
    userName.value = LocalStorage.getName().isNotEmpty
        ? LocalStorage.getName()
        : 'ব্যবহারকারী';
  }

  void _loadDummyLawyers() {
    lawyers.assignAll([
      Lawyer(
        id: '1',
        name: 'অ্যাডভোকেট জন স্মিথ',
        photo: 'https://i.pravatar.cc/150?u=1',
        specialty: 'পারিবারিক আইন বিশেষজ্ঞ',
        experience: 10,
        location: 'ধানমন্ডি, ঢাকা',
        rating: 4.8,
        reviewsCount: 125,
        fee: 2000.0,
        practiceAreas: ['পারিবারিক', 'ডিভোর্স', 'ভূমি', 'খোরপোশ', 'সন্তানের অভিভাবকত্ব', 'উত্তরাধিকার'],
        bio: 'বাংলাদেশ সুপ্রিম কোর্টে ১০ বছরেরও বেশি অভিজ্ঞতাসম্পন্ন সিনিয়র আইনজীবী। পারিবারিক বিরোধ এবং ভূমি সংক্রান্ত মামলা সফলতার সাথে পরিচালনার জন্য পরিচিত।',
        education: 'এলএলবি (অনার্স), এলএলএম, ঢাকা বিশ্ববিদ্যালয়',
        barEnrollment: 'BC/2013/1234',
        languages: ['বাংলা', 'ইংরেজি'],
        successRate: '৯২%',
        reviews: [
          {'name': 'রহিম উদ্দিন', 'rating': 5.0, 'comment': 'দারুণ সার্ভিস, খুব প্রফেশনাল।', 'date': '২ দিন আগে'},
          {'name': 'করিম আহমেদ', 'rating': 4.5, 'comment': 'ভূমি সংক্রান্ত সমস্যার জন্য দারুণ পরামর্শক।', 'date': '১ সপ্তাহ আগে'},
        ],
      ),
      Lawyer(
        id: '2',
        name: 'অ্যাডভোকেট লরা লিম',
        photo: 'https://i.pravatar.cc/150?u=2',
        specialty: 'ফৌজদারি আইন বিশেষজ্ঞ',
        experience: 12,
        location: 'আগ্রাবাদ, চট্টগ্রাম',
        rating: 4.9,
        reviewsCount: 85,
        fee: 2500.0,
        practiceAreas: ['ফৌজদারি', 'শ্রম আইন', 'ব্যবসায়িক', 'রিট', 'সাইবার আইন'],
        bio: 'ফৌজডারি প্রতিরক্ষা এবং শ্রম আইন সংক্রান্ত বিরোধে বিশেষজ্ঞ। সততা এবং কৌশলগত আইনি লড়াইয়ের মাধ্যমে মক্কেলের অধিকার রক্ষায় নিবেদিত।',
        education: 'এলএলবি, লন্ডন বিশ্ববিদ্যালয়; এলএলএম, চট্টগ্রাম বিশ্ববিদ্যালয়',
        barEnrollment: 'BC/2011/5678',
        languages: ['বাংলা', 'ইংরেজি', 'হিন্দি'],
        successRate: '৮৮%',
        reviews: [
          {'name': 'আসিফ খান', 'rating': 5.0, 'comment': 'চট্টগ্রামের অন্যতম সেরা ফৌজদারি আইনজীবী।', 'date': '৩ দিন আগে'},
        ],
      ),
    ]);
  }
}
