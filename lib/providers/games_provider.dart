import 'dart:convert';
import 'package:latimovies/models/detailed_game_model.dart';
import 'package:latimovies/models/game_model.dart';
import 'package:latimovies/providers/base_provider.dart';
import 'package:latimovies/services/api.dart';

class GamesProvider extends BaseProvider {
  Api api = Api();
  bool isLoading = false;
  List<GameModel> games = [];
  fetchGames(String platform) async {
    isLoading = true;
    notifyListeners();
    games.clear();
    final response = await api
        .get("https://www.freetogame.com/api/games?platform=$platform");
    // await http.get(
    //     Uri.parse("https://www.freetogame.com/api/games?platform=$platform"));

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);

      games =
          List<GameModel>.from(decodedData.map((e) => GameModel.fromJson(e)))
              .toList();

      isLoading = false;
      notifyListeners();
    }
  }

// -------------------------- Detailed Game --------------------------
  DetailedGameModel? detailedGameModel;

  fetchGameById(String id) async {
    isLoading = true;
    notifyListeners();
    // games.clear();
    final response =
        await api.get("https://www.freetogame.com/api/game?id=$id");

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);

      detailedGameModel = DetailedGameModel.fromJson(decodedData);
      getGamesByCategory(detailedGameModel!.genre);

      isLoading = false;
      notifyListeners();
    }
  }

// -------------------------- Similar Games --------------------------

  List<GameModel> similarGames = [];
  getGamesByCategory(String category) async {
    isLoading = true;
    notifyListeners();
    similarGames.clear();
    final response = await api
        .get("https://www.freetogame.com/api/games?category=$category");

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);

      similarGames =
          List<GameModel>.from(decodedData.map((e) => GameModel.fromJson(e)))
              .toList();

      isLoading = false;
      notifyListeners();
    }
  }
}
