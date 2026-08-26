import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lawyer_model.dart';

/// TODO: no lawyer-listing/search endpoint exists in the backend yet
/// (ported as-is from ukil-chaai's hardcoded `HomeController._loadDummyLawyers`).
/// Replace this provider's body with a real repository call once one ships —
/// home, lawyer_list and lawyer_details all read lawyers through here, so
/// nothing else needs to change.
final lawyersProvider = Provider<List<Lawyer>>((ref) => const [
      Lawyer(
        id: '1',
        name: 'Advocate John Smith',
        photo: 'https://i.pravatar.cc/150?u=1',
        specialty: 'Family Law Specialist',
        experience: 10,
        location: 'Dhanmondi, Dhaka',
        rating: 4.8,
        reviewsCount: 125,
        fee: 2000.0,
        practiceAreas: ['Family', 'Divorce', 'Land', 'Alimony', 'Child Custody', 'Inheritance'],
        bio:
            'A senior lawyer with over 10 years of experience at the Supreme Court of Bangladesh. '
            'Known for successfully handling family disputes and land-related cases.',
        education: 'LLB (Hons), LLM, University of Dhaka',
        barEnrollment: 'BC/2013/1234',
        languages: ['Bangla', 'English'],
        successRate: '92%',
        reviews: [
          LawyerReview(name: 'Rahim Uddin', rating: 5.0, comment: 'Great service, very professional.', date: '2 days ago'),
          LawyerReview(name: 'Karim Ahmed', rating: 4.5, comment: 'Excellent advisor for land-related issues.', date: '1 week ago'),
        ],
      ),
      Lawyer(
        id: '2',
        name: 'Advocate Laura Lim',
        photo: 'https://i.pravatar.cc/150?u=2',
        specialty: 'Criminal Law Specialist',
        experience: 12,
        location: 'Agrabad, Chattogram',
        rating: 4.9,
        reviewsCount: 85,
        fee: 2500.0,
        practiceAreas: ['Criminal', 'Labor Law', 'Business', 'Writ', 'Cyber Law'],
        bio:
            'Specialist in criminal defense and labor law disputes. Dedicated to protecting client '
            'rights through integrity and strategic legal advocacy.',
        education: 'LLB, University of London; LLM, University of Chittagong',
        barEnrollment: 'BC/2011/5678',
        languages: ['Bangla', 'English', 'Hindi'],
        successRate: '88%',
        reviews: [
          LawyerReview(name: 'Asif Khan', rating: 5.0, comment: "One of Chattogram's best criminal lawyers.", date: '3 days ago'),
        ],
      ),
    ]);

const lawyerCategories = ['Family', 'Criminal', 'Personal', 'Divorce', 'Land', 'Tax'];
