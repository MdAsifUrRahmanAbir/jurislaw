import 'package:get/get.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../data/models/lawyer_model.dart';

class HomeController extends GetxController {
  final userName = ''.obs;
  
  final lawyers = <Lawyer>[].obs;
  final categories = ['Family', 'Criminal', 'Private', 'Divorce', 'Land', 'Tax'].obs;
  final selectedCategory = 'Family'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
    _loadDummyLawyers();
  }

  void _loadUser() {
    userName.value = LocalStorage.getName().isNotEmpty
        ? LocalStorage.getName()
        : 'User';
  }

  void _loadDummyLawyers() {
    lawyers.assignAll([
      Lawyer(
        id: '1',
        name: 'Adv. Jhon Smith',
        photo: 'https://i.pravatar.cc/150?u=1',
        specialty: 'Family Law Specialist',
        experience: 10,
        location: 'Dhanmondi, Dhaka',
        rating: 4.8,
        reviewsCount: 125,
        fee: 2000.0,
        practiceAreas: ['Family', 'Divorce', 'Land', 'Alimony', 'Child Custody', 'Succession'],
        bio: 'Senior Advocate with over 10 years of experience in the Bangladesh Supreme Court. Specializes in handling complex family disputes and land litigation with a high success rate.',
        education: 'LL.B (Honours), LL.M, University of Dhaka',
        barEnrollment: 'BC/2013/1234',
        languages: ['Bangla', 'English'],
        successRate: '92%',
        reviews: [
          {'name': 'Rahim Uddin', 'rating': 5.0, 'comment': 'Excellent service, very professional.', 'date': '2 days ago'},
          {'name': 'Karim Ahmed', 'rating': 4.5, 'comment': 'Highly recommended for land issues.', 'date': '1 week ago'},
        ],
      ),
      Lawyer(
        id: '2',
        name: 'Adv. Laura Lim',
        photo: 'https://i.pravatar.cc/150?u=2',
        specialty: 'Criminal Law Expert',
        experience: 12,
        location: 'Agrabad, Chittagong',
        rating: 4.9,
        reviewsCount: 85,
        fee: 2500.0,
        practiceAreas: ['Criminal', 'Labour', 'Business', 'Writ', 'Cyber Law'],
        bio: 'Specializing in criminal defense and labour law disputes. Dedicated to protecting client rights with integrity and strategic litigation.',
        education: 'LL.B, University of London; LL.M, Chittagong University',
        barEnrollment: 'BC/2011/5678',
        languages: ['Bangla', 'English', 'Hindi'],
        successRate: '88%',
        reviews: [
          {'name': 'Asif Khan', 'rating': 5.0, 'comment': 'Best criminal lawyer in Chittagong.', 'date': '3 days ago'},
        ],
      ),
    ]);
  }
}
