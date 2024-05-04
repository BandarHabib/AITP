import 'models/models.dart';

abstract class AttractionRepo {
  Future<List<Attraction>> getAttractions();
}
