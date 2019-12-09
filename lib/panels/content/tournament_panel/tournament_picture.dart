import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../blocs/blocs.dart';

class TournamentPicture extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TournamentBloc, TournamentState>(
      builder: (context, state) {
        return FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: (state is TournamentSelected && state.tournament.images.length > 0)
                ? state.tournament.images[0].url
                : 'https://picsum.photos/80'
        );
      },
    );
  }

}
