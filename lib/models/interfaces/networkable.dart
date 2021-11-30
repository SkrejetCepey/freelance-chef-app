import 'package:freelance_chef_app/bloc/network_service/network_bloc.dart';

// Добавляет явность использования API блоку.

abstract class Networkable {
  late NetworkBloc networkBloc;
}