import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  static HttpLink httpLink = HttpLink('https://graphqlzero.almansi.me/api');

  GraphQLClient client() =>
      GraphQLClient(link: httpLink, cache: GraphQLCache());
}
