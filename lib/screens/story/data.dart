// ignore: import_of_legacy_library_into_null_safe
import 'package:repost/models/story_model.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:repost/models/user_model.dart';

final User user = User(
  name: 'John Doe',
  profileImageUrl: 'https://wallpapercave.com/wp/AYWg3iu.jpg',
);
final List<Story> stories = [
  Story(
    url:
        'https://instagram.fsdq2-1.fna.fbcdn.net/v/t51.2885-15/300936255_811799749820521_2609619263351251659_n.jpg?stp=c0.280.720.720a_dst-jpg_e15_s640x640&_nc_ht=instagram.fsdq2-1.fna.fbcdn.net&_nc_cat=101&_nc_ohc=MZLTm9qWG9gAX-tQeFg&tn=xf8B22Ww6gGWJ-RX&edm=APU89FABAAAA&ccb=7-5&oh=00_AT9dZrJ3_v1LFattAvlHdwrzETOJg05Y6ye9R-nDQvx80Q&oe=6314C943&_nc_sid=86f79a',
    media: MediaType.image,
    duration: const Duration(seconds: 10),
    user: user,
  ),
  Story(
    url:
        'https://instagram.fsdq2-1.fna.fbcdn.net/v/t51.2885-15/300936255_811799749820521_2609619263351251659_n.jpg?stp=c0.280.720.720a_dst-jpg_e15_s640x640&_nc_ht=instagram.fsdq2-1.fna.fbcdn.net&_nc_cat=101&_nc_ohc=MZLTm9qWG9gAX-tQeFg&tn=xf8B22Ww6gGWJ-RX&edm=APU89FABAAAA&ccb=7-5&oh=00_AT9dZrJ3_v1LFattAvlHdwrzETOJg05Y6ye9R-nDQvx80Q&oe=6314C943&_nc_sid=86f79a',
    media: MediaType.image,
    user: User(
      name: 'John Doe',
      profileImageUrl:
          'https://instagram.fsdq2-1.fna.fbcdn.net/v/t51.2885-15/300936255_811799749820521_2609619263351251659_n.jpg?stp=c0.280.720.720a_dst-jpg_e15_s640x640&_nc_ht=instagram.fsdq2-1.fna.fbcdn.net&_nc_cat=101&_nc_ohc=MZLTm9qWG9gAX-tQeFg&tn=xf8B22Ww6gGWJ-RX&edm=APU89FABAAAA&ccb=7-5&oh=00_AT9dZrJ3_v1LFattAvlHdwrzETOJg05Y6ye9R-nDQvx80Q&oe=6314C943&_nc_sid=86f79a',
    ),
    duration: const Duration(seconds: 7),
  ),
  Story(
    url:
        'https://static.videezy.com/system/resources/previews/000/005/529/original/Reaviling_Sjusj%C3%B8en_Ski_Senter.mp4',
    media: MediaType.video,
    duration: const Duration(seconds: 0),
    user: user,
  ),
  Story(
    url:
        'https://instagram.fsdq2-1.fna.fbcdn.net/v/t51.2885-15/300936255_811799749820521_2609619263351251659_n.jpg?stp=c0.280.720.720a_dst-jpg_e15_s640x640&_nc_ht=instagram.fsdq2-1.fna.fbcdn.net&_nc_cat=101&_nc_ohc=MZLTm9qWG9gAX-tQeFg&tn=xf8B22Ww6gGWJ-RX&edm=APU89FABAAAA&ccb=7-5&oh=00_AT9dZrJ3_v1LFattAvlHdwrzETOJg05Y6ye9R-nDQvx80Q&oe=6314C943&_nc_sid=86f79a',
    media: MediaType.image,
    duration: const Duration(seconds: 5),
    user: user,
  ),
  Story(
    url:
        'https://static.videezy.com/system/resources/previews/000/007/536/original/rockybeach.mp4',
    media: MediaType.video,
    duration: const Duration(seconds: 0),
    user: user,
  ),
  Story(
    url:
        'https://instagram.fsdq2-1.fna.fbcdn.net/v/t51.2885-15/300936255_811799749820521_2609619263351251659_n.jpg?stp=c0.280.720.720a_dst-jpg_e15_s640x640&_nc_ht=instagram.fsdq2-1.fna.fbcdn.net&_nc_cat=101&_nc_ohc=MZLTm9qWG9gAX-tQeFg&tn=xf8B22Ww6gGWJ-RX&edm=APU89FABAAAA&ccb=7-5&oh=00_AT9dZrJ3_v1LFattAvlHdwrzETOJg05Y6ye9R-nDQvx80Q&oe=6314C943&_nc_sid=86f79a',
    media: MediaType.image,
    duration: const Duration(seconds: 8),
    user: user,
  ),
];
