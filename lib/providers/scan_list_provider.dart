import 'package:flutter/foundation.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:qr_scan/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier{
  List<ScanModel> scans =[];
  String tipusSeleccionat = 'http';

  Future<ScanModel> nouScan(String valor) async {
    final nouScan = ScanModel(valor: valor);
    final id = await DBProvider.db.insertScan(nouScan);
    nouScan.id = id;

    if(nouScan.tipus == tipusSeleccionat){
      this.scans.add(nouScan);
      notifyListeners();
    }
    return nouScan;
  }

  carregaScans() async{
    final scans = await DBProvider.db.getAllScans();
    this.scans = [...scans];
    notifyListeners();
  }

  //TO DO
  // Carrega scans per tipus
  carregaScansPerTipus(String tipus) async {
    final scansPerTipus = await DBProvider.db.getScanPerTipus(tipus);
    this.scans = [...scansPerTipus];
    notifyListeners();
  }

  // Esborra tots els scans
  esborraTots() async {
    await DBProvider.db.deleteAllScans();
    this.scans = [];
    notifyListeners();
  }

  // Esborra un scan per ID
  esborraPerId(int id) async {
    await DBProvider.db.deleteScan(id);
    this.scans.removeWhere((scan) => scan.id == id);
    notifyListeners();
  }
}