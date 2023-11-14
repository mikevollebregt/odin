class AddressDTO {
  String? address;
  String? city;
  String? postcode;
  String? country;

  AddressDTO({this.address, this.city, this.postcode, this.country});

  AddressDTO.fromJson(String json) {
    final splitString = json.split(',');
    if (splitString.length >= 3) {
      address = splitString[0].trim();
      final splitPostal = splitString[1].trim().split(' ');
      var i = 0;
      for (final item in splitPostal) {
        if (i == 0) {
          postcode = item;
        } else if (i == 1) {
          postcode = '${postcode!} $item';
        } else if (i == 2) {
          city = item;
        } else {
          city = '${city!} $item';
        }

        if (i < splitPostal.length) i++;
      }
      country = splitString[2].trim();
    } else {
      final splitPostal = splitString[0].trim().split(' ');
      var i = 0;
      for (final item in splitPostal) {
        if (i == 0) {
          postcode = item;
        } else if (i == 1) {
          postcode = '${postcode!} $item';
        } else if (i == 2) {
          city = item;
        } else {
          city = '${city!} $item';
        }

        if (i < splitPostal.length) i++;
      }
      country = splitString[1].trim();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['address'] = this.address;
    data['city'] = this.city;
    data['postcode'] = this.postcode;
    data['country'] = this.country;
    return data;
  }

  String toStringFormat() {
    final data = '$address, $postcode $city, $country';
    return data;
  }
}
