enum CorporationType { gh, sh }

extension CorporationTypeExtension on CorporationType {
  String get korean {
    switch (this) {
      case CorporationType.gh:
        return "경기주택도시공사";
      case CorporationType.sh:
        return "서울주택도시공사";
    }
  }
}
