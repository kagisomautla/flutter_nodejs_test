import 'package:intl/intl.dart';

class Weight {
  final int weightID;
  final String weight;
  String createdOn;
  Weight(this.weightID, this.weight, this.createdOn);

  setDateCreatedOn() {
    var dt = DateTime.now();
    var dateFormat = DateFormat("yy-MM-dd");
    createdOn = dateFormat.format(dt);
  }

  get getWeight => this.weight;
  get getDateCreatedOn => this.createdOn;
  get getWeightId => this.weightID;
}
