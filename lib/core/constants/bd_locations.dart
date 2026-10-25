/// Bangladesh divisions and their districts, for the address dropdowns on
/// complete-profile and edit-profile. The API has no address-lookup
/// endpoint, and it stores these as plain strings, so a static list is
/// enough. Upazila / village stay free-text.
class BdLocations {
  BdLocations._();

  static const Map<String, List<String>> districtsByDivision = {
    'Dhaka': [
      'Dhaka', 'Faridpur', 'Gazipur', 'Gopalganj', 'Kishoreganj', 'Madaripur', 'Manikganj',
      'Munshiganj', 'Narayanganj', 'Narsingdi', 'Rajbari', 'Shariatpur', 'Tangail',
    ],
    'Chattogram': [
      'Bandarban', 'Brahmanbaria', 'Chandpur', 'Chattogram', "Cox's Bazar", 'Cumilla', 'Feni',
      'Khagrachhari', 'Lakshmipur', 'Noakhali', 'Rangamati',
    ],
    'Rajshahi': ['Bogura', 'Chapai Nawabganj', 'Joypurhat', 'Naogaon', 'Natore', 'Pabna', 'Rajshahi', 'Sirajganj'],
    'Khulna': [
      'Bagerhat', 'Chuadanga', 'Jashore', 'Jhenaidah', 'Khulna', 'Kushtia', 'Magura', 'Meherpur',
      'Narail', 'Satkhira',
    ],
    'Barishal': ['Barguna', 'Barishal', 'Bhola', 'Jhalokati', 'Patuakhali', 'Pirojpur'],
    'Sylhet': ['Habiganj', 'Moulvibazar', 'Sunamganj', 'Sylhet'],
    'Rangpur': ['Dinajpur', 'Gaibandha', 'Kurigram', 'Lalmonirhat', 'Nilphamari', 'Panchagarh', 'Rangpur', 'Thakurgaon'],
    'Mymensingh': ['Jamalpur', 'Mymensingh', 'Netrokona', 'Sherpur'],
  };

  static List<String> get divisions => districtsByDivision.keys.toList();

  static List<String> districtsOf(String? division) =>
      division == null ? const [] : districtsByDivision[division] ?? const [];
}
