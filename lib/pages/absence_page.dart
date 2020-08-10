import 'package:ais_project/bloc/absences_bloc.dart';
import 'package:ais_project/models/absence_model.dart';
import 'package:ais_project/repository/ais_repository.dart';
import 'package:ais_project/styling/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class AbsencePage extends StatefulWidget {
  AbsencePage({@required this.repo});
  final AISRepository repo;
  @override
  _AbsencePageState createState() => _AbsencePageState();
}

class _AbsencePageState extends State<AbsencePage> {
  AbsencesBloc _bloc;

  @override
  void initState() {
    _bloc = AbsencesBloc(repo: widget.repo);
    _bloc.add(AbsencesGet());
    super.initState();
  }

  Widget _buildAbsencesList(List<Absence> absences) {
    List<Widget> _tiles = List<Widget>();
    absences.forEach((absence) {
      _tiles.add(ListTile(
        trailing: Icon(Icons.arrow_drop_down),
        title: Text('${absence.reason}'),
      ));
    });

    return Material(
      child: ListView(
        children: _tiles,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocListener<AbsencesBloc, AbsencesState>(
        listener: (context, state) {
          if (state is AbsencesLoading) {
            showToast('Problem z pobraniem nieobecności');
          }
        },
        child: BlocBuilder<AbsencesBloc, AbsencesState>(
          builder: (context, state) {
            if (state is AbsencesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is AbsencesLoaded) {
              return _buildAbsencesList(state.absences);
            } else {
              return Center(
                child: Icon(
                  Icons.error,
                  size: 50,
                  color: Palette.aisred,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
